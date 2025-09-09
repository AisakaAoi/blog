---
title: 学习报告：用于图像和视频识别的Transformer
categories:
  - 🌙进阶学习
  - ⭐脑机接口与混合智能研究团队（BCI团队）
  - 💫学习报告
abbrlink: c743ff6b
date: 2022-07-30 04:23:22
tags:
---

本次分享的学习报告主要围绕2021年在ICLR上发表的《An Image is Worth 16x16 Words: Transformers for Image Recognition at Scale》[1] (ViT)以及2021年ICCV上发表的《ViViT: A Video Vision Transformer》[2](ViViT)进行讲解。通过对这两篇论文的讲解，分析在NLP领域大放异彩的Transformer模型结构是如何使用在CV领域的。

<!--more-->

***

### 研究背景和内容

近几年，Transformer架构模型凭借其self-attention的特点在NLP领域取得了非常好的成果，但其在计算机视觉中的应用仍然受到限制，比如一张图片往往是二维的，而Transformer的输入是一维的序列，所以Transformer架构能否同样适用于视觉领域，成为除卷积网络外的又一主干网络变成当时的一大热点问题。

***

### 提出的方法

#### 运用在图像中的Transformer：Visual Transformer (ViT)

如图1所示，ViT模型的输入遵循基本Transformer的模式，是1维的token embedding。原始图片被切片成N个设定好尺寸大小的patch(这里是16*16)，将二维的图像转换为N*768(16*16*3)的序列，并将每个patch线性映射为一个token，同时增加一个可以训练的cls token用作最后的分类处理，即最终的token输入数量为(N+1)。

为了保留切分为多个patch后原始图片的位置顺序，ViT遵循NLP中Transformer的位置编码思想，为每一个token提供可以训练的Positional Encoding。每一个Positional Encoding的长度和token的长度一致，并直接与对应token进行求和，作为Transformer Encoder的输入。

Transformer Encoder主要由Multi-Head Attention (MHA)和Multilayer Perceptron (MLP)构成，其重点在于可以获取全局性特征的MHA。MHA是由多个含有self-attention的Head构成，而self-attention的原理可参考图2。通过所有token得到三个矩阵Q、K、V，并让Q与所有K矩阵计算得到对应的权重，并与V矩阵进行加权求和。

{% asset_img 1.webp %}
<div align='center'>图1 ViT模型结构</div>

{% asset_img 2.webp %}
<div align='center'>图2 Self-attention计算机制</div>

***

#### 运用在视频中的Transformer：Video Vision Transformer (ViViT)

与ViT同理，需要将视频映射为序列化的token，所以在ViViT模型中，提出两种token的构建方式。方式1如图3所示，从输入视频片段中均匀采样Nt个帧，使用与ViT相同的方法独立嵌入每个二维图像帧，得到Nh*Nw个token，并将所有这些token concat到一起，就得到Nt×Nh×Nw个token。不同于方式1的空间维度上的采样，方式2直接在时空维度上通过tubelet进行采样。如果tubelet维度为t×h×w，则新的token维度Nt×Nh×Nw（Nt=T/t,Nh=H/h,Nw=W/w）。方式2相较于方式1，融合了时间维度的帧信息，即这种构建方式获取的序列token同时融合了空间和时间信息。

{% asset_img 3.webp %}
<div align='center'>图3 上图为均匀采样，下图为tubelet采样</div>

作者在论文中提出了四种Transformer结构，如图4所示。因为在实验部分ViViT作者主要采用模型2，所以这里选择第2种模型进行讲解。模型2的Transformer的encoder根据功能分成Spatial Transformer Encoder和Temporal Transformer Encoder。将相同时间序列提取的token输入到Spatial Transformer Encoder中进行空间维度上的关系建模，并将temporal encoding与其输出重新编码成新的token作为Temporal Transformer Encoder的输入。最后将学习了所有特征信息的cls token输入到MLP中完成分类。

{% asset_img 4.webp %}
<div align='center'>图4 ViViT模型2的Factorised encoder结构</div>

***

### 实验

为了能证明Transformer的架构模型也能同CNN架构模型一样在计算机视觉领域取得较好效果，作者将几个ViT模型的变体和基于ResNet152的BiT方法以及基于EfficientNet的Noisy Student方法在几个经典的CV分类数据集上进行了效果对比。如表1所示，预训练后的几个ViT模型在几个经典的分类数据集上的结果都优于卷积模型的方法，并且大大缩小了理论上的训练时间。

<div align='center'>表1 ViT与其他方法在图像分类的结果</div>
{% asset_img 5.webp %}

此外ViT作者还做了许多实验去证明ViT每个模块的有效性，这里选取位置编码的可视化进行说明。ViT采用位置编码来保证被展平后的patch依旧保留其位置信息。通过图5可知，每个patch与自己的相似度最高（黄色），同时与自己周边及同行同列的patch具有一定的相似性，这说明通过后期的不断训练，ViT的位置编码机制可以有效地保留patch间的位置信息。

{% asset_img 6.webp %}
<div align='center'>图5 位置编码相似度可视化</div>

在视频分类方面，如表2所示，采用tubelet采样机制的ViViT在几个常见的视频数据集上同样取得了较好的成绩，普遍优于以往的方法。

<div align='center'>表2 ViViT与其他方法在视频分类的结果</div>
{% asset_img 7.webp %}

***

### 学习总结

这两篇论文最大贡献是成功将Transformer模块迁移到计算机视觉任务，在CNN之外提供了另一种有效的Backbone。在ViT模型中，提出了可训练的位置编码来保证图像patch之间的空间信息，并利用self-attention去完成完整序列特征的建模。相较于CNN通过一层一层卷积，逐渐扩大卷积视窗的信息， ViT 模型即使在最低层，也可以通过自注意力机制允许模型有更大的视窗。在ViT基础上，ViViT的作者提出了新的采样方式来解决由2D的图片向3D视频数据的转变。同时作为Transformer在视频分类的Backbone，作者为ViViT模型设计出4种结构供以后学者不断探索。

虽然ViT和ViViT在其各自任务上取得较好的结果，证明了在NLP领域大显神威的Transformer在CV领域同样适用，但它们的作者同样留下了许多改进的空间。比如在self-attention中，计算复杂度都是平方级别（因为每个token在MHA中需要和其他token做attention计算），存在一些无关特征时也容易导致需要额外的内存和计算成本。此外，在ViT模型中所有patch的size都是一致的，得到的特征过于单一，这都是在ViT和ViViT在CV领域提出后可以改进的问题。

***

### 参考文献

> [1] Alexey Dosovitskiy, Lucas Beyer, Alexander Kolesnikov, Dirk Weissenborn, Xiaohua Zhai, Thomas Unterthiner, Mostafa Dehghani, Matthias Minderer, Georg Heigold, Sylvain Gelly, et al. An image is worth 16x16 words: Transformers for image recognition at scale. In ICLR, 2021.
> [2] Anurag Arnab, Mostafa Dehghani, Georg Heigold, Chen Sun, Mario Lucic, and Cordelia Schmid. ViViT: A video vision transformer. In ICCV, 2021.

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=12063>
