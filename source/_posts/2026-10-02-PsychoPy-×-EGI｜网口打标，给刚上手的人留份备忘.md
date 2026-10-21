---
title: PsychoPy × EGI｜网口打标，给刚上手的人留份备忘
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫基础知识
abbrlink: c9b8b273
date: 2026-10-02 12:03:15
tags:
---

最近不少人问我：“PsychoPy 怎么通过网口给 EGI 发 trigger？”索性把连接、安装和 Builder 里要放的几段代码整理一下。

刚上手时可以照着检查，以后换电脑、重装软件，也省得重新翻聊天记录。

说起 PsychoPy，我们那一批人最初用它，理由其实挺现实：当年 Presentation、E-Prime 一套买下来不便宜，经费又有限，只能先找个能把实验跑起来的办法。

至于来路不明的版本，实验能不能稳定做完，心里总有点没底。后来用着用着，PsychoPy 也逐渐顺手了。

常规实验可以在 Builder 里搭流程，需要特殊逻辑时再加几段代码，更复杂的任务则交给 Coder。

对于实验室新人，能先把刺激、反应和循环的关系看明白，再慢慢接触代码，确实友好一些。

**它后来也支持在线实验。老用户可能还记得，2021 年法国 OVH 数据中心火灾曾导致 Pavlovia 服务中断，团队随后恢复服务和数据访问。我那时候主要跑本地，对在线实验还比较保守，倒是没赶上这番折腾。**

这篇主要讲 EGI 400 系列与本地 PsychoPy Builder 的网口打标。

用到的工具是 **egi-pynetstation**：事件通过 NetStation 的 ECI 接口发送，NTP 则用于对齐时间。

可以简单理解为，一边负责“把标记送过去”，另一边负责“让两边对得上时间”。

下面按实际操作顺序来。

<!--more-->

### 01 先查网络，别急着改代码

第一次连接，建议先把三个地址写清楚：

| 设备 | 示例 IP |
| --- | --- |
| 刺激电脑，也就是运行 PsychoPy 的电脑 | 10.10.10.43 |
| 运行 NetStation 的采集电脑 | 10.10.10.42 |
| EGI 400 系列放大器 | 10.10.10.51 |

这里的地址只是示例。实际使用时，以实验室现有设置为准，三台设备的 IP 各不相同，不能照着同一个地址填。

**刺激电脑也需要接入EGI的局域网中，记得一定得改IP和子网掩码。**

在这组示例里，脑电网络所用网卡的子网掩码可以设为 255.255.255.0。接着检查：

- 刺激电脑是否接入了脑电设备所在的网络。
- 浏览器能否打开放大器管理页，例如 <http://10.10.10.51>。
- NetStation 是否已经启动，并开放 ECI 接口。
- 代码中的 ECI 端口是否与 NetStation 设置一致，示例使用 55513。

PsychoPy 官方示例也通过放大器管理页核对放大器和 NetStation 电脑的地址。

{% asset_img 6.webp %}

很多时候，连接失败只是地址没有改、网卡选错，或者端口没开。先把这些查清楚，再去看 Python 报错，会省不少时间。

**ping 可以辅助检查网络连通**，但能 ping 通以后，还要继续确认 ECI 和时间同步是否正常。

### 02 安装库，顺手记下版本

较新的 PsychoPy 可以从下面这个入口检查和安装：

Tools → Plugin/Package Manager → Packages → 搜索 egi_pynetstation

这里要确认包是否已经安装、装的是哪个版本。使用包管理器的方便之处，是比较容易把库装进当前 PsychoPy 使用的 Python 环境。

手动安装时也要注意这一点。有时候命令行明明提示安装成功，PsychoPy 还是报 ModuleNotFoundError，原因就是库被装进了电脑上的另一套 Python。

例如，调用 PsychoPy 自带的解释器安装 2.x，可以写成：

```
"C:\Program Files\PsychoPy\python.exe" -m pip install "egi-pynetstation>=2,<3"
```

前面的路径要按你的实际安装位置修改。

下面的代码按 **egi-pynetstation 2.x** 写。

PsychoPy 的示例页仍保留了 1.0.1 的一些用法，而库的现行文档已经调整了时钟同步机制。

旧实验如果还在使用 1.x，先保留已验证的环境，按对应版本的文档操作；版本混着抄，排查起来会很费劲。

### 03 在 Builder 里放好这几段代码

在 Builder 中添加 Code Component，代码类型选择 Py，用于本地运行。

要做的事情不多：**实验开始时连接，每轮刺激前重置标志，刺激出现时打标，结束时停止记录并断开。**

{% asset_img 11.webp %}

#### 1）Begin Experiment：初始化连接

```python
from egi_pynetstation.NetStation import NetStation
from psychopy.constants import STARTED

IP_ns = '10.10.10.42'   # NetStation 采集电脑的 IP
IP_amp = '10.10.10.51'  # 放大器的 IP
port_ns = 55513         # 与 NetStation 设置一致的 ECI 端口

eci = NetStation(IP_ns, port_ns)
eci.connect(ntp_ip=IP_amp)
eci.begin_rec()
eci.send_event(event_type='STRT')
```

这套示例由 eci.begin_rec() 控制开始记录，所以运行前，先确认 NetStation 已准备就绪、处于未录制状态。如果实验室采用手动开始记录的流程，就要相应调整代码，别让两套操作互相打架。

{% asset_img 12.webp %}

#### 2）Begin Routine：重置本轮打标标志

```python
triggerSent = False
```

它的作用是让每轮刺激只发送一次标记。

这里没有再加旧示例里的 eci.resync()。

PS：2.x 默认在后台采样并处理时钟漂移，现行文档已不建议在每个 trial 中调用这个方法；默认后台采样开启时，这样调用还可能报错。

#### 3）Each Frame：把视觉标记安排到屏幕刷新时发送

```python
if image_stim.status == STARTED and not triggerSent:
    win.callOnFlip(eci.send_event, event_type='STIM')
    triggerSent = True
```

这里有两个地方值得多看一眼。

首先，image_stim 要换成你自己的刺激组件名称。并且按这个写法，Code Component 要放在对应刺激组件下方，方便在同一帧读到刚更新的刺激状态。Builder 按界面中从上到下的顺序执行组件代码，位置也会影响执行时机。

其次，win.callOnFlip() 会把发送动作安排在接下来的屏幕翻转时执行，让视觉事件标记与呈现这一帧的刷新对齐。比起在帧循环里直接调用 send_event()，这个时序更明确。

事件码提前规划好，统一使用 **4 个 ASCII 字符**，例如：

STRT、FIXA、GO01、LEFT、CORR、ERRO、STOP

Stimulus1 就太长了。现在多花几分钟把名字定清楚，后面做 ERP 分析时，会少猜不少东西。

#### 4）End Experiment：结束记录，断开连接

```python
eci.send_event(event_type='STOP')  # 发送STOP作为结束事件
eci.end_rec()                      # 结束记录
eci.disconnect()                   # 解除链接
```

这几行负责正常结束时收尾。

**如果实验中途报错或被强制退出，仍要看一眼 NetStation 是否还在录制。**

先把设备状态处理好，再查原因，也方便下一次重新连接。

### 04 先跑一个小实验，再上正式任务

第一次联调，先做一个简单实验就够了：显示图片，发送 STIM，结束时发送 STOP。检查标记有没有出现、事件码是否正确、数量是否符合预期，以及实验结束后记录是否正常停止。

PsychoPy 也提供了 EGI 示例，可以从 Demos → Hardware → EGI_netstation 查找；如果还没有展开示例，先执行 Unpack Demos。

{% asset_img 15.webp %}

再补一句容易被忽略的：**新版的漂移模型需要累积时钟样本，当前文档中的稳定模型要求至少约三分钟的采样跨度。**

可以提前建立连接，让准备或说明阶段兼顾后台采样；是否已经满足实验的时序要求，还是要在自己的设备上测。

标记收到以后，还要检查它与实际刺激出现之间的时间关系。 做视觉 ERP，可以用光电二极管记录屏幕真正亮起来的时刻，再与事件标记比较。屏幕刷新对齐、网络时间同步和实际显示延迟，各自解决不同的问题，最后要一起验证。

这些检查做完，正式实验跑起来也会顺畅一些。

建议顺手留下 PsychoPy、egi-pynetstation 和 NetStation 的版本，以及 IP、端口与测试结果。

以后新人接手，或者换电脑重装软件，就有一份可以对照的记录。

第一次看到自己发出的 STIM 出现在 NetStation 里，还是挺开心的。接下来再确认数量和时间都对得上，这条打标链就算真正理顺了。

祝大家 trigger 全对，baseline 平稳。至于 p 值，让数据自己说话。

参考：

> <https://www.psychopy.org/hardware/egiNetStation.html>
> <https://egi-pynetstation.readthedocs.io/en/latest/>

***

### 原文链接

> <https://mp.weixin.qq.com/s/EQKL9mic1uLjeIYqyIWuPw>
