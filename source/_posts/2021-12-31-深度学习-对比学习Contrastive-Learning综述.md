---
title: 对比学习Contrastive Learning综述
categories:
  - 🌙进阶学习
  - ⭐论文带读
  - 💫精读经典
abbrlink: cec8ebcf
date: 2021-12-31 23:28:04
tags:
---

自监督学习有生成式学习和对比学习，对比学习需要从无标注的数据中学习特征表示，并用于下游任务中。指导原则是: 通过构造相似实例和不相似实例，学习一个表示学习模型，使得相似的实例在投影空间中较接近，不相似的实例在投影空间中距离较远。对比学习有三个关键问题: 1. 正负样本的构造 2. 编码器的设计 3. Loss函数的选取。

过去几年，尤其是18年开始到现在，对比学习在计算机视觉领域的发展历程，总结一下可以规划成四个阶段:
1. 2018~2019年中，Inst Disc、CPC、CMC等方法和模型都还没有统一，目标函数和代理任务也还没有统一;
2. 2019~2020年中，SimCLR 、 Moco、 CPC/CMC的延伸工作、SwAV，这个阶段发展非常迅速;
3. 不用负样本也可以做对比学习，如BYOL和后续改进，SimSiam把所有方法总结归纳融入SimSiam框架，是用CNN做对比学习的一个总结;
4. Transformer时代，MoCo-v3和DINO。随着Vision Transformer的爆火，对于自监督学习，不论是对比学习还是最新的掩码学习，都是用VIT做的。

<!--more-->

***

### 第一阶段：2018~2019年中

Inst Disc、CPC、CMC等，方法和模型都还没有统一，目标函数和代理任务也还没有统一。

#### Inst Disc - Unsupervised Feature Learning via Non-Parametric Instance Discrimination

basic idea：让图片聚集在一起的原因并不是因为他们有相同的语义标签，而是图片(object)很相似。采用个体判别任务——无监督学习方式，把每个instance看成一个类别，目标就是能学一种特征，从而把每个图片都区分开。

{% asset_img 1.webp %}

正样本：图片本身+数据增强 负样本：其他图片
memory bank: 存所有图片的特征，也就是一个字典，每个特征的维度不能太高——128维。
NCE loss 算对比学习的目标函数。更新完网络后，把mini batch的特征到memory bank更换掉。反复更新encoder和memory bank。
Proximal Regularization: 给模型训练加了约束，让memory bank里的特征进行动量式的更新。——跟Moco想法很一致。
实验超参数设置：温度0.07 4096个负样本(从memory bank抽取) 起始learning rate0.03 …
取得了不错的无监督表征学习的结果。

***

#### Unsupervised Embedding Learning via Invariant and Spreading Instance Feature - 2019 - CVPR

基本的对比学习，SimCLR的前身。没有使用额外的数据结构存负样本，正负样本来自同一个minibatch, 就可以只使用一个编码器进行端到端学习。

{% asset_img 2.webp %}

basic idea: 相似的图片和物体特征应该保持不变性。对于不相似的任务，特征应该尽可能分散开。
代理任务——个体判别。目标函数——NCE loss的一个变体

{% asset_img 3.webp %}

原始数据 256 数据增强 256 * 2。正样本 256 负样本(256-1)*2。
end-to-end
字典必须足够大，对比学习时候负样本最好是足够多，本文没有TPU，也没有SimCLR那么强大的数据增广和MLP projector, 所以结果没有那么出彩。

***

#### CPC- Representation Learning with Contrastive Predictive Coding

CPC——用预测的代理任务做对比学习

{% asset_img 4.webp %}

gar——自回归模型。常见的自回归模型auto-regressive：RNN、LSTM
t当前时刻，Ct 代表上下文的一个特征表示，可以用来预测下文。
正样本——未来的输入通过编码器以后得到的未来时刻的特征输出，做出的预测是query，真正的输出是由输入决定的。负样本——很广泛，可以任意选取输入，通过编码器得到输出。
图中的序列可以换成文字序列、图片patch等。

***

#### CMC - Contrastive Multiview Coding

CMC——第一个或者比较早做多视角对比学习的，证明了对比学习的灵活性和多视角多模态的可行性。

{% asset_img 5.webp %}

正样本——四个视角：原始图像，深度信息(每个物体离观察者多远), surface normal、物体分割图像，虽然输入来自不同的传感器，或者不同的模态，但是对应一张图片，互为正样本。特征空间中，四个绿色点应该接近，负样本特征红点应该远离绿色。

基于CMC，OpenAI在2021年提出了**CLIP模型**，利用text信息监督视觉任务自训练，本质就是将分类任务化成了图文匹配任务，效果可与全监督方法相当。多模态的对比学习。CLIP文本端用BERT,图像端用VIT，不同的模态需要不同的编码器。Transformer的好处：可以同时处理不同模态的数据。

CMC利用对比学习的思想，做了一篇蒸馏的工作：不论用什么网络，只要输入是同一张图片，得到的特征应该尽可能类似(eg. teacher和student作为正样本对，从而做对比学习)。

***

### 第二阶段：2019年中~2020年中

SimCLR 、 Moco、 CPC/CMC的延伸工作、SwAV，这个阶段发展非常迅速。

#### MoCo - Momentum Contrast for Unsupervised Visual Representation Learning

MoCo的主要贡献是把之前对比学习的一些方法都归纳总结为一个字典查询的问题。
提出了两个东西：队列queue和动量编码器momentum encoder，从而形成一个又大又一致的字典帮助更好地对比学习。

{% asset_img 6.webp %}

MoCo和 Inst Disc很相似，用queue取代memory bank去存负样本，解决大字典的问题。用动量编码器取代loss里的约束项，从而达到动量更新编码器的目的，而不是动量的更新特征，解决特征不一致问题，从而能得到更好的结果。

实验参数：ResNet as encoder、基线模型res50、特征维度128、L2-norm、目标函数info NCE、 loss温度0.07…

***

#### SimCLR - A Simple Framework for Contrastive Learning of Visual Representations

{% asset_img 7.webp %}

对mini-batch的所有图片做更多的数据增强，得到xi和xj。同一图片延伸得到的两个图片就是正样本，batch size是N的话，正样本个数是N，负样本个数就是剩下所有的样本及增强过后的样本2(N-1)。

经过编码器f 共享权重，得到特征表示h。创新点在h之后又加了一个g函数—projector（只有训练的时候才用g,做下游任务时候是扔掉的），就是一个MLP， 包含全连接层后加一个激活函数relu(Non-linear)。最后衡量一下正样本之间是不是能不能达到最大的一致性。

采用normalized(h后进行L2归一化) temperature scaled(在loss上×个τ)的交叉熵函数。
用了更大的batch size且训练更久

{% asset_img 8.webp %}

最有效的数据增强——crop和color，其他的增强可有可无 锦上添花

{% asset_img 9.webp %}

使用Non-linear会比什么都不用提升十几个点
z最后的维度不管是多少，都没太大区别，所以对比学习都选一个比较低的维度，128就够了。

***

#### MoCo v2 - Improved Baselines with Momentum Contrastive Learning

{% asset_img 10.webp %}

在SimCLR的基础上，moco v2：MLP + aug+ + cosine learning rate schedule + 800 epochs

无监督学习训练越久 模型越大 结果会更好些

{% asset_img 11.webp %}

MoCo v2相对于SimCLR的优越性——硬件。SimCLR——end to end

{% asset_img 12.webp %}

***

#### SimCLR v2 - Big Self-Supervised Models are Strong Semi-Supervised Learners

{% asset_img 13.webp %}

自监督的对比学习去训练一个大的模型出来， 有一小部分有监督的数据去做一个有监督的微调， 用模型生成很多伪标签，可以在更多无标签的数据上去做自学习。

SimCLR v1 - v2的改进：v2是个两页的技术报告
- 更大的模型，152层的ResNet Selective kernels SK net，骨干网络很强
- SimCLR的projector MLP层有用， 多加几层？两层的MLP就够了，由原来的fc+relu变成fc+relu fc+relu，加深了projection head。
- 也使用了动量编码器，提升不大，因为负样本已经相当多了，字典大小和特征一致性SimCLR已经足够好了。

***

#### SwAV - Unsupervised Learning of Visual Features by Contrasting Cluster Assignments - CNN中用res50分最高的工作75.3

basic idea: 给定同样的图片，生成不同的视角， 希望可以用一个view得到的特征去预测另外一个视角得到的特征， 所以view的特征应该是非常接近的。

做法：把对比学习和聚类(无监督的特征表示学习方式，相似的物体聚集在某个聚类中心附近，不相似的尽量推开)结合。

{% asset_img 14.webp %}

左：之前对比学习的方法，同一个图片做两次数据增强，所有的样本通过一个编码器(res50或加一个projection head)，得到一个特征，去做对比学习的loss就可以。
右：SwAV, 左图简单，但是直接拿所有图片的特征去跟特征作对比，有点原始且有点费资源， 因为所有的图片都是自己的类。能不能不做近似， 能不能借助先验信息不去跟大量的负样本比，而去跟一些更简洁的东西比？—— 可以去和聚类中心比，右图中的c(矩阵),维度d*k，d为特征的维度，k是有多少个聚类中心，本文是3000。

区别：得到特征z后并不是直接在特征上做对比学习的loss，而是通过聚类的方法，让特征z和c生成一个目标q1,q2 相当于一个ground truth。z1,z2很相似，按道理可以互相去做预测，代理任务是 z1和c做点乘，可以预测q2，z2和c点乘，可以预测q1，通过换位预测对模型进行训练。

聚类的好处：如果很很多负样本进行类比，需要成千上万的负样本，也是一个近似。而跟聚类中心做类比，可以用几百最多3000个聚类中心就足以表示。另外，聚类中心是有明确地语义含义的，如果只是之前的随机抽样负样本去做对比，有可能抽到正样本，负样本类别也不均衡，不如使用聚类中有效。(参考deep cluster, deep cluster two)

另一个性能提升点：multi-crop，使用了更多的正样本。之前是取224 * 224的两个crop，现在取两个160的crop学习全局的特征，为了增加正样本数量学习局部特征，随机选4个小点的crop 96 * 96。（multi-crop对其他对比学习方法也有用）

{% asset_img 15.webp %}

{% asset_img 16.webp %}

聚类和对比学习的方法结合也没什么优势，multi-crop这个全局和局部特征都要关注的思想才是重点。SwAV算是一个承上启下的工作，也没有用什么负样本，用的聚类中心。

附：CPC v2——用了更大的模型，更大的图像块，做了更多方向上的预测任务，把batch norm换成了layer norm，使用了更多的数据增强

Info Min—— CMC的作者做的分析延伸工作，到底选什么样的视角才能对对比学习最好，提出了InfoMin的原则-最小化互信息，想要不多不少刚好的互信息。按InfoMin原则做合适的数据增强，拿到合适的对比学习的视角。

综上，对比学习到了第二阶段 很多细节都趋于统一，目标函数都是用Info NCE或类似函数去算，模型都是用一个编码器加一个projection head，都采用了更强的数据增强，使用动量编码器，尝试训练更久，在ImageNet上的准确度也逐渐逼近于有监督的基线模型。第三阶段就是不用负样本的对比学习。第二阶段的SwAV也算是一个承上启下的工作，也没有用什么负样本，用的聚类中心，但是明确对比的对象，第三阶段的BYOL和SimSiam就是正样本自己玩，没有负样本和聚类中心 这样明确的东西去做对比。

***

### 第三阶段：2020 不用负样本也可以做对比学习

#### BYOL - Bootstrap Your Own Latent A New Approach to Self-Supervised Learning

Bootstrap: 已经有的东西之上改造， Latent: 特征。看论文看到latent、hidden、feature、embedding都是特征的意思。BYOL自己跟自己学，完全没用任何负样本。在ImageNet上得到74.3的top1准确率。

对比学习中负样本是约束，如果没有负样本，只能让所有相似的物体 特征也尽可能相似，不管给什么输入，都是相同的输出，算对比学习的loss都是0，负样本限制这种什么都学不到的情况发生(model collapse)。

{% asset_img 17.webp %}

mini-batch的输入，数据增强后，上下编码器使用同样的网络架构，但是参数是不同的，上面的通过梯度更新而更新，下面的和MoCo一样是用动量编码器Moving average更新。得到特征，跟SimCLR一样用了一个projector，ztheta是256维，比128维效果好一点， 上下是一样的网络结构但参数不一样。

BYOL加了新的一层q theta，跟g theta一样也是一个MLP，得到一个新的特征q(z theta)，让这个预测跟z xi尽可能一致，把匹配的问题换成一个预测的问题。自己预测自己，sg = stop gradient没有梯度。

上面一行相当于query编码器，下面相当于key的编码器，key的编码器都是query编码器的动量更新，不一样是代理任务不一样，用自己一个视角的特征去预测另外一个视角的特征，去完模型性的训练。训练完成后只有编码器f theta留下了，最后用y theta 2048维的特征去做下游任务。

目标函数MSE loss。

***

#### Blog - How to understand BYOL

{% asset_img 18.webp %}

projection head是MLP，fc+BN+Relu+fc。

BYOL训练的时候不坍塌，肯定是和Batch Norm有关系的。BN是把batch里所有样本的特征拿过来算均值和方差，去做归一化。当算某个正样本的loss的时候，其实也看到了其他样本的特征，这里面是有信息泄露的（Shuffling BN防止信息泄露）。

当有了batch norm之后，BYOL其实并不光是正样本自己跟自己学，其实也在做对比，一种隐式的对比学习：正样本的图片和平均图片(batch norm产生的，有聚类中心的意思，中值的意思)有什么差别。

***

#### BYOL works even without batch statistics

BYOL的作者不想让大家觉得BYOL的成功是依赖于batch norm，做了一系列实验，回应上个blog：

{% asset_img 19.webp %}

当projector有BN的时候，有一个BYOL还是训练失败了，不能解释BN很关键。当encoder和Projector都没有BN的是，SimCLR也失败了，证明BN不是提供了一个隐式的负样本，即使给了显式的负样本还是训练不出来。

最后达成一致：BN主要作用是提高模型训练的稳健性，导致不会模型坍塌。

**BYOL作者实验：Using GN with WS leads to competitive performance**
采用Group Norm 、 Weight Standardization模型初始化方式 都没有计算批统计量，没有隐式的对比，BYOL还是一个全新的自学方式。

***

#### SimSiam - Exploring Simple Siamese Representation Learning

不需要负样本、不需要大的batch size、不需要动量编码器，不仅不模型坍塌，结果也好。

{% asset_img 20.webp %}

孪生网络——两个编码器，一般结构是一样的，共享参数。整体架构和BYOL非常一样。SimSiam Pseudocode, PyTorch-like伪代码：D函数是算loss的，MSE loss 对称性的loss，然后梯度回传，更新网络。

{% asset_img 21.webp %}

SimSiam能够不模型坍塌成功训练，主要是有stop gradient操作的存在，SimSiam可以看成一种EM算法，一个训练过程或者一套模型参数被人为劈成两份，相当于解决两个子问题一样，模型更新也在交替进行。通过逐步更新的方式避免模型坍塌。

{% asset_img 22.webp %}

所有孪生网络的做法归纳：SimCLR end-to-end学习，两边都是有梯度回传的，还是做的一个对比任务。SwAV也是对比任务，没有跟负样本比，跟聚类中心(Sinkhorn-Knopp算法产生的)去比。BYOL新的贡献—predictor，从对比任务变为预测任务，用左边预测右边，还使用了动量编码器，SimSiam和BYOL很像，左边一样，右边没有用动量编码器。

{% asset_img 23.webp %}

分类来说最强的方法 ——BYOL
下游任务：MoCo v2和SimSiam表现最好，对比学习的工作，MoCo v2可当基线模型，训练快、稳，下游任务迁移的好。

Barles Twins:主要就是更换了一个目标函数。把之前的对比和预测，变成两个矩阵之间比相似性。因为是2021年3月提出的，很快淹没在ViT的洪流中。

***

### 第四阶段：2021 Transformer时代

#### MoCo v3 - An Empirical Study of Training Self-Supervised Vision Transformers

MoCo v3只是一种架构，CNN也可以用，ViT也可以用。本文改进自监督训练VIT而更稳定。MoCo v3是MoCo v2和SimSiam的延伸工作

{% asset_img 24.webp %}

{% asset_img 25.webp %}

batch size变大后，准确度会掉下，恢复后也不如原来高。观察训练时候每一层回传梯度的情况。梯度波峰发生在第一层做patch projection的时候。如何把图片打成一个patch给它一个特征是一个可训练的全连接层，梯度不正常不如不训练。随机初始化了一个patch projection层然后冻住，整个训练过程都不变。对MoCo v3和BYOL都有用，用BYOL框架把残差网络换成VIT，patch projection冻住，一样能获得更平滑的曲线，更好地结果。

不改Transformer本身，只能改开头Tokenazition和结尾loss 。

***

#### DINO - Emerging Properties in Self-Supervised Vision Transformers

自监督训练ViT的方式，ViT在自监督训练下的特性: 完全不用任何标签信息，训练出来的ViT，把自注意力图拿出来，可以准确的抓住每个物体的轮廓，媲美无监督分割。

{% asset_img 26.webp %}

{% asset_img 27.webp %}

DINO——Self distillation with no labels 蒸馏的框架，延续了BYOL，换了个名字，student预测teacher，teacher可以想成group-truth。为了避免模型坍塌，DINO做了一个centering，把batch里的样本算一个均值，减掉均值就算centering。stop gradient操作。最后用p1去预测p2。

{% asset_img 28.webp %}

从方法和模型方面，跟第三阶段基本是一样的，主要是融合了ViT。

***

### 一张图总结对比学习历程

{% asset_img 29.webp %}

对比学习还是一个很火的方向，虽然没有ViT火，MAE火爆了后都尝试掩码学习而不是对比学习，对比学习从火爆发展期变成发展潜伏期。而多模态的对比学习还是一个主流，CLIP的效果就很好。在多模态中图像和文本之间的对比学习loss还是一个标准的目标函数。对比学习只是一个想法而不是一个具体工作，几十年前就已经提出来了，接下来应该还会看到很多对比学习和其他方法的结合工作。

***

### 原文链接

> <https://zhuanlan.zhihu.com/p/555359995>
