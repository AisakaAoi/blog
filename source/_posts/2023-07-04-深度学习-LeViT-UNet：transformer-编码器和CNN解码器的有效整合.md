---
title: LeViT-UNet：Transformer编码器和CNN解码器的有效整合
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: 74c52285
date: 2023-07-04 01:18:32
tags:
---

levi - unet[2]是一种新的医学图像分割架构，它使用transformer 作为编码器，这使得它能够更有效地学习远程依赖关系。levi - unet[2]比传统的U-Nets更快，同时仍然实现了最先进的分割性能。

levi - unet[2]在几个具有挑战性的医学图像分割基准上取得了比其他法更好的性能，包括Synapse多器官分割数据集(Synapse)和自动心脏诊断挑战数据集(ACDC)。

### LeViT-UNet架构

levi - unet的编码器使用LeViT块构建，设计用于高效和有效地学习全局特征。解码器是使用卷积块构建的。

{% asset_img 1.webp %}

<!--more-->

编码器从多个分辨率的输入图像中提取特征映射。这些特征映射被上采样，连接然后通过跳过连接传递到解码器。跳过连接允许解码器从编码器访问高分辨率的局部特征，有助于提高分割性能。

这种设计使模型能够综合transformer 和 cnn 的优点。transformer 刚擅长学习全局特征，而cnn擅长学习局部特征。通过结合这两种方法，levi - unet能够获得良好的分割性能，同时也相对高效。

***

#### LeViT编码器

编码器采用LeViT[1]，主要由两个部分组成:卷积块和变压器块。卷积块通过对输入图像应用4层3x3卷积(步幅为2)来执行分辨率降低。在提取更多抽象特征的同时，这将图像的分辨率降低了一半。然后transformer块获取卷积块的特征映射并学习全局特征。

在编码器的最后阶段将来自卷积块和变压器块的特征连接起来。这使得编码器具有本地和全局特性。局部特征对于识别图像中的小而详细的物体很重要，而全局特征对于识别图像的整体结构很重要。通过结合局部和全局特征，编码器能够生成更准确的分割。

根据输入第一个transformer块的通道数量，开发了3个LeViT编码器:levi-128s, levi-192和levi-384。

{% asset_img 2.webp %}

***

#### CNN解码器

levi - unet的解码器将编码器的特征与跳过连接连接在一起。使得解码器能够从编码器访问高分辨率的局部特征，并采用级联上采样策略，利用cnn从前一层恢复分辨率。它由一系列上采样层组成，每个上采样层后面是两个3x3卷积层，一个BN和一个ReLU层。

***

### 实验结果

实现细节:数据增强(随机翻转和旋转)，优化器(Adam，学习率1e-5，权重衰减1e-4)，图像大小224x224，批大小8,epoch 350和400用于Synapse和ACDC数据集

LeViT模型优于现有模型，并且明显快于TransUNet，后者将Transformer块合并到CNN中。

{% asset_img 3.webp %}

上图显示了TransUNet、UNet、DeepLabv3+和levi -UNet四种不同方法的定性分割结果。其他三种方法更可能导致器官不足或者过度分割。例如，胃被TransUNet和DeepLabV3+分割不足(如上行第三个面板的红色箭头所示)，被UNet过度分割(如第二行第四个面板的红色箭头所示)。

与其他方法相比，论文提出的模型输出相对平滑，表明在边界预测方面更具优势。

{% asset_img 4.webp %}

***

### 参考资料

> <https://mp.weixin.qq.com/s?__biz=MzU5OTM2NjYwNg==&mid=2247502654&idx=1&sn=a0e39cb619df3084e73e89a2ff791a69>
> [1] Benjamin Graham, Alaaeldin El-Nouby, Hugo Touvron, Pierre Stock, Armand Joulin, Herv’e J’egou, Matthijs Douze, LeViT: a Vision Transformer in ConvNet’s Clothing for Faster Inference, 2021. <https://arxiv.org/abs/2104.01136>
> [2] Guoping Xu, Xingrong Wu, Xuan Zhang, Xinwei He, LeViT-UNet: Make Faster Encoders with Transformer for Medical Image Segmentation, 2021. <https://arxiv.org/abs/2107.08623>
