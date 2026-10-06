---
title: 团队成员余杨祖怡等在Top期刊IEEE JBHI发表意识障碍睡眠新成果
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫团队成果
abbrlink: 2ea35853
date: 2024-10-26 20:40:33
tags:
---

近日，脑机团队2022级研究生余杨祖怡等以第一作者在生物医学信号处理领域的权威期刊IEEE Journal of Biomedical and Health Informatics (JCR Q1, 中科院一区Top, IF: 6.7 )上发表了题为“A Multimodal Consistency-Based Self-Supervised Contrastive Learning Framework for Automated Sleep Staging in Patients with Disorders of Consciousness”的研究论文。论文的通讯作者为华南师范大学潘家辉教授和广东工伤康复中心何艳斌主任。该论文自2024年4月25日提交，于2024年10月26日正式被接收。

<!--more-->

### 研究背景

睡眠障碍的有效治疗对于意识障碍（Disorders of Consciousness, DOC）患者的意识恢复具有潜在的积极影响。因此，对DOC患者的睡眠分期进行分析，可能有助于改善他们的病情。尽管对DOC患者的睡眠结构研究越来越受到关注，但目前对于睡眠特征的定义缺乏统一的标准，这成为了研究的一大障碍。严重的脑损伤导致的脑电图（EEG）的幅度、波形和频率的变异性，增加了在这类患者中定义睡眠特征的难度。此外，由于病理差异、数据采集设备以及医院环境的影响，EEG特征在个体之间存在显著差异，这对研究构成了额外的挑战。目前，对DOC患者的睡眠特征进行手动分析还受限于标准化流程的缺失，这限制了自动睡眠分期方法在不同患者间的适用性。

为了应对这些挑战，团队开发了一种新型的多模态一致性特征提取模型，命名为MultiConsSleepNet。该模型结合了脑电图（EEG）和眼电图（EOG）信号，利用自我监督的对比学习策略，提取单一模态信号中的共有特征和差异性特征。这种方法不仅提升了睡眠分期的准确性，还通过使用未标记数据来优化模型的性能。MultiConsSleepNet特别适用于分析DOC患者的非典型睡眠特征，有望成为临床诊断和治疗的有力辅助工具。

### 研究方法

MultiConsSleepNet的整体架构如图1所示。

1. 单模态特征提取器，用于捕获每种模态的表示。应用时间对比学习策略，为每种模态训练单独的对比估计，以获得更泛化的模态表示。
2. 多模态一致性学习结构，其中自我监督信号源自EOG和EEG特征之间的距离。这种方法促进了睡眠信号的通用表示的学习。

{% asset_img 1.webp %}
<div align='center'>图1 MultiConsSleepNet模型整体结构</div>

### 结果分析

本文提出的MultiConsSleepNet模型在训练时仅使用了10%的标注数据，却在Sleep-EDF数据集上实现了84.1%的准确率，并在ISRUC S3数据集上达到了75.1%的准确率。在全面监督的条件下，模型的表现进一步提升，在Sleep-EDF数据集上的准确率达到了85.8%，在MASS SS3数据集上更是达到了87.6%。这些结果均优于现有的基线方法，从而验证了我们方法的有效性。

进一步的消融实验揭示了多模态一致性模块在捕捉不同模态间互补信息方面的重要性，这一模块显著增强了模型的泛化能力，并改善了结果。值得注意的是，MultiConsSleepNet在自我采集的DOC患者数据集上也展现出了77.2%的准确率，这证明了模型在实际临床应用中的潜力和有效性。

### 总结

MultiConsSleepNet模型的这一成功应用不仅为自动化的睡眠分期提供了创新的技术方案，而且为意识障碍患者的睡眠分期研究贡献了重要的成果。这一研究进展预示着在未来意识障碍的诊断研究中，MultiConsSleepNet模型有望发挥更加关键的作用，为临床实践带来积极影响。

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=16353>
