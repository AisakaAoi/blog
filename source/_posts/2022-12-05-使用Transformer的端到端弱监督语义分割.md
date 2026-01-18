---
title: 使用Transformer的端到端弱监督语义分割
categories:
  - 🌙进阶学习
  - ⭐脑机接口与混合智能研究团队（BCI团队）
  - 💫学习报告
abbrlink: 2e59fe20
date: 2022-12-05 20:51:52
tags:
---

本篇学习报告的内容来自《Learning Affinity from Attention: End-to-End Weakly-Supervised Semantic Segmentation with Transformers》，目前该文章已经收录到CVPR2022当中。在基于图像级别标注的弱监督语义分割问题中，CNN分类模型不能正确地探索全局信息，进而导致不完全的语义区域激活。为解决这个问题，作者引入Transformer结构，并探索了适合视觉Transformer的初始伪标签生成方法。

<!--more-->

***

### 研究背景和问题

语义分割的目标是为了给图像中的每个像素点分配标签，是计算机视觉的基础任务之一。传统的全监督语义分割任务大都需要非常大的带有像素级标签的数据集，成本巨大，代价高且耗时耗力。为解决这个问题，最近的一些工作提出了弱监督语义分割（WSSS）的方法。目前流行的WSSS方法中大部分都是采用多阶段训练框架的方法，也就是利用伪标签来训练网络。伪标签技术就是利用在已标注数据所训练的模型在未标注的数据上进行预测，根据预测结果对样本进行筛选，再次输入模型中进行训练的一个过程，具体的步骤：
1. 使用标记数据训练有监督模型M。
2. 使用有监督模型M对无标签数据进行预测，得出预测概率P。
3. 通过预测概率P筛选高置信度样本。
4. 使用有标记数据以及伪标签数据训练新模型M’。

这种方法由于需要训练多个网络，或者多次训练网路导致整个流程的效率低下。为了避免这个问题，许多端到端的方法被提出，但大多利用卷积神经网络，而卷积神经网络对全局特征提取以及全局特征间联系获取能力不足，从而对生成的伪标签质量产生显著的影响。

基于上述问题，作者引入Transoformer结构。首先Transformer的自注意力机制可以保证全局特征的提取，解决了CNN的局部性缺陷，因此能够提高初始伪标签的准确性。同时，自注意力图和像素之间的语义affinity也存在天然的一致性，而语义affinity可以被进一步用于对初始伪标签进行细化。然而，由于自然学习到的自注意力矩阵缺乏监督信息，直接将原始自注意力矩阵作为affinity信息对伪标签进行细化并不能取得令人满意的效果。故作者提出了Affinity from Attention（AFA）模块，以初始伪标签作为监督信息指导自注意力的训练，从而学习到高质量的affinity信息，用于伪标签的改善。

***

### 本文做出的贡献

1. 本文提出了一种基于端到端Transformer框架的带有图像级别标签弱监督语义分割框架（WSSS）。据作者所了解，这是第一个用Transformer去研究WSSS的工作。
2. 在本文中作者利用Transformer的内在优点，设计了Affinity from Attention（AFA）模块。AFA从多头自注意力中学到可靠的语义Affinity，并以学习到的Affinity传播伪标签。
3. 本文提出了一种有效的像素自适应细化（PAR）模块，该模块结合了局部像素的RGB和位置信息，用于标签细化。

***

### 实验方法

{% asset_img 1.webp %}
<div align='center'>图1. 端到端WSSS框架图。本文使用Transformer作为基础编码器。初始伪标签由CAM方法生成，然后使用提出的像素自适应细化模块（PAR）进行修正。在affinity学习模块（AFA）中，从Transformer中的多头自注意力（MHSA）生成语义affinity预测。AFA使用基于细化初始伪标签的伪affinity标签进行监督。然后，利用学习到的affinity通过随机游走方法对初始伪标签进行改善。在经过PAR的进一步修正后，作为分割分支的监督信息。</div>

***

#### Transformer Backbone

如图1所示，作者使用Transformer作为backbone。首先将输入图像分割成h * w个patch，并且经过线性层后得到相同数量的patch token。在每个Transformer block当中都是用多头注意力机制（multi-head self-attention MHSA）来捕捉全局特征感知，也就是得到token之间的关系。其中，用Qi，Ki，Vi来表示注意力中的query，key和value，其中i表示第I个头（head）。对应的注意力矩阵和输出公式分别计算为：

{% asset_img 2.webp %}

多头注意力的结果（X1~Xn）会进行拼接，然后作为输入进入FFN层作为Transformer block的输出X0，即

{% asset_img 3.webp %}

最后通过堆叠多个block，主干backbone会为后续模块生成feature maps

***

#### CAM Generation

考虑到生成伪标签的简洁性和效率，作者使用类激活映射（class activation maps CAM）来生成初始的伪标签。对于提取的特征映射F和给定的类c，通过将F中的特征映射及其对类c的影响进行加权，即分类层中的权重矩阵W，生成激活映射M。计算公式如下：

{% asset_img 4.webp %}

使用ReLu函数消除负激活值后进行归一化，在选取合适的背景阈值得到初始的伪标签。

***

#### Affinity from Attention

{% asset_img 5.webp %}
<div align='center'>图2.视觉Transformer中的多头注意力（中）及基于注意力学习到的Affinity（右）</div>

如图2所示，作者指出Transformer的MHSA与语义Affinity之间存在一致性，进而可以用MHSA来找到目标对象的区域。然而，由于在训练过程中没有对自注意力矩阵施加明确的约束，因此在MHSA中学习到的Affinity通常是不准确的。这也意味着直接用MHSA作为Affinity来细化初始labels并不能得到令人满意的效果。因此作者提出Affinity from Attention（AFA）模块来解决这个问题。

假设Transformer块的MHSA表示为S ∈ R hw×hw×n，其中hw是图像空间的大小，n是注意力头的数量。在AFA模块中，作者通过线性组合多头注意力机制，即使用一个MLP层，直接生成语义Affinity。然而自注意力机制是一种像素间有向的建模方式，即自注意力矩阵是不对称的，而语义Affnity的关联应当是无向的。

所以，为了实现MHSA到语义Affinity的转换，作者直接将S和它的转置进行相加：

{% asset_img 6.webp %}

***

#### Pseudo Affinity Label Generation

为了学习有用的语义Affinity A，最重要的一步是得到一个可靠的伪Affinity标签Yaff并对其进行监督。为了得到可靠的伪标签，作者选取两个背景阈值将初始伪标签分为可靠的前景、背景和不确定区域。根据给定的CAM M ∈ Rh×w×C，构建伪标签Yp的公式如下：

{% asset_img 7.webp %}

然后从Yp中推导出伪affinity标签Yaff。对于Yp，如果（i，j）和（k，l）共享同一个语义信息，那么将它们的Affinity值设为正，其他情况则为负。如果像素对在被忽略的区域内被采样，则它们的Affinity也会被忽略。此外，这里只考虑像素对在同一个局部窗口的情况，而不考虑远处像素对的Affinity。

***

#### Affinity Loss

利用生成的伪Affinity标签Yaff来监督预测的affinity A。Affinity 损失公式如下：

{% asset_img 8.webp %}

其中，R+和R-表示Yaff样本正负集合，N+和N-表示R+和R-的数量。根据上式，一方面网络能从MHSA中学习到可靠的Affinity关系；另一方面，由于Affinity是MHSA的线性组合，上式又能保证注意力矩阵中更好的特征交互。

***

#### Propagation with Affinity

在得到可靠的Affinity矩阵之后，我们通过随机游走算法对初始伪标签进行修正：

{% asset_img 9.webp %}

通过随机游走算法，可以对初始为标签中的高Affinity区域进行激活，并抑制低Affinity的错误激活区域，从而使得伪标签更好地贴合图像的语义信息。

***

#### Pixel-Adaptive Refinement

据图1所示，伪Affinity标签Yaff来自于初始伪标签。然而，初始伪标签通常都是粗糙且局部不一致的，具有相似low-level的临近像素也可能不具有相同的语义。为确保局部的一致性，之前一些工作采用了CRF来调整初始为标签，但是CRF由于其训练效率低，所以并不是很适合端到端的网络。受PAMR的启发，作者结合RGB和空间信息来定义低级的pairwise affinity并构建自己的像素自适应细化模块（PAR）。

首先给定的输入图像 I，对于给定位置的像素对，定义两个像素的RGB信息和位置信息的kernel：

{% asset_img 10.webp %}

根据定义的位置和RGB信息kernel函数计算像素之间的low-level affinity值为：

{% asset_img 11.webp %}

与CRF中计算全局像素的low-level affinity不同，我们根据像素的8个邻居像素进行计算，该过程可以使用3x3的像素自适应卷积实现，从而能够高效的插入到端到端的训练框架中。同时为了扩大感受野，使用多个空洞卷积进行多个邻居像素信息的提取。得到像素之间的low-level affinity之后，通过多次迭代进行伪标签的修正：

{% asset_img 12.webp %}

***

#### Network Training

据图1所示，训练损失函数包括分类损失，分割损失和affinity损失。其中分类损失采用常见的多分类软间隔损失，分割损失则采用交叉熵损失。总损失计算公式如下：

{% asset_img 13.webp %}

***

### 实验结果

本文作者使用的数据集是PASCAL VOC2012和MS COCO 2014数据集，这两个数据集的训练集都是仅用图像级标签进行标注，且作者使用mean Intersection-Over-Union (mIOU)作为评估标准。在网络结构方面，作者使用比vanila ViT更加友好的Mix Transformer作为backbone。对于分割解码器，作者使用MLP解码头，它将多层次的特征图和简单的MLP层融合进行预测。主干参数用ImageNet-1k预训练的权值初始化，其他参数用随机初始化。

在CNN中，分类层前的池化方法对CAM生成效果有显著的影响，作者实验了对Transformer结构合适的池化方式，并且发现相比于CNN中的全剧平均池化（GAP），Transformer结构全局最大池化（GMP）能够得到更好的类别激活图.

<div align='center'>表1.Top-k池化对生成的类别激活图的影响</div>
{% asset_img 14.webp %}

<div align='center'>表2.消融实验下加入各模块的mIOU</div>
{% asset_img 15.webp %}

表2展示了作者提出模块的具体效果。我们可以看到在只有Baseline的情况下，val集达到了46.7%。而所提出的PAR和AFA进一步显著提高了mIOU，分别提高了56.2%和62.6%，此外在改进了损失计算公式后该框架达到了63.8%的mIOU。CRF后处理进一步带来了2.2%的mIOU提升，将最终的性能提高到66.0%的mIOU。简而言之，作者提出的模块是非常有效的。

<div align='center'>表3. AFA在不同模块下的伪标签的mIoU</div>
{% asset_img 16.webp %}

{% asset_img 17.webp %}
<div align='center'>图3. 学习到的MHSA，affinity，及生成的伪标签可视化图</div>

图3和表3中展示了AFA模块中多头注意力和语义Affinity可视化图，其中表的实验模块为没有AFA模块（w/o AFA）、有AFA模块但没有随机游走传播（AFA(w/prop.)）、直接用MHSA作为Affinity信息（AFA (prop. with MHSA)）以及使用了完整的AFA模块。我们注意到AFA损失以及随后的随机游走传播过程都能够有效的提高伪标签效果，以及直接使用MHSA作为Affinity信息并不能带来效果提升。

{% asset_img 18.webp %}
<div align='center'>图4. PAR模块对伪标签的修正效果（左）及不同设置的影响（右） </div>

<div align='center'>表4.在VOC（左）和COCO（右）上的语义分割结果</div>
{% asset_img 19.webp %}

在VOC和COCO数据集上的实验都显示AFA超过了最近的端到端语义分割方法，并且同时超过了部分多阶段的方法以及一些引入的额外显著性监督的方法。

***

### 结论

本文探索了Transformer架构对WSSS任务的内在优点。具体来说就是作者使用一个基于Transformer的backbone来生成CAM作为初始的伪标签，避免了CNN的固有缺陷。此外，作者注意到了MHSA和语义Affinity之间的一致性，从而提出了AFA模块。AFA从伪标签中获得可靠的Affinity标签，强加Affinity标签来监督MHSA，并产生可靠的Affinity预测。利用学习到的Affinity，通过随机游走传播来修正初始伪标签。在PASCAL VOC和MS COCO数据集上，本文的方法实现了端到端WSSS的SOTA性能。从长远的角度上来讲，该方法还为视觉Transformer提供了一种新的视角，即通过语义关系引导自注意力，以确保更好的特征聚合。

***

原文链接：https://arxiv.org/abs/2203.02664 

代码链接：https://github.com/rulixiang/afa

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=12806>
