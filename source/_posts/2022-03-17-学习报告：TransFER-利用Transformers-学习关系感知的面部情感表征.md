---
title: 学习报告：TransFER：利用Transformers 学习关系感知的面部情感表征
categories:
  - 🌙进阶学习
  - ⭐脑机接口与混合智能研究团队（BCI团队）
  - 💫学习报告
abbrlink: ca83c09a
date: 2022-03-17 18:32:48
tags:
---

本次分享的学习报告围绕ICCV（International Conference on Computer Vision）2021的一篇文章《TransFER: Learning Relation-aware Facial Expression Representations with Transformers》[1]进行分享。

<!--more-->

***

### 论文背景与相关工作

在过去的几十年里，面部表情识别（Facial Expression Recognition，简称FER）在计算机视觉研究领域得到了越来越多的关注，因为它对于让计算机理解人类的情感，实现更智能的人机交互非常重要。虽然近几年FER领域不断取得新的突破，但FER自身存在两大难题仍然使得这项任务具备挑战，这两大难题分别是：（1）极大的类间相似性（inter-class similarities）。图1展示了两张表情相似度较高，但是属于不同表情类别的图片。如果仅从嘴部区域去判断图片中人的表情非常容易出错，需要结合人的眼部周围的一些信息才更准确地进行判断。（2）极小的类内相似性（intra-class similarities.）。属于同一类别的表情表现方式随着不同人的种族、性别、年龄和文化背景的不同而可能产生巨大的差异。 

{% asset_img 1.webp %}
<div align='center'>图1 两张表情相似度较高，但是属于不同表情类别的图片。（左）惊讶，（右）生气。</div>

针对上述问题而提出的一些改进方法可大致分为两类：基于全局特征的方法和基于局部特征的方法。基于全局特征的方法主要是通过设计新的损失函数对网络进行约束进而提高特征的表达能力[2]。由于这些方法都是以全局面部图像作为输入，模型仍然侧重学习全局的信息进而忽略一些细微却关键的面部区域，因而仍然难以解决类间相似性过大的问题。而基于局部特征的方法侧重于综合不同的面部区域信息学习具有区分性的特征。基于局部特征的方法又可以具体地分为基于特征点的方法和基于注意力的方法。

基于特征点的方法[3]是指提取脸部特征点附近的面部图像特征以进行表情的识别。但当图像被严重遮挡或人的姿态发生大幅度偏转，现有的特征点定位方法可能无法正确定位特征点。另外，脸部特征点位置都是人为设定的，真正反映人脸表情的区域不一定出现在设定特征点的附近。因此在FER中捕捉关键的面部区域是很有必要的，同时对于非关键区域的图像特征需要减少其对模型识别过程的影响。基于注意力的方法则是利用注意力机制引导算法模型关注更容易辨别表情的面部区域以更准确地对表情进行分类。但现有的方法对于一个情感类别往往只关注一个较大面部区域，细微的面部区域容易被忽略，且区域与区域之间没有关联，若出现类似于图1的情况，现有的基于注意力的方法容易只依赖嘴部区域去辨别表情进而出现错误的判断。因此在FER中关注细微的局部区域并将这些区域与大的关键区域进行关联也是很有必要的。

***

### 提出的方法

针对基于局部特征的方法存在问题，文章认为在FER中需要同时关注范围较大的面部关键区域以及细微的面部区域，并将这两种区域互相关联，共同辅助模型更好地理解人脸表情。与此同时，模型训练过程中也需要抑制非关键区域的面部特征的影响。因此文章提出了TransFER模型来学习不同关系感知的局部面部情感表征，模型的整体结构如图2所示。 

{% asset_img 2.webp %}
<div align='center'>图2 [1]中提出的TransFER模型结构图</div>

从图2中我们可以看到整个网络主要分成两大部分。在Local CNNs中，图像经过主干网络（Stem CNN）后转换为长，宽，通道数分别为h, w, c的特征图X。随后利用B个不同权重的LANet将X转换为长与宽尺寸相同但通道数为1的特征图M(b)，b的取值范围为[1,B]。从图2中我们可以看到，LANet作用相当于空间注意力机制，将原始的特征图转化为关注局部特征的权重特征图。而MAD（Multi-Attention Dropping）则是借鉴了Dropout[4]的思想，在训练过程中会随机从B个权重特征图中“舍弃”一个（具体操作是将“舍弃”特征图的每个像素值设为0），使得模型无法仅仅依赖特定局部特征进行表情的识别，同时引导模型关注不同局部特征的关联性。在计算完所有的权重特征图后，在所有的权重特征图中取每个像素的最大值，构成最终的输出权重特征图M(out)，再与原始特征图X进行逐项乘法运算后得到输出空间特征图X(out)。

从Local CNNs获得输出空间特征图X(out)后，首先利用1×1卷积将X(out)转换为长与宽不变通道数变为c(2)的Transformer的输入特征图X(p)。随后将X(p)切分成c(2)个长度为h×w的特征向量x作为Transformer的输入。与传统Transformer网络不同，文章在多头自注意力层后加入了MAD策略，同样是引导网络关注不同区域的关联性。值得注意的是，图中网络另一大组成部分MSAD是指Multi-head Self-Attention Dropping，即在Transformer的多头自注意力层后加入MAD。虽然用MSAD来指代Transformer+MAD的网络结构容易误导读者，但文章此举的意图应该是为了进一步突出文章对于Transformer的改进。

***

### 实验

文章的实验是在三个自然场景下的表情数据集FERPlus[5]、RAF-DB[2]以及AffectNet[6]上进行模型验证的，这三个使用的数据集也是当前FER中最有挑战性的数据集。由于文章做了大量的消融与对比实验，在学习报告中不一一列举，仅选择几个关键的实验进行分享，感兴趣的同学可以下载原文查看完整的实验。

{% asset_img 3.webp %}

表1展示了依次往模型添加文章提出的不同模块时在RAF-DB和AffectNet上的测试结果。需要说明一下的是，在文章展示的模型结构图中，MAD是包含在Local CNNs的，但后续的实验中Local CNNs表示不包含MAD的其余结构。从表中可以看到，在使用了Local CNNs，以及不断添加了MAD和MSAD后，两个数据集上的实验效果也是不断提升的，证明了文章提出的这些模块都是有效的。而文章中最核心的创新点MAD机制对比直接使用Dropout或者类似的机制如Drop Block[7]、Spatial Dropout[8]文章作者也专门进行了对比实验，实验结果如表2所示。从表2可以看到，对比同类的机制，文章提出的MAD分别在RAF-DB和AffectNet上至少提升了0.56%和0.17%，证明了MAD是有效的。

{% asset_img 4.webp %}
{% asset_img 5.webp %}
<div align='center'>图3 不同方法在AffectNet不同类别的一个图像示例上的注意力可视化结果 </div>

最后一个值得关注的实验是可视化的实验，图3展示了不同方法在AffectNet不同类别的一个图像示例上的注意力可视化结果。其中，图3（a）至（f）每一行分别表示愤怒、厌恶、恐惧、开心、中立、悲伤以及惊讶的表情。第一列代表原始图像，第二列至第三列分别是基准方法、只使用Local CNNs的方法、Local CNNs加上了MAD的方法以及完整TransFER的方法的注意力可视化效果。从可视化结果我们可以看到在未添加MAD前，无论是基准方法还是使用Local CNNs但未加MAD的方法对大部分表情重点只关注一个面部区域的特征。而在使用了MAD之后，模型会关注多个面部区域并将它们互相关联，共同用于辅助对最终结果的判断，因此文章提出的改进方法是有效的。

***

### 学习总结

纵观整篇文章，我们可以发现这篇文章本质上仅有MAD一个核心的创新点，但在添加了丰富的实验以及优秀的“讲故事”能力后，文章依然可以发表在顶级的会议上。这其中也告诉我们：（1）好的文章真正意义上的创新点并不需要太多。抛开运气的成分，如果我们能富有逻辑地阐述、推理你的idea，并通过大量的实验去证明你提出创新点的有效性，那我们的工作本身就不会太差，甚至能够冲击好的期刊或会议。（2）创新点未必越复杂越好。本篇文章的核心创新点MAD，在真正的实现过程中，仅需要在每轮训练的时候将一层特征图用0填充。对框架熟悉的话，仅需几行代码即可实现。且MAD的核心思想源自于每一位使用过深度学习框架的人员都知道的Dropout机制。这也告诉我们在日常的学习中需要多思考，多读论文，有时候在某个领域常用的东西经过转换后可能就能形成自己的创新点。

由于这篇文章是会议论文，所以文章中很多东西需要有大量的储备知识才能够看懂。且文中很多细节上的东西会使读者感到疑惑，如图中用MSAD表示整个Transformer+MAD结构以及Local CNNs的含义前后不一致等，这也告诉我们在日后自己的文章中需要多考虑从读者的角度去审视所写内容，自己所能了解的东西未必读者就能轻易理解。

***

> [1] XUE F, WANG Q, GUO G. Transfer: Learning relation-aware facial Expression representations with transformers[C]//Proceedings of the IEEE/CVF International Conference on Computer Vision. 2021: 3601-3610.
> [2] LI S, DENG W, DU J. Reliable crowdsourcing and deep locality-preserving learning for Expression recognition in the wild[C]//Proceedings of the IEEE conference on computer vision and pattern recognition. 2017: 2852-2861.
> [3] XIE S, HU H, WU Y. Deep multi-path convolutional neural network joint with salient region attention for facial Expression recognition[J]. Pattern Recognition, 2019, 92: 177-191.
> [4] SRIVASTAVA N, HINTON G, KRIZHEVSKY A, et al. Dropout: a simple way to prevent neural networks from overfitting[J]. The journal of machine learning research, 2014, 15(1): 1929-1958.
> [5] BARSOUM E, ZHANG C, FERRER C C, et al. Training deep networks for facial Expression recognition with crowd-sourced label distribution[C]//Proceedings of the 18th ACM International Conference on Multimodal Interaction. 2016: 279-283.
> [6] MOLLAHOSSEINI A, HASANI B, MAHOOR M H. Affectnet: A database for facial Expression, valence, and arousal computing in the wild[J]. IEEE Transactions on Affective Computing, 2017, 10(1): 18-31.
> [7] GHIASI G, LIN T-Y, LE Q V. Dropblock: A regularization method for convolutional networks[J]. Advances in neural information processing systems, 2018, 31.
> [8] TOMPSON J, GOROSHIN R, JAIN A, et al. Efficient object localization using convolutional networks[C]//Proceedings of the IEEE conference on computer vision and pattern recognition. 2015: 648-656.

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=11305>
