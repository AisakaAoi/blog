---
title: 人脸识别-人脸识别系列（十七）：ArcFace/Insight Face
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
abbrlink: e608b8f
date: 2022-11-03 06:25:35
---

论文链接：[ArcFace: Additive Angular Margin Loss for Deep Face Recognition](https://arxiv.org/abs/1801.07698)

作者开源代码：<https://github.com/deepinsight/insightface>

这篇论文原名是ArcFace，但是由于与虹软重名，后改名为Insight Face。

其实这篇论文可以看作是AmSoftmax/CosFace的一种改进版本，总体思路相对较为简单。

### AmSoftmax

{% asset_img 1.webp %}

### Arcface

{% asset_img 2.webp %}

这样修改的**原因**：

**角度距离比余弦距离在对角度的影响更加直接**

<!--more-->

决策边界的具体比较如下图

{% asset_img 3.webp %}

***

### IR

除了损失函数的改进之外，作者还提出了一种称为IR的网络结构，就是对Resnet的block进行了一些改进，文章说更适合对人脸图片的训练了

{% asset_img 4.webp %}

***

### 实验

使用了几种网络结构作实验，包括MobileNet、 Inception-Resnet-V2、Densely connected convolutional networks(DenseNet)、Squeeze and excitation networks(SE) 和Dual path Network (DPN)

实验结果如下：

#### lfw得分

{% asset_img 5.webp %}

#### MegaFace得分

{% asset_img 6.webp %}

截止至2018年3月，是MegaFace榜第一，达到了98.36%的成绩，但是因为作者对动了MegaFace中的数据，将FaceScrub与MegaFace1M干扰项中重叠的部分去除了，（这也就是表中R的含义），因此不能体现该算法对其他算法有绝对的优势。

即便如此，这篇论文以及作者开源的代码对人脸识别研究做出的贡献也是不可磨灭的。

***

### 参考资料

> 版权声明：本文为CSDN博主「Fire_Light_」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
> 原文链接：https://blog.csdn.net/Fire_Light_/article/details/79602705
