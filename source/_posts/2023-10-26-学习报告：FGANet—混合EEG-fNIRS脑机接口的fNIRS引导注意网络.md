---
title: FGANet—混合EEG-fNIRS脑机接口的fNIRS引导注意网络
categories:
  - 🌙进阶学习
  - ⭐脑机接口与混合智能研究团队（BCI团队）
  - 💫学习报告
abbrlink: f16c3c53
date: 2023-10-26 07:26:51
tags:
---

本篇学习报告基于期刊IEEE TRANSACTIONS ON NEURAL SYSTEMS AND REHABILITATION ENGINEERING在2022年2月刊登的文章《FGANet: fNIRS-Guided Attention Network for Hybrid EEG-fNIRS Brain-Computer Interfaces》，这篇论文提出了fNIRS引导的注意力网络（FGANet）作为一种基于深度学习的早期融合结构，用于对心算任务和运动想象任务进行分类，均取得良好效果。实验结果表明该框架可广泛应用于任何混合EEG-fNIRS的脑机接口。

<!--more-->

***

### 背景

非侵入式脑机接口（BCIs）已被广泛应用于神经信号解码，将神经信号与控制设备连接起来。利用**脑电图（EEG）**和**功能性近红外光谱（fNIRS）**的混合脑机接口系统克服了EEG和fNIRS独立脑机接口系统的局限性，受到了广泛的关注。然而，由于时间分辨率和记录位置的差异，大多数混合EEG-fNIRS脑机接口研究都集中在后期融合上。尽管混合脑机接口的性能有所提高，但后期融合方法难以同时提取EEG和fNIRS信号的相关特征。

为了解决这个问题，在这篇论文中，作者提出了一种基于深度学习的早期融合结构，该结构在全连接层之前结合了EEG和fNIRS两个信号，称为fNIRS-guided Attention Network（FGANet）。FGANet基于神经血管耦合提取了EEG和fNIRS张量的联合表示，从fNIRS信号中识别重要的空间区域，并从EEG信号中提取出详细的神经模式。通过对EEG和fNIRS引导的注意力特征的预测分数之和进行加权，得到最终的预测结果，以此来缓解由fNIRS响应延迟导致的性能下降问题。

***

### 原理

论文提出的**fNIRS引导的注意力网络（FGANet）**由三个特征提取器分支组成：**EEG分支**、**fNIRS分支**和**融合分支**。

{% asset_img 1.webp %}
<div align='center'>图1 FGANet架构图</div>

大脑的时空动态是一个复杂的认知过程，为了在输入数据中包含时空信息用于网络训练，作者首先将一维的信号张量转换为三维张量。具体操作如下：对于EEG，利用方位等投影距离将头皮上的三维电极位置投影到大小为16×16的二维图像中，在映射点的数据中填充了相应电极的时间信息，然后用三次样条插值法对电极之间的空值进行差值；对于fNIRS，其检测的信息为神经活动中产生的血流动力学变化，首先通过比尔·兰伯特定律将检测到的原始fNIRS信号转化为**含氧血红蛋白（HbO）**和**脱氧血红蛋白（HbR）**在任务周期内的浓度变化，再使用类似的三维EEG张量生成过程将一维fNIRS信号转换为三维fNIRS张量。与EEG不同的是，fNIRS信号是通过光源和探测器来测量的，因此在光源与检测器之间的路径填充了相同的HbO或HbR值，使用样条插值对光源和检测器之间的空值进行插值。经过系列操作后，得到了能够进行空间对齐的三维EEG和fNIRS张量。

{% asset_img 2.webp %}
{% asset_img 3.webp %}
<div align='center'>图2 三维EEG张量和三维fNIRS张量</div>

为了从三维EEG和fNIRS张量中提取时空信息，作者构建了由三个三维卷积层组成的EEG独立网络（ESNet）和fNIRS独立网络（FSNet）。此外，作者还构建了一个**时间注意池化层（TAP）**用于压缩由三个连续卷积层提取的时间信息。

{% asset_img 4.webp %}
<div align='center'>表1 ESNet网络结构</div>

{% asset_img 5.webp %}
<div align='center'>表2 FSNet网络结构</div>

{% asset_img 6.webp %}
<div align='center'>图3 时间注意池化层的结构</div>

在FGANet中，使用了ESNet和FSNet的三个卷积层分别作为EEG分支和fNIRS分支的特征提取器。融合分支在每经过一个与ESNet相同的卷积层之后，会有一个fNIRS引导的注意力（FGA）层。FGA层基于神经血管耦合提取三维EEG和fNIRS张量的联合表示，其中使用fNIRS提取重要空间区域对大脑进行解码，并将空间注意力应用于EEG特征。所提出的FGA不同于传统的自我注意机制，它通过将原始特征与从原始特征本身得到的注意图相乘来强调分类的基本区域。在FGA层中，包含一个FGA图，表示从fNIRS信号中提取的空间权重矩阵，根据输入的数据自适应调整。

{% asset_img 7.webp %}
<div align='center'>图4 FGA层的结构</div>

***

###　实验与结果

#### 数据集

Open access dataset for simultaneous EEG and NIRS brain-computer interface (BCI)

数据来源于29位健康受试者，其中有28位右撇子和1位左撇子（14名男性和15名女性），平均年龄为28.5±3.7岁。受试者分别进行运动想象（MI）和心算（MA）任务，从30个通道记录1000 Hz的EEG信号，从由14个源和16个探测器组成的36个通道记录12.5 Hz的fNIRS信号。

***

#### 实验结果

对每个被试采用五折交叉验证，FGANet在MI和MA任务的分类精度分别达到78.59%和91.96%，相比于最先进的算法（IDPF），精度分别高了1.7% 和4.3%。为确保实验结果的公平性，作者还实现了具有EEG分支和fNIRS分支的pth-PF算法用于比较，结果显示FGANet的平均准确率要高2%，这是在MI和MA任务中最先进的基于深度学习的算法。

与以往工作者的实验结果进行对比，论文呈现出最高的分类精度，这些结果表明，论文所提出的FGANet是先进的EEG-fNIRS融合方法，可以显著提高混合EEG-fNIRS 脑机接口系统的性能。

{% asset_img 8.webp %}
<div align='center'>表3 不同方法下MA和MI任务的分类精度</div>

***

### 结论

论文提出的FGANet作为一种基于深度学习的早期融合结构，能够有效利用EEG和fNIRS的特征相关性，缓解由fNIRS信号固有延迟造成的性能下降。此外，还验证了FGA图能够正确地突出EEG特征的空间重要区域。这个框架可以广泛应用于任何混合EEG-fNIRS脑机接口系统。

***

### 参考资料

> <https://mp.weixin.qq.com/s/Ml05JspcB2CRN37rwQ1mXw>
> <https://www.scholat.com/teamwork/showPostMessage.html?id=14561>
