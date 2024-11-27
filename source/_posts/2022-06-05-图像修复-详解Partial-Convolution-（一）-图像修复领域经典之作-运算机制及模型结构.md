---
title: 图像修复-详解Partial Convolution （一） | 图像修复领域经典之作 | 运算机制及模型结构
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫研究领域 Research Area
  - 🛰️计算机视觉 Computer Vision
tags:
  - ☄️图像修复 Image Inpainting
abbrlink: 16681d4d
date: 2022-06-05 05:07:59
---

### 论文信息

- 论文标题：《Image Inpainting for Irregular Holes Using Partial Convolutions》
- 论文链接：[ECCV 2018 Open Access Repository](https://openaccess.thecvf.com/content_ECCV_2018/html/Guilin_Liu_Image_Inpainting_for_ECCV_2018_paper.html)

<!--more-->

***

### 图像修复简介

图像修复(Image Inpainting)，顾名思义，就是将图像中损坏的部分修复起来。该技术可以应用在图像编辑上，例如移除物体(remove unwanted object), 图像补全，修复老照片等。传统的图像修复方法有diffusion-based和patch-based两种，而近些年来的方法多数都是基于深度学习来做的。

{% asset_img 1.webp %}

{% asset_img 2.webp %}

***

### Partial Convolution详解

基于深度学习的图像修复方法在之前基本都是使用卷积神经网络（CNN）来做的，也就是将损坏图片作为输入，完整图片作为标签进行学习。而普通的卷积作用在图片的损坏区域时，大多数的计算都被浪费了，因为损坏区域的像素值为0。同时，卷积核在做计算时不能区分损坏和未损坏的区域，对两部分的信息差并不敏感。

在ECCV2018中，来自NVIDIA的Guilin Liu等人提出了Partial Convolution (PConv)。PConv通过加入mask掩码参与到卷积运算中，大大提升了运算效率，且将损坏与非损坏区域的像素区别开来，提升了其敏感性。

***

#### PConv运算

每一层PConv的运算可以用以下公式来表达：

{% asset_img 3.webp %}

{% asset_img 4.webp %}

***

#### Mask更新

{% asset_img 5.webp %}

***

#### Padding填充

运算过程中还有一个细节：在进行部分卷积操作之前，需要对图像和Mask的边界进行值为0的填充，进行0的填充目的是为了修补的内容不受图像外部无效值的影响。

***

### 网络结构

- 网络的输入大小均为：image 512×512 mask 512×512
- 采用与《Globally and locally consistent image completion》相同的类似U-net的网络结构，将所有的卷积层替换为部分卷积层( partial convolutional layers ),同时在解码器中上采样使用 nearest neighbor up-sampling，同时采用Skips links连接编码器中的feature map。在最后一个部分卷积层将输入图像（带缺失部分）和网络生成的图像结合，将网络生成的图像非缺失部分全部替换为输入图像的非缺失部分。具体网络结构如下：

{% asset_img 6.webp %}
<div align='center'>Partial Convolutional U-Net 网络结构</div>

{% asset_img 7.webp %}
<div align='center'>Partial Convolutional U-Net 网络结构图</div>

***

### 参考资料

> <https://zhuanlan.zhihu.com/p/519446359>
> [1] Image Inpainting for Irregular Holes Using Partial Convolutions
> [2] High-Fidelity Pluralistic Image Completion with Transformers
> [3] Bringing Old Photos Back to Life
> [4] [李文鑫：Partial Convolutions for Image Inpainting](https://zhuanlan.zhihu.com/p/139405565)
