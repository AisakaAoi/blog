---
title: 深度学习-DenseNet、MobileNet、DPN…你都掌握了吗？一文总结图像分类必备经典模型（二）
categories:
  - - 🌙进阶学习
    - ⭐人工智能 Artificial Intelligence
    - 💫研究领域 Research Area
    - 🛰️计算机视觉 Computer Vision
  - - 🌙进阶学习
    - ⭐人工智能 Artificial Intelligence
    - 💫网络模型 Networks Model
tags:
  - ☄️图像分类 Image Classification
abbrlink: cf26f90d
date: 2022-12-02 03:39:19
---

本文将分 3 期进行连载，共介绍 15 个在图像分类任务上曾取得 SOTA 的经典模型。

- 第 1 期：AlexNet、VGG、GoogleNet、ResNet、ResNetXt
- 第 2 期：DenseNet、MobileNet、SENet、DPN、IGC V1
- 第 3 期：Residual Attention Network、ShuffleNet、MnasNet、EfficientNet、NFNet

（您正在阅读的是其中的第 2 期。前往 SOTA！模型资源站（sota.jiqizhixin.com）即可获取本文中包含的模型实现代码、预训练模型及 API 等资源。）

<!--more-->

***

本期收录模型速览

| 模型 | SOTA！模型资源站收录情况 | 模型来源论文 |
| :-- | :---------------------- | :---------- |
| DenseNet | https://sota.jiqizhixin.com/models/models/5c51c076-350d-4d1c-a142-66c6e04b6e61 | Densely Connected Convolutional Networks |
| MobileNet | https://sota.jiqizhixin.com/models/models/111fcb54-cf50-49f0-a340-2b80ce56ae4c | MobileNets: Efficient Convolutional Neural Networks for Mobile Vision  Applications |
| SENet | https://sota.jiqizhixin.com/models/models/c7dfc0ec-ee5d-4d85-866d-0b4ac306e1ff | Squeeze-and-Excitation Networks |
| DPN | https://sota.jiqizhixin.com/models/models/4431847d-c2b1-4cba-a31a-fa5585495abb | Dual Path Networks |
| IGC V1 | https://sota.jiqizhixin.com/models/models/8a1636be-753d-4b72-a4c7-ec7a9f6ffc6f | Interleaved Group Convolutions for Deep Neural Networks |

图像分类是计算机视觉领域最经典的任务之一，目的是将输入的图像对应到预定义的语义类别中，即打上类别标签。传统的图像分类方法由底层特征学习、特征编码、空间约束、分类器设计、模型融合等步骤组成。

首先，从图像中提取特征，经典的特征提取方法包括 HOG(Histogram of Oriented Gradient, 方向梯度直方图) 、LBP(Local Bianray Pattern, 局部二值模式)、SIFT(Scale-Invariant Feature Transform, 尺度不变特征转换)等，也可以将多种特征融合以保留更多有用信息。然后，对特征进行编码后去除冗余和噪声，生成特征编码，经典方法包括稀疏编码、局部线性约束编码、Fisher 向量编码等。再然后，经过空间特征约束后实现特征汇聚，例如经典的金字塔特征匹配方法。最后，利用分类器进行分类，经典分类器包括 SVM、随机森林等等。

{% asset_img 1.webp %}

Alex Krizhevsky 在 2012 年 ILSVRC 提出的 CNN 模型首次将深度学习应用于大规模图像分类任务，其效果远超传统的图像分类方法，一举获得 ILSVRC 2012 的冠军，开启了深度学习模型在图像分类中的应用历程。这个模型就是著名的 AlexNet。自此，图像分类改变了传统的致力于提取有效的特征、改进分类器的有效性的研究和应用路径，转为研究不同的深度学习模型架构。

深度卷积神经网络为图像分类带来了一系列突破。深度神经网络集成了低/中/高层次的特征，可以被端到端训练，特征的层次可以通过网络的深度来丰富。甚至有研究人员称，正是在图像分类任务中应用的巨大成功，带动了深度学习的方法。

***

### DenseNet

DenseNet 是 CVPR 2017 年的 Best Paper。DenseNet 脱离了加深网络层数 (ResNet) 和加宽网络结构 (Inception) 来提升网络性能的定式思维。DenseNet 的思路是通过特征重用和旁路 (Bypass) 设置，在减少参数量的同时缓解梯度消失、模型退化问题。

考虑一个通过卷积网络的单一图像 x_0。该网络由 L 层组成，每个层都实现了非线性变换 H_(·)，其中 l 指代该层。H_(·) 可以是一个操作的复合函数，如批量归一化(BN)、整顿线性单元(ReLU)、池化或卷积(Conv)。为了进一步改善各层之间的信息流，作者提出了一种不同的连接模式：作者引入了从任何一层到所有后续层的直接连接。图 11 示意性地说明了 DenseNet 的结构：第 l 层接收前面所有层的特征图作为输入。

{% asset_img 2.webp %}

[x_0,...X_(l-1)] 是指在第 0、...、l-1 层产生的特征图的串联。由于其密集的连接性，将这种网络结构称为密集卷积网络（DenseNet）。将 H_(·) 定义为三个连续操作的复合函数：批量归一化（BN），然后是 ReLU 和 3×3 卷积（Conv）。当特征图的大小发生变化时，连接操作是不可行的。然而，卷积网络的一个重要部分是改变特征图大小的下采样层。为了便于在架构中进行下采样，将网络分为多个密集连接的密集块。我们把块间的层称为过渡层，过渡层执行卷积和池化操作。实验中使用的过渡层包括一个批处理归一化层和一个 1×1 卷积层，然后是一个 2×2 平均池化层。

{% asset_img 3.webp %}
<div align='center'>图 1 一个有三个密集块的 DenseNet</div>

如图 1 所示，DenseNet 两个相邻块之间的层被称为过渡层，通过卷积和池化改变特征图的大小。

如果每个函数 H 产生 k 个特征图，那么，第 l 层有 k_0+k×(l-1) 个输入特征图，其中k_0 是输入层的通道数。DenseNet 与现有网络架构的一个重要区别是，DenseNet 可以有很窄的层，例如，k=12。我们把超参k称为网络的增长率。每一层都可以访问其块中所有先前的特征图，因此，可以访问网络的 "collective knowledge"，我们可以把特征图看作是网络的整体状态，每一层都在这个状态中加入自己的 k 个特征图。全局状态可以从网络中的任何地方访问，而且与传统的网络架构不同，不需要在层与层之间进行复制。虽然每层只产生 k 个输出特征图，但它通常有更多的输入。可以在每个 3×3 卷积之前引入一个 1×1 卷积作为瓶颈层，以减少输入特征图的数量，从而提高计算效率。作者发现这种设计对 DenseNet 特别有效，于是把带有这种瓶颈层的网络，即 H_l 的BN-ReLU-Conv(1×1)-BN-ReLU-Conv(3×3) 版本，命名为 DenseNet-B。

为了进一步优化模型的简洁性，可以在 transition layer 中降低 feature map 的数量。若一个 Dense block 中包含 m 个 feature maps，那么我们使其输出连接的 transition layer 层生成 ⌊θ_m⌋ 个输出 feature map。其中 θ 为压缩因子。当 θ=1 时，transition layer 将保留原特征维度不变。作者将使用压缩处理且 θ=0.5 的 DenseNet 命名为DenseNet-C，将引入瓶颈层和压缩处理且 θ=0.5 的 DenseNet 命名为 DenseNet-BC。

当前 SOTA！平台收录 DenseNet 共 18 个模型实现资源，支持的主流框架包含 CANN、PyTorch、TensorFlow、PaddlePaddle、Torch 等。

{% asset_img 4.webp %}

| 项目 | SOTA！平台项目详情页 |
| :-- | :------------------ |
| DenseNet | 前往 SOTA！模型平台获取实现资源：https://sota.jiqizhixin.com/models/models/5c51c076-350d-4d1c-a142-66c6e04b6e61 |

***

### MobileNet（MobileNet系列）

MobileNet 模型是 Google 针对手机等嵌入式设备提出的一种**轻量级**的深层神经网络，其核心思想是**depthwise separable convolution（深度可分离卷积）**，而整个网络实际上就是深度可分离卷积模块的堆叠。该系列包括 MobileNet v1、v2 和 v3。

MobileNet V1 是由 Google 在 2016 年提出，CVPR 2017 发表的文章。深度可分离卷积已被证明是轻量级网络的有效设计，它是因子化卷积的一种形式，将标准卷积分解为深度卷积和 1×1 卷积，称为逐点卷积（pointwise）。对于移动网络来说，纵深卷积对每个输入通道应用一个单一的过滤器。然后，逐点卷积应用 1×1 卷积来组合逐深度卷积的输出，主要作用就是对特征图进行升维和降维。标准卷积在一个步骤中对输入进行过滤并合并成一组新的输出。深度可分离卷积则分成两层，一个单独的过滤层和一个单独的组合层。这种因子分解具有大幅减少计算和模型大小的效果。图 2 显示了一个标准卷积（图 2(a)）是如何被分解成逐深度卷积（图 2(b)）和 1×1 逐点卷积（图 2(c)）的。

{% asset_img 5.webp %}
<div align='center'>图2. (a)中的标准卷积滤波器被两层所取代：(b)中的逐深度卷积和(c)中的逐点卷积，以建立一个深度可分离的滤波器</div>

标准卷积层将 DF×DF×M 的特征图 F 作为输入，产生 DF×DF×N 的特征图 G，其中DF 是正方形输入特征图的空间宽度和高度，M 是输入通道的数量（输入深度），DG 是正方形输出特征图的空间宽度和高度，N 是输出通道的数量（输出深度）。标准卷积层的参数是大小为 DK×DK×M×N 的卷积核 K，其中 DK 是假定为方形的核的空间维度，M 是输入通道数，N 是前面定义的输出通道数。假设跨度为 1，标准卷积的输出特征图计算为：

{% asset_img 6.webp %}

标准卷积的计算成本为：

{% asset_img 7.webp %}

其中，计算成本为输入通道数 M、输出通道数 N、内核大小 Dk × Dk 和特征图大小 DF × DF 的倍数。MobileNet 模型解决了这些条款中的每一项及其相互作用。首先，它使用深度可分离卷积来打破输出通道的数量和内核的大小之间的相互作用。

深度可分离卷积是由两层组成的：逐深度卷积和逐点卷积。我们使用逐深度卷积来为每个输入通道（输入深度）应用一个过滤器。顺时针卷积，一个简单的 1×1 卷积，被用来创建深度层输出的线性组合。每个输入通道有一个滤波器的纵深卷积 (输入深度)可以写作：

{% asset_img 8.webp %}

K^为大小为 DK × DK × M 的深度卷积核。逐深度卷积的计算成本为：

{% asset_img 9.webp %}

逐深度卷积相对于标准卷积来说是非常有效的。然而，它只是对输入通道进行过滤，并没有将它们结合起来以构建新的特征。因此，需要一个额外的层，通过 1×1 卷积计算深度卷积输出的线性组合，以产生这些新的特征。深度可分离卷积成本为：

{% asset_img 10.webp %}

通过将卷积表达为过滤和组合的两步过程，减少了计算量：

对比标准卷积和深度可分离卷积的计算量就会发现，因为卷积核的尺寸 K 通常远小于输出通道数 ，因此标准卷积的计算复杂度近似为 DW + PW 组合卷积的 K^2 倍。计算量减少，模型的计算过程自然会快。MobileNet 使用 3×3 的深度可分离卷积，比标准卷积的计算量少了 8 到 9 倍，而准确度只是略有下降。

MobileNet v1 的结构定义在表 1 中。除了最后的全连接层没有非线性之外，所有的层都有一个 batchnorm 和 ReLU，并将其送入一个 softmax 层进行分类。

{% asset_img 11.webp %}
<div align='center'>表1 MobileNet的结构</div>

图 3 将具有常规卷积、batchnorm 和 ReLU 的层与具有逐深度卷积、1×1 逐点状卷积以及 batchnorm 和每个卷积层后的 ReLU 的因子化层进行了对比。在逐深度卷积和第一层中，向下采样是用分层卷积处理的。在全连接层之前，最后的平均集合将空间分辨率降低到1。将逐深度和逐点卷积算作独立的层，MobileNet 有 28 层。

{% asset_img 12.webp %}
<div align='center'>图 3. 左图：带有 batchnorm 和 ReLU 的标准卷积层。右图：深度可分离卷积层与逐深度和逐点数层，然后是 batchnorm 和 ReLU。</div>

由图 3，MobileNet v1 的结构实际上非常简单，是类似于 VGG 的直筒结构，没有复用图像特征。此外，逐深度卷积也存在一些问题，一是在处理低维数据（比如逐深度的卷积）时，relu 函数会造成信息的丢失；二是，DW 卷积由于本身的计算特性决定它自己没有改变通道数的能力，上一层给它多少通道，它就只能输出多少通道。所以如果上一层给的通道数本身很少的话，DW 也只能在低维空间提特征，因此效果不够好。

与 v1 相比，MobileNet v2 提出了 Bottleneck Residual Block（瓶颈残差模块）（《MobileNetV2: Inverted Residuals and Linear Bottlenecks》https://arxiv.org/pdf/1801.04381.pdf）。MobileNet v2 最后的 Point-Wise 卷积的ReLU 都换成了线性函数，作者将这个操作命名为 linear bottleneck 。深度卷积本身没有改变通道的作用，为了能让深度卷积能在高维上工作，v2 提出在深度卷积之前加一个扩充通道的卷积操作，即增加一个 1x1 卷积。这种在深度卷积之前扩充通道的操作在 v2 中被称作 Expansion layer 。此外，v2 在 v1 网络结构基础上加入了跳跃连接。相较于引入跳跃连接的 ResNet 的残差块结构，v2 给这种结构命名为 Inverted resdiual block，即倒残差块。如图 4 所示。

{% asset_img 13.webp %}
<div align='center'>图 4 残差块和倒残差的区别</div>

对角线上加盖的层不使用非线性。我们用每个块的厚度来表示它的相对通道数。注意经典的残差是如何连接通道数量多的层的，而倒置的残差则是连接瓶颈的

综合上述三个关键点：Linear Bottlenecks、Expansion layer 和 Inverted resdiual 之后就组成了 MobileNet v2 的 block，如图 5 所示。

{% asset_img 14.webp %}
<div align='center'>图5 MobileNet v2 结构</div>

MobileNet v3 是谷歌于 2019 年提出的（《Searching for MobileNetV3》1905.02244.pdf (arxiv.org)）。在 v2 网络的基础上，v3 提出了四个大的改进措施：一是，使用 NAS 神经架构搜索确定网络结构；二是在 v2 的 block 基础上引入Squeeze and Excitation 结构；三是使用 h-swish 激活函数；四是对 v2 网络尾部结构进行改进。MobileNet v3 的结构如图 6。

{% asset_img 15.webp %}
<div align='center'>图 6 MobileNet v3 结构</div>

当前 SOTA！平台收录 MobileNet 共 8 个模型实现资源，支持的主流框架包含 TensorFlow、CANN、PaddlePaddle、PyTorch 等。

{% asset_img 16.webp %}

| 项目 | SOTA！平台项目详情页 |
| :-- | :------------------ |
| MobileNet | 前往 SOTA！模型平台获取实现资源：https://sota.jiqizhixin.com/models/models/111fcb54-cf50-49f0-a340-2b80ce56ae4c |

***

### SENet

SENet 是 ImageNet 2017 的冠军模型，正式论文发表在 CVPR 2018。SENet **引入通道注意力机制，对通道进行加权**，这不是引入一个新的空间维度来进行特征通道间的融合，而是采用了一种全新的“特征重标定”策略，此外，SENet 是即插即用的。因此，和ResNet 的出现类似，SENet 在很大程度上减小了之前模型的错误率，并且降低了复杂度，新增参数和计算量小。SENet的全称是 Squeeze-and-Excitation Networks，即压缩和激励网络。

SENet 和 ResNet 很相似，但比 ResNet 做得更多。ResNet 只是增加了一个跳跃连接（skip connection），而 SENet 在相邻两层之间加入了处理，使得通道之间的信息交互成为可能，进一步提高了网络的准确率。此外，SENet 可以随意插入到任何网络中，提升效果非常显著。

SENet 主要由两部分组成：
1. Squeeze 部分。即为压缩部分，原始 feature map 的维度为 H x W x C，其中 H 是高度（Height），W 是宽度（width），C 是通道数（channel）。Squeeze 做的事情是把 H x W x C 压缩为 1x1xC，相当于把 HW 压缩成一维了，实际中一般是用global average pooling 实现的。HW 压缩成一维后，相当于这一维参数获得了之前 HW 全局的视野，感受区域更广。
2. Excitation 部分。得到 Squeeze 的 1x1xC 的表示后，加入一个 FC 全连接层（Fully Connected），对每个通道的重要性进行预测，得到不同通道的重要性大小后再作用（激励）到之前的 feature map 的对应通道上，再进行后续操作。

这两部分的作用分别是：
1. Squeeze 的影响。我们观察到，全局信息的使用对模型的性能有很大的影响，强调了 squeeze 操作的重要性。此外，与 NoSqueeze 设计相比，SENet 的 SE（Squeeze-and-Excitation）块允许以一种计算简单的方式使用这种全局信息。
2. Excitation 的作用。SE 块产生了特定于实例的反应，但其功能是支持模型在架构中不同层的越来越多的特定类别需求。

图 7 给出了 SE 构建块的结构。对于任何给定的转换 F_tr 将输入 X 映射到特征图 U。U 首先通过挤压（Squeeze）操作，通过在其空间维度（H×W）上聚集特征图，产生一个通道描述符。这个描述符的功能是产生一个通道式特征响应的全局分布的嵌入，使网络的全局感应域的信息能够被其所有层使用。聚合之后是激励（Excitation）操作，其形式是一个简单的自门控机制，将嵌入作为输入，并产生一个每个通道调制权重的集合。这些权重被应用于特征图 U，以产生 SE 块的输出，可以直接输入网络的后续层。

{% asset_img 17.webp %}
<div align='center'>图7 Squeeze-and-Excitation（SE）块</div>

通过简单地堆叠 SE 块的集合，就可以构建一个 SE 网络（SENet）。此外，这些SE块还可以在网络结构中的一系列深度上作为原始块的投放替代物。虽然构件的模板是通用的，但它在整个网络的不同深度所发挥的作用是不同的。在早期层中，它以一种与类别无关的方式激发信息特征，加强共享的低层次表征。在后面的层中，SE 块变得越来越专门化，并以高度特定的方式对不同的输入作出反应。因此，由 SE 块执行的特征重新校准的好处可以通过网络累积。

通过在每次卷积之后的非线性变换之后插入，可以将SE块集成到很多模型中，例如VGGNet。而且，SE 块的灵活性意味着它可以直接应用于标准卷积以外的转换。为了说明这一点，作者通过将 SE 块合并到一些更复杂的体系结构示例中来开发 SENet，如图 8 和图 9 所示。

{% asset_img 18.webp %}
<div align='center'>图8 原始 Inception 模块（左）和 SEInception 模块（右）的模式</div>

{% asset_img 19.webp %}
<div align='center'>图9 原始的 Residual 模块（左）和 SEResNet 模块（右）</div>

对 Inception 网络的 SE 块的构造。只需将转换 F_tr 作为整个 Inception 模块（见图18），通过对架构中的每一个这样的模块做这样的改变，可以得到一个 SE-Inception 网络。SE 块也可以直接用于 Residual 网络（图 9 描述了一个 SE-ResNet 模块的模式）。这里，SE 块变换 F_tr 被认为是一个 Residual 模块的非同一性分支。挤压和激励都是在与身份分支相加之前发生作用。

当前 SOTA！平台收录 SENet 共 15 个模型实现资源，支持的主流框架包含 CANN、PyTorch、MindSpore、PaddlePaddle、TensorFlow 等。

{% asset_img 20.webp %}

| 项目 | SOTA！平台项目详情页 |
| :-- | :------------------ |
| SENet | 前往 SOTA！模型平台获取实现资源：https://sota.jiqizhixin.com/models/models/c7dfc0ec-ee5d-4d85-866d-0b4ac306e1ff |

***

### DPN

Dual Path Networks（DPN）**通过High Order RNN（HORNN）将ResNet和DenseNet 进行了融合，所谓的 dual path，即一条 path 是 ResNet，另一条 path 是 DenseNet**。通过对 ResNet 和 DenseNet 的分解，证明了 ResNet 更侧重于特征的复用，而 DenseNet 则更侧重于特征的生成，通过分析两个模型的优劣，将两个模型有针对性的组合起来，提出了 DPN，获得了 2017 年 ILSVRC 物体检测的冠军。

{% asset_img 21.webp %}
<div align='center'>图10 不同网络的结构比较</div>

(a)  Residual Network。(b) Densly Connected Network，其中每一层都可以访问之前所有微块的输出。这里，为了与（a）中的微块设计保持一致，增加了一个 1×1 卷积层（下划线）。(c) 通过在 (b) 中的微块之间共享相同输出的第一个 1×1 连接，密集连接的网络退化为一个残差网络。(c) 中的点状矩形突出了残差单元。(d) 本文提出的的Dual Path 结构 DPN。(e) 从实现的角度看 (d) 的等效形式，其中符号 "∫ "表示分割操作，"+"表示元素相加。

由图 10 给出的不同网络结构比较我们可以看出，ResNet 复用了前面网络提取的特征，而每一层的特征都会原封不动的传到下一层，这样每一层提取到的特征都有其不同点，特征的冗余度较低。而 DenseNet 的每个 1 x 1 卷积的参数都不同，前面提到的层不再被后面的层直接使用，而是被重新加工后生成了新的特征，这种结构可能会造成后面的层提取到的特征是前面的网络已经提取过的特征，所以说 DenseNet 是一个冗余度比较高的网络。通过分析可以看出，ResNet 的缺点是特征复用率高，但是冗余度低，而DenseNet 则可以创造新的特征，但是其冗余度高，基于这个动机，作者结合了两个网络的优点，创造了 DPN。

DPN 以 ResNet 为主要框架，保证了特征的低冗余度，并在其基础上添加了一个非常小的 DenseNet 分支，用于生成新的特征。DPN 的结构可以使用下面的公式来表示：

{% asset_img 22.webp %}

其中 x^k 和 y^k 表示在第 k 步从单个路径中提取的信息，v_t() 是一个特征学习函数。第一个式子表征 densely connected 的路径，能够探索新的特征。第二个式子表征残差路径，使共同的特征得以重新使用。第三个式子表征 dual path，用于聚合第四个式子的变换函数。最后的转换函数 g^k() 生成当前状态，用于生成下一个映射或预测。

图 10（e）是真正的 DPN 结构，和图 10（d）的最大不同在于 ResNet 和 DenseNet共享了第一个 1 x 1 卷积。在实际计算 3 x 3 卷积时，使用了分组卷积来提升网络的性能。在设计网络的超参时，ResNet 的通道数也比 DenseNet 的通道数多，防止DenseNet 随着层数的增加引发的显存消耗速度过快的问题。

{% asset_img 23.webp %}
<div align='center'>表2 DPN 和其他最先进的网络的结构和复杂性比较（DenseNet和ResNeXt）。符号（+k）表示 densely connected 路径上的宽度增量</div>

当前 SOTA！平台收录 DPN 共 8 个模型实现资源，支持的主流框架包含 CANN、PyTorch、TensorFlow、MindSpore、PaddlePaddle 等。

{% asset_img 24.webp %}

| 项目 | SOTA！平台项目详情页 |
| :-- | :------------------ |
| DPN | 前往 SOTA！模型平台获取实现资源：https://sota.jiqizhixin.com/models/models/4431847d-c2b1-4cba-a31a-fa5585495abb |

***

### IGC

IGC（Interleaved Group Convolutions），是指交错分组卷积。IGC v1 发表在 2017年的 ICCV 上。IGC 提出了一种**新的网络单元交错分组卷积（interleaved group convolution），有助于提高参数优化和计算性能**。在保持相同的网络大小和计算复杂度的情况下，提出的网络单元相比传统的组卷积具有更宽的宽度，也就具有更先进的表现。

IGC 的构建模块基于分组卷积，这是一种将输入通道划分为若干分区并对每个分区分别进行常规卷积的方法。分组卷积可以被看作是具有稀疏块对角线卷积核的常规卷积，其中每个块对应于通道的一个分区，并且分区之间没有连接。交错组卷积由两个分组卷积组成，primary 组卷积和 secondary 组卷积。图 11 中给出一个例子。使用 primary 组卷积来处理空间相关性，并采用空间卷积核，如 3×3。卷积是在每个分区的通道上分别进行的。作者使用 secondary 组卷积来混合由 primary 组卷积输出的各分区的通道，使用 1×1 卷积核。IGCNet v1 就是使用的结构化稀疏的思想，将一个传统的卷积矩阵转化成一个稀疏的对角矩阵，以减少计算量与参数量。

{% asset_img 25.webp %}
<div align='center'>图11 交错分组卷积，L=2 个 primary 分区，M=3 个 secondary 分区。primary 组卷积中每个 primary 分区的卷积是空间的。secondary 组卷积中的每个 secondary 分区的卷积是点状的（1×1）</div>

**primary组卷积。**令 L 表示 primary 组卷积中的分区数量，称为 primary 分区。我们选择每个分区包含相同数量（M）的通道。作者提出在单一空间位置上的分组卷积，对所有空间位置的表述都很容易得到。primary 组卷积的情况如下：

{% asset_img 26.webp %}

其中 z_l 为（MS）维度向量，S 为核大小，例如 3x3 核为 9。(W_ll)^p 对应于第 l 个分区的卷积核，是一个大小为 M×(MS) 的矩阵。x 表征 primary 组卷积的输入。

**secondary组卷积。**将 primary 组卷积输出的通道{y1, y2, .... , yL}，分成 M 个 secondary 分区，每个分区由 L 个通道组成，这样，同一 secondary 分区的通道来自不同的 primary 分区。作者采用一个简单的方案来形成 secondary 分区：第 m 个 secondary 分区是由每个 primary 分区的第 m 个输出通道组成。

{% asset_img 27.webp %}

-y_m 表征第 m 个 secondary 分区，P 为扰动矩阵。secondary 组卷积是在 M 个 secondary 分区上进行的：

{% asset_img 28.webp %}

其中，(W_mm)^d 对应第 m 个 secondary 分区的 1x1 卷积核，为 LxL 大小的矩阵。secondary 组卷积输出的通道通过扰动后退回 primary 形式，作为下一个交错组卷积块的输入。L 扰动回退操作为：

{% asset_img 29.webp %}

综上所述，交错组卷积块被表述为

{% asset_img 30.webp %}

令  W=PW^dP^TW^p 为 复合卷积核，则可得到：

{% asset_img 31.webp %}

这意味着 IGC 块等同于一个常规卷积，卷积核是两个稀疏核的乘积。参数量固定意味着主分组卷积和次卷积的有效参数固定，当输入的特征维度更多时，卷积核也越大，卷积矩阵将变得更加稀疏，这可能导致性能的下降。

由表 3，IGC 采用 IGC+BN+ReLU 的设置。

{% asset_img 32.webp %}
<div align='center'>表3 IGC结构</div>

上面介绍的 IGC 为经典 IGC，也被称为 IGC v1。IGCNet v1 通过两个分组卷积来对原卷积进行分解，减少参数且保持完整的信息提取。不过作者发现，因为 primary 组卷积和 secondary 组卷积在分组数上是互补的，导致 secondary 卷积的分组数一般较小，每个分组的维度较大，secondary 卷积核较为稠密。为此，作者提出了 IGCV2，**引入Interleaved Structured Sparse Convolution，使用多个连续的稀疏分组卷积来替换原来的secondary分组卷积，每个分组卷积的分组数都足够多，以保证卷积核的稀疏性。**（《 IGCV2: Interleaved Structured Sparse Convolutional Neural Networks 》1804.06202.pdf (arxiv.org)）。

IGCNet v2 的主要创新点就是在 IGCNet v1 的基础上，对于 block 里的 secondary 组卷积再进行一次 IGC，以及使用多个稀疏卷积来替换原本比较稠密的 secondary 卷积。

{% asset_img 33.webp %}
<div align='center'>图12 IGC v2的结构</div>

当前 SOTA！平台收录 IGC V1 共 1 个模型实现资源，支持的主流框架包含 MXNet。

{% asset_img 34.webp %}

| 项目 | SOTA！平台项目详情页 |
| :-- | :------------------ |
| IGC V1 | 前往 SOTA！模型平台获取实现资源：https://sota.jiqizhixin.com/models/models/8a1636be-753d-4b72-a4c7-ec7a9f6ffc6f |

***

### 参考资料

> <https://mp.weixin.qq.com/s/8Svli4dmU3Hyq-932_SXgQ>
