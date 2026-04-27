---
title: ICCV 2025 | FaceXFormer：一种用于面部分析的统一 Transformer 架构
categories:
  - 🌙进阶学习
  - ⭐脑机接口与混合智能研究团队（BCI团队）
  - 💫学习报告
abbrlink: 9a32fd12
date: 2026-01-30 02:53:07
tags:
---

{% asset_img 1.webp %}

该论文发表于IEEE/CVF International Conference on Computer Vision (ICCV)，题目为《FaceXFormer: A Unified Transformer for Facial Analysis》。约翰霍普金斯大学（JHU）的Kartik Narayan和Vibashan VS为此文共同第一作者。

论文链接：https://openaccess.thecvf.com/content/ICCV2025/papers/Narayan_FaceXFormer_A_Unified_Transformer_for_Facial_Analysis_ICCV_2025_paper.pdf

<!--more-->

***

### 论文概要

本文提出了一种全能的端到端统一Transformer模型FaceXFormer，旨在攻克面部分析领域中由于任务孤立导致的架构冗余与扩展性难题。传统方法通常只针对一个特定的任务进行设计，这限制了它们的可扩展性和集成到统一架构中。FaceXFormer引入“任务即令牌”范式，将不同任务（Task）统一建模为可学习的令牌（Learnable Token），并且设计了一个名为FaceX的参数高效解码器—利用自注意力和双向交叉注意力机制处理面部特征和任务令牌，多层感知机（MLP）处理不同任务结果。实验在9个公开数据集（人脸语义分割：CelebAMaskHQ，面部地标检测：300W，头部姿态估计：300W-LP，属性预测：CelebA，面部表情识别：RAF-DB、AffectNet，年龄/性别/人种估计：UTKFace、FairFace，可见度分析：COFW）上验证了FaceXFormer的优越性，不仅在多项指标上达到或超越了最先进的专用（Specialist）模型，更在保持 33.21 FPS 高速推理性能的前提下，实现了对复杂“野外”场景的极强泛化能力。该工作不仅证明了多任务统一架构在人脸视觉领域的巨大潜力，也为构建高效、通用的实时人脸理解系统开辟了新路径。

***

### 研究背景

面部分析（Face analysis）是一个重要问题，它有着广泛的应用前景，比如人脸识别和验证、监视、人脸交换、人脸编辑、去遮挡、3D人脸重建、图像生成和人脸检索。面部分析任务有人脸解析、面部标志点检测、头部姿态估计、属性预测、面部表情识别、年龄/性别/人种估计和可见度分析。因此，开发用于所有任务的通用且鲁棒的人脸模型是人脸社区中的关键且长期存在的问题。

近年来，面部分析取得了重大进展，开发了最先进的方法和用于各种任务的面部库。尽管这些方法实现了有希望的性能，但由于其专门的模型设计和特定于任务的预处理技术，它们无法集成到单个管道中。此外，同时部署多个专用模型对于实时应用是不切实际的，这会提高系统复杂度和资源消耗。为此，本文提出了一种基于Transformer的统一模型FaceXFormer，结合可学习令牌和双向交叉注意力机制有效地解决了单一任务模型难以扩展集成问题，同时轻量化设计有效地解决了资源消耗问题。

***

### 研究方法

本文提出了一种端到端的统一Transformer模型FaceXFormer，用于集成不同面部分析任务。如图1所示，FaceXFormer由多尺度编码器（Multi-scale Encoder）、FaceX解码器（FaceX Decoder）和统一头（Unified Head）组成。

{% asset_img 2.webp %}
<div align='center'>图1 FaceXFormer网络结构</div>

***

#### 多尺度编码器（Multi-scale Encoder）

对于一张预处理后的人脸图片，FaceXFormer利用多尺度编码器进行特征提取，其中多尺度编码器由Swin-Transformer作为主干网络进行构建，4个编码层得到不同程度的特征，进过多层感知机（MLP）后，由一个轻量化多层感知机（Lightweight MLP-Fusion）进行特征融合得到面部特征F。多尺度特征融合的公式为：

{% asset_img 3.webp %}

***

#### FaceX解码器（FaceX Decoder）

FaceX是一个参数高效的解码器，旨在用面部令牌有效地建模任务令牌。具体来说，每个任务令牌通过与其他任务令牌T和面部令牌F交互来学习与任务相关的表示，从而增强整体表示。FaceX解码器由三部分组成：（1）任务自注意力（Task Self-Attention，TSA）（2）任务-面部交叉注意力（Task-to-Face Cross-Attention，TFCA）（3）面部-任务交叉注意力（Face-to-Task Cross-Attention，FTCA）。

任务自注意力被设计为细化任务令牌T，每个不同任务的令牌对应于特定面部任务的嵌入式表示。TSA通过关注所有其他任务令牌来更新每个任务令牌，以捕获特定于任务的交互。TSA的公式为：

{% asset_img 4.webp %}

任务-面部交叉注意力允许每个任务令牌与融合的面部特征表示F交互，这使得每个任务令牌能够从融合的面部特征中收集与其特定面部任务相关的信息。TFCA的公式为：

{% asset_img 5.webp %}

面部-任务交叉注意力被设计为基于来自更新的任务令牌的信息来细化融合的面部特征表示F。该过程有助于用任务特定的细节来增强面部特征表示，从而改善整体融合表示的提取。FTCA的公式为：

{% asset_img 6.webp %}

***

#### 统一头（Unified Head）

统一头通过任务到FTCA来处理输出面部令牌F和任务令牌T，以获得最终的精细特征。然后，输出令牌被馈送到其对应的任务头，其中任务头由多层感知机构建，最终得到不同任务的输出结果。

***

### 实验结果

本文对于不同任务采用了不同的数据集进行验证，论文将FaceXFormer与最近的方法在各种任务进行比较分析，如表1所示。

<div align='center'>表1 在CelebAMask-HQ数据集上进行人脸解析的性能比较。符号×表示模型不执行相应的任务。红色：最优，蓝色：次优</div>
{% asset_img 7.webp %}

FaceXFormer在人脸解析方面达到了最先进的性能，在CelebAMaskHQ上的平均F1得分为92.01，分辨率为224×224，这是其他最先进方法所需输入大小的一半。

<div align='center'>表2 头部姿态、地标检测和属性识别的性能比较。符号×表示模型不执行相应的任务，-表示不提供此数据集的结果。红色：最优，蓝色：次优</div>
{% asset_img 8.webp %}

如表2所示，FaceXFormer在BIWI数据集上的头部姿态估计结果平均绝对误差（MAE）与其他最先进方法比较为最佳，结果为3.52。在300W数据集上的面部地标检测结果Full、Com和Chal与其他最先进方法相比性能表现最佳，最终标准化平均误差（NME）为4.67。在CelebA数据集上属性预测FaceXFormer同样展示了优越的性能，91.83%的正确率优于其他最先进的算法。

<div align='center'>表3 人脸表情识别、人脸可见性预测和年龄估计的性能比较。符号×表示模型不执行相应的任务。红色：最优，蓝色：次优</div>
{% asset_img 9.webp %}

如表3所示，在面部表情识别方面，FaceXFormer在RAF-DB上的正确率88.24%接近次优，在多任务模型下取得的性能仅次于QFace，侧面验证了FaceXFormer在识别不同情绪特征时也能正确区分，而在COFW数据集上进行的可见度分析任务则是取得了72.56%的最佳性能，在年龄估计的任务上也同样具有竞争力，在UTKFace数据集上得到仅次于Faceptor的性能其平均绝对误差为4.17。

为了评估FaceXFormer中每个组件的贡献，本文进行了一项消融研究，重点关注特定设计选择的重要性及其对各种任务性能的影响。

<div align='center'>表4 FaceXFormer的各种组件对性能的影响</div>
{% asset_img 10.webp %}

如表4所示（其中HPE表示头部姿态预测，Lnd表示面部地标检测，Attr.表示属性预测，Age表示年龄估计），FXDec解码器结合了自我注意力以及面部特征和任务令牌之间的交互，在性能方面起着至关重要的作用。没有FXDec，所有任务的平均绝对误差（MAE）都显著下降。例如，面部标志点检测的平均绝对误差（MAE）从4.67增加到31.49，属性分类的准确率从91.83%下降到79.90%。这种大幅下降突出了解码器在有效捕获这些任务所需的复杂特征关系方面的重要性。类似的，整合了多尺度特征提取的FaceXFormer相比于没有整合多尺度特征提取的结果均有所提高，这些结果显示了整合多尺度特征以捕获至关重要的全局和局部信息对于统一模型的重要性。

***

### 结论

本文引入了一种新的端到端统一模型FaceXformer，可以实时有效地处理各种面部分析任务。通过采用基于transformer的编码器-解码器架构，并将每个任务视为可学习的令牌，本文的方法成功地将多个任务集成在一个框架中。所提出的参数高效解码器FaceX，增强了模型在不同任务中学习鲁棒和广义人脸表征的能力。综合实验表明，所提出的模型在多个人脸分析任务中达到了最先进的性能。此外，在多个数据集上进行训练可以获得更好的表征学习。总之，FaceXFormer证明了面部任务可以被视为令牌，从而实现任务的统一;在此之后，FaceXFormer可以为开发能够执行多个面部分析任务的大型模型提供基础。

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=17779>
