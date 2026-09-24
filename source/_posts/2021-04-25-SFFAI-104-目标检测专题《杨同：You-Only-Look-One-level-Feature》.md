---
title: SFFAI 104 | 目标检测专题《杨同：You Only Look One-level Feature》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
  - 💫SFFAI
abbrlink: 665997fa
date: 2021-04-25 22:18:23
tags:
---

<iframe src="//player.bilibili.com/player.html?isOutside=true&aid=976681585&bvid=BV1F44y1v7bw&cid=442644351&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>

<!--more-->

关注公众号：【人工智能前沿讲习】，回复【SFFAI104】获取讲者PPT资料，入交流群，推荐论文下载。

特征金字塔（Feature Pyramid Networks, FPN）是一种利用常规CNN模型来高效提取图片中各维度特征的方法，可以用于解决识别尺寸差异很大的物体的问题。它对每一种尺度的图像进行特征提取，能够产生多尺度的特征表示，并且所有等级的特征图都具有较强的语义信息，甚至包括一些高分辨率的特征图。

论坛网站：https://bbs.sffai.com/

***

### 讲者介绍

**杨同：**北京旷视科技有限公司basemodel组研究员，主要研究方向为通用物体检测，目前在 NeurIPS、CVPR、AAAI等会议上发表论文6篇。

**报告题目：**You Only Look One-level Feature

**报告摘要：**目前，FPN是通用物体检测的一个重要组件，有效提升了物体检测的性能。但是，现有工作都是基于两阶段方法中对FPN的理解，认为FPN的主要作用是不同层级的特征融合。而对于单阶段检测方法中，却很少有工作深入分析FPN成功的原因。本文从优化角度对FPN进行了分解，指出分治思想是FPN在单阶段检测中成功的至关重要的因素。然而，在单阶段检测中，FPN带来的在多层级特征上检测的范式，大大增大了模型的计算量与减慢了模型推理速度。考虑到FPN带来的副作用，我们提出一种不同于原先多层级特征检测的方法: YOLOF，该方法采用基于单个层级特征(C5)的检测模式。它包括两个模块: 多尺度编码器(Dilated Encoder)和一致性匹配策略(Uniform Matching)。该模型在COCO数据集上的性能可以达到基于FPN的检测模型并且推理速度更快。与DETR相比，YOLOF可以在⅐的训练轮数下达到差不多一致的性能。除此之外，相对YOLOv4，YOLOF(60FPS)可以达到44.3 mAP，在精度和速度上超过YOLOv4。

**Spotlight：**
1. 不同于FPN现有认知: 多层级特征融合是FPN的关键，本文指出FPN中的分治思想是单阶段检测模型成功的因素；
2. 本文提出了一种基于单个层级特征(C5) 的单阶段检测模型。该模型可以达到基于FPN的检测模型的性能但是推理速度更快；
3. 本文为通用物体检测提供了一个新方向: 如何充分挖掘单个层级特征的表示能力。

***

### 论文推荐

1. YOLOv4 Optimal Speed and Accuracy of Object Detection

    **推荐理由：**这篇论文对目前通用物体检测领域所用到的模块和技术有一个综述性的概括。同时，它在追求速度的同时在精度上达到了state-of-the-art的性能。

2. Scaled-YOLOv4 Scaling Cross Stage Partial Network

    **推荐理由：**这篇论文基于YOLOv4从网络结构角度出发提出了3种不同大小的通用物体检测模型，均达到了实时高精度，有很好的实用价值。

3. End-to-End Object Detection with Transformers

    **推荐理由：**这篇论文提出了一种端到端的通用物体检测模型。它摒弃了人为设计(Anchor、NMS等)，提供了一个通用检测的新思路。

4. Feature Pyramid Networks for Object Detection

    **推荐理由：**这是一篇经典通用物体检测文章。它提出了FPN，极大解决了如何检测小物体的问题，提升了检测模型的整体性能。

5. Focal Loss for Dense Object Detection

    **推荐理由：**这篇论文是单阶段物体检测的经典。它提出了Focal Loss，解决了单阶段物体检测中正负样本不均衡的现象。

6. FCOS Fully Convolutional One-Stage Object Detection

    **推荐理由：**这是一篇经典的物体检测文章。它定义了一种物体检测的方法: anchor-free method，为物体检测提供了新思路。

***

### 参考资料

> <https://www.bilibili.com/video/BV1F44y1v7bw/>
