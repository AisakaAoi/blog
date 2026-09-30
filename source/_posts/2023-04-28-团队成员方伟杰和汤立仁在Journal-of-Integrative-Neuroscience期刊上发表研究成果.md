---
title: 团队成员方伟杰和汤立仁在Journal of Integrative Neuroscience期刊上发表研究成果
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫团队成果
abbrlink: 7889b760
date: 2023-04-28 22:06:36
tags:
---

近日，团队成员方伟杰、汤立仁在潘家辉教授指导下，在SCI期刊Journal of Integrative Neuroscience 发表研究成果“AGL-Net An Efficient Neural Network for EEG-based Driver Fatigue Detection”。本论文于2023年1月21日投稿，2023年4月26日录用。

<!--more-->

随着全球车辆数量的不断增加，道路交通安全已成为一个突出的问题。而疲劳驾驶的检测是平衡效率和准确性的挑战。虽然存在各种方法，但由于参数过多且计算效率低，基于脑电信号（EEG）的疲劳检测深度学习模型难以在移动设备上实现，因此EEG被认为是检测疲劳的黄金标准。 为了解决这个挑战，本文提出了一个名为AGL-Net（Attention-based Ghost-LSTM Neural Network）的轻量级深度学习模型，用于基于EEG的疲劳检测。AGL-Net结构如图1所示。AGL-Net利用注意机制集中于相关特征，并使用Ghost bottleneck来高效提取空间EEG疲劳信息。然后，使用长短期记忆（LSTM）网络提取时间EEG疲劳特征。

{% asset_img 1.webp %}
<div align='center'>图1 AGL-Net示意图</div>

AGL-Net模型具有比现有深度学习模型更高的计算效率和轻量级设计，其FLOPs和Params值分别为2.67 M和103530。此外，在SEED-VIG疲劳驾驶数据集上，AGL-Net实现了87.3％的平均准确率和约0.0864的平均RMSE，表明其先进的性能能力。 对SEED-VIG数据集进行的实验表明了所提出的疲劳检测方法的可行性和先进性能。通过彻底的消融实验验证了AGL-Net的每个模块的有效性。此外，Ghost bottleneck的实现大大提高了模型的计算效率。总的来说，所提出的方法比先前的疲劳检测方法具有更高的准确性和计算效率，提供了更大的实际应用价值。

撰稿人：方伟杰

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=13593>
