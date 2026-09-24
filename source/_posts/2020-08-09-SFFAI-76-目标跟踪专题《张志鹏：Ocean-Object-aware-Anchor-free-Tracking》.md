---
title: 'SFFAI 76 | 目标跟踪专题《张志鹏：Ocean: Object-aware Anchor-free Tracking》'
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
  - 💫SFFAI
abbrlink: 9de94b53
date: 2020-08-09 05:21:57
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=420519291&bvid=BV1K341127Pr&cid=408625341&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

<!--more-->

关注公众号：【人工智能前沿讲习】，回复【SFFAI76】获取讲者PPT资料，入交流群，推荐论文下载。
本期论坛我们邀请到了来自中科院自动化研究所的张志鹏同学，分享他在ECCV2020的工作，将基于anchor-free的回归网络和基于特征对齐的object-aware分类网络相结合，提高跟踪准确度。同时，讲者将会简单介绍近期在Ocean上的用于视频分割的新工作，实现速度接近前提下，在vot2020[跟踪+分割]远超当前SOTA 11个点的效果。

***

### 讲者介绍

**张志鹏：**中国科学院自动化研究所模式识别国家重点实验室直博生，主要研究方向为目标跟踪，在CVPR2019发表SiamDW (Oral), ECCV2020发表Ocean。

**报告题目：**Ocean: Object-aware Anchor-free Tracking

**报告摘要：**近年在单目标跟踪中基于anchor的算法大放异彩，尤其是在offline算法中处于绝对的统治地位。为了使算法易于收敛，基于anchor的Siamese算法本身在训练时设置了较为严苛的正负样本阈值(IoU>0.6)。但是这种设置固有的问题是：算法在训练时无法“看见”重合度较小的anchor，如果在测试时候分类分支将这样的anchor选为目标区域，那回归网络预测结果将非常差。为了解决问题，我们在论文中提出了基于anchor-free的回归网络，和基于特征对齐的object-aware分类网络。anchor-free回归网络能在较大空间范围内回归出目标区域，同时，其回归得到的目标框给分类网络提供指导使其学习更关注于物体整体的特征。两者相辅相成提高了跟踪的准确度。

另外，基于Ocean的框架，我们在VOT2020比赛中赋予其分割能力，只需要非常少的代码就可以实现在VOT2020中大幅领先当前基于跟踪的分割算法，i.2. online和offline版本分别以18和12个点领先于SiamMask，9/2个点领先于基于D3S，且保持单帧实时(35-40fps)。

**Spotlight：**
1. 提出基于anchor-free的回归网络和基于特征对齐的分类网络，两者相辅相成提高了Siamese跟踪框架的精度。
2. 文章中提出的不对称并行的cross-correlation简单有效的提升了特征匹配的能力。
3. 在VOT2020上的结果证明了我们算法的可扩展性。

***

### 论文推荐

#### 领域前沿

1. A Simple Baseline for Multi-Object Tracking

    **推荐理由：**微软近期的一个多目标跟踪工作，目的是提供一个简单又有效的多目标跟踪pipeline。很推这种文章，不堆砌东西，从简出发。

2. Quasi-Dense Instance Similarity Learning

    **推荐理由：**Jiangmiao Pang近期的一个工作，用简单的双向softmax实现稠密匹配，简洁有效。

3. Tracking by Instance Detection A Meta-Learning Approach

    **推荐理由：**Guangting在CVPR2020中的工作，近期中将meta learning用于跟踪中一个比较好的范例。

#### 领域经典

4. High-Speed Tracking with Kernelized Correlation Filters

    **推荐理由：**相关滤波目标跟踪方向的一个里程碑，利用循环矩阵在频域中特性构建了快速的跟踪算法。

5. SiamFC

    **推荐理由：**开辟了目标跟踪方向连续5年在Siamese目标跟踪算法上的研究热度。

6. ATOM

    **推荐理由：**相关滤波算法的中兴之作，在Siamese逐渐统治领域时杀出重围，将相关滤波算法和前沿检测算法结合，使相关滤波算法重新出现在SOTA舞台。

***

### 参考资料

> <https://www.bilibili.com/video/BV1K341127Pr/>
