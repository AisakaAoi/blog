---
title: SFFAI 65 | 目标跟踪主题《许胤达：SiamFC++：视觉目标跟踪器设计的指导准则》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
abbrlink: 22fca189
date: 2020-05-24 05:02:09
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=925970775&bvid=BV1NT4y1J7R5&cid=199738912&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

<!--more-->

关注微信公众号：【人工智能前沿讲习】，回复【SFFAI65】获取讲者PPT资料，入交流群，推荐论文下载。

目标跟踪是计算机视觉中的一项重要任务, 是指对图像序列中的目标状态进行持续推断的过程。此项技术在军事和民用方面都有着十分广泛的应用, 军事方面包括无人飞行器、精确制导、空中预警、战场监视等；民用方面包括智能视频监控、人机交互、机器人视觉导航、虚拟现实、医学诊断等。本期论坛我们邀请到了来自浙江大学的许胤达，来分享他在视觉目标跟踪器方向上的研究成果。

***

### 讲者介绍

**许胤达：**浙江大学电气工程学院在读硕士，主要研究方向为单目标跟踪/视觉目标跟踪。2019年在旷视科技实习期间发表AAAI-20一篇（共一），并参与VOT Challenge 2019获得实时跟踪赛道第二名。

**报告题目：**SiamFC++：视觉目标跟踪器设计的指导准则

**报告摘要：**视觉跟踪问题要求在给定跟踪目标的情况下，完成鲁棒的分类和精确的出框。现有方法提出了多种出框方式，但是很少有人考虑了跟踪问题的任务特点。基于仔细的分析，我们提出了一套实用的指导准则来指导高性能通用目标跟踪器的设计。遵循这些准则，我们设计了我们的SiamFC++跟踪器，同时（G1）引入没有歧义的打分分支（G2）和不依赖目标数据先验的出框分支（G3），并对出框质量进行评估（G4）。详尽的分析和消融实验验证了设计准则的有效性。我们的跟踪器在各大主流数据集上达到甚至超过State-of-the-Art的性能。

**Spotlight：**
1. 本文分析了当时已有跟踪方法，提出了指导跟踪器设计的指导准则；
2. 本文基于指导准则设计了跟踪器，并且通过主流数据集上的实验验证了准则的有效性；
3. 本文将提出的应用了准则的跟踪器与没有应用准则的跟踪器做了对比和分析，解释了性能提升的来源。

***

### 论文推荐

#### 经典论文

1. Fully-Convolutional Siamese Networks for Object Tracking [Luca Bertinetto, et al.]

    **推荐理由：**这是一篇孪生网络应用于视觉目标跟踪的早期工作之一，首次通过feature map之间的互相关操作，简洁地完成了模板匹配。后续孪生网络的模板匹配操作几乎都来源于此。工作中提出的预处理、后处理等细节设计也为后续工作所延用。
    值得一提的是我们工作也是可以理解为对SiamFC的per-pixel scoring的继承及其有效的拓展。消融实验介绍了SiamFC演化至SiamFC++的性能变化过程。
 
2. High Performance Visual Tracking with Siamese Region Proposal Network [Bo Li, et al.]

    **推荐理由：**这篇孪生网络跟踪器的工作从one-shot detection的视角看待单目标跟踪任务，首次引入检测中的bbox regressor来完成目标尺寸的估计，大大提升了跟踪器的精度。同时验证了模板匹配后的完成多任务（打分/回归出框）的可能性。
 
3. ATOM Accurate Tracking by Overlap Maximization [Martin Danelljan, el al.]

    **推荐理由：**这篇工作将目标跟踪中的目标粗定位（分类）和尺寸估计（出框）两个子任务解耦，前者继承了相关滤波方法的思路，对粗定位的滤波器进行在线更新；后者引入IoU-Net，和分类分支解耦，完成精准的出框。该方法对跟踪性能提升非常明显，开创了一个全新的跟踪框架。

#### 近期论文

4. Siam R-CNN Visual Tracking by Re-Detection [Paul Voigtlaender, et al.]

    **推荐理由：**这篇工作引入了多目标跟踪（MOT）的思路，对所有candidate (target / distractor)的轨迹都进行了跟踪，维护一段memory，并在memory上通过动态规划的方式选出目标。这种在时间维度上完成的推理极大提升了跟踪器的鲁棒性，使其在各大主流数据集上（特别是不带重启的OPE数据集）获得了很显著的性能提升。
 
5. Probabilistic Regression for Visual Tracking [Martin Danelljan, et al.]

    **推荐理由：**这篇工作在DiMP的基础上提出了一种新颖的回归方式，训练网络预测输入和输出的联合分布概率，然后固定输入，调整输出，通过优化的方式完成对目标尺寸的估计。和先前的IoU-Net相比，该回归方式完成对不确定性建模，从而能更为鲁棒地应对跟踪过程中的遮挡、模糊等难例。值得关注的是，这种新颖的回归方式是通用的，可以泛化到其他涉及回归目标的任务（检测、年龄回归等）。c.f. DCTD: Deep Conditional Target Densities for Accurate Regression
 
6. Tracking Holistic Object Representations [Axel Sauer, et al.]

    **推荐理由：**这是一篇专注于孪生网络跟踪器的模板库维护策略的工作，提出了一种有效的模板库更新策略。其中长时模板专注于提升模板库的多样性（e.g. 偏好收集目标不同朝向的模板），短时模板则关注目标的实时变化。提出的方法不需要对网络进行重新训练就能提升跟踪器的性能。

***

### 参考资料

> <https://www.bilibili.com/video/BV1NT4y1J7R5/>
