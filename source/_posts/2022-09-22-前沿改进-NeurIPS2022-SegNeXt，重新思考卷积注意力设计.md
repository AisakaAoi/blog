---
title: 前沿改进-NeurIPS2022 | SegNeXt，重新思考卷积注意力设计
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫前沿改进 Frontier Improvement
abbrlink: 2a21242b
date: 2022-09-22 13:27:50
tags:
---

NeurIPS2022 | SegNeXt，重新思考卷积注意力设计

### 写在前面

本文提出了 SegNeXt，一种用于语义分割的简单卷积网络架构。由于自注意力在编码空间信息方面的效率，最近基于transformer的模型在语义分割领域占据主导地位。在本文中，作者展示了卷积注意力是一种比transformer中的自注意力机制更有效和高效的方式来编码上下文信息。通过重新检查成功的分割模型所拥有的特征，作者发现了导致分割模型性能改进的几个关键组件。这促使作者设计一种使用廉价卷积操作的新型卷积注意力网络。本文的 SegNeXt 显着提高了以前最先进方法在流行基准上的性能，包括 ADE20K、Cityscapes、COCO-Stuff、Pascal VOC、Pascal Context 和 iSAID。值得注意的是，SegNeXt 的性能优于带 NAS-FPN 的 EfficientNet-L2，并且仅使用其 1/10 的参数就在 Pascal VOC 2012 测试排行榜上实现了 90.6% 的 mIoU。与在 ADE20K 数据集上使用相同或更少计算的最先进方法相比，SegNeXt 平均实现了约 2.0% 的 mIoU 改进。

<!--more-->

***

### 论文和代码地址

{% asset_img 1.png %}

SegNeXt: Rethinking Convolutional Attention Design for Semantic Segmentation

论文地址：<https://github.com/Visual-Attention-Network/SegNeXt/blob/main/resources/paper.pdf>

代码地址：<https://github.com/Visual-Attention-Network/SegNeXt>

***

### 动机

作为计算机视觉中最基本的研究课题之一，旨在为每个像素分配一个语义类别的语义分割在过去十年中引起了极大的关注。从早期的基于 CNN 的模型，以 FCN和 DeepLab 系列为代表，到最近的基于Transformer的方法，以 SETR和SegFormer为代表，语义分割模型在网络架构方面经历了重大变革。

{% asset_img 2.png %}

通过重新审视之前成功的语义分割工作，作者总结了不同模型拥有的几个关键属性，如上表所示。 基于上述观察，作者认为一个成功的语义分割模型应该具有以下特点： (i) **强大的骨干网络作为编码器。**与之前基于 CNN 的模型相比，基于 Transformer 的模型的性能提升主要来自更强大的骨干网络。 (ii) **多尺度信息交互。**与主要识别单个对象的图像分类任务不同，语义分割是一项密集的预测任务，因此需要在单个图像中处理不同大小的对象。 (iii) **空间注意力。**空间注意力允许模型通过语义区域内区域的优先级来执行分割。 (iv) **计算复杂度低。**这在处理来自遥感和城市场景的高分辨率图像时尤其重要。

考虑到上述分析，在本文中，作者重新思考了卷积注意力的设计，并提出了一种高效且有效的语义分割编码器-解码器架构。与之前在解码器中使用卷积作为特征细化器的基于Transformer的模型不同，本文的方法反转了Transformer-卷积 编码器-解码器架构。具体来说，对于编码器中的每个块，作者更新了传统卷积块的设计，并利用多尺度卷积特征通过简单元素乘法来唤起空间注意力。作者发现这种建立空间注意力的简单方法比空间信息编码中的标准卷积和自注意力更有效。对于解码器，作者从不同阶段收集多级特征，并使用 Hamburger进一步提取全局上下文。在此设置下，本文的方法可以获得从局部到全局的多尺度上下文，实现空间和通道维度的适应性，以及从低到高的信息聚合。

{% asset_img 3.png %}

本文的网络，称为 SegNeXt，主要由卷积操作组成，除了解码器部分，它包含一个基于分解的 Hamburger 模块 (Ham)，用于全局信息提取。这使得本文的 SegNeXt 比以前严重依赖Transformer的分割方法更有效。如上图所示，SegNeXt 明显优于最近基于Transformer的方法。特别是，本文的 SegNeXt-S 仅使用大约 1/6（124.6G 对 717.1G）的计算成本和 1/2 的参数（13.9M 对 27.6M）就在Cityscapes 数据集上优于 SegFormer-B2（81.3% 对 81.0%）。

本文的贡献可以总结如下：
- 本文确定了一个好的语义分割模型应该拥有的特征，并提出了一种新颖的定制网络架构，称为SegNeXt，它通过多尺度卷积特征唤起空间注意力。、
- 作者表明，具有简单且廉价卷积的编码器仍然可以比视觉Transformer表现更好，尤其是在处理对象细节时，同时它需要的计算成本要低得多。
- 本文的方法在各种分割基准上大幅提高了最先进的语义分割方法的性能，包括 ADE20K、Cityscapes、COCO-Stuff、Pascal VOC、Pascal Context 和 iSAID。

***

### 方法

#### Convolutional Encoder

{% asset_img 4.png %}

在大多数先前的工作之后，作者为编码器采用金字塔结构。对于编码器中的构建块，作者采用了与 ViT类似的结构，但不同的是没有使用自注意机制，而是设计了一种新颖的多尺度卷积注意 (MSCA) 模块.如图 2 (a) 所示，MSCA 包含三个部分：用于聚合局部信息的**深度卷积**，用于捕获多尺度上下文的**多分支深度条带卷积**，以及用于建模不同通道之间关系的 **1×1 卷积**。 1×1卷积的输出直接用作注意力权重来重新加权MSCA的输入。在数学上，MSCA 可以写成：

{% asset_img 5.png %}

其中 F 表示输入特征。 Att 和 Out 分别是注意力图和输出。⊗ 是逐元素矩阵乘法运算。 DW-Conv 表示深度卷积，Scale_i, i∈{0,1,2,3}，表示图 2(b) 中的第 i 个分支。Scale0 是identity连接。在每个分支中，作者使用两个深度方向的带状卷积来逼近具有大内核的标准深度方向的卷积。这里，每个分支的内核大小分别设置为 7、11 和 21。作者选择深度条带卷积的原因有两个。一方面，带状卷积是轻量级的。为了模拟内核大小为 7 × 7 的标准 2D 卷积，只需要一对 7 × 1 和 1 × 7 卷积。另一方面，分割场景中有一些条状物体，如人、电线杆。因此，带状卷积可以是网格卷积的补充，有助于提取带状特征。

堆叠一系列构建块产生了所提出的卷积编码器，称为 MSCAN。对于 MSCAN，作者采用了一个通用的层次结构，它包含四个空间分辨率递减的阶段H/4 × W/4 , H/8 × W/8 , H/16 × W/16 , H/32 × W/32。这里，H 和 W 分别是输入图像的高度和宽度。每个阶段包含一个下采样块和一堆building block。下采样块有一个步幅为 2 且内核大小为 3×3 的卷积，然后是一个Batch Norm层。请注意，在 MSCAN 的每个构建块中，作者使用batch norm而不是layer norm，因为作者发现batch norm对分割性能的增益更大。

{% asset_img 6.png %}

作者设计了四种不同尺寸的编码器模型，分别命名为 MSCAN-T、MSCAN-S、MSCAN-B 和 MSCAN-L。相应的整体分割模型分别称为 SegNeXt-T、SegNeXt-S、SegNeXt-B、SegNeXt-L。

***

#### Decoder

{% asset_img 7.png %}

在分割模型中，编码器大多是在 ImageNet 数据集上预训练的。为了捕获高级语义，通常需要一个解码器，它应用于编码器。在这项工作中，作者研究了三个简单的解码器结构，如上图所示。第一个在 SegFormer中采用，是一个纯粹基于 MLP 的结构。第二种主要采用基于 CNN 的模型。在这种结构中，编码器的输出直接用作重型解码器头的输入，如 ASPP、PSP 和 DANet 。最后一个是本文的 SegNeXt 中采用的结构。作者汇总了最后三个阶段的特征，并使用轻量级 Hamburger来进一步建模全局上下文。结合强大的卷积编码器，作者发现使用轻量级解码器可以提高性能计算效率。

与 SegFormer 的解码器聚合从阶段 1 到阶段 4 的特征不同，本文的解码器只接收来自最后三个阶段的特征，这一点毫无价值。这是因为本文的 SegNeXt 基于卷积。第 1 阶段的特征包含过多的低级信息并损害性能。此外，Stage 1 上的操作带来了沉重的计算开销。在本文的实验部分，作者将证明本文的卷积 SegNeXt 比最近最先进的基于Transformer的 SegFormer和 HRFormer表现得更好。

***

### 实验

{% asset_img 8.png %}

在 ImageNet 验证集上与最先进的方法进行比较。

{% asset_img 9.png %}

在遥感数据集 iSAID 上与最先进的方法进行比较。

{% asset_img 10.png %}

解码器中不同注意力机制的性能。

{% asset_img 11.png %}

MSCA设计的消融研究。

{% asset_img 12.png %}

不同解码器结构的性能。

{% asset_img 13.png %}

SegNeXt-B 和 SegFormer-B2 在 Cityscapes 数据集上的定性比较。

{% asset_img 14.png %}

多尺度卷积注意力（MSCA）的重要性。

{% asset_img 15.png %}

在 ADE20K、Cityscapes 和 COCO-Stuff 基准上与最先进的方法进行比较。

{% asset_img 16.png %}

在 Pascal VOC 数据集上与最先进的方法进行比较。

{% asset_img 17.png %}

在 Cityscapes 测试数据集上与最先进的实时方法进行比较。

{% asset_img 18.png %}

Pascal Context 基准比较。

***

### 总结

在本文中，作者分析了以前成功的分割模型，并找到了它们所拥有的良好特征。基于这些发现，作者提出了一个定制的卷积注意力模块 MSCA 和一个 CNN 风格的网络 SegNeXt。实验结果表明，SegNeXt 在相当大的程度上超越了当前最先进的基于Transformer的方法。最近，基于Transformer的模型已经主导了各种细分排行榜。相反，本文表明，在使用适当的设计时，基于 CNN 的方法仍然可以比基于Transformer的方法表现更好。

***

### 参考资料

> <https://blog.csdn.net/Jason_android98/article/details/126970145>
