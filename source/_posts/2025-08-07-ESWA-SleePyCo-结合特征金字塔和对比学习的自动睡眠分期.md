---
title: 'ESWA | SleePyCo: 结合特征金字塔和对比学习的自动睡眠分期'
categories:
  - 🌙进阶学习
  - ⭐脑机接口与混合智能研究团队（BCI团队）
  - 💫学习报告
abbrlink: 32226af2
date: 2025-08-07 07:25:09
tags:
---

{% asset_img 1.webp %}

该论文发表在《Expert Systems With Applications》期刊 2024 年第 240 卷（计算机科学1区，IF=7.5），题目为《SleePyCo: Automatic sleep scoring with feature pyramid and contrastive learning》。第一作者是韩国光州科学技术院（GIST）的 Seongju Lee 博士后研究员，通讯作者是 Kyoobin Lee 教授。

论文链接：https://doi.org/10.1016/j.eswa.2023.122551

代码链接：https://github.com/gist-ailab/SleePyCo

<!--more-->

***

### 论文概要

该研究的主要贡献如下：
1. 提出了一种名为 SleePyCo 的新型自动睡眠分期框架，该框架结合了特征金字塔和有监督对比学习，用于自动睡眠评分。
2. 将特征金字塔整合到自动睡眠分期中，并提出了 SleePyCo-backbone，以考虑原始单通道脑电图中存在的不同时间和频率尺度，从而提高睡眠阶段之间的区分度。
3. 通过对比分析表明，SleePyCo 在四个公共数据集上的性能优于最先进的框架。

***

### 研究背景

自动睡眠分期对于睡眠障碍的诊断、治疗以及实现家庭环境下的长期睡眠监测至关重要。多导睡眠图（PSG）是睡眠评分的黄金标准，包含多种生物信号，睡眠专家会依据相关标准对 PSG 数据的 20 或 30 秒片段（即 “epoch”）进行睡眠阶段划分。

目前，基于单通道脑电图（EEG）的自动睡眠评分研究较为活跃，因为获取睡眠时的多通道信号存在困难。但从原始 EEG 信号中学习表征面临着一些挑战：一是与睡眠相关的 EEG 模式会出现在不同的时间和频率尺度上；二是不同睡眠阶段的 EEG 模式存在相似性。这些问题使得自动睡眠分期的准确性和有效性受到影响，亟需新的方法来解决。

***

### 研究方法

1. 模型架构

SleePyCo 的架构由三个主要组件构成，整体设计考虑了 EEG 信号在不同时间和频率尺度上的特征，以及睡眠阶段间的区分性需求，具体结构如图1所示：

{% asset_img 2.webp %}
<div align='center'>图1 SleePyCo的整体结构</div>

- 骨干网络（SleePyCo-backbone）：包含 5 个卷积块，每个块由 1D 卷积层、批归一化层和参数化 ReLU（PReLU）组成，并加入挤压 - 激励模块（SE）增强特征选择。通过最大池化层减少时间维度，最终输出 3 个不同层级的特征序列（C₃、C₄、C₅），覆盖多尺度时间和频率信息。
- 横向连接（Lateral Connections）：将骨干网络输出的不同通道维度的特征序列转换为相同通道维度，形成特征金字塔（F₃、F₄、F₅），确保多尺度特征可被统一分类器处理。
- 分类器网络：采用 Transformer 编码器捕捉特征金字塔中的时序关系。首先通过全连接层将特征金字塔映射到模型维度，加入改进的位置编码以保留时间信息；再通过注意力机制聚合特征，最终通过多个层级的输出 logits 求和预测目标 epoch 的睡眠阶段。

2. 训练过程

训练分为两个阶段，分别优化特征提取和时序上下文学习：

{% asset_img 3.webp %}
<div align='center'>图2 SleePyCo的训练过程</div>

- 对比表征学习（CRL）：采用有监督对比学习预训练骨干网络。通过对单个 EEG epoch 进行两种不同的数据增强（如振幅缩放、时间偏移、加性高斯噪声等），生成 “多视图” 样本；利用对比损失最小化同类样本距离、最大化异类样本距离，增强特征的类别区分性。
- 多尺度时序上下文学习（MTCL）：冻结 CRL 预训练的骨干网络参数，训练横向连接和分类器。输入连续 L 个 EEG epoch（研究中 L=10），通过交叉熵损失学习多尺度特征的时序关系，预测目标 epoch 的睡眠阶段。

具体训练的伪代码如下：

{% asset_img 4.webp %}

***

### 研究结果

#### 与现有方法的性能对比

<div align='center'>表1 SleePyCo与现有方法的性能对比</div>
{% asset_img 5.webp %}

SleePyCo 在四个公共数据集（Sleep-EDF、MASS、Physio2018、SHHS）上均实现了最先进（SOTA）的性能，具体表现如下：
- Sleep-EDF：总体准确率（ACC）84.6%、宏 F1 分数（MF1）79.0、Cohen's Kappa 系数（κ）0.787，优于 XSleepNet 等方法，其中 N1 阶段 F1 分数提升 0.5%，REM 阶段提升 2.4%。
- MASS：ACC 86.8%、MF1 82.5、κ 0.811，在 N1 阶段 F1 分数达 60.1%，显著高于 SeqSleepNet（52.8%）和 IITNet（59.8%）。
- Physio2018：ACC 80.9%、MF1 78.9、κ 0.737，在单通道 EEG 输入下优于结合原始信号和频谱图的 XSleepNet。
- SHHS：ACC 87.9%、MF1 80.7、κ 0.830，与 SleepTransformer 相当，但仅需单通道 EEG，参数更少（2.37M vs 5.8M），推理速度更快（14.5ms vs 29.7ms）。

***

#### 消融实验

- 特征金字塔（FP）的作用：在基线模型（BL）基础上加入 FP 后，Sleep-EDF 的 ACC 提升 0.3%，MF1 提升 0.4%，尤其 N1 阶段 F1 分数提升 1.3%，表明多尺度特征融合增强了模糊阶段（如 N1 和 REM）的区分度。
- 有监督对比学习（CRL）的作用：CRL 使基线模型的 ACC 提升 1.0%，MF1 提升 1.2%，N1、N2、REM 阶段 F1 分数分别提升 2.7%、1.0%、1.9%，验证了其减少睡眠阶段特征歧义的效果。
- 协同效应：FP 与 CRL 结合时，Sleep-EDF 的 ACC 提升 1.4%，MF1 提升 1.7%，轮廓系数从 0.292 升至 0.325，表明两者协同增强了类内相似度和类间差异。

<div align='center'>表2 SleePyCo在SleepEDF上进行的消融实验</div>
{% asset_img 6.webp %}

***

#### 骨干网络性能

SleePyCo-backbone 在单尺度和多尺度设置下均优于 DeepSleepNet、TinySleepNet 等现有骨干网络：

- 单尺度设置中，在 Sleep-EDF 的 ACC 达 84.1%，高于 IITNet（83.5%）和 U-Time（83.6%）。
- 多尺度设置中，结合特征金字塔后，在 MASS 和 SHHS 的 ACC 分别达 86.8% 和 87.9%，显著高于 U-Time 和 XSleepNet 的多尺度版本。

<div align='center'>表3 SleePyCo-backbone 在单尺度和多尺度设置下与基准网络的对比</div>
{% asset_img 7.webp %}

***

### 结论

SleePyCo 仅使用原始单通道 EEG 即可超越需多模态输入（如频谱图）的方法，避免了信息损失和预处理成本。且该模型在低频（如 N3 的慢波）和中频（如 N1 的 theta 波）特征上的区分能力显著，在实时睡眠分期场景具有巨大潜力。

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=17229>
