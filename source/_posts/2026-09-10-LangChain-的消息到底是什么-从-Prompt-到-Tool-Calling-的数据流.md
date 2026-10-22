---
title: LangChain 的消息到底是什么 从 Prompt 到 Tool Calling 的数据流
date: 2026-09-10 23:43
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: b4b696d8
tags:
---

### LangChain 的消息到底是什么 从 Prompt 到 Tool Calling 的数据流

不少 LangChain 程序在原型阶段只做一件事：把字符串传给模型，再读取返回文本。等到你加入多轮对话、工具调用、流式输出或多模态输入，原来的写法便开始出现难以解释的问题。模型明明要求调用工具，程序却只看到一句空文本；

历史消息已经保存，角色顺序却错了；流式界面能显示文字，最终保存的对象却缺少工具参数；日志中的两段文本完全相同，模型行为仍然不同。

这些问题的共同原因是把模型交互理解成字符串输入和字符串输出。LangChain v1 把消息定义为模型上下文的基本单元。消息除了内容，还携带角色、工具调用、关联标识、Token 用量和供应商响应信息。

Prompt 模板负责生成这些消息，聊天模型返回 AIMessage，工具执行结果通过 ToolMessage 回到模型，流式响应则以可合并的 AIMessageChunk 逐步到达。

本文只解决一个核心问题：这些对象如何组成一条完整的数据流。读完后，你应该能够解释字符串、Message、Prompt Template 和 PromptValue 的区别，正确检查 AIMessage 的结构，手动构造一次工具调用消息链，并知道数据在哪个边界丢失时应该检查什么。

<!--more-->

{% asset_img 2.webp %}
<div align='center'>图 1 结构化消息从输入到模型响应与应用消费的整体路径</div>

### 实际问题从字符串开始暴露

**单轮文本生成允许直接调用 model.invoke("解释 Python 列表")。官方文档把字符串说明为单个用户消息的快捷方式，适合不需要历史和复杂内容的独立请求。问题在于，字符串只能表达内容，不能**回答“谁说的” “这是指令还是工具结果”“这段内容对应哪个工具请求”等问题。

假设客服应用收到“取消订单”。如果只保存文本，系统无法区分它是用户请求、模型建议、系统规则还是工具返回的执行结果。更危险的情况是，工具返回“订单已取消”，程序把它当成用户消息重新发送；可见文字没有变化，角色却改变了模型对事实来源的判断。

{% asset_img 3.webp %}
<div align='center'>图 2 字符串与结构化消息的信息量差异</div>

消息对象解决的是上下文语义和关联关系，不是单纯的 Python 封装。它为不同模型供应商提供共同接口，使上层代码能够读取角色、内容块、工具调用和元数据。使用共同接口并不代表所有供应商行为完全一致；

标准对象保留差异，并把供应商特有信息放入适合的字段，业务层因此可以选择哪些部分需要统一、哪些部分需要显式适配。

### Message 的共同结构

**HumanMessage、AIMessage、SystemMessage 和 ToolMessage 都属于消息体系。最常用的共同字段是 content，它可以是字符串，也可以是内容块列表。**

消息还可以带 id、name、additional_kwargs 和 response_metadata。具体子类再增加自己的结构，例如 AIMessage.tool_calls、AIMessage.usage_metadata 和 ToolMessage.tool_call_id。

{% asset_img 4.webp %}
<div align='center'>图 3 一条消息的类型 内容与元数据结构</div>

内部数据流值得逐步理解。应用先构造消息或把简写格式转换为消息；聊天模型集成把标准消息翻译成供应商请求；供应商响应再被集成包还原为 AIMessage。因此 AIMessage 不是响应 JSON 的机械复制，而是标准字段和供应商字段的组合。

跨模型代码应优先读取标准字段，需要诊断特定供应商时再查看 response_metadata。

调试时建议先打印 type(message).**name** 和 message.type。前者是 Python 类名，后者是 LangChain 序列化与消息识别使用的类型标签。

之后再检查 content、tool_calls、usage_metadata 和 response_metadata。直接 print(message) 适合快速观察，却**不应**成为稳定的机器解析协议，因为对象的字符串表示不是业务 schema。

### 四种核心角色与消息顺序

**SystemMessage 放置系统级行为规则和背景，通常位于消息序列开头。**HumanMessage 表示用户输入。AIMessage 表示模型产生的消息，既可能包含最终文本，也可能包含工具调用请求。

ToolMessage 表示应用执行某个工具后的结果，并通过 tool_call_id 与对应请求配对。

{% asset_img 5.webp %}
<div align='center'>图 4 四种核心消息的职责和顺序</div>

消息列表不是数据库记录的任意排序。工具调用的典型顺序是 HumanMessage、包含 tool call 的 AIMessage、对应的 ToolMessage、模型最终 AIMessage。省略中间 AIMessage，只把工具结果放进历史，模型便看不到自己请求了什么。

工具结果的 call id 不匹配时，某些 provider 会拒绝请求，另一些**错误**可能在集成层出现。具体报错文本属于 provider 行为，需要现场验证。

系统消息也存在边界。模型是否支持独立 system role、如何处理多条 system message，以及它与 provider 原生 developer 指令的关系，都可能变化。LangChain 提供标准 SystemMessage，却**不能**强迫底层模型采用完全一致的优先级。

对安全、权限和合规有硬约束的规则**必须**在应用与工具层执行，**不能**只依赖系统消息。

### Prompt Template PromptValue 与 Message 的区别

**Prompt Template 是生成模型输入的规则，Message 是已经生成的上下文对象。**ChatPromptTemplate 保存角色模板、固定消息和占位符；调用 .invoke() 时，它读取变量并返回 ChatPromptValue。

ChatPromptValue.to_messages() 可以得到最终消息列表，.to_string() 则给出字符串形式，但对聊天模型而言，消息列表能保留更完整的角色结构。

{% asset_img 6.webp %}
<div align='center'>图 5 Prompt 模板生成 ChatPromptValue 和消息列表</div>

这解释了一个常见类型**错误**。开发者以为 Prompt 的输出是字符串，于是对结果调用字符串方法；实际输出却是 ChatPromptValue。在 LCEL 管道中，PromptValue 可以继续传给聊天模型，因为模型接口接受这种语言模型输入。

若下一步是普通 Python 函数，则应先明确它需要 PromptValue、消息列表还是最终字符串，再做显式转换。

变量校验发生在模板格式化边界。模板含 {question} 而输入字典缺少该键时，会在调用模型前**失败**。这是一件好事，因为**错误**尚未消耗模型请求。只有一个变量时，ChatPromptTemplate.invoke("内容") 可以自动注入；工程代码仍建议传字典，以免增加变量后输入语义悄悄变化。

模板格式也有安全边界。当前 Reference 支持 f-string、mustache 和 jinja2 等格式，并明确建议**不要**接收不可信的 Jinja2 模板。沙箱只能视为尽力保护，**不能**作为执行未知模板的安全保证。

若用户只提供变量值，应由应用控制模板本身，而不是允许用户提交任意模板代码。

### MessagesPlaceholder 如何插入历史

**多轮 Prompt 通常需要在系统消息与当前问题之间插入历史。**MessagesPlaceholder("history") 声明此处接收一组消息。输入可以是 BaseMessage 对象，也可以是可转换的消息简写。

占位符不会替你查询数据库，也不会决定哪个会话属于哪个用户；应用仍需先读取正确历史，再把它作为 history 变量传入。

{% asset_img 7.webp %}
<div align='center'>图 6 MessagesPlaceholder 对历史消息的插入和窗口限制</div>

默认情况下，未提供必需 placeholder 会触发 KeyError。设置 optional=True 后，缺省历史被解释为空列表。n_messages 可以限制只取最后若干条消息，但它按消息条数裁剪，不理解业务语义。

若最后两条刚好把 AI tool call 与 ToolMessage 拆开，得到的上下文可能不合法。因此窗口策略**必须**以对话回合和工具调用配对为单位检查，而**不能**只写一个数字。

还要区分 Prompt 插入历史与 Agent 状态持久化。Placeholder 只描述“历史放在 Prompt 的哪个位置”，它不会保存任何内容。checkpointer、数据库或消息历史组件负责存储，Prompt 只消费已经读取的数据。

把这两个职责混在一起，常见结果是程序每次都构造正确模板，却始终传入空 history。

### AIMessage 是模型响应的结构化记录

**读取 AIMessage.content 只能看到原始内容载荷。为了生成界面文本，可优先使用 message.text 或从标准文本内容块提取；为了驱动工具循环，需要检查 **tool_calls；为了统计成本，需要读取可用的 usage_metadata；

为了排查停止原因、模型标识或供应商返回值，再检查 response_metadata。

{% asset_img 8.webp %}
<div align='center'>图 7 AIMessage 的内容 动作与运行元数据</div>

模型请求工具时，content 可能为空，而 tool_calls 有值。如果代码以“content 为空”等价于“模型没有输出”，就会丢弃一次有效的动作请求。相反，模型也可能生成看似工具调用的普通文本，却没有结构化 tool call；

应用**不应**解析自然语言去猜工具名，除非它明确实现了旧式文本协议并承担相应**风险**。

usage_metadata 是 LangChain 的标准用量视图，通常包含输入、输出和总 Token 数；是否存在以及细分字段由 provider 决定。response_metadata 更贴近供应商响应。

生产日志可记录必要的数量、模型标识和停止原因，但要避免保存完整敏感 Prompt。消息 id 适合追踪和更新消息，也**不能**自动代替用户身份或会话权限。

### content 与 content_blocks

**content 保持宽松类型，是为了兼容字符串、供应商原生块以及 LangChain 标准块。**content_blocks 提供标准化、带类型的内容视图，可表达 text、reasoning、image、file、audio 等内容。

官方文档说明，该属性可以按需把 provider 原生 content 解析为标准块；也可以在构造消息时直接传入标准 content_blocks，此时 content 仍会被填充。

{% asset_img 9.webp %}
<div align='center'>图 8 content 原始载荷与标准 content blocks 的关系</div>

两者不是新旧替代关系。需要把消息原样交还同一 provider 时，原始 content 可能包含重要信息；需要统一渲染多个 provider 的文本、图像或推理结果时，content_blocks 更容易消费。

设置环境变量 LC_OUTPUT_VERSION=v1 或为模型配置 output_version="v1"，可以选择把标准内容块序列化进消息 content。是否应该启用取决于存储格式和下游消费者，应先用真实响应做兼容测试。

多模态支持**必须**局部标注“**待验证**”。LangChain 能表示 image、file、audio 和 video，不等于所选模型接受所有类型、URL、Base64 或 file id。文件大小、MIME 类型、远程 URL 权限和输出能力应以模型 provider 文档为准。

**不要**把标准 schema 的存在误解成底层能力保证。

### ToolMessage 如何关联工具结果

**Tool Calling 分为两个动作。模型生成 **AIMessage.tool_calls，应用读取名称和参数并执行函数；执行结果被包装成 ToolMessage，其 tool_call_id**必须**匹配原请求 id。随后消息列表再次传给模型，由模型结合结果生成答案或继续请求工具。

{% asset_img 10.webp %}
<div align='center'>图 9 AIMessage 工具请求与 ToolMessage 工具结果的关联</div>

ToolMessage.content 是会进入模型上下文的工具结果，应简洁、准确并避免泄露无关内部数据。artifact 保存应用需要、但不希望发送给模型的补充对象，例如原始检索文档 id、页码、调试字段或用于前端展示的数据。

把大型原始 JSON 全部塞入 content 会增加 Token 和提示注入**风险**；只把摘要放入 content、把完整结构留在 artifact，可以明确两类消费者。

工具异常也应结构化处理。网络超时、权限拒绝和参数校验**失败**发生在应用执行阶段，不是模型文本生成阶段。Agent 运行时可以把可安全展示的**错误**转换成 ToolMessage 让模型调整，但不可重试的写操作**必须**由业务逻辑阻止重复执行。消息关联保证上下文可解释，却不提供幂等性和授权。

### 流式输出中的 AIMessageChunk

**聊天模型流式运行时返回 AIMessageChunk。每个 chunk 只包含当前到达的增量，文本、工具调用参数片段、响应元数据或用量信息可能出现在不同块中。**LangChain 消息块支持相加，按顺序合并后才能得到完整内容和较完整的结构。

{% asset_img 11.webp %}
<div align='center'>图 10 AIMessageChunk 按顺序合并为完整消息</div>

用户界面可以边到达边显示 chunk.text，持久化层却**不应**把每个 chunk 当成独立对话消息。更稳妥的方式是维护一个累加对象，流结束后保存合并结果，同时在异常中断时标记该消息未完成。

工具调用参数常以 JSON 片段逐步出现，在完整合并和验证之前调用函数，会得到缺字段或语法不完整的数据。

流式模型 token、Agent 步骤更新和自定义事件属于不同流模式。本文只讨论消息块。接入真实模型后，首块时间、总耗时、取消行为、最终用量位置都属于 provider 和运行环境相关信息，**必须**通过带时间戳的实测确认，**不能**根据 stream() 方法名推断。

### 消息简写和强制转换失败

**LangChain 接受若干便利格式，例如字符串、{"role": "user", "content": "..."} 字典、("human", "...") 元组和正式消息对象。这些输入会在组件边界转换为标准消息。简写适合局部代码；当消息要跨模块存储、校验或追踪时，显式对象通常更清楚。**

{% asset_img 12.webp %}
<div align='center'>图 11 消息简写经过强制转换后的成功和失败路径</div>

常见的 MESSAGE_COERCION_FAILURE 来源包括字典缺少 role 或 content、角色名称无法识别、把整个消息列表多包了一层，或把业务 JSON 当成消息字典传入。

异常往往发生在距离原始输入较远的 Prompt 或模型边界，因此需要在进入链之前打印 type(value) 与受控长度的 repr(value)，并为外部请求先做 schema 校验。

**不要**通过不断增加 str() 消除类型**错误**。它会把对象变成可读文本，却同时丢掉 role、tool call id 和其他字段，使**错误**从“立即**失败**”变成“静默改变模型行为”。正确做法是确定下一个组件要求的输入类型，并构造对应对象。

### 可运行的消息结构观察器

**下面的小项目不连接模型，而是完整演示 Prompt 格式化、历史窗口、工具请求、工具结果、流式合并和标准内容块。这样可以先验证数据结构，再把外部模型作为单独变量接入。**

{% asset_img 13.webp %}
<div align='center'>图 12 调试消息问题时应检查的字段顺序</div>

安装环境如下。

```bash
python -m venv .venv
.venv\Scripts\activate
python -m pip install "langchain==1.4.0" "langchain-core==1.6.2"
```

保存为 message_lab.py 后运行。

```python
from langchain.messages import (
    AIMessage, AIMessageChunk, HumanMessage, ToolMessage
)
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
 
def describe(message) -> None:
    print(
        f"{type(message).__name__}: "
        f"type={message.type!r}, content={message.content!r}"
    )
 
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是{domain}助手，只回答当前问题。"),
    MessagesPlaceholder("history", optional=True, n_messages=2),
    ("human", "{question}"),
])
 
prompt_value = prompt.invoke({
    "domain": "Python",
    "history": [
        HumanMessage("列表如何排序？"),
        AIMessage("可以使用 sorted。"),
        HumanMessage("它会修改原列表吗？"),
    ],
    "question": "请给一个不修改原列表的例子。",
})
 
print("prompt value:", type(prompt_value).__name__)
for message in prompt_value.to_messages():
    describe(message)
 
tool_request = AIMessage(content=[], tool_calls=[{
    "name": "lookup_python_doc",
    "args": {"topic": "sorted"},
    "id": "call_001",
    "type": "tool_call",
}])
tool_result = ToolMessage(
    content="sorted(iterable) 返回新的已排序列表。",
    tool_call_id="call_001",
    name="lookup_python_doc",
    artifact={"source": "local_demo", "page": 1},
)
print("tool call:", tool_request.tool_calls[0])
print("tool result content:", tool_result.content)
print("tool result artifact:", tool_result.artifact)
 
chunks = [
    AIMessageChunk(content="原列表"),
    AIMessageChunk(content="不会改变"),
    AIMessageChunk(content="。"),
]
full = chunks[0]
for chunk in chunks[1:]:
    full = full + chunk
print("stream merged:", full.text)
 
multimodal = HumanMessage(content_blocks=[
    {"type": "text", "text": "请描述这张图片"},
    {"type": "image", "url": "https://example.com/demo.png"},
])
print("content block types:", [
    block["type"] for block in multimodal.content_blocks
])
```

实测输出如下。

```text
prompt value: ChatPromptValue
SystemMessage: type='system', content='你是Python助手，只回答当前问题。'
AIMessage: type='ai', content='可以使用 sorted。'
HumanMessage: type='human', content='它会修改原列表吗？'
HumanMessage: type='human', content='请给一个不修改原列表的例子。'
tool call: {'name': 'lookup_python_doc', 'args': {'topic': 'sorted'}, 'id': 'call_001', 'type': 'tool_call'}
tool result content: sorted(iterable) 返回新的已排序列表。
tool result artifact: {'source': 'local_demo', 'page': 1}
stream merged: 原列表不会改变。
content block types: ['text', 'image']
```

输出展示了三个容易忽略的过程。第一，n_messages=2 只保留 history 的最后两条，所以最早的“列表如何排序”没有进入 Prompt。第二，工具内容与应用 artifact 被分开，模型只应消费 content。

第三，三个流式块相加后得到完整文本；单独查看任意块都**不能**代表最终消息。

{% asset_img 14.webp %}
<div align='center'>图 13 消息结构观察器从 Prompt 到流式合并的实验流程</div>

### 常见错误与调试方法

**第一个错误是把 AIMessage 当字符串。典型症状是字符串拼接失败**，或序列化后出现大量意外字段。应先决定业务需要展示文本还是保存完整响应：展示层读取 text，Agent 与审计层保留消息对象。**不要**在共同服务层过早降级为字符串。

第二个**错误**是只检查 content，因此把含 tool calls 的空内容响应当成**失败**。调试顺序应是消息类型、content、tool_calls、invalid_tool_calls、usage_metadata、response_metadata。

真实模型返回结构与本地模拟不一致时，再打开 tracing 检查发送给 provider 的请求和收到的原始响应。

第三个**错误**是 Placeholder 变量不匹配。模板等待 history，调用方却传 messages，或者传入单条消息而非消息列表。

使用 prompt.input_variables、prompt.optional_variables 和 prompt.get_input_schema() 检查契约，并给 Prompt 格式化写独立测试。此类**错误**无需调用模型即可复现。

第四个**错误**是 ToolMessage.tool_call_id 与请求不一致。日志**必须**同时记录 AIMessage 中的 call id、工具执行 id 和 ToolMessage id。若存在并行工具调用，**不能**按列表位置猜配对关系，应以 id 为准。

工具返回内容还要限制长度，并把内部原始数据放入 artifact。

第五个**错误**是逐块解析流式工具参数。正确流程是收集 chunk、按顺序合并、验证完整 tool call，再执行工具。界面渲染和业务执行应使用两条消费路径：前者可以展示增量文本，后者等待结构完整。

### 适用边界

**结构化消息适合多轮对话、工具调用、多模态输入、用量统计、审计和跨 provider 适配。一次性的纯文本转换任务可以继续使用字符串快捷方式，不需要为了形式统一构造复杂历史。框架对象也不应**直接成为数据库的永久 schema；长期存储要设计版本字段、序列化格式、隐私删除和迁移策略。

Prompt Template 适合由应用控制结构、由运行时填充变量的场景。若输入只是固定字符串，模板会增加不必要的间接层。MessagesPlaceholder.n_messages 适合简单窗口实验，不负责语义摘要、Token 精确预算或工具回合完整性。

复杂上下文管理需要独立策略和测试。

消息标准化能减少上层分支，却不会抹平底层差异。任何关于多模态格式、system role、推理块、工具并行和 Token 统计的能力，都**必须**在选定模型和 provider 包版本上重新验证。文档中能构造某种消息，只说明 schema 接受这种表示，**不保证**模型能够处理它。

### 结语

**LangChain 的模型数据流可以按对象边界解释：ChatPromptTemplate 接收变量并生成 ChatPromptValue，PromptValue 转成消息列表，聊天模型返回 AIMessage，工具请求位于 tool_calls，工具结果通过匹配 id 的 ToolMessage 回传，流式增量以 AIMessageChunk 到达并在结束时合并。**

每一步都有可检查的 Python 类型和字段。

一旦保留这些结构，常见问题就能沿数据流定位。角色**错误**检查消息顺序，变量**错误**检查 Prompt 输入，工具未执行检查 tool_calls，结果无法关联检查 call id，流式结构不完整检查 chunk 合并。把消息过早转换成字符串，会让这些证据同时消失。

***

### 原文链接

> <https://mp.weixin.qq.com/s/1b0NnAVf-p2uc7HEK5YZJg>
