---
title: SFFAI 72 | 行为理解专题《李永露：PaStaNet：Toward Human Activity Knowledge Engine》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
  - 💫SFFAI
abbrlink: '93199855'
date: 2020-07-12 05:15:16
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=796505813&bvid=BV12C4y1b7bw&cid=219801712&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

<!--more-->

关注公众号：【人工智能前沿讲习】，回复【SFFAI72】获取讲者PPT资料
在“以人为中心的计算”中，根据传感器数据来识别和理解人的动作是关键的一环，而基于视觉的行为识别更是人机交互与感知中的关键。已有行为识别的方法大多基于实例级别的特征或知识进行学习，但对于人与物体交互这种复杂的行为，仅靠这种粗粒度的知识是不够的。SFFAI72期-行为理解专题我们邀请到了来自上海交通大学的李永露同学，分享他在CVPR2020发表的一篇文章，用更细粒度的数据集和两阶段推理方法，对上述问题给出了较好的解决方案。

***

### 讲者介绍

**李永露：**https://dirtyharrylyl.github.io，上海交通大学计算机系三年级在读博士生，研究方向为计算机视觉中的人类行为理解及智能机器人应用，主要的研究问题在于如何利用人类的先验知识和因果推理改善现有的行为理解算法。目前建立了首个大型细粒度人体行为局部语义知识库HAKE（Human Activity Knowledge Engine，http://hake-mvig.cn/），项目主页已有超过25000次访问，包含了多个人类行为识别、人体-物体交互行为检测、物体知识提取，交互人体-物体三维重建等开源项目代码。目前在CVPR、ECCV、ICCV等计算机视觉顶会上发表论文7篇，其中一作5篇，并担任CVPR、NeurIPS、ACCV、WACV、Neurocomputing等会议或期刊的审稿人。

**报告题目：**PaStaNet：Toward Human Activity Knowledge Engine

**报告摘要：**随着近年来深度学习的蓬勃发展，视觉问题中的行为理解取得了很大的进步，但也和大多数模式识别问题一样，目前的视觉系统缺乏可解释性、依赖于大型数据集，在小样本学习和零样本学习下表现不佳。为此，我们提出了Human Activity Knowledge Engine（HAKE，http://hake-mvig.cn/）方案，旨在利用人类的先验知识和因果推理改善上述问题，并且为下一代的行为理解提供一个数据和任务平台。本次介绍的工作为HAKE项目的第一篇文章：PaStaNet，我们提出了一个大型知识库，PaStaNet基于现有的大型人类行为数据库建立，为人类个体行为标注增加了细粒度的人体部位行为状态标签，建立了人体局部状态和整体行为的逻辑关联。通过结合大型自然语言表征提取器Bert，为人体行为理解（图像或视频）建立了一种强大的新型表征，在多个通用大型数据集上取得了较大的性能提升，尤其适用于小样本学习情况下的行为识别。

**Spotlight：**
1. 本文提出了一个大型人体局部行为细粒度语义知识库，在大量图像数据上为常见的约160种行为标注了人体局部状态标签；
2. 通过将传统的直接推理改为两阶段推理，即像素到人体局部状态再到行为概念，我们利用PaStaNet中的大量知识，大幅提升了小样本学习下的行为理解性能，并论证了两阶段推理在目前多个大型基准数据集上的性能提升空间；
3. 在提升行为理解性能的同时，基于PaStaNet中的视觉-语言知识，我们还提出了一个通用的行为表征提取器Activity2Vec，可以同时运用于行为检测、语言描述、检索等多个下游任务。

***

### 论文推荐

1. Visual Relationship Detection with Language Priors

    **推荐理由：**首次提出了基于视觉的物体关系理解任务，为更深层次的图像理解提供了重要的研究方向。

2. Learning to Detect Human-Object Interactions

    **推荐理由：**提出了human-object interaction检测领域重要的大型数据集HICO-DET，目前已成为HOI检测领域的重要基准。

3. AVA A Video Dataset of Spatio-temporally Localized Atomic Visual Actions

    **推荐理由：**提出了视频行为理解和人体-物体交互检测上的首个大型实例级别数据集，目前已成为视频行为检测中的重要基准。

4. Beyond Holistic Object RecognitionEnriching Image Understanding with Part States

    **推荐理由：**提出了细粒度的物体局部状态概念，为图像中的实体理解和物体关系检测提供了更细粒度的离散状态语义描述。

5. Detecting and Recognizing Human-Object Interactions

    **推荐理由：**针对HOI检测任务提出了一个完整的检测框架，并研究了基于人体信息搜索交互物体空间位置分布的拟合算法。

6. Transferable Interactiveness Knowledge for Human-Object Interaction Detection

    **推荐理由：**针对HOI检测中复杂度较高的人体-物体穷举匹配，提出了交互性检测算法，并利用交互性分类结果对匹配图进行剪枝，可有效减少无交互配对并提高检测性能。

***

### 参考资料

> <https://www.bilibili.com/video/BV12C4y1b7bw/>
> <https://bbs.sffai.com/d/167-pastanettoward-human-activity-knowledge-engine>
