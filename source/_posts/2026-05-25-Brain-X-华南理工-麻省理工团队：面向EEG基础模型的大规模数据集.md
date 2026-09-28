---
title: Brain-X | 华南理工/麻省理工团队：面向EEG基础模型的大规模数据集
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫学习报告
abbrlink: c589eae6
date: 2026-05-25 16:17:30
tags:
---

在脑电基础模型研究中，高质量、大规模、可复用的公开 EEG 数据资源是模型预训练和泛化评估的重要基础。然而，当前公开 EEG 数据集普遍分散在不同平台和文献中，实验范式、采集设备、通道设置、数据格式和元数据标准差异较大，给数据发现、筛选、整合和复用带来了较高成本，也限制了通用 EEG 基础模型的发展。

近日，**华南理工大学李小俚教授/陈贺教授团队，联合麻省理工学院路子童博士**，以 “**Toward general-purpose foundation models for electroencephalography: A unified data registry**” 为题，在 **Brain-X** 发表研究论文。该研究面向 EEG 通用基础模型的数据需求，系统构建了一个统一的公开 EEG 数据注册库，旨在为大规模脑电预训练、跨数据集基准测试和开放科学研究提供标准化数据入口。

{% asset_img 1.webp %}

<!--more-->

该研究系统筛选了 2020 年以来公开发布的 EEG 数据集，并结合数据平台检索、文献审查和人工筛选，最终整理出 827 个合格 EEG 数据集，覆盖超过 13 万名参与者。研究团队根据数据的主要科学目的和应用场景，将其划分为认知、脑机接口、自然场景、临床、神经调控和方法学六大类别，并进一步记录了任务范式、采集设备、通道数量、导联布局、采样率、参与者数量、地区、年龄、健康状态、许可证、数据模态、标签可用性、托管平台、发表年份和访问链接等标准化元数据。

{% asset_img 2.webp %}

研究发现，当前公开 EEG 数据资源虽然数量持续增长，但仍存在类别分布不均、平台集中度较高、元数据完整性不足和格式标准不统一等问题。这些因素使得研究者在开展跨任务、跨设备、跨被试的 EEG 表征学习时，往往需要投入大量时间进行数据清洗、比对和组织。尤其是在基础模型预训练场景下，数据规模、异质性和可追溯性直接影响模型的泛化能力和评估可靠性。

该研究的意义在于，它从数据基础设施层面回应了 EEG 基础模型发展的关键需求。通过建立统一的数据注册库和结构化元数据体系，该工作降低了公开 EEG 数据的发现和复用门槛，为后续模型训练、数据集比较、任务筛选和基准评测提供了便利。这项研究不仅梳理了当前公开 EEG 数据资源的整体格局，也揭示了脑电基础模型发展中仍需解决的数据标准化问题。未来，随着更多 EEG 数据集被持续整理和规范接入，该注册库有望成为推动 EEG 通用基础模型、脑机接口和临床智能分析研究的重要支撑。

本文链接：https://onlinelibrary.wiley.com/doi/10.1002/brx2.70046

数据库链接：https://zenodo.org/records/18815016

本文引用格式：

> Shengle Shi, Yinglu Song, Yong Wang, Jiaqing Xiao, Xinpeng Lin, Heng Wang, Zhibin Zhao, Pengyu Wang, Zitong Lu, Xiaoli Li, He Chen. Toward general-purpose foundation models for electroencephalography: a unified data registry. Brain-X. 2026;4:e70046. https://doi.org/10.1002/brx2.70046

***

### 原文链接

> <https://mp.weixin.qq.com/s/rjMKsVQfk2Lq6P0d1oHHuQ>
