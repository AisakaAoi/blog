---
title: invoke、ainvoke、batch 与 stream 到底有什么区别：从调用语义到并发和流式背压
date: 2026-09-12 17:40
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: 80247b0d
tags:
---

同一条 LangChain 数据处理链，在命令行脚本里可能只处理一个问题，在 FastAPI 服务里要同时处理许多请求，在离线任务中要处理数千条文档，在聊天界面里又必须尽快显示第一个 Token。链条本身没有改变，但调用它的方式已经是四种不同的工程问题。

如果只把 invoke、ainvoke、batch 和 stream 理解为“同步版、异步版、批量版、流式版”，开发时很容易做出错误判断：看到 ainvoke 就认为底层一定是原生异步；看到 batch 就认为供应商执行了服务端批处理；看到 stream 返回多个 chunk 就认为整个 LCEL 管道没有缓冲；看到 batch_as_completed 先返回某个结果，就忘了它已经改变输出顺序。

选择调用方法前，需要回答三个问题：本次有一个输入还是多个输入？调用线程应该阻塞还是让出控制权？消费者需要最终结果，还是要在结果产生过程中逐步消费？这三个维度共同决定调用语义。

<!--more-->

{% asset_img 1.webp %}
<div align='center'>图 1：四种入口解决的是不同的基数、调度和交付问题。</div>

本文只解决一个核心问题：同一个 Runnable 通过不同入口运行时，数据数量、并发边界、返回顺序、流式时序、失败方式和资源占用分别发生什么变化。

### 一张选择表：先确定语义，再选择方法

| 调用方式 | 输入数量 | 调用方等待方式 | 返回形式 | 典型场景 |
|---|---|---|---|---|
| invoke | 1 | 当前线程阻塞 | 一个最终输出 | 命令行、同步任务、节点单测 |
| ainvoke | 1 | await ，允许事件循环调度其他协程 | 一个最终输出 | 异步 Web 服务、并发 I/O |
| batch | N | 同步等待整批结束 | 按输入顺序排列的列表 | 离线任务、批量评估 |
| abatch | N | 异步等待整批结束 | 按输入顺序排列的列表 | 异步批处理服务 |
| batch_as_completed | N | 同步迭代完成事件 | (index, result) | 先完成先展示、逐项落库 |
| abatch_as_completed | N | 异步迭代完成事件 | (index, result) | 异步任务队列、实时进度 |
| stream | 1 | 同步迭代 chunk | Iterator[chunk] | 命令行流式显示、同步 SSE 适配 |
| astream | 1 | 异步迭代 chunk | AsyncIterator[chunk] | 异步 SSE、WebSocket、Agent UI |

表中最容易混淆的是“完成顺序”和“返回顺序”。batch 内部可以并发执行，但最终列表仍按输入位置对齐；batch_as_completed 则按完成时间交付，所以必须保留返回的 index。

### invoke：最简单的调用并不等于落后

invoke(input, config=None) 在当前线程中启动一次调用，直到得到最终输出或抛出异常才返回。对于短小脚本、同步队列消费者、单元测试和节点级调试，它通常是最清晰的选择。

```python
from langchain_core.runnables import RunnableLambda

uppercase = RunnableLambda(lambda text: text.strip().upper())
result = uppercase.invoke("  runnable  ")
print(result)
```

预期输出：

```text
RUNNABLE
```

这里没有事件循环，也没有批量调度。当前线程进入 Runnable，完成后才继续执行下一行。若这个节点内部等待模型 20 秒，调用线程同样被占用 20 秒。

{% asset_img 2.webp %}
<div align='center'>图 2：invoke 的控制流容易推理，但耗时操作会占用当前请求线程。</div>

同步不是错误。错误的是在本来需要同时维持数百个 I/O 请求的异步服务器里，对每个请求直接执行耗时同步网络调用。反过来，一个一次只执行一项任务的维护脚本如果强行引入事件循环，代码会更复杂，却不一定获得可测量收益。

invoke 还适合作为调试基线。发现 batch 或异步链行为异常时，可以先对同一个输入调用 invoke，确认业务变换本身正确，再检查并发、顺序和共享资源。

### ainvoke：让出等待时间，不会自动减少计算量

ainvoke 返回可等待对象，调用方使用：

```python
result = await runnable.ainvoke(input)
```

当底层实现使用异步网络客户端并在等待 I/O 时 await，事件循环可以调度其他协程。同一线程因此可以管理多个处于等待状态的请求。它提高的是等待阶段的资源利用率，不是把一次模型推理从10秒压缩到2秒。

{% asset_img 3.webp %}
<div align='center'>图 3：异步任务在等待 I/O 时让出控制权，使其他任务继续推进。</div>

#### 默认异步回退为什么必须理解

Runnable 基类的默认异步实现可以通过线程池运行同步入口。这样，一个只实现 invoke 的组件也可能被 await ainvoke() 调用。接口兼容性提高了，但不能据此断言底层 SDK 已经是非阻塞异步。

{% asset_img 4.webp %}
<div align='center'>图 4：可 await 的外观与原生异步实现是两件事。</div>

这一区别会影响四件事：

1. 线程池有容量上限，大量阻塞调用可能耗尽工作线程；
2. 同步库必须保证线程安全；
3. CPU 密集计算不会因为放入线程池就线性加速；
4. 取消外层协程不保证已经开始运行的同步线程立即停止。

若组件同时提供同步和异步函数，可以显式构造：

```python
import asyncio
import time
from langchain_core.runnables import RunnableLambda

def sync_job(item: dict) -> str:
    time.sleep(item["delay"])
    return item["name"].upper()

async def async_job(item: dict) -> str:
    await asyncio.sleep(item["delay"])
    return item["name"].upper()

worker = RunnableLambda(
    sync_job,
    afunc=async_job,
    name="timed_worker",
)
```

此时 invoke 走同步函数，ainvoke 使用 afunc。真实组件是否具有原生异步实现，应查询该组件的当前 Reference 或源代码，而不是靠方法是否存在来判断。

#### 不要在已有事件循环里反复调用 asyncio.run

在普通脚本入口可以使用：

```python
asyncio.run(main())
```

但在 FastAPI、Jupyter Notebook 或其他已经运行事件循环的环境中，应在协程内部直接 await runnable.ainvoke(...)。再次调用 asyncio.run() 可能触发 RuntimeError: asyncio.run() cannot be called from a running event loop。调试时先打印当前代码是否已在 async 函数中，不要通过安装事件循环补丁掩盖结构问题。

### 同一工作负载的四组可运行对照实验

下面使用三个任务：slow 等待0.30秒，fast 等待0.10秒，medium 等待0.20秒。它们返回大写名称。完整脚本可以直接运行。

```python
from __future__ import annotations

import asyncio
import time
from collections.abc import Iterator

from langchain_core.runnables import RunnableGenerator, RunnableLambda

ITEMS = [
    {"name": "slow", "delay": 0.30},
    {"name": "fast", "delay": 0.10},
    {"name": "medium", "delay": 0.20},
]

def sync_job(item: dict) -> str:
    time.sleep(item["delay"])
    return item["name"].upper()

async def async_job(item: dict) -> str:
    await asyncio.sleep(item["delay"])
    return item["name"].upper()

worker = RunnableLambda(sync_job, afunc=async_job, name="timed_worker")

def timed(label: str, func):
    started = time.perf_counter()
    result = func()
    elapsed = time.perf_counter() - started
    print(f"{label}: {result} elapsed≈{elapsed:.2f}s")

def sync_modes_demo() -> None:
    print("=== invoke ===")
    timed("one", lambda: worker.invoke(ITEMS[1]))

    print("=== repeated invoke ===")
    timed("sequential", lambda: [worker.invoke(x) for x in ITEMS])

    print("=== batch ===")
    timed(
        "batch",
        lambda: worker.batch(ITEMS, config={"max_concurrency": 3}),
    )

    print("=== batch_as_completed ===")
    started = time.perf_counter()
    for index, result in worker.batch_as_completed(
        ITEMS,
        config={"max_concurrency": 3},
    ):
        elapsed = time.perf_counter() - started
        print(index, result, f"at≈{elapsed:.2f}s")

async def async_modes_demo() -> None:
    print("=== ainvoke ===")
    print(await worker.ainvoke(ITEMS[1]))

    print("=== abatch ===")
    started = time.perf_counter()
    results = await worker.abatch(
        ITEMS,
        config={"max_concurrency": 3},
    )
    print(results, f"elapsed≈{time.perf_counter() - started:.2f}s")

    print("=== abatch_as_completed ===")
    started = time.perf_counter()
    async for index, result in worker.abatch_as_completed(
        ITEMS,
        config={"max_concurrency": 3},
    ):
        elapsed = time.perf_counter() - started
        print(index, result, f"at≈{elapsed:.2f}s")

def split_words(inputs: Iterator[str]) -> Iterator[str]:
    for text in inputs:
        for word in text.split():
            time.sleep(0.03)
            yield word + "|"

def stream_demo() -> None:
    streamer = RunnableGenerator(split_words)
    print("=== stream ===")
    print(list(streamer.stream("first second third")))
    print("invoke merges chunks:", streamer.invoke("first second third"))

if __name__ == "__main__":
    sync_modes_demo()
    asyncio.run(async_modes_demo())
    stream_demo()
```

一次实测输出如下，耗时允许因机器调度产生少量波动：

```text
=== invoke ===
one: FAST elapsed≈0.12s
=== repeated invoke ===
sequential: ['SLOW', 'FAST', 'MEDIUM'] elapsed≈0.60s
=== batch ===
batch: ['SLOW', 'FAST', 'MEDIUM'] elapsed≈0.31s
=== batch_as_completed ===
1 FAST at≈0.10s
2 MEDIUM at≈0.20s
0 SLOW at≈0.30s
=== ainvoke ===
FAST
=== abatch ===
['SLOW', 'FAST', 'MEDIUM'] elapsed≈0.31s
=== abatch_as_completed ===
1 FAST at≈0.11s
2 MEDIUM at≈0.22s
0 SLOW at≈0.31s
=== stream ===
['first|', 'second|', 'third|']
invoke merges chunks: first|second|third|
```

#### 实验一：重复 invoke

三个任务顺序执行，总等待时间接近 0.30 + 0.10 + 0.20 = 0.60 秒。每个结果产生后，下一项才开始。这种方式顺序最明确，但 I/O 等待没有重叠。

#### 实验二：batch

三个输入并发运行，总耗时接近最慢任务的0.30秒。尽管 fast 最先完成，返回列表仍是 ['SLOW', 'FAST', 'MEDIUM']，与输入索引对齐。

{% asset_img 5.webp %}
<div align='center'>图 5：内部完成顺序不会改变 batch 最终列表的索引。</div>

#### 实验三：batch_as_completed

结果按 FAST、MEDIUM、SLOW 交付，每项都带原输入索引。消费者可以在0.10秒左右开始显示第一项，不必等待整批完成。若要最终恢复原顺序，可以预先创建等长列表，再执行 ordered[index] = result。

{% asset_img 6.webp %}
<div align='center'>图 6：as_completed 降低可见延迟，但顺序恢复成为消费者的责任。</div>

#### 实验四：stream 与 invoke

同一个 RunnableGenerator 通过 stream 返回三个 chunk；通过 invoke 调用时，框架把可加的 chunk 合并成一个最终字符串。这说明“组件能流式产生数据”和“调用方选择逐块消费”是两层决定。

### batch：并发不是越大越好

官方模型文档说明，常见 batch() 是客户端并行，与 OpenAI、Anthropic 等供应商可能提供的服务端 Batch API 不同；max_concurrency 可以限制同时发出的调用数量。Models：Batch 与并发

```python
results = worker.batch(
    ITEMS,
    config={"max_concurrency": 2},
)
```

并发上限要同时考虑：provider 每分钟请求数与 Token 配额、HTTP 连接池、数据库连接数、进程内存、单项响应大小和下游写入速度。把 max_concurrency 从10提高到100，可能只会更快触发429、连接超时或内存峰值。

{% asset_img 7.webp %}
<div align='center'>图 7：并发参数首先是资源保护手段，其次才是性能调节手段。</div>

#### Sequence 的 batch 怎样推进

对于 step_a | step_b | step_c，RunnableSequence.batch() 会让整批输入依次经过每个步骤的 batch，而不是让第一项从头跑到尾以后再处理第二项。这意味着中间结果会以批次形式存在，可能产生较高内存占用。

若第一步产生大型文档列表，第二步又生成大型嵌入输入，批次过大可能比并发度更早耗尽内存。生产任务应同时设置分块大小与 max_concurrency，而不是只调整线程数量。

#### batch_as_completed 的索引不能丢

官方 Reference 将 abatch_as_completed 的返回值定义为异步的 (index, output_or_exception) 序列。abatch_as_completed 官方 Reference

以下写法有风险：

```python
async for _, result in chain.abatch_as_completed(inputs):
    save_to_database(result)
```

若结果本身不包含稳定业务 ID，丢掉 index 后就无法证明它属于哪条输入。正确做法是保留 index，并在落库时使用输入的业务主键或幂等键。

### stream：核心价值是首块时间，不是总时间魔法

流式调用把一次最终返回拆成多个时间点。用户可以更早看到文字或进度，服务端可以更早把数据推向 SSE、WebSocket 或命令行消费者。它主要改善首块时间（time to first chunk）和过程可见性，不会自动减少模型必须完成的推理或工具执行。

{% asset_img 8.webp %}
<div align='center'>图 8：首块提前到达，最终完整结果仍需等待所有 chunk。</div>

#### chunk 不是天然完整对象

聊天模型可能把文本、工具名称、JSON 参数、推理块和用量元数据分散在不同 chunk 中。界面层可以逐块展示文本，业务层却不应在工具参数尚未闭合时执行工具。正确模式通常是两条消费路径：

- 展示路径：尽快显示可安全展示的增量；
- 业务路径：按协议合并 chunk，验证完整结构，再持久化或执行工具。

上一章已经说明过 AIMessageChunk 的合并机制。本章强调的是调用时序：stream() 返回迭代器以后，真正的工作通常随着迭代继续推进。若调用方创建迭代器却不消费，不能假定后台已经完成全部工作。

#### LCEL 中的流式屏障

RunnableSequence 只有在相关节点实现 transform 或 atransform 时才能保持逐块传递。官方 Reference 特别指出，普通 RunnableLambda 默认不支持 transform；如果它位于流式链中，流式输出会在该节点完成后才继续。RunnableSequence 流式说明

{% asset_img 9.webp %}
<div align='center'>图 9：链条有 stream 方法，不代表每个中间节点都能边接收边输出。</div>

调试流式性能时，应记录：调用开始时间、第一块到达时间、相邻块间隔、最后一块时间、完整合并时间和异常发生位置。只记录总耗时无法判断是模型首块慢、中间 Lambda 缓冲，还是客户端读取不及时。

#### 背压与慢消费者

对本地同步生成器而言，消费者每调用一次迭代才推进生产者，慢消费者会自然减慢上游。但真实模型集成还可能包含 HTTP 缓冲、SDK 队列和框架内部任务；消费者处理过慢时，内存中仍可能积累 chunk。

生产服务不要在读取循环里执行耗时数据库写入或复杂渲染。可以把轻量增量发送给客户端，把持久化交给有容量限制的队列，并设置最大缓冲量。超过容量时要明确选择阻塞、丢弃非关键进度、合并更新或取消上游，不能让队列无限增长。具体 provider 是否能及时响应取消属于“待验证”。

### 数据流与事件流必须分开

stream/astream 返回的是 Runnable 的业务输出 chunk。astream_events() 返回的则是运行事件，例如节点开始、节点流式输出、节点结束和错误。事件用于 tracing、调试和进度展示，不应被直接当成最终答案。

{% asset_img 10.webp %}
<div align='center'>图 10：业务消费者与观测系统读取的是不同通道。</div>

```python
async for event in chain.astream_events(input_data, version="v2"):
    print(event["event"], event["name"])
```

在 Agent 和 LangGraph 层，当前官方文档还提供 updates、messages 和 custom 等 stream mode，用于输出 Agent 步骤、模型消息 Token 与自定义进度。它们是更高层运行时的流式投影，不应与基础 RunnableGenerator 的任意 Python chunk 混为一谈。LangChain Streaming 官方文档

### 接近真实项目的示例：异步文档批处理

下面的项目模拟三个远程文档加载任务。文档完成后立即分析并交付；最终再根据 index 恢复原输入顺序。代码不依赖外部服务，可以直接运行。

```python
from __future__ import annotations

import asyncio
import time

from langchain_core.runnables import RunnableLambda

DOCUMENTS = [
    {
        "id": "D-1",
        "delay": 0.30,
        "text": "Runnable defines an execution protocol.",
    },
    {
        "id": "D-2",
        "delay": 0.10,
        "text": "Batch keeps results aligned with inputs.",
    },
    {
        "id": "D-3",
        "delay": 0.20,
        "text": "Stream yields incremental chunks.",
    },
]

def load_sync(item: dict) -> dict:
    time.sleep(item["delay"])
    return {"id": item["id"], "text": item["text"]}

async def load_async(item: dict) -> dict:
    await asyncio.sleep(item["delay"])
    return {"id": item["id"], "text": item["text"]}

def analyze(document: dict) -> dict:
    words = document["text"].split()
    return {
        "id": document["id"],
        "word_count": len(words),
        "preview": " ".join(words[:4]),
    }

loader = RunnableLambda(
    load_sync,
    afunc=load_async,
    name="load_document",
)
analyzer = RunnableLambda(analyze, name="analyze_document")
pipeline = loader | analyzer

async def main() -> None:
    started = time.perf_counter()
    ordered: list[dict | None] = [None] * len(DOCUMENTS)

    async for index, result in pipeline.abatch_as_completed(
        DOCUMENTS,
        config={
            "max_concurrency": 3,
            "tags": ["document-batch"],
            "metadata": {"job_id": "JOB-2026-09-11"},
        },
    ):
        elapsed = time.perf_counter() - started
        ordered[index] = result
        print(
            f"completed index={index} "
            f"id={result['id']} at≈{elapsed:.2f}s"
        )

    print("ordered ids:", [item["id"] for item in ordered if item])
    print("results:", ordered)

if __name__ == "__main__":
    asyncio.run(main())
```

一次实测输出：

```text
completed index=1 id=D-2 at≈0.14s
completed index=2 id=D-3 at≈0.23s
completed index=0 id=D-1 at≈0.32s
ordered ids: ['D-1', 'D-2', 'D-3']
results: [
  {'id': 'D-1', 'word_count': 5, 'preview': 'Runnable defines an execution'},
  {'id': 'D-2', 'word_count': 6, 'preview': 'Batch keeps results aligned'},
  {'id': 'D-3', 'word_count': 4, 'preview': 'Stream yields incremental chunks.'}
]
```

{% asset_img 11.webp %}
<div align='center'>图 12：完成事件可以立即消费，最终顺序通过 index 恢复。</div>

这个项目接近真实批处理的地方不在于文本分析逻辑，而在于控制面：加载步骤有原生异步实现；并发受到限制；结果按完成时间交付；业务 ID 与输入索引都得到保留；最终输出可以恢复稳定顺序；tags 和 job_id 进入观测配置而不是业务字典。

若下一步接入模型，应把 analyzer 替换为模型或结构化输出链，同时重新测量 provider 配额、Token 用量和取消行为。不要因为本地 asyncio.sleep 实验显示0.3秒完成，就推断真实模型也会按同样比例扩展。

### 批量失败怎样处理

默认 batch 或 abatch 遇到异常会向调用方抛出。已经并发启动的其他任务可能已经完成或仍在进行，框架不会替业务系统回滚外部副作用。

需要逐项记录失败时，可以设置：

```python
from langchain_core.runnables import RunnableLambda

divide = RunnableLambda(lambda x: 12 // x)
results = divide.batch(
    [3, 0, 4],
    return_exceptions=True,
)

print([
    type(x).__name__ if isinstance(x, Exception) else x
    for x in results
])
```

预期输出：

```text
[4, 'ZeroDivisionError', 3]
```

{% asset_img 12.webp %}
<div align='center'>图 11：返回异常对象只是把失败放回对应结果位，不代表异常已经得到处理。</div>

生产代码至少要记录输入索引、业务 ID、异常类型、可重试性和尝试次数。网络超时、429和临时服务错误可能适合退避重试；schema 错误、权限错误和非法输入通常不应盲目重试。包含写操作的任务还必须使用幂等键，避免成功步骤在批次重试时重复执行。

### 超时、取消与资源释放

RunnableConfig 的常见字段包括 tags、metadata、callbacks 和 max_concurrency，但应用级超时通常还需要调用方或 provider 配置共同参与。异步代码可以在应用边界使用：

```python
import asyncio

async with asyncio.timeout(10):
    result = await chain.ainvoke(input_data)
```

超时取消的是等待任务；如果底层是线程池中的同步函数，已经运行的线程未必停止。如果底层 HTTP 客户端支持取消，请求是否真正中止还取决于集成实现。涉及计费或副作用时，应把“调用方不再等待”和“远端工作已经停止”视为两个状态分别记录。

流式消费者退出时也要正确关闭迭代器、HTTP 响应和数据库连接。不要只在正常 end 事件中释放资源；异常、客户端断开和取消同样需要 finally 路径。

### 六个常见错误与调试方法

#### 错误一：在异步服务器中调用同步 invoke

症状是单个请求正常，但并发增加后事件循环整体卡顿。用事件循环延迟、线程数和请求堆积长度确认问题；支持原生异步的组件应改用 await ainvoke。若只有同步 SDK，应显式评估线程池容量，而不是假设框架能无限扩展。

#### 错误二：把 ainvoke 当成“更快的 invoke”

单次调用总耗时通常不会仅因 await 下降。比较时要区分单请求延迟和系统吞吐：异步可能让100个等待型请求更好地共存，但一个请求仍需等待相同远端工作完成。

#### 错误三：丢弃 as_completed 的 index

症状是结果都正确，却写入了错误记录。日志必须同时包含 index 和业务主键；测试应故意设置不同延迟，确认完成顺序变化后仍能正确关联。

#### 错误四：并发过高导致429或连接耗尽

先固定批次大小，再逐步提高 max_concurrency，同时记录成功率、P50/P95延迟、429数量、连接池等待和内存峰值。吞吐不再增长或错误率明显上升的位置通常比“机器还能开多少线程”更有意义。

#### 错误五：只确认有 chunk，不测首块时间

流式接口最终返回多个 chunk，仍可能在前20秒没有任何输出。应给每个 chunk 打时间戳，并检查 Sequence 中是否存在不支持 transform 的节点。

#### 错误六：开启 return_exceptions 后不检查类型

异常对象会与正常结果出现在同一列表。如果下游直接序列化或写库，可能把异常文本当成业务结果。必须使用 isinstance(result, Exception) 分支处理，并保留原输入标识。

### 适用边界：怎样选择而不过度设计

使用 invoke，当任务数量为一、调用环境同步、无需逐块展示，并且阻塞当前线程可以接受。

使用 ainvoke，当调用方已有事件循环、工作主要等待 I/O，并且底层组件提供原生异步或线程回退经过容量评估。

使用 batch/abatch，当输入有多个、消费者需要完整有序列表、内存可以容纳整批中间结果。

使用 batch_as_completed/abatch_as_completed，当先完成先处理能降低可见延迟，消费者能够保存 index 和业务 ID，并能逐项处理错误。

使用 stream/astream，当消费者确实能利用增量，例如聊天界面、实时进度、长文本解析或工具调用可视化；若调用方最终还是等待并拼接全部 chunk，流式可能只增加复杂度。

这些接口不替代任务队列、分布式调度器、数据库事务和持久化工作流。跨进程恢复、定时重试、人工审批和长时间状态管理应由 Celery、消息队列、LangGraph Checkpointer 或其他合适系统承担。

***

### 原文链接

> <https://mp.weixin.qq.com/s/uKxRC62aDoEJZUZ2Q0m8PQ>
