---
title: 团队成员陈荣滔等在IEEE TNSRE发表脑机接口情绪识别的研究成果
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫团队成果
abbrlink: 72581fc0
date: 2025-08-23 22:21:15
tags:
---

近日，脑机团队大二本科生陈荣滔、谢楚雯和张嘉慧在潘家辉教授、游琪副研究员指导下的研究成果“A Progressive Multi-Domain Adaptation Network with Reinforced Self-Constructed Graphs for Cross-Subject EEG-Based Emotion and Consciousness Recognition”被中国人工智能学会（CAAI）的B类推荐期刊IEEE Transactions on Neural Systems and Rehabilitation Engineering（中科院康复医学一区，IF=5.2）录用。本论文于2025年3月7日投稿，2025年8月23日录用。

<!--more-->

情绪识别技术在脑机接口领域能发挥重要作用，但受限于个体差异与数据跨域特性，存在两大核心瓶颈：一是难以提取既保留情绪信息又具跨域普适性的特征，二是不同个体间的联合概率分布难对齐。为此，我们提出了一种创新的基于强化学习的自构图多域适应网络（如图1所示），为该领域带来突破性进展。

我们引入强化自构图模块，基于强化学习机制，动态构建适应性图表示，精准捕捉脑电图数据特征，实现领域不变神经特征的高效提取，如图2所示。同时，开创性地提出EEG-CutMix策略，融合余弦相似性筛选相似个体、通道保留动态CutMix技术生成混合样本，并巧妙融入高斯噪声，全方位提升数据鲁棒性。此外，搭建增强数据驱动的PMDA框架，借助动态调度机制逐步对齐分布，配合多目标损失函数实现个体间联合概率分布精准对齐，从多维度攻克技术难关。更值得一提的是，该域适应框架已成功应用于南方医科大学珠江医院12位意识障碍患者的意识水平检测中，为临床神经康复领域开辟全新技术路径，彰显了其在实际医疗场景中的巨大潜力。

{% asset_img 1.webp %}
<div align='center'>图1：模型整体框架图</div>

{% asset_img 2.webp %}
<div align='center'>图2：强化自构图模块详细结构</div>

为了直观地展示模型的分类性能，该论文绘制了模型的AUC和ROC曲线（如图3所示）。从图中可以看出，该模型展现出快速的学习能力和强大的分类性能，其AUC分数在训练过程中迅速收敛至较高水平。最终的ROC曲线也进一步验证了这一结果。具体来说，在SEED数据集上获得0.983的平均分数，在SEED-IV数据集上获得0.961的平均分数。

{% asset_img 3.webp %}
<div align='center'>图3：AUC和ROC曲线</div>

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=17260>
