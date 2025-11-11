---
title: SFFAI 25 | 刘永成：Geometric Relation Learning in 3D Point Cloud Analysis
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
abbrlink: 89c95937
date: 2019-04-21 02:57:40
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=52927906&bvid=BV1h4411E7jD&cid=92602954&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

近年来，卷积神经网络（CNN）在图像这类规则数据的处理中获得了举世瞩目的成功，然而如何拓展CNN以分析点云这种不规则数据，仍然是一个开放的研究问题。对于点云而言，每一个点并非孤立存在，相邻的点形成一个有意义的形状，因此对点间关系进行深度学习建模非常重要。

<!--more-->

***

### 讲者介绍

**刘永成：**中科院自动化所，模式识别国家重点实验室15级在读博士，研究兴趣包括三维点云处理、图像分割、场景分类等。以第一作者在CVPR、ACM MM等国际会议上发表论文3篇，国际顶级期刊上发表论文1篇。以第一完成人获国际图像分割竞赛冠军1次，国内目标检测竞赛亚军、季军各一次。

**报告题目：**Geometric Relation Learning in 3D Point Cloud Analysis

**报告摘要：**三维点云来自距离度量空间，这意味着每一个点并非孤立存在，相邻的点形成一个有意义的几何形状。因此，对点间几何关系进行建模非常重要。本次分享将回顾近年来使用深度学习进行点间关系学习的经典论文，并介绍我们的CVPR 2019 Oral工作“Relation-Shape Convolutional Neural Network for Point Cloud Analysis”。我们提出了一种几何关系卷积方法，并用该卷积搭建了一个关系形状卷积神经网络，简称RS-CNN。RS-CNN在三个主流的点云分析任务上均取得了SOTA，同时也具有很好的鲁棒性。并且，RS-CNN不仅能够在三维空间中学习几何关系，还能从二维投影空间中推理几何形状。

**Spotlight：**
1. 回顾点间关系学习的经典论文。
2. CVPR 2019 Oral工作：RS-CNN。

***

### 论文推荐

1. Dynamic Filter Networks

    **推荐理由：**该工作发表于NIPS 2016。在传统卷积网络中，训练后的卷积滤波器权重固定不变。这篇工作提出了一个新卷积框架（图1），在测试阶段，卷积滤波器的权重根据输入数据而动态生成。该卷积框架在视频预测、图数据处理等领域具有非常广泛的应用，尤其是图数据处理，多篇顶会论文的核心idea均来自于此。强烈推荐大家阅读该论文，择需调研引用该论文的文章，相信会受益匪浅。

2. Dynamic Edge-Conditioned Filters in Convolutional Neural Networks on Graphs

    **推荐理由：**该工作发表于CVPR 2017，受到“Dynamic Filter Networks”的启发，提出了一个新颖的图卷积网络，并且第一个将图卷积应用于点云分类。该工作在点云上构建图，将每一个三维点作为图顶点，用三维点坐标定义边属性。卷积滤波器的权重根据输入的三维点以及边属性动态生成，捕获图结构信息，整个流程简单来说就是三维点—图—边属性—卷积权重。该工作构建的图卷积不受图数据不规则性的影响，同时满足卷积操作的范式，非常值得一读。

3. Dynamic Graph CNN for Learning on Point Clouds

    **推荐理由：**该论文于2018年1月就挂在arXiv上，到现在仍未正式发表，但其重要价值不可忽略。该工作也是构建图卷积网络，但动机非常直观：在点云学习中，高维特征空间中邻近的点，其在原始三维空间中所处的局部形状结构也应该相似。基于此，该工作在特征空间中寻找近邻点构建图网络。由于每一层的特征都不同，于是所构建的图在动态变化，因此称为动态图卷积。此外，为了捕获点间关系，该工作提出边缘卷积，即对由每一层特征所构建的边特征进行卷积。这篇论文idea新颖直观，方法简单有效，推荐阅读。

***

### 参考资料

> <https://www.bilibili.com/video/BV1h4411E7jD/>
> <https://bbs.sffai.com/d/63>
