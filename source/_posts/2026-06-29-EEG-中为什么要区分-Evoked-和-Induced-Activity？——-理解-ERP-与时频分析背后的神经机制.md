---
title: EEG 中为什么要区分 Evoked 和 Induced Activity？—— 理解 ERP 与时频分析背后的神经机制
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫基础知识
abbrlink: e77c1d1
date: 2026-06-29 12:01:00
tags:
---

### 为什么有些脑电信号"平均后消失了"？

在做 EEG（脑电图）分析时，一个看起来有点"反直觉"的现象经常出现：

- 当我们把多次实验的脑电信号对齐并平均后，有些清晰的波形（比如 P300、N100）会逐渐显现出来。
- 但与此同时，还有一些在单次试验中非常明显的脑电变化，在平均之后却"消失"了。

它们真的不存在吗？其实并不是。

在 EEG 研究中，这两类与刺激相关的脑活动分别被称为：

- **Evoked activity（诱发活动）：相位锁定（phase-locked）的神经活动。**
- **Induced activity（诱导活动）：非相位锁定（non-phase-locked）但与事件相关的活动。**

它们的关键区别不在于"有没有发生"，而在于 —— **是否在时间上与刺激严格同步（phase-locked）。**

{% asset_img 1.webp %}

<!--more-->

### 1 Evoked activity：大脑"同步的回声"

**Evoked activity （诱发活动）是由外部刺激引起的生理或心理反应，是与刺激时间严格锁定的脑电反应（phase-locked）。**

当你把多次 trial 叠加平均：

- 随机噪声互相抵消
- 稳定成分不断增强
- 最终得到 ERP（event-related potential）

比如：

- N100（早期感觉加工）
- P300（注意与决策）

{% asset_img 2.webp %}

Evoked activity 通常出现在感觉输入后的早期加工阶段，具有严格的时间锁定（phase-locked）特性，因此能够通过 ERP 平均直接观察到。常见实验包括：

{% asset_img 3.webp %}

这些成分通常发生在刺激后的**50–500 ms 内**，主要反映**感觉编码、注意分配和决策过程**。

### 2 Induced activity：不"对拍"的脑内节奏

**Induced activity （诱导活动）是由内部因素或先前经验引导的心理反应，是与刺激相关，但不严格时间锁定的脑振荡（non-phase-locked）。**

如果你像之前一样做 trial 平均：

- 因为相位不同步
- 波峰和波谷互相抵消
- 最后看起来"消失了"

如果你换一种分析方法：不看波形本身，而看"频率能量"，你可能会发现：

- α波减少（注意增强）
- γ波增强（认知加工）
- β节律变化（运动准备）

这些需要用：

**时频分析（time-frequency analysis）**

才能看到。

{% asset_img 4.webp %}

Induced activity 更多反映的是神经元群体振荡（oscillation）的重组，因此通常需要**时频分析**才能观察到。相比于 Evoked，它更容易受到：

- 注意力（Attention）
- 工作记忆（Working memory）
- 学习（Learning）
- 预期（Expectation）
- 运动准备（Motor preparation）

等高级认知过程的调节。常见实验包括：

{% asset_img 5.webp %}

这些变化通常持续**数百毫秒甚至数秒**，因此更适合采用连续时频分析进行研究。

### 3 Evoked和Induced区别

{% asset_img 6.webp %}

- Evoked 指的是**相位锁定（phase-locked）**的神经活动；
- Induced 指的是**非相位锁定（non-phase-locked）**但与事件相关的活动。

值得注意的是，某些频段振荡（尤其是 γ 振荡）既可能包含 evoked 成分，也可能包含 induced 成分。因此，在研究中，研究者有时会进一步区分：

- Evoked oscillation：相位锁定振荡
- Induced oscillation：非相位锁定振荡

**二者的区别不在于频率，而在于相位是否跨试次保持一致**。

***

### 原文链接

> <https://mp.weixin.qq.com/s/ogn7o7gtYyTbmTJ_8VWLFg>
