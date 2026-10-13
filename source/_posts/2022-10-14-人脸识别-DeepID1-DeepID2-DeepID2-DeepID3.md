---
title: 人脸识别-DeepID1 DeepID2 DeepID2+ DeepID3
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: cea9d0ff
date: 2022-10-14 02:36:10
---

DeepID1: [Deep Learning Face Representation from Predicting 10,000 Classes(CVPR2014)](http://www.cv-foundation.org/openaccess/content_cvpr_2014/papers/Sun_Deep_Learning_Face_2014_CVPR_paper.pdf)

DeepID2: [Deep Learning Face Representation by Joint Identification-Verification(CVPR2015)](https://arxiv.org/abs/1406.4773)

DeepID2+: [Deeply learned face representations are sparse, selective, and robust](https://arxiv.org/abs/1412.1265)

DeepID3: [Face Recognition with Very Deep Neural Networks](https://arxiv.org/abs/1502.00873)

<!--more-->

***

### DeepID1

#### 主要思想

1. DeepID1通过深度学习学习到一组高级特征表示集合（被称为Deep hidden IDentitiy feature）用于face verification。
2. 然而，文章并没有用二类分类实现，而是通过学习一个多类（10000类，每个类大约有20个实例）人脸识别任务来学习特征，并把特征泛化到face varification和其他unseen新的identification。**同时指出，随着训练时要预测的人脸类越多，DeepID的泛化能力就越强。**对所有的identities进行多类分类，而不是二值分类，**基于两个考虑：一是，把一个训练样本训练成多个类中的一类，比进行二值分类更困难，这个挑战能够充分利用神经网络的超级学习能力以提取有效特征；二是，隐含的对ConvNet上增加了强规则化，帮助产生对分类有效的共享隐藏层表示。因此，学习到的特征有好的泛化能力。**
3. 关于网络。沿着特征抽取的层次，不断的减少神经元的个数，就会逐渐在高层形成紧致的和identity有关的只有少量隐藏神经元的特征。DeepID特征取自最后一个隐藏层的激活值。**使DeepID 明显少于预测的类别数，对学习到高度紧致和具有判别性的特征很重要。**从多个人脸区域中抽取特征，形成相互补充和超完备的表示。
4. DeepID和其他的人脸分类器（如 Joint Bayesian）相整合。

#### 网络结构

{% asset_img 1.webp %}

一共4个卷积层，其中前三个卷积层后都有一个max-pooling layer。注意最后一个卷积层相当小（1*2的feature map）。正因为太小，是信息传递的瓶颈，所以，第一个全连接层（DeepID层，160维）同时全连接到最后一个卷积层和第三个卷积层（池化后）。最后一个全连接层是学习类别分布的，若类别数是10000，则该层维度是10000。

**注意：DeepID只有160维，而类别数却较大，正是因为这样，帮助学习到紧致和具有判别性的特征。**

#### Face verification

进行人脸确认，要有两个步骤：特征抽取+确认学习

##### Feature extraction

从人脸图像中选取10个区域，3个尺度，RGB和gray图像块共60个块，每个块及其水平翻转抽取160维的特征。这样整个DeepID的长度是160 * 60 * 2。

##### face verification

分别采用Joint Bayesian和构建深度网络分别进行。实验表明Joint Bayesian较好。
用于face verification的深度网络如图：

{% asset_img 2.webp %}

实验表明，块提取的越多，性能就又进一步提高。

{% asset_img 3.webp %}

最后，通过扩充CelebFace数据库到CelebFace+,包含10177个人202599张图片。最终在LFW上获得了97.45%的准确率。

#### Experiments

为了表明提出算法的有效性，进行了如下几个方面的实验：

##### Multi-scale ConvNets

验证第三个卷积层（池化后）全连接到DeepID层的有效性，通过去掉这个连接和带上这个连接进行比较。

{% asset_img 4.webp %}

##### Learning effective features

表明：同时对大量的identities进行分类对学习到具有判别性和紧致的隐藏特征是关键。
做法：指数级增加identity classes，通过top-1验证误差率观察分类能力，通过测试集的确认精确度观察学习到的隐藏层特征的性能。

{% asset_img 5.webp %}

##### Over-complete representation

评估：多少个块的组合对性能的贡献大
做法：分别从有k（k=1,5,15,30,60）个块组成的特征训练face verification model.
表明：越多的特征，性能越好

##### Method comparison

和其他算法比较性能。

***

### DeepID2

人脸识别的关键挑战是开发有效的特征表示以减少类内变化增大类间变化。作者同时使用face identification 和 verification信号进行监督学习。face identification增大类间的变化，face verification减少类内变化。在LFW数据库上得到了99.15%人脸确认率。

4个实验：
#### Balancing the identification and verification signals

调查两种信号间的相互作用，通过在verification signal上加个系数λ，让λ从0变化到+∞。

（1）首先报告了随着λ变化，face verification accuracy 的变化曲线，说明单独使用一种信号都是不是最优的，两者的结合能够达取得有效的特征。

（2）分析产生这个现象的原因。

一方面进行分析：类内类间的方差对应相应散度矩阵的特征值。如果所有的特征方差集中在一小部分的特征向量上，意味着类内或类间的变化很小。

另一方面，以图示的方式展示6个identities的PCA特征的前两维。λ=0.05的时候簇的效果要好一些。

#### Rich identity information improves feature learning

指数增加参与训练的identity数，报告随着类别数的增加，verification accuracy 的增加。

#### Investigating the verification signals

比较加入verification signal，不加verification signal，只加入L2+（只减少同一类的距离），只加入L2-（只增加不同类间的距离），采用L1 norm 的verification signal和 采用cosine verification signal的verification accuracy.

表明：（1）采用L2norm的verification signal要比L1 norm 和 cosine 的好；（2）加入verification 比不加好；（3）L2+的效果和L2 norm 接近，而L2-的效果要差，说明：verification主要是增加类内的紧致度，而identification是反应类间的变化。

#### 和其他方法的比较。

***

### DeepID2+

#### 与DeepID2相比的变化

有三点：
1. 隐藏层的maps数增加。4个卷积层（原来的feature maps 分别是 20,40,60,80）在原来基础上再增加128； fc4层从160增加到512。
2. 训练数据增加了CelebFaces+ dataset，WDRef，和一些新收集到的个体。
这个数据集有12，000个个体的大约290,000张图片。（原来的8,000个个体，160,000张图片）
3. 监督信号不仅在FC4上有，DeepID2+在早期的每个卷积层的后面都加了一个512为的全连接层，并添加identification-verification的监督信号。

{% asset_img 6.webp %}

#### 实验分析

这是这篇paper的亮点，分析了提取特征的特点，应当说是填补了目前深度学习研究的一个空白。需要仔细研究作者的处理方法和理解问题角度。

##### 分析DeepID2+ nets网络的高性能

如果是我，我可能只会想到用自己算法的结果跟别的算法比较，而作者除此以外，将他们的三个改进分别去掉一个，和三个改进都用上的结构分别比较，结果表明作者这三个方面的任何一个地方去掉都会对性能有影响。并且报告了fc1 fc2 fc3 fc4上的结果。

{% asset_img 7.webp %}

##### 神经元激活值的中等稀疏性

稀疏性体现在两个方面：一是，每个图像，大约有一半的神经元是被激活的；二是，对每个神经元，在大约一半的图像是是被激活的。

图像的中等稀疏性，使得不同身份的人脸图像具有最大的可区分性；神经元的中等稀疏性，使得他们能够有最大的判别能力。

**作者的验证方法：一是，计算验证集中46，594张图像的被激活的神经元数（下图左）；二是，计算每个神经元是激活状态的图像数。**

{% asset_img 8.webp %}

理解上图：left的单个bar表示有多少的图像的激活状态的神经元个数是x（横轴坐标）—>反应每张图像对应的激活状态的神经元个数。

right的单个bar表示有多少个神经元在x（横轴坐标）上是被激活的—>反应每个神经元是激活状态的图像数。

**另，进一步验证激活模式：验证神经元是否被激活比其精确值更重要。通过阈值的方式把激活值二值化，发现accuracy大约只下降1%。**

{% asset_img 9.webp %}

##### 对身份和属性的选择性

作者通过以下三个方面进行分析：
**一、神经元的判别能力**
**二、神经元的兴奋与抑制**
**三、神经元激活值的分布**

###### 一、神经元的判别能力

为了验证DeepID2+特征中每个神经元的判别能力，作者进行了两方面的实验：身份的二值分类（即是否属于某个人），属性的二值分类（是否拥有某个属性）。
Fig.8：属性分类的精确性，和不同维度的LBP特征进行比较。这部分用的特征是单个DeepID2+net产生的fc4特征+水平翻转图像的特征。
Fig.9：身份分类精度
Fig 10：属性分类精度。 Fig.9 和Fig. 10用的特征是：展示做好的一个特征（神经元）产生的分类精度，强有力的表明了学习到的特征对身份和属性的选择性。

{% asset_img 10.webp %}

###### 二、神经元的兴奋与抑制

发现：是由于神经元对特定的身份和属性的兴奋与抑制模式，使得它们对身份和属性具有强的判别性。例如，在某个人或属性上兴奋的神经元，在其他人或属性上可能是抑制的。

{% asset_img 11.webp %}
{% asset_img 12.webp %}
{% asset_img 13.webp %}

上图中，由于特征取自图像及其水平翻转的fc4，因此，特征的维度是512*2=1024.

###### 三、神经元的激活值分布

通过一些神经元值分布的例子，表明在某个身份或属性上兴奋的神经元，在其他的身份或属性上是抑制的。
Fig.13. 和Fig.14. 这里只粘了Fig.13

{% asset_img 14.webp %}
{% asset_img 15.webp %}

上图中，每个直方图的横坐标，表示这个神经元的激活值。

##### 特征的鲁棒性

测试DeepID2+特征对遮挡的鲁棒性，发现：尽管特征是在没有人为遮挡的图像上训练的net上提取的，但是却自动地学习到了对遮挡鲁棒的特征。
做法：
将人脸进行如下两种人为遮挡，将遮挡的图像用于测试，将DeepID2+特征和LBP特征在LFW的结果进行比较。

{% asset_img 16.webp %}
{% asset_img 17.webp %}
{% asset_img 18.webp %}

另外，还给出了遮挡情况下每个神经元被激活的情况，图18和19.

{% asset_img 19.webp %}
{% asset_img 20.webp %}

***

### DeepID3

本文调查极深神经网络对人脸识别的作用。论文提出了用于人脸识别的两个非常深的神经网络结构（被称为DeepID3）。这两个结构在VGG和GooLeNet的基础上进行构建合适的结构，使得方便人脸识别。结果发现DeepID3的结果和DeepID2+相当，或许当有更多的训练数据时，能够提高性能，需要进一步研究。

{% asset_img 21.webp %}

***

### 参考资料

> 版权声明：本文为CSDN博主「CH-Yuan」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
> 原文链接：https://blog.csdn.net/yuanchheneducn/article/details/51034463
