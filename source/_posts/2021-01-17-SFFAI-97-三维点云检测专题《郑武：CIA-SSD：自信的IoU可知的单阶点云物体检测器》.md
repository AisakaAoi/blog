---
title: SFFAI 97 | 三维点云检测专题《郑武：CIA-SSD：自信的IoU可知的单阶点云物体检测器》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
abbrlink: b57c0a3c
date: 2021-01-17 21:42:09
tags:
---

<iframe src="//player.bilibili.com/player.html?isOutside=true&aid=933374578&bvid=BV1cT4y1f7vx&cid=416412235&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>

<!--more-->

关注公众号：【人工智能前沿讲习】，回复【SFFAI97】获取讲者PPT资料，入交流群。

我们提出了一种新的单阶物体检测器，称为自信的IoU可知的单阶物体检测器（CIA-SSD）。首先，我们设计了轻量的空间语义特征聚合模块，以自适应地融合高级抽象语义特征和低级空间特征，用于准确预测边界框和分类置信度。另外，使用我们设计的IoU可知的置信度校正模块可以进一步校正预测的置信度，以使置信度与定位精度更加一致。基于校正后的置信度...

***

### 讲者介绍

**郑武：**香港中文大学二年级博士研究生，本科毕业于清华大学自动化系，主要研究方向是自动驾驶场景下基于点云的三维物体检测。

**报告题目：**CIA-SSD：Confident IoU-Aware Single Stage Object Detector From Point Cloud

**报告摘要：**我们提出了一种新的单阶物体检测器，称为自信的IoU可知的单阶物体检测器（CIA-SSD）。首先，我们设计了轻量的空间语义特征聚合模块，以自适应地融合高级抽象语义特征和低级空间特征，用于准确预测边界框和分类置信度。另外，使用我们设计的IoU可知的置信度校正模块可以进一步校正预测的置信度，以使置信度与定位精度更加一致。基于校正后的置信度，我们进一步构造了距离可变的IoU加权NMS，以获得更平滑的回归并避免冗余的预测。我们将CIA-SSD在KITTI测试集中对3D汽车检测进行了测试，结果表明，它在官方排名尺度(Moderate AP)上取得了最高性能, 并达到了32 FPS的实时推理速度，优于所有以前的单阶段检测器。论文的代码在: https://github.com/Vegeta2020/CIA-SSD

**Spotlight：**
1. 本文提出了一种适用于单阶物体检测器的IoU可知的置信度校正模块；
2. 本文设计了一种轻量的空间语义聚合模块以提取更加鲁棒的BEV特征；
3. 本文构造了考虑深度因素的DI-NMS方法用于获取更加平滑的边界框回归并避免冗余的预测框；
4. 我们所提出的CIA-SSD是目前KITTI数据集上性能最优的单阶物体检测器。

***

### 论文推荐

1. CIA-SSD Confident IoU-Aware Single-Stage Object Detector From Point Cloud

    **推荐理由：**目前KITTI汽车检测上性能最佳的单阶点云物体检测器，具有最高的检测精度和超高的检测效率，目前已在Github放出源码。

2. Structure Aware Single-stage 3D Object Detection from Point Cloud

    **推荐理由：**这篇论文是我们论文之前的最优单阶点云物体检测器，它通过设计基于点云分割和回归的辅助任务，在获取结构信息更加丰富的特征的同时，并未降低检测效率。

3. 3DSSD Point-based 3D Single Stage Object Detector

    **推荐理由：**这篇论文融合了基于点坐标间距离和点特征间距离的采样策略用于点云的下采样，并采用一种3D中心分配策略用于计算回归目标，结合无anchor的检测头，取得了较好的性能。

4. SECOND Sparsely Embedded Convolutional Detection

    **推荐理由：**基于稀疏卷积的backbone大幅提升了网络检测的效率，它所提出的ground truth增广策略也得到大量后续检测工作的直接沿用。

5. VoxelNet End-to-End Learning for Point Cloud Based 3D Object Detection

    **推荐理由：**比较早期的将点云体素化后用3D和2D卷积层提取特征的检测器，奠定了基于体素的检测器的基础。

6. PV-RCNN Point-Voxel Feature Set Abstraction for 3D Object Detection

    **推荐理由：**目前在KITTI数据集上性能最优的二阶检测器，这篇文章在聚合第一阶网络所提取的特征用于第二阶网络的预测修正上所采用的方法比较有代表性。

***

### 参考资料

> <https://www.bilibili.com/video/BV1cT4y1f7vx/>
> <https://bbs.sffai.com/d/217-cia-ssdconfident-iou-aware-single-stage-object-detector-from-point-cloud>
