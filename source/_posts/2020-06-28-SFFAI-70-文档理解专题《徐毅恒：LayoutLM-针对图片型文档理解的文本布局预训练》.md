---
title: 'SFFAI 70 | 文档理解专题《徐毅恒：LayoutLM: 针对图片型文档理解的文本布局预训练》'
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
abbrlink: cbf9b6c1
date: 2020-06-28 05:12:16
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=926424519&bvid=BV1cT4y1j73C&cid=214588106&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

<!--more-->

关注微信公众号：【人工智能前沿讲习】，回复【SFFAI70】获取讲者PPT资料，入交流群，推荐论文下载。
文档理解是指对电子文章进行识别后，对其进行分析并建立内容逻辑的任务。将纸质文档转化为电子文档，是许多专业领域在数字化进程需要的关键技术，也具有很高的应用价值和商业价值。本期论坛我们邀请到了来自哈尔滨工业大学的徐毅恒同学，分享他在KDD 2020发表的文档理解方向的最新研究成果，并分享本科生参与科研工作的经验与感悟。

***

### 讲者介绍

**徐毅恒：**哈尔滨工业大学大四本科生，社会计算与信息检索研究中心本科生研究助理，加州大学圣巴巴拉分校访问学生。目前为微软亚洲研究院自然语言计算组实习生。主要方向为多模态信息抽取。实习期间在KDD 2020发表一作论文。

**报告题目：**LayoutLM: 针对图片型文档理解的文本布局预训练

**报告摘要：**近年来，预训练技术已经在各种NLP任务中得到了验证。虽然预训练模型得到了广泛的应用，但是它们几乎只关注文本层面的操作，而忽视了对文档图像理解至关重要的文本布局和样式信息。本次将介绍我们在KDD 2020中的工作：我们提出了LayoutLM来联合建模图片型或富文本文档的文本与布局信息，从而应用于文档理解任务。此外，我们还利用图像特征将文字的视觉信息引入到LayoutLM中。据我们所知，这是首次在同一框架中进行文档级预训练，联合学习文本和布局表示。LayoutLM成功地在几个下游任务中取得了SOTA结果，包括表单理解（从70.72%到79.27%），票据理解（从94.02%到95.24%）和文档图像分类（从93.07%到94.42%）。

**Spotlight：**
1. 本文首次将图片型/富文本文档中的文本和布局信息在同一框架中进行预训练，同时充分利用图像特征。该框架几乎可以利用现有的所有文档类型作为训练数据；
2. LayoutLM以Mask Vision-Language Model和Multi-Label Document Classification作为训练目标，在文档图像理解任务中显著优于几个SOTA预训练模型；
3. 我们将预训练模型和样例代码进行了开源 https://aka.ms/layoutlm。

***

### 论文推荐

1. Chargrid TowardsUnderstanding2DDocuments

    **推荐理由：**本文是较早采用在字符级别进行文本和位置信息对齐来研究文档理解任务的工作，具有启发意义。

2. Graph Convolution for Multimodal InformationExtraction fromVisuallyRichDocuments

    **推荐理由：**本文通过引入图神经网络并同时结合文本和视觉信息，在票据理解任务中取得了显著效果，是文档理解领域较早引入图神经网络的工作。

3. VisualDetectionwithContextforDocumentLayoutAnalysis

    **推荐理由：**本文将对象检测技术Faster R-CNN应用于文档布局检测，并同时结合上下文信息以利用文档的固有局部特性来提高文档布局检测的性能。

4. RobustLayout-awareIEforVisuallyRichDocumentswith Pre-trainedLanguageModels

    **推荐理由：**本文通过引入预训练模型同时结合图神经网络来融合文本和位置信息，并将其应用在表单理解任务中。

5. Spatial Dependency Parsing for 2D Document Understanding. ArXiv, abs2005.00642

    **推荐理由：**当前任务通常将文档理解建模为序列标注问题，但序列化w文档的过程中容易出现文本乱序问题。本文将文档信息抽取任务建模为二维空间构建依存图任务，从而解决了序列标注存在的乱序问题。

6. DocBank ABenchmarkDatasetforDocumentLayoutAnalysis∗

    **推荐理由：**当前的文档分析数据集大部分是针对图像方法进行设计，而没有对文本的相应数据集。针对这一问题，本文通过半监督方法同时提供文本和图像标注，从而解决了图像方法和文本方法的可比较性。

***

### 参考资料

> <https://www.bilibili.com/video/BV1cT4y1j73C/>
