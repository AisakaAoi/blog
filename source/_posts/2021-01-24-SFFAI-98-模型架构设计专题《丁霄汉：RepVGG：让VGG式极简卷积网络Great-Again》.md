---
title: SFFAI 98 | 模型架构设计专题《丁霄汉：RepVGG：让VGG式极简卷积网络Great Again》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
  - 💫SFFAI
abbrlink: 8b04a71a
date: 2021-01-24 21:49:17
tags:
---

<iframe src="//player.bilibili.com/player.html?isOutside=true&aid=721123634&bvid=BV1TQ4y1z7eA&cid=423795396&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>

<!--more-->

关注公众号：【人工智能前沿讲习】，回复【SFFAI98】获取讲者PPT资料，入交流群，推荐论文下载。

如何设计一个高性能且实用的网络架构是一项有趣且有重大意义的研究问题。本期我们邀请到了来自清华大学的丁霄汉同学，介绍他设计的一种VGG式单路极简卷积网络架构，这种架构实现简单、速度快、性能高，可以仅通过堆加数个卷积层就实现原有模型的精度提升。

***

### 讲者介绍

**丁霄汉：**清华大学在读博士生，导师为丁贵广副教授。主要研究方向为卷积神经网络的设计与优化。曾在CVPR,ICML,ICCV,NeurIPS等会议上作为第一作者发表论文5篇。曾获2019年百度奖学金。RepVGG是在旷视科技实习期间和张祥雨博士等人合作的工作。

**报告题目：**RepVGG：让VGG式极简卷积网络Great Again

**报告摘要：**我们提出一种VGG式单路极简卷积网络架构，一路3×3卷到底，在速度和性能上达到SOTA水平，在ImageNet上超过80%正确率。这一架构是用“结构重参数化”方法实现的，训练时模型具有多分支结构，训练完成后等价转换为单路3×3卷积架构。

**Spotlight：**
1. 提出的是一种极其简单、非常实用、速度快、性能高的通用卷积神经网络架构；
2. 不用NAS，不用attention，不用各种新颖的激活函数，甚至不用分支结构，只用3×3卷积和ReLU，也能达到SOTA性能；
3. “结构重参数化”方法的实现非常简单，写成代码不过三十行。

***

### 论文推荐

#### 经典论文

1. VERY DEEP CONVOLUTIONAL NETWORKS FOR LARGE-SCALE IMAGE RECOGNITION

    **推荐理由：**经典VGG架构。

2. Deep Residual Learning for Image Recognition

    **推荐理由：**ResNet的shortcut是本文灵感来源之一。

3. Aggregated Residual Transformations for Deep Neural Networks

    **推荐理由：**ResNeXt是众多现代ResNet类模型（如RegNet）的基础。

#### 前沿论文

4. Designing Network Design Spaces

    **推荐理由：**RegNet使用大量人工迭代设计的方法优化卷积网络架构。

5. EfficientNet Rethinking Model Scaling for Convolutional Neural Networks

    **推荐理由：**NAS+复合缩放策略。

6. ShuffleNet V2 Practical Guidelines for Efficient CNN Architecture Design

    **推荐理由：**实用高效网络设计的诸多思考和指导原则。

***

### 参考资料

> <https://www.bilibili.com/video/BV1TQ4y1z7eA/>
