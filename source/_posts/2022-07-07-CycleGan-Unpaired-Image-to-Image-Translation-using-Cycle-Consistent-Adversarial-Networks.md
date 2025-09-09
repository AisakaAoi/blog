---
title: >-
  CycleGan:Unpaired Image-to-Image Translation using Cycle-Consistent
  Adversarial Networks
categories:
  - 🌙进阶学习
  - ⭐脑机接口与混合智能研究团队（BCI团队）
  - 💫学习报告
abbrlink: d8ae0f01
date: 2022-07-07 04:29:23
tags:
---

本学习报告基于《Unpaired Image-to-Image Translation using Cycle-Consistent Adversarial Networks》，该文献发表于2017年，由BAIR实验室和加州大学伯克利分校的研究者共同完成。作者介绍了CycleGan，一个使用循环一致对抗的未配对的图像到图像的转换模型。

{% asset_img 1.webp %}
<div align='center'>图1：CycleGan图像转换效果</div>

<!--more-->

***

### 研究背景

图像到图像转换是一类视觉和图形问题，其目标是从一组成对的图像中学习输入图像与输出图像之间的映射。然而，获取成对的训练集是非常困难和昂贵的，获得像是艺术化风格这样的图形任务的输入-输出对就非常的困难。

{% asset_img 2.webp %}
<div align='center'>图2：成对的数据与非成对数据</div>

***

### CycleGan

在文章中，作者提出一种可以图像“翻译”的方法：在没有任何成对训练例子的情况下，捕捉一个图像集合的特殊特征，并学习这些特征如何转换成另一个图像集合。这个问题可以更广泛地描述为图像到图像地转换，将图像冲给定场景的一个表示x转换为另一种表示y。

#### 原理

{% asset_img 3.webp %}
<div align='center'>图3：CycleGan原理</div>

CycleGan中包括两个生成器G : X → Y 和F : Y → X，两个对抗鉴别器Dy和Dx。G将生成出令Dy难以分辨真假的图片，同理，F将生成出领Dx难以分辨真假的图片。为了进一步规范化映射，文中引入两个循环一致性损失，如果把x转换成y’，再把y’转换成x’，那么x和x’也应该尽可能的相似，即x → G(x) → F(G(x)) ≈ x，同理可得y → F(y) → G(F(y)) ≈ y，例如图4中Reconstruction F(G(x))与input x应尽可能相似。

{% asset_img 4.webp %}
<div align='center'>图4：输入图像、转换图像、重建图像</div>

***

#### 模型结构

{% asset_img 5.webp %}
<div align='center'>图5：CycleGan模型结构</div>

以 马<—>斑马 相互转换为例。如图5所示，模型中包含两对生成器分别把马转换成斑马(GeneratorA2B)、把斑马转成马(GeneratorB2A)，两对鉴别器分别鉴别斑马(DiscriminatorB)和马(DiscriminatorA)的真假。

将马的图片输入到GeneratorA2B将输出斑马的图片，将输出的斑马图片输入GeneratorB2A将输出马的图片，最初输入的马的图片与最终生成的马的图片之间的距离即为循环一致性损失。两对鉴别器输入图像，输出图像的真实性。

{% asset_img 6.webp %}
<div align='center'>图6：CycleGan生成器结构</div>

如图6所示，生成器由Encoding——Transformation——Decoding架构组成，其中Encoding由卷积层组成，Transformation由ResNet组成，Decoding由反卷积层组成。

{% asset_img 7.webp %}
<div align='center'>图7：CycleGan鉴别器结构</div>

如图7所示，鉴别器由卷积层组成，最终输出[0, 1]的浮点数代表输入图像的真实性。

***

#### 损失函数

对抗性损失：对于生成器G : X → Y 和Dy来说，其损失为：

{% asset_img 8.webp %}

循环一致性损失：为了使x → G(x) → F(G(x)) ≈ x，y → F(y) → G(F(y)) ≈ y，引入以下损失：

{% asset_img 9.webp %}

总体损失：

{% asset_img 10.webp %}

***

### 实验结果

{% asset_img 11.webp %}
<div align='center'>图8：使用不同方法将城市景观图的语义分割标签图转化为照片</div>

{% asset_img 12.webp %}
<div align='center'>图9：使用不同方法将鸟瞰图转化为谷歌地图图片</div>

***

### 参考文献

> [1] Zhu J Y, Park T,Isola P,et al.Unpaired Image-to-Image Translation using Cycle-Consistent Adversarial Networks[C]// International Conference on Computer Vision. IEEE, 2017.

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=11961>
