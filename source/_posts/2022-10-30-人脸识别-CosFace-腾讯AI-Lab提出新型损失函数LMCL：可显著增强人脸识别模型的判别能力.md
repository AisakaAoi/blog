---
title: 人脸识别-CosFace 腾讯AI Lab提出新型损失函数LMCL：可显著增强人脸识别模型的判别能力
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫研究领域 Research Area
  - 🛰️计算机视觉 Computer Vision
tags:
  - ☄️人脸识别 Face Recognition
abbrlink: d854f1cb
date: 2022-10-30 10:43:03
---

深度卷积神经网络 (CNN) 已经推动人脸识别实现了革命性的进展。人脸识别的核心任务包括人脸验证和人脸辨识。然而，在传统意义上的深度卷积神经网络的 softmax 代价函数的监督下，所学习的模型通常缺乏足够的判别性。为了解决这一问题，近期一系列损失函数被提出来，如 Center Loss、L-Softmax、A-Softmax。所有这些改进算法都基于一个核心思想： 增强类间差异并且减小类内差异。腾讯 AI Lab 的一篇 CVPR 2018 论文从一个新的角度研究了这个问题，并设计了一个新的损失函数，即增强边缘余弦损失函数 (LMCL)。更具体地说，通过对特征向量和权向量的 L2 归一化，把 softmax 损失函数转化为余弦损失函数，这样做消除了半径方向的变化，并在此基础上引入了一个余弦边缘值 m 来进一步最大化所学习的特征在角度空间的决策边界。因此，采用这种归一化和增强余弦决策边界的方法，能够更有效地起到最大化类间差异和最小化类内差异的作用。作者在最权威的人脸公开测试集上进行了实验评估，这些测试集包括 MegaFace Challenge、YouTube Faces (YTF) 和 Labeled Face in the Wild (LFW)，取得了极其优异的表现，表明了新方法的有效性。

<!--more-->

***

深度卷积神经网络（CNN）的近期进展已经显著提升了多种计算机视觉任务的当前最佳表现，使得深度 CNN 成为了计算机视觉领域主导的机器学习方法。人脸识别是最常见的计算机视觉任务之一，通常包含两个子任务：人脸验证和人脸辨识；其中人脸验证是比较两张人脸以确定它们是否来自同一主体，而人脸辨识是根据人脸图库识别人的身份。这两个任务都涉及到三个阶段：人脸检测、特征提取、分类。深度 CNN 可以提取整齐干净的高层面特征，这使得其可凭借相对简单的分类网络实现优越的表现：通常情况下是后面跟着 softmax 的多层感知器网络。但是，近期的研究发现传统的 softmax 不足以最大化在分类任务上的判别能力。

为了实现更好的判别表现，研究界已经进行了很多研究。所有这些研究在最大化判别能力上都具有一个共同的思想：最大化类间差异且最小化类内差异。

相比于 [1,11,13] 提出的欧几里德边缘（Euclidean margin），角边缘（angular margin）更好，因为角的余弦与 softmax 具有固有的一致性。但是，进一步看，似乎直接在两个不同的类之间引入余弦边缘（cosine margin）会更为自然。此外，余弦的公式与常用于人脸识别的相似度度量是匹配的。从以上角度看，余弦边缘提供了一种用于提升余弦相关的判别信息的直接方法，要优于欧几里德边缘或角边缘。

在这篇论文中，我们通过对特征向量和权重向量的 L2 归一化，把 softmax 损失函数转化为余弦损失函数，从而消除了半径方向上的变化，并在此基础上引入了一个余弦边缘值 m 来进一步最大化所学习的特征在余弦角度空间中的决策边界。具体而言，我们发明了一种巧妙的算法，称为增强边缘余弦损失函数 (LMCL)，其以归一化后的特征为输入，可通过最大化类间余弦边缘来学习高度判别性的特征。

{% asset_img 1.webp %}

图 1：我们提出的 CosFace 框架。在训练阶段，使用不同类之间的增强边缘学习判别性的人脸特征。在测试阶段，首先将测试数据输入 CosFace 来提取人脸特征，然后再将这些特征用于计算余弦相似度分数以执行人脸验证和人脸辨识。

基于 LMCL，我们开发了一种精巧的深度模型 CosFace，如图 1 所示。在训练阶段，LMCL 引导卷积网络使用增强余弦边缘来学习特征。在测试阶段，卷积网络提取出人脸特征，用以执行人脸验证或人脸辨识。我们的贡献总结如下：
1. 我们接受了最大化类间差异和最小化类内差异的思想，提出了一种全新的损失函数 LMCL，可用于为人脸识别学习高度判别性的深度特征。
2. 根据 LMCL 所带来的超球面特征分布，我们提供了一个合理的理论分析。
3. 在 LFW、YTF 和 Megaface 等流行的人脸数据库上，我们提出的方法在大多数基准上都优于之前的最佳表现。

***

### 我们提出的方法

在本章节中，我们将首先详细介绍我们提出的 LMCL。然后我们将给出 LMCL 与其它损失函数的比较，以表明其优越性。然后我们将描述 LMCL 中所使用的特征归一化技术，以阐明其有效性。最后，我们将给出对所提出的 LMCL 的理论分析。

***

### 增强边缘余弦损失函数 (LMCL)

形式上，LMCL 的定义为：

{% asset_img 2.webp %}

使其满足：

{% asset_img 3.webp %}

***

### 与不同损失函数的比较

我们比较了我们的方法（LMCL）与 Softmax、NSL 和 A-Softmax 的决策边界，如图 2 所示。

{% asset_img 4.webp %}

图 2：在两个类别上，不同损失函数的决策边界的比较。虚线表示决策边际线，灰色区域是决策边界。

***

### 在特征上的归一化

在我们提出的 LMCL 中，归一化方案的目的是推导余弦损失函数的形式和消除半径方向上的变化。和 [3] 中仅归一化权重向量不同，我们的方法是同时归一化权重向量和特征向量。因此，其特征会分布在一个超球面上，其中缩放参数（scaling parameter）s 控制着半径大小。

***

### 对 LMCL 的理论分析

{% asset_img 5.webp %}

图 4：不同损失函数在 8 个带有 2D 特征的身份上的简化实验。第一行是将 2D 特征映射到欧几里德空间上，而第二行是将 2D 特征投射到角空间上。随着边缘值 m 增大，间隙变得越来越明显。

***

### 实验

{% asset_img 6.webp %}

图 5：在 LFW 和 YTF 上，具有不同边缘参数值 m 的 CosFace 的表现（%）

{% asset_img 7.webp %}

表 2：我们提出的 LMCL 与人脸识别社区当前最佳的损失函数的比较。这个表格中的所有方法都使用了同样的训练数据和同样的 64 层 CNN 架构。

{% asset_img 8.webp %}

表 3：在 LFW 和 YTF 数据集上的人脸验证表现（%）。#Models 表示评估方法中所使用的模型的数量。

{% asset_img 9.webp %}

表 4：在 Megaface Challenge 1 (MF1) 上的人脸辨识和人脸验证评估。

{% asset_img 10.webp %}

表 5：在 Megaface Challenge 2 (MF2) 上的人脸辨识和人脸验证评估。

***

### 论文：CosFace：用于深度人脸识别的增强边缘余弦损失（CosFace: Large Margin Cosine Loss for Deep Face Recognition）

{% asset_img 11.webp %}

论文地址：<https://arxiv.org/abs/1801.09414>

在深度卷积神经网络（CNN）的发展的推动下，人脸识别已经取得了革命性的进展。人脸识别的核心任务涵盖人脸验证和人脸辨识，都涉及到人脸特征判别。但是，深度 CNN 的传统 softmax 损失通常缺乏判别能力。为了解决这个问题，最近有 Center Loss、L-Softmax、A-Softmax 等一些损失函数被提了出来。所有这些改进算法都基于同一个思想：最大化类间差异并且最小化类内差异。在这篇论文中，我们设计了一种全新的损失函数增强边缘余弦损失函数 (LMCL)，从不同的角度实现了这一想法。具体而言，我们通过对特征向量和权向量的 L2 归一化，把 softmax 损失函数转化为余弦损失函数，这样做消除了半径方向的变化，并在此基础上引入了一个余弦边缘值 m 来进一步最大化所学习的特征在角度空间的决策边界。由此，通过归一化和余弦决策边界的最大化，可实现类间差异的最大化和类内差异的最小化。我们将我们使用 LMCL 训练得到的模型称为 CosFace。为了测试我们的方法，我们在 MegaFace Challenge、YouTube Faces (YTF) 和 Labeled Face in the Wild (LFW) 等最流行的公开域人脸识别数据集上进行了大量实验评估。我们在这些基准实验上实现了当前最佳的表现，这证明了我们的方法的有效性。

***

### 参考资料

> <https://www.jiqizhixin.com/articles/tencent-ai-lab-lmcl>