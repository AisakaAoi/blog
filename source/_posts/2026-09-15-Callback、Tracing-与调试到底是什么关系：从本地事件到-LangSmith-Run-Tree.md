---
title: Callback、Tracing 与调试到底是什么关系：从本地事件到 LangSmith Run Tree
date: 2026-09-15 09:30
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: 827ad281
tags:
---

一条 LCEL 流水线能正常返回结果，只能证明“这一次调用最终没有抛出异常”。它没有回答：模型实际收到什么消息？分类节点用了多久？为什么出现两次模型调用？429 是哪一个分支触发的？失败之后哪些节点已经产生了副作用？

上一章的可视化客服系统已经把工单拆成校验、清洗、分类、并行分析、路由和回复等节点。本章继续解决一个更接近生产的问题：**如何让每一次 Runnable 执行留下可定位、可关联、可筛选的证据。**

本文只讲可观测与调试，不展开 Tool Calling 和 Agent 循环。读完后，你将能自己编写 Callback Handler，理解 run_id 与父子运行，消费 astream_events()，派发业务进度事件，并判断什么时候使用本地日志、什么时候接入 LangSmith。

<!--more-->

{% asset_img 1.webp %}
<div align='center'>图 1：最终输出只描述结果，不足以还原中间执行。</div>

### 2. 先分清四个相似概念

初学者常把 Callback、Event、Trace 和日志当成四个名字不同的“打印信息”。它们观察的可能是同一次调用，但职责并不相同。

**Callback 是进程内通知机制。** Runnable 开始、输出新 Token、结束或报错时，框架调用 Handler 上对应的方法，例如 on_chain_start()、on_llm_new_token()、on_chain_error()。它是推送式的：不是你的业务函数不断询问框架，而是框架在生命周期节点主动通知 Handler。

**Event Stream 是事件消费接口。** 调用方执行 async for event in runnable.astream_events(...)，主动消费结构化事件。它适合驱动实时页面、进度条和调试面板。你不必自己实现一整套 Handler；当前 langchain-core 内部使用事件流 Tracer 把 Callback 体系转换为异步事件迭代器。

**Trace 是一棵持久化运行树。** 一次用户操作对应一个 Trace，Prompt、模型、解析器和工具等步骤分别是 Run。Trace 保存的不只是几行文字，还包括输入、输出、耗时、错误、父子关系、标签与元数据。LangSmith 可以存储、检索和比较这些 Trace。

**调试是一套寻找原因的方法。** Callback、Event 和 Trace 都只是证据来源。真正的调试仍要固定输入、缩小问题、验证数据形状、重现失败并增加回归测试。

{% asset_img 2.webp %}
<div align='center'>图 2：Callback 是通知机制，Event 是消费接口，Trace 是结构化运行记录。</div>

### 3. Callback 为什么不是普通的 print

假设我们在每个函数中手写：

```python
print("开始分类")
print("分类结束")
```

它能在本机看到文字，却缺少三个关键能力。第一，无法稳定关联“开始”和“结束”属于哪一次请求；多个并发请求的日志会交错。第二，不知道当前步骤属于哪个父工作流。第三，Prompt、模型、Retriever、Tool 等组件都要重复写日志代码。

Callback 协议把生命周期统一为一组方法。不同组件触发不同事件：

- RunnableLambda、Sequence 和解析器通常产生 chain 类型事件；
- Chat Model 产生 chat model 或 LLM 相关事件；
- Tool 产生 tool start、end、error；
- Retriever 产生 retriever start、end、error；
- 流式模型可以产生 on_llm_new_token ；
- 用户代码可以派发 custom event。

成功运行通常经历 start 和 end；失败运行经历 start 和 error。on_chain_error() 不会代替 Python 异常处理，它只是让观察者收到失败通知；原异常仍会向调用方传播。

{% asset_img 3.webp %}
<div align='center'>图 3：成功和失败都是一次 Run 的终态。</div>

### 4. run_id 与 parent_run_id 如何还原执行树

同一个节点可能同时处理十张工单，也可能在重试时运行多次，只看 name="classify_ticket" 无法区分实例。Callback 因此为每次运行提供 run_id，并用 parent_run_id 指向直接父运行。

例如根流水线运行 ID 为 …e93ce093，三个子节点分别拥有不同 ID，但都指向同一个父 ID：

```text
ticket_pipeline     run=…e93ce093  parent=-
├─ validate_ticket  run=…50ae48f2  parent=…e93ce093
├─ classify_ticket  run=…eb0bed3d  parent=…e93ce093
└─ route_ticket     run=…34e3e99b  parent=…e93ce093
```

本地实验还暴露了一个容易忽略的问题：LangChain 当前生成的运行标识可能采用 UUIDv7。它的前缀包含时间信息，短时间内创建的多个 UUID 可能共享前几位。因此日志若只打印 str(run_id)[:8]，不同子节点看起来可能完全相同。教学代码改为显示尾部八位；正式系统最好保存完整 UUID，只在界面展示缩写。

{% asset_img 4.webp %}
<div align='center'>图 4：名称描述组件，运行 ID 描述这一次组件执行。</div>

### 5. RunnableConfig 是观测上下文的运输通道

调用 Runnable 时可以传入：

```python
config = {
    "callbacks": [handler],
    "tags": ["tutorial", "ticket"],
    "metadata": {
        "app_version": "1.0.0",
        "environment": "development",
    },
    "max_concurrency": 4,
}

result = chain.invoke(payload, config=config)
```

callbacks 决定谁接收通知；tags 用于粗粒度分类与筛选；metadata 保存键值上下文；max_concurrency 控制支持该配置的并发执行。节点自己的 run_name 通常通过 with_config() 设置：

```python
validate = RunnableLambda(validate_ticket).with_config(
    {"run_name": "validate_ticket"}
)
```

在标准 LCEL 组合里，父 config 会传播给子 Runnable，子节点创建自己的 run ID，并继承可继承的 Callback、标签和元数据。自定义函数若在内部调用另一个 Runnable，却故意丢掉 config 或脱离当前上下文创建任务，就可能造成 Trace 断裂。因此不要在每个函数里重新构造一份互不相关的 CallbackManager；先让 Runnable 的配置传播机制工作。

{% asset_img 5.webp %}
<div align='center'>图 5：一个顶层 Handler 可以接收根运行与后代运行的事件。</div>

### 6. 最小可运行实验：自己写一个 Callback Handler

先实现只观察 chain 生命周期的 Handler。关键代码如下：

```python
import json
import time
from typing import Any
from uuid import UUID

from langchain_core.callbacks import BaseCallbackHandler

def compact(value: Any, limit: int = 90) -> str:
    text = json.dumps(value, ensure_ascii=False, default=str)
    return text if len(text) <= limit else text[: limit - 1] + "…"

def short_id(value: UUID | str | None) -> str:
    return str(value)[-8:] if value else "-"

class ConsoleTraceHandler(BaseCallbackHandler):
    def __init__(self) -> None:
        self.started_at: dict[UUID, float] = {}

    def on_chain_start(
        self,
        serialized: dict[str, Any],
        inputs: dict[str, Any],
        *,
        run_id: UUID,
        parent_run_id: UUID | None = None,
        tags: list[str] | None = None,
        metadata: dict[str, Any] | None = None,
        **kwargs: Any,
    ) -> None:
        self.started_at[run_id] = time.perf_counter()
        name = kwargs.get("name", "unnamed")
        print(
            f"START name={name:<18} run={short_id(run_id)} "
            f"parent={short_id(parent_run_id):<8} input={compact(inputs)}"
        )

    def on_chain_end(
        self,
        outputs: Any,
        *,
        run_id: UUID,
        parent_run_id: UUID | None = None,
        **kwargs: Any,
    ) -> None:
        started = self.started_at.pop(run_id, time.perf_counter())
        elapsed_ms = (time.perf_counter() - started) * 1000
        print(
            f"END   run={short_id(run_id)} parent={short_id(parent_run_id):<8} "
            f"ms={elapsed_ms:6.2f} output={compact(outputs)}"
        )

    def on_chain_error(
        self,
        error: BaseException,
        *,
        run_id: UUID,
        parent_run_id: UUID | None = None,
        **kwargs: Any,
    ) -> None:
        started = self.started_at.pop(run_id, time.perf_counter())
        elapsed_ms = (time.perf_counter() - started) * 1000
        print(
            f"ERROR run={short_id(run_id)} parent={short_id(parent_run_id):<8} "
            f"ms={elapsed_ms:6.2f} error={type(error).__name__}: {error}"
        )
```

这里的 **kwargs 不能随便删除。Callback 方法除了文档中列出的固定参数，还可能携带 name 等上下文；保留它可以兼容协议扩展。started_at 使用 run ID 作为键，而不是节点名称，所以并发运行同名节点时不会互相覆盖开始时间。

构建三个确定性节点：

```python
import asyncio
from langchain_core.runnables import RunnableLambda

def validate_ticket(raw: dict) -> dict:
    ticket_id = str(raw.get("ticket_id", "")).strip()
    text = str(raw.get("text", "")).strip()
    if not ticket_id:
        raise ValueError("ticket_id 不能为空")
    if len(text) < 3:
        raise ValueError("text 至少需要 3 个字符")
    return {"ticket_id": ticket_id, "text": " ".join(text.split())}

async def classify_ticket(ticket: dict) -> dict:
    await asyncio.sleep(0.05)
    category = (
        "payment"
        if any(word in ticket["text"] for word in ("扣款", "退款", "支付"))
        else "product"
    )
    return {**ticket, "category": category}

def route_ticket(ticket: dict) -> dict:
    routes = {
        "payment": "billing_team",
        "product": "product_support",
    }
    return {**ticket, "route": routes[ticket["category"]]}

def build_pipeline():
    return (
        RunnableLambda(validate_ticket).with_config(
            {"run_name": "validate_ticket"}
        )
        | RunnableLambda(classify_ticket).with_config(
            {"run_name": "classify_ticket"}
        )
        | RunnableLambda(route_ticket).with_config(
            {"run_name": "route_ticket"}
        )
    ).with_config({"run_name": "ticket_diagnostic_pipeline"})

pipeline = build_pipeline()
```

调用时把 Handler 放入本次运行的 config：

```python
async def run_callbacks(fail: bool = False) -> None:
    payload = {
        "ticket_id": "T-1001",
        "text": "会员已经扣款，但是权益没有到账。",
    }
    if fail:
        payload["text"] = "请触发错误，检查异常归属。"

    handler = ConsoleTraceHandler()
    try:
        result = await build_pipeline().ainvoke(
            payload,
            config={"callbacks": [handler]},
        )
        print("RESULT", result)
    except Exception as exc:
        print(f"FINAL_ERROR {type(exc).__name__}: {exc}")


asyncio.run(run_callbacks())
```

一次实际输出如下。ID 和耗时每次都会变化：

```text
START name=ticket_diagnostic_pipeline run=e93ce093 parent=-
START name=validate_ticket    run=50ae48f2 parent=e93ce093
END   run=50ae48f2 parent=e93ce093 ms=0.74
START name=classify_ticket    run=eb0bed3d parent=e93ce093
END   run=eb0bed3d parent=e93ce093 ms=55.92
START name=route_ticket       run=34e3e99b parent=e93ce093
END   run=34e3e99b parent=e93ce093 ms=1.01
END   run=e93ce093 parent=- ms=59.79
RESULT {'ticket_id': 'T-1001', 'category': 'payment', 'route': 'billing_team', ...}
```

这段日志已经能回答：总调用包含哪些子节点、父子关系是什么、哪个节点最慢，以及每个节点的输入输出是什么。

### 7. astream_events v2：不写 Handler 也能消费事件

需要把执行进度交给 Streamlit、SSE 或 WebSocket 时，与其在 Callback 方法里直接改 UI，不如让调用方消费结构化事件：

```python
async for event in pipeline.astream_events(
    payload,
    version="v2",
    include_names=[
        "ticket_diagnostic_pipeline",
        "validate_ticket",
        "classify_ticket",
        "route_ticket",
    ],
):
    print(event)
```

通用 Runnable 的 v2 StreamEvent 是字典，核心字段包括：

- event ： on_chain_start 、 on_chain_stream 、 on_chain_end 等；
- name ：产生事件的 Runnable 名称；
- run_id ：当前运行标识；
- parent_ids ：从根到直接父运行的 ID 路径；
- tags 与 metadata ：筛选和补充上下文；
- data ：根据事件类型包含 input 、 chunk 、 output 或错误数据。

include_names、include_types、include_tags 以及对应的 exclude 参数在事件产生后帮助消费者缩小范围。筛选事件主要降低消费端噪声，不应被误解成“被过滤节点没有执行”。

#### 7.1 事件在内部怎样产生

理解内部过程能避免把 Event Stream 当成另一套独立执行引擎。一次 Runnable 调用开始时，框架根据 RunnableConfig 配置 CallbackManager；Manager 为当前组件创建 RunManager，并触发对应的 start 通知。组件调用子 Runnable 时，子组件取得继承后的 CallbackManager，同时把当前 run ID 设为父运行。组件产生数据块、正常结束或异常时，RunManager 再触发 stream、end 或 error 通知。

astream_events() 并不会把业务链再运行一遍。当前实现为这一次调用附加内部事件流 Handler，将收到的生命周期通知写入异步内存流；外部的 async for 从另一端读取这些事件。由此得到两个工程结论。

第一，**事件消费者必须持续读取。** 如果 UI 或网络客户端消费很慢，缓存与背压策略就会影响内存和交付延迟。不要在循环中对每条 Token 执行缓慢数据库事务。

第二，**事件观察与业务结果共享同一次命运。** 消费循环抛出异常、被取消或过早退出时，需要明确底层 Runnable 是否也被取消以及外部网络资源是否释放；不能仅凭页面不再更新就认定模型停止计费。具体取消行为受 Runnable、异步任务和 provider SDK 共同影响，必须用所选版本做集成测试。

{% asset_img 6.webp %}
<div align='center'>图 6：事件字典携带数据，也携带运行关系。</div>

实际事件序列的一部分：

```text
{"event":"on_chain_start","name":"ticket_diagnostic_pipeline","parents":[],"data_keys":["input"]}
{"event":"on_chain_start","name":"validate_ticket","parents":["…root"],"data_keys":[]}
{"event":"on_chain_stream","name":"validate_ticket","parents":["…root"],"data_keys":["chunk"]}
{"event":"on_chain_end","name":"validate_ticket","parents":["…root"],"data_keys":["input","output"]}
```

为什么子节点的 start 可能没有 input，end 反而同时带 input 和 output？因为流式管道可能先建立下游消费关系，再逐块传递数据。可视化页面如果只在 start 事件读取输入，就可能显示空值。客服项目的 event_tracker.py 因此会在 end 事件补齐缺失输入。

{% asset_img 7.webp %}
<div align='center'>图 7：事件时间线不能简单等同于串行函数调用栈。</div>

### 8. 自定义事件：把业务进度放进同一条事件流

框架知道 Runnable 开始和结束，却不知道“100 个文档已经处理了 30 个”。这种业务语义可以通过 adispatch_custom_event() 发出：

```python
from langchain_core.callbacks.manager import adispatch_custom_event
from langchain_core.runnables import RunnableConfig

async def classify_ticket(
    ticket: dict,
    config: RunnableConfig,
) -> dict:
    await adispatch_custom_event(
        "progress",
        {
            "node": "classify_ticket",
            "message": "开始匹配分类规则",
        },
        config=config,
    )
    # 执行业务逻辑……
    return {**ticket, "category": "payment"}
```

在 Callback Handler 中实现：

```python
def on_custom_event(
    self,
    name: str,
    data: Any,
    *,
    run_id: UUID,
    tags: list[str] | None = None,
    metadata: dict[str, Any] | None = None,
    **kwargs: Any,
) -> None:
    print(f"CUSTOM name={name} run={short_id(run_id)} data={data}")
```

或者从 astream_events(version="v2") 中读取 event == "on_custom_event"。实际输出：

```text
CUSTOM name=progress run=eb0bed3d data={
  'node': 'classify_ticket',
  'message': '开始匹配分类规则'
}
```

事件 data 最好保持可 JSON 序列化，不要塞入数据库连接、文件句柄或大型模型对象。进度事件也不应每处理一个字符就发送一次，否则可观测系统本身会成为负载来源。

{% asset_img 8.webp %}
<div align='center'>图 8：自定义事件补充业务进度，不替代框架生命周期事件。</div>

### 9. 故障实验：为什么根节点和子节点都会报错

在分类函数中加入教学故障：

```python
if "触发错误" in ticket["text"]:
    raise RuntimeError("分类服务不可用（教学故障）")
```

用同一 Handler 运行：

```text
START name=ticket_diagnostic_pipeline run=6f2c0f55 parent=-
START name=validate_ticket             run=81c360c3 parent=6f2c0f55
END   run=81c360c3 parent=6f2c0f55
START name=classify_ticket             run=1f9ef474 parent=6f2c0f55
CUSTOM name=progress                   run=1f9ef474
ERROR run=1f9ef474 parent=6f2c0f55 error=RuntimeError: 分类服务不可用（教学故障）
ERROR run=6f2c0f55 parent=-        error=RuntimeError: 分类服务不可用（教学故障）
FINAL_ERROR RuntimeError: 分类服务不可用（教学故障）
```

这不是三个独立错误。最内层分类 Run 首先失败，异常使根 Sequence 也无法完成，最后由调用方捕获同一个异常。排查时通常先找到树中最深的 error Run，再检查其输入与直接子运行；只看根节点错误会丢失真正原因。

{% asset_img 9.webp %}
<div align='center'>图 9：错误状态沿父运行向上传播，原异常仍交给调用方。</div>

### 10. 完整可运行项目

项目的 main.py 支持三种模式：正常 Callback、结构化事件流和主动错误。完整代码已经保存在 callback_tracing_demo/main.py，运行命令为：

```bash
cd "D:\3D Visions\LangChainBlog\callback_tracing_demo"

# 使用上一篇项目已经创建的虚拟环境
..\ticket_workflow\.venv\Scripts\python.exe main.py callbacks
..\ticket_workflow\.venv\Scripts\python.exe main.py events
..\ticket_workflow\.venv\Scripts\python.exe main.py error
```

若独立创建环境：

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python main.py callbacks
```

三种运行使用同一条工单和同一条 LCEL 流水线，区别只在观察方式和是否注入异常。因此读者可以直接比较：Callback 收到的方法调用与 Event Stream 返回的字典，是否描述了同一棵运行树。

事件模式和命令入口的完整代码如下，可以直接追加在前面的节点定义之后：

```python
import argparse

NORMAL_INPUT = {
    "ticket_id": "T-1001",
    "text": "会员已经扣款，但是权益没有到账。",
}

async def run_events() -> None:
    async for event in build_pipeline().astream_events(
        NORMAL_INPUT,
        version="v2",
        include_names=[
            "ticket_diagnostic_pipeline",
            "validate_ticket",
            "classify_ticket",
            "route_ticket",
            "progress",
        ],
    ):
        row = {
            "event": event["event"],
            "name": event["name"],
            "run_id": short_id(event["run_id"]),
            "parents": [
                short_id(item)
                for item in event.get("parent_ids", [])
            ],
            "data_keys": sorted(event.get("data", {}).keys()),
        }
        print(json.dumps(row, ensure_ascii=False))

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "mode",
        choices=["callbacks", "events", "error"],
    )
    args = parser.parse_args()

    if args.mode == "events":
        asyncio.run(run_events())
    else:
        asyncio.run(
            run_callbacks(fail=args.mode == "error")
        )

if __name__ == "__main__":
    main()
```

#### 10.1 把观察机制接回可视化客服系统

客服项目中的 collect_run() 正是这个小项目的工程化版本。它先为九个可见业务节点建立 waiting 快照，然后消费 pipeline.astream_events(payload, version="v2")。遇到 start，把节点改成 running 并记录开始时间；遇到 end，保存输出、补齐输入并计算耗时；遇到 error，则保存异常。

这里不能简单使用一个“当前节点”变量。LCEL 中的并行分支会同时运行，多个节点可能同时处于 running；模型、Prompt 和解析器又是业务节点内部的子 Run。项目因此维护 visible_runs: dict[run_id, node_name]，用完整 run ID 把底层事件归属到页面上的业务节点。收到 on_chat_model_start 时，它沿 parent_ids 从内向外寻找最近的可见祖先，从而知道这次模型调用属于分类还是回复。

若模型请求抛出 429，某些下游节点可能已经产生 start 事件，但没有真正收到完整数据。把“最后启动的节点”染成红色会误导读者。采集器优先标记仍在活动的模型所属业务节点；普通 Python 异常则按依赖顺序选择最早未完成节点。生产系统还应保留完整事件和异常栈，因为九张卡片只是运行树的业务投影，不是原始事实的替代品。

### 11. LangSmith：把一次本地观察变成可检索 Trace

本地 Handler 适合开发时立即打印，但进程退出后日志可能散落在文件中。LangSmith 将一次操作保存为 Trace，并把每个 Prompt、模型、解析器、Retriever 或 Tool 调用保存为 Run。项目用于组织多条 Trace；标签和元数据用于筛选与比较。

对于 LangChain Runnable，当前官方方式可以通过环境变量启用自动追踪：

```bash
LANGSMITH_TRACING=true
LANGSMITH_API_KEY=你的LangSmith密钥
LANGSMITH_PROJECT=langchain-callback-tutorial
```

然后照常调用：

```python
result = pipeline.invoke(payload)
```

无需在每一个节点手动添加上传代码。若账号所在区域不是默认区域，还要按照工作区区域设置正确的 LANGSMITH_ENDPOINT；端点与 Key 区域不匹配会导致鉴权失败。

只想追踪某一段代码时，可以使用官方当前推荐的上下文方式：

```python
import langsmith as ls

with ls.tracing_context(
    enabled=True,
    project_name="ticket-debug-session",
):
    result = pipeline.invoke(payload)
```

run_name 只重命名当前 Runnable，不会自动把所有内部模型 Run 改成同一个名字。这样设计是正确的：根流水线和模型调用应当是两个可区分的 Run。

{% asset_img 10.webp %}
<div align='center'>图 10：LangSmith 的 Tracer 也是 Callback 体系的消费者。</div>

### 12. Tracing 不是零成本，也不是默认可以上传所有内容

Trace 可能包含完整 Prompt、客户问题、检索文档、工具参数和模型输出。对客服、医疗、财务或企业知识库应用而言，这些字段可能包含手机号、邮箱、订单号、身份信息与内部文档。

接入云端追踪前至少要确定：

- 哪些环境允许开启 tracing；
- 输入输出是否需要隐藏或脱敏；
- 哪些租户禁止记录正文；
- 采样比例和数据保留期限是多少；
- 谁能访问项目和分享链接；
- 日志、Trace 和业务数据库中的请求 ID 怎样关联。

如果某次请求包含不允许上传的数据，可以通过 tracing_context(enabled=False) 对该作用域关闭追踪。若仍需保留耗时和结构，应根据当前 LangSmith SDK 的隐私配置隐藏输入输出，而不是自行假设字段一定会被自动脱敏。

{% asset_img 11.webp %}
<div align='center'>图 11：可观测平台是新的数据出口，必须纳入安全设计。</div>

### 13. 六个常见错误及原因

#### 13.1 Callback 方法签名与当前版本不匹配

旧教程可能只写 on_chain_start(self, serialized, inputs)。当前处理器会传递 run_id、parent_run_id、tags、metadata 和其他关键字。自定义方法应按当前 Reference 实现，并保留 **kwargs。遇到 TypeError: unexpected keyword argument，先用 inspect.signature() 查看本地版本，不要凭旧博客修改。

#### 13.2 用节点名称计算耗时

若两个相同节点并发运行，started_at["classify_ticket"] 会互相覆盖。应使用完整 run_id 作为键，并在 end 或 error 后清理，避免字典持续增长。

#### 13.3 只处理 end，不处理 error

失败运行不会正常触发 end。如果只在 on_chain_end 计算耗时和释放资源，异常路径会留下脏状态。start 创建的观测状态必须在 end 与 error 两条路径上都关闭。

#### 13.4 把 on_llm_new_token 当作必然事件

只有模型与调用路径实际启用流式输出时，Token Callback 才会出现。某些提供方或配置会返回完整响应；中间 Runnable 也可能形成流式屏障。没有 Token 事件不等于 Handler 一定失效，应先确认模型的 streaming 支持和实际调用入口。

#### 13.5 创建了 astream_events，却没有消费

astream_events() 返回异步迭代器。只把它赋值给变量不会运行完整消费逻辑：

```python
events = pipeline.astream_events(payload, version="v2")  # 还没有消费
```

必须 async for，或者在测试中收集为列表。消费者提前退出还涉及取消和资源释放，不能把“停止显示事件”误认为后端任务一定已经停止。

#### 13.6 把 v2 和 v3 的返回结构混用

在本文固定的 langchain-core 1.6.2 中，通用 Runnable 的 astream_events() 默认是 v2 字典事件，并支持 custom event。v3 是面向内容块的类型化协议，目前只由实现它的 BaseChatModel 与 CompiledGraph 等组件支持，且仍标注 beta；对普通 RunnableLambda 请求 v3 会产生 NotImplementedError。

LangChain 当前 Agent 文档为新应用推荐 v1.3 引入的 event streaming 投影接口，但这不意味着所有通用 Runnable 示例都应立即把 version="v2" 替换为 v3。迁移前先确认对象类型、返回协议和本地版本。

#### 13.7 Callback 自己发生异常

Handler 也属于运行路径的一部分。如果在 on_chain_end() 中同步写入不可用的远程数据库，Handler 的延迟会被加到主请求上；若处理器设置为遇错上抛，观测故障甚至可能影响业务调用。Callback 中只做轻量、可失败隔离的工作：构造小型记录、增加内存计数或推入有界队列。真正的网络发送交给经过监控的后台批处理，并明确队列满时是丢弃观测数据、降级还是阻塞业务。

不要在 Handler 中打印完整 API Key、Authorization Header 或未经脱敏的 Prompt。调试工具越靠近底层，越容易接触原始数据；“只在开发环境使用”也不是泄密免责条件。

### 14. 旧教程迁移说明

当前代码从 langchain_core.callbacks 导入 BaseCallbackHandler，并通过 Runnable 调用的 config={"callbacks": [...]} 挂载处理器。不要把旧式 Chain 构造器中的 callback 参数、全局 verbose=True 和 LCEL 运行配置混成一种机制。

verbose=True 适合临时查看框架输出，但它不是稳定的结构化观测协议；无法代替 run ID、父子关系和机器可读事件。旧文章中常见的 LangSmith 环境变量命名也可能与当前文档不同。本文采用当前官方文档中的：

```text
LANGSMITH_TRACING
LANGSMITH_API_KEY
LANGSMITH_PROJECT
LANGSMITH_ENDPOINT（非默认区域时）
```

不要仅因为旧变量在某个兼容版本仍可工作，就继续把它写进新项目。发布或升级前应核对当前 LangSmith 配置页。

### 15. 一套可以重复使用的调试流程

面对“回答不对”“页面卡住”或“某节点变红”，建议按以下顺序处理：

1. 固定 Python、LangChain、provider 包和模型版本，并保存同一份输入；
2. 用确定性演示或 Fake Model 排除外部模型波动；
3. 单独 invoke() 每个节点，确认输入输出数据形状；
4. 查看完整 Run Tree，找到最深层 error，而不是最后一个 start；
5. 检查失败节点的原始 Prompt、响应、解析错误或工具参数；
6. 比较耗时、Token 和重试次数，判断是逻辑问题还是服务问题；
7. 修复后把失败输入加入回归测试；
8. 最后再恢复并发、流式和真实 provider。

{% asset_img 12.webp %}
<div align='center'>图 12：日志用于描述现象，Trace 用于定位路径，测试用于锁定修复。</div>

### 16. 适用边界

自定义 Callback 适合把运行事件接入本地日志、指标系统、Token 统计器或第三方观测平台。astream_events 适合调用方需要实时消费结构化进度的场景。LangSmith 适合跨请求保存和比较 Run Tree，并配合数据集、反馈和评估形成工程闭环。

但不是每个 Python 函数都要变成可观测节点。纯粹的短计算若没有独立调试价值，塞进大量 Runnable 只会制造事件噪声。Callback 中也不应执行缓慢网络请求或复杂业务逻辑；同步 Handler 阻塞时，可能直接增加主调用延迟。重型日志发送应使用经过验证的异步或批量方案。

Trace 也不能证明模型回答正确。它能告诉你模型收到了什么、输出了什么、调用了哪些步骤；回答质量仍要通过测试集、人工反馈和评估指标判断。可观测性解决的是“发生了什么以及在哪里发生”，不是自动替你决定“业务上是否正确”。

#### 16.1 怎样测试观测代码本身

Callback 不是只能靠肉眼看终端。测试中可以实现一个只向列表追加记录的 Handler，运行固定流水线后断言：根与子节点都出现 start；每个成功 run 都有对应 end；错误 run 有 error 且没有 end；子节点的 parent ID 指向根；敏感字段未进入记录。

事件流测试则可以收集：

```python
events = [
    event
    async for event in pipeline.astream_events(
        payload,
        version="v2",
    )
]

assert events[0]["event"] == "on_chain_start"
assert events[-1]["event"] == "on_chain_end"
assert any(
    item["event"] == "on_custom_event"
    and item["name"] == "progress"
    for item in events
)
```

不要断言具体 UUID 和毫秒数，因为它们每次都会变化。应断言结构关系、事件种类、必要字段和合理的耗时范围。对于真实模型，只把少量测试作为集成测试；其余使用确定性节点或 Fake Model，避免网络波动让 CI 随机失败。

### 17. 本章实践项目的验收标准

完成 callback_tracing_demo 后，请不要只看脚本能否退出。至少验证以下结果：

- callbacks 模式输出根节点和三个子节点的不同 run ID；
- 每个子节点的 parent ID 都能指回根运行；
- 分类节点耗时明显包含约 50ms 的模拟 I/O；
- custom progress 事件归属于分类节点；
- events 模式能看到 start、stream、end 和 parent IDs；
- error 模式首先标记分类节点失败，然后标记根流水线失败；
- 最终 try/except 捕获原始 RuntimeError；
- 不配置 LangSmith Key 时，本地实验仍能完整运行；
- 开启 LangSmith 后，项目中出现一条包含子 Run 的 Trace；
- Trace 中没有不应上传的真实客户敏感数据。

满足这些条件，才说明你不仅会“打开 tracing”，还理解了事件怎样产生、怎样关联、怎样失败以及怎样安全地被消费。

项目还提供三项自动化测试：正常工单结果、v2 自定义事件和异常向上传播。执行：

```bash
cd "D:\3D Visions\LangChainBlog\callback_tracing_demo"
..\ticket_workflow\.venv\Scripts\python.exe -m pytest -q
```

预期结果：

```text
3 passed
```

测试不依赖网络和模型 Key，因此适合放入 CI；LangSmith 上传应作为单独的集成测试运行。

***

### 原文链接

> <https://mp.weixin.qq.com/s/-5ASq-BcTtF4mU2CYtjQPA>
