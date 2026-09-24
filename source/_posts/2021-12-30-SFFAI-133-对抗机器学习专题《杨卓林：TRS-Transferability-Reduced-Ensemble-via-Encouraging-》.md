---
title: >-
  SFFAI 133 | 对抗机器学习专题《杨卓林：TRS：Transferability Reduced Ensemble via
  Encouraging...》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
  - 💫其它讲座
abbrlink: 20bd4067
date: 2021-12-30 02:16:29
tags:
---

<iframe src="//player.bilibili.com/player.html?isOutside=true&aid=254492176&bvid=BV1FY411V7ji&cid=518657750&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>

<!--more-->

SFFAI论坛网站已开放注册，详情点击查看：https://bbs.sffai.com/d/312

关注公众号：【人工智能前沿讲习】，回复【SFFAI133】获取讲者PPT资料，入交流群，推荐论文下载。

对抗攻击中的迁移性质指的是，即使一些模型有着不一样的模型架构以及训练过程，针对一个模型生成的对抗样本仍然能成功迁移攻击到另一个模型。为了更好地保护 ML 系统免受对抗性攻击，需要考虑迁移现象产生的充分条件是什么以及如何去控制它？以及有没有办法降低迁移性从而提升整体机器学习模型的鲁棒性？本期我们邀请到了来自伊利诺伊大学香槟分校的杨卓林，对这些问题进行解答。

***

### 讲者介绍

**杨卓林：**伊利诺伊大学香槟分校博士三年级在读，主要研究方向为用额外信息（模型多样性，领域知识等）来提升多模型鲁棒性，对抗攻击中的迁移性质等。目前在一些主流机器学习会议（NeurIPS, ICLR, ICML等）发表论文 5 篇。

**报告题目：**TRS: Transferability Reduced Ensemble via Encouraging Gradient Diversity and Model Smoothness

**报告摘要：**我们首先从理论上分析并概述了模型之间迁移现象产生的充分条件；然后提出一种实用的算法来降低模型之间对抗攻击中迁移现象产生的频率，从而提高其鲁棒性。我们的理论分析表明，仅仅促进子模型梯度之间的正交性不足以确保低迁移性：模型平滑度是控制可迁移性的重要因素。从理论角度出发，我们提供了特定条件下迁移性的下限和上限。同时，受理论分析的启发，我们提出了一种可有效降低迁移性的训练策略（TRS），通过在子模型之间约束两两梯度正交性，同时增加约束模型平滑性的函数来训练得到低迁移性的ML系统。大量的白盒黑盒攻击实验表明，我们所提出的 TRS 显着优于其他基线模型。

**论文题目：**TRS: Transferability Reduced Ensemble via Encouraging Gradient Diversity and Model Smoothness

**分享亮点：**
1. 我们提出了创新性的关于迁移性的定义和分析，并且得到了评估迁移性的理论下界和上界。基于我们给出的理论上界和下界，我们得到了低迁移性的关键变量：梯度的正交性和模型的平滑度。基于这两个变量，我们提出了TRS训练策略；
2. 实验上来说，TRS策略可以达到在特别强的攻击场景下，最好的多模型鲁棒性。

***

### 论文推荐

1. Why Do Adversarial Attacks Transfer? Explaining Transferability of Evasion and Poisoning Attacks [USENIX’19]
    从实验上验证了梯度正交性会和迁移性有很大关联，算是这一块研究的开端。

2. Improving adversarial robustness of ensembles with diversity training. [arxiv]
    比较早的一篇从实验上尝试约束梯度正交性来提升多模型鲁棒性的文章，效果尚可但没有理论依据。

3. Exploiting Joint Robustness to Adversarial Perturbations [CVPR’20]
    基于上一篇，进一步提升基于梯度正交性约束的文章，取得了更好的鲁棒性。这篇文章开始有了一些理论分析为什么梯度正交可以有利于提升鲁棒性。

4. Improving Adversarial Robustness via Promoting Ensemble Diversity [ICML‘19]
    多模型鲁棒性领域比较经典的一篇，一般都默认会和这篇作为基线比较。这篇不是从梯度出发而是从logits出发来提升多模型鲁棒性。他们的实验设置有些小问题。

5. DVERGE: Diversifying Vulnerabilities for Enhanced Robust Generation of Ensembles [NeurIPS’20 Oral]
    熟悉这个领域或者关注NeurIPS的应该肯定有看过这一篇：这篇是基于鲁棒特征来提升多模型鲁棒性的文章：对于鲁棒性较差的子模型，如何去降低他们共有的鲁棒特征是降低迁移性的一个很好的方向。

6. On Adaptive Attacks to Adversarial Example Defenses [NeurIPS’20]
    carlini 大师写的关于对抗攻击防御的现状的很不错的整合文章：其中第十一章着重提到了目前多模型鲁棒性的进展与实际效果。

***

### 参考资料

> <https://www.bilibili.com/video/BV1FY411V7ji/>
