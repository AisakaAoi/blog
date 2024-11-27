---
title: 人脸识别-人脸识别系列（十六）：AMSoftmax
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫研究领域 Research Area
  - 🛰️计算机视觉 Computer Vision
tags:
  - ☄️人脸识别 Face Recognition
abbrlink: 2f45f198
date: 2022-11-02 06:41:49
---

论文链接：[Additive Margin Softmax for Face Verification](https://arxiv.org/abs/1801.05599)

（2019.1.24：注：腾讯AI Lab的 CosFace: Large Margin Cosine Loss for Deep Face Recognition和本文算法基本一致，工作也几乎是同时完成，两篇论文也都各自中了不同的会议。）

### AMSoftmax

#### Softmax

{% asset_img 1.webp %}

<!--more-->

#### ASoftmax

{% asset_img 2.webp %}

这是在SphereFace中提出来的损失函数

{% asset_img 3.webp %}

#### AMSoftmax

这就是本文新提出的损失函数了。其变化就在于修改了Cos(mθ)为一个新函数：

{% asset_img 4.webp %}

与ASoftmax中定的的类似，可以达到减小对应标签项的概率，增大损失的效果，因此对同一类的聚合更有帮助

然后根据Normface，对f进行归一化，乘上缩放系数s，最终的损失函数变为：

{% asset_img 5.webp %}

这样做的好处在于ASoftmax的倍角计算是要通过倍角公式，反向传播时不方便求导，而只减m反向传播时导数不用变化

***

### 角度距离与余弦距离

作者认为，Asoftmax是用m乘以θ，而AMSoftmax是用cosθ减去m，这是两者的最大不同之处：一个是**角度距离**，一个是**余弦距离**。

使用传统的Softmax的时候，角度距离和余弦距离是等价的，即

{% asset_img 6.webp %}

但是当我们试图要推动决策边界的时候，角度距离和余弦距离就**有所不同**了。

最终的决策边界是和余弦相关的，根据cos的性质，优化角度距离比优化余弦距离更有效果，因为余弦距离相对更密集

之所以选择cosθ-m而不是cos（θ-m），这是因为我们从网络中得到的是W和f的内积，如果要优化cos（θ-m）那么会涉及到arccos操作，计算量过大。

***

### 特征归一化

这里提到了一个归一化特征的重要目的：

高质量的图片提取出来的特征范数大，低质量的图片提取出来的特征范数小，如图：

{% asset_img 7.webp %}

这是因为Softmax的目标是尽可能最大化正确分类的概率，它会忽略掉一些比较难分辨的图片：也就是低质量的图片，而优先拟合高质量的图片
因此把特征强行归一化会使得低范数的图片变得高范数，也会获得更多的网络的注意力。

（这和tripletloss刻意去挖掘难以识别的图片的最终结果是一样的，方法不一样而已）

{% asset_img 8.webp %}

这张图说明的是特征归一化之后，原来范数比较小的特征会获得更大的梯度，对应于normface中的求导式：

{% asset_img 9.webp %}

***

### 实验

#### 网络

20层Resnet

#### 参数

We set the weight decay parameter to be 5e.4. The batch size is 256 and the learning rate begins with 0.1 and is divided by 10 at the 16K, 24K and 28K iterations

#### 训练集

CASIA-Webface

#### 验证方式

图片与其镜像图片提取出来的特征对应相加，比较余弦距离

#### 结果

{% asset_img 10.webp %}

不使用特征归一化，在高质量图片集（LFW）上结果更好

使用特征归一化，在具有很多低质量的图片集（MegaFace）上结果更好。

***

### 参考资料

> 版权声明：本文为CSDN博主「Fire_Light_」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
> 原文链接：https://blog.csdn.net/fire_light_/article/details/79602310
