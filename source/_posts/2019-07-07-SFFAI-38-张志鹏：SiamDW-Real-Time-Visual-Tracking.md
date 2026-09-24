---
title: SFFAI 38 | 张志鹏：SiamDW Real-Time Visual Tracking
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
  - 💫SFFAI
abbrlink: b649d7f1
date: 2019-07-07 07:26:05
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=58902668&bvid=BV1ut411L7Ru&cid=102676995&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

《SFFAI38-网络结构搜索-单目标跟踪》分享会上讲者张志鹏首先回顾了Siamese跟踪的几篇经典论文；然后介绍了他们在CVPR2019的工作：Deeper and Wider Siamese Networks for Real-Time Visual Tracking；最后分享了关于Siamese跟踪的感悟。

<!--more-->

***

### 讲者介绍

**张志鹏：**中科院自动化所模式识别国家重点实验室，研二，导师胡卫明。暂与微软亚洲研究院合作(包括CVPR19论文)。研究方向为单目标跟踪。

**报告题目：**Deeper and Wider Siamese Network for Real-Time Object Tracking (CVPR2019 Oral)

**报告摘要：**目标跟踪是计算机视觉的基本任务之一，近年来随着大量跟踪数据库如OTB,VOT,LASOT，GOT10K的提出，以及VOT比赛的推广，单目标跟踪领域迅速发展。而这其中siamese跟踪算法由于其在速度和精度之间很好的平衡而逐渐成为单目标跟踪研究中最火的方向。然而在今年之前，siamese跟踪算法仍然是只是基于浅层的AlexNet，深层网络不但没有帮助反而会使效果下降。在CVPR19中，我们通过对网络结构属性的分析，提出网络padding, 感受野, 特征输出大小，stride是影响加深网络的关键。进而我们提出了适用于跟踪siamese网络的crop-in-residual模块，通过堆积模块加深网络，使深层siamese网络在跟踪上效果有了显著提高。Ps：MSRA组里招实习生，有意向请联系houwen.peng@microsoft.com (不限于跟踪很多方向)。

**论文地址：**https://arxiv.org/abs/1901.01660

**论文代码：**https://github.com/researchmm/SiamDW

**Spotlight：**
1. 提出CIR模块结果siamese网络不能加深的问题；
2. 用大量实验分析网络属性对siamese跟踪的影响；
3. 提出设计siamese跟踪网络的guideline。

***

### 论文推荐

1. Fully-Convolutional Siamese Networks for Object Tracking

    **推荐理由:** 在某种意义上SiamFC是SOT里继KCF后的又一个里程碑，发表在ECCVW2016。Siamese tracking的开山之作SINT将目标跟踪定义为一个匹配问题。将所有的proposal对应的特征提取之后与目标特征一一比对，得到最相似的即为最终目标。但是这种方法速度很慢。为了提高速度，SiamFC将特征提取比对的过程抽象成一个卷积层，以模板对应的特征作为卷积核在搜索区域对应的特征上进行滑窗卷积，多快好省的完成了匹配过程。近期流行的Siamese目标跟踪方法本质上都是在其上面做的改进。

2. High Performance Visual Tracking with Siamese Region Proposal Network

    **推荐理由:** 商汤在CVPR2018的SiamRPN是对SiamFC的一个重要改进。SiamFC存在的一个本质问题是无法进行尺度估计，而跟踪中随着时间的变化目标大小形状一直在变化。为了解决这个问题，SiamRPN在SiamFC的基础上增加了一个用于回归目标大小的head，可以将其看成是一个onestage的特定目标检测。速度快，精度高。

3. A Twofold Siamese Network for Real-Time Object Tracking

    **推荐理由:** 2018年ECCV中MSRA的一篇工作。自SiamFC在2016年出来之后，一直到2018年前没有很亮眼的改进。SA-SIAM是继SiamRPN后一篇很有意思的改进。SA-SIAM的思想很简单（就像所有的siamese工作那样），利用双流网络去学习输入图像不同的特征，然后将不同的特征cross-correlation之后的相应图进行fusion得到最后结果。为了保持两支网络的差异化，分别将其在Imagenet和tracking的数据集上进行训练。SA-SIAM的后续改进在VOT-2018 real-time challenge取得了第三名。

4. SPM-Tracker ：Series-Parallel Matching for Real-Time Visual Object Tracking

    **推荐理由:** SA-SIAM团队在2019年CVPR的一篇新工作。其核心思想是将onestage的SiamRPN转成twostage。利用第二个stage refine的结果来进一步提高准确率。值得一提的是在训练时SPM将location的难度分解到两个stage上面。在第一个stage训练时将同类物体都当成正样本，在第二个stage再从这些检测到的同类物体进行精分。降低了传统训练SiamRPN时候直接将target从同时从同类物体和背景中分离的难度。

***

### 参考资料

> <https://www.bilibili.com/video/BV1ut411L7Ru/>
> <https://bbs.sffai.com/d/93-recent-advances-and-highlights-of-nas/3>
