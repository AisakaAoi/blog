---
title: 人脸识别-人脸识别合集 | 9 CosFace解析(腾讯AI Lab CVPR2018)
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫研究领域 Research Area
  - 🛰️计算机视觉 Computer Vision
tags:
  - ☄️人脸识别 Face Recognition
abbrlink: 8b9c602d
date: 2023-06-18 02:29:44
---

CosFace是腾讯AI Lab的Hao Wang等在CVPR2018.01发表，在SphereFace基础上改进了对特征向量归一化和additive cosine margin。由此，通过归一化和余弦决策边界的最大化，可实现类间差异的最大化和类内差异的最小化。[CosFace: Large Margin Cosine Loss for Deep Face Recognition](https://arxiv.org/abs/1801.09414)

<!--more-->

***

### 主要思想

- Large Margin Cosine Loss (LMCL)：Cosine空间上的损失函数，将A-Softmax中的θ乘以m，改为了对cos(θ)减去余弦间隔m（additive cosine margin），还对特征向量和权重归一化。
- 主要流程和SphereFace类似，用MTCNN对齐图片输入CNN进行训练，测试时也是经过此CNN来提取出特征，再做余弦相似度计算，来进行人脸验证和人脸识别。
    - 人脸验证：阈值判断
    - 人脸识别：分数排序
- 在LFW上99.73％，YouTube Faces上97.6％
- AMSoftmax：电科大的[《Additive Margin Softmax for Face Verification》](https://arxiv.org/abs/1801.05599)和CosFace的发表时间、损失函数等基本一样，图画推导不一样。

***

### CosFace模型框架

- 训练阶段：LMCL引导CNN使用不同类别间的large margin来学习判别性的人脸特征。CNN和SphereFace一样，但损失函数用LMCL。
- 测试阶段：将测试数据输入CNN来提取人脸特征，然后再将这些特征用于计算余弦相似度（Cosine Similarity）分数，再进行人脸验证和人脸识别：
    - 人脸验证：阈值判断
    - 人脸识别：分数排序

{% asset_img 1.webp %}

***

### 比较各损失函数

#### Softmax loss

- Softmax loss：权重的模和角度对后验概率都有影响

{% asset_img 2.webp %}

- 决策边界：它的边界既依赖于权重向量的大小，又依赖于角度的余弦值，从而导致余弦空间中的决策区域重叠(重叠就是margin < 0)。

{% asset_img 3.webp %}

***

#### Normalized version of Softmax Loss (NSL)

- NSL：权重归一化，同时对输入向量归一化到一个固定值s

{% asset_img 4.webp %}

- 决策边界：能在余弦空间中对测试样本进行完美分类。但是，margin为0，由于没有决策间隔，对噪声不太鲁棒。
    - NSL学到的特征没有充分的判别性（discriminative ），因为NSL只强调正确的分类。

{% asset_img 5.webp %}

***

#### A-Softmax Loss

- A-Softmax Loss：θ乘以决策余量m，进行权重归一化并将偏置项归零（||W_i||=1，b_i=0）

{% asset_img 6.webp %}

- 决策边界：

{% asset_img 7.webp %}

- A-Softmax的margin在所有θ值上都不一致：当θ减小时， margin变小，当θ= 0时，margin完全消失。这导致两个潜在的问题：
    - 首先，对于视觉上相似因此在W1和W2之间具有较小角度的困难类别C1和C2，margin很小。
    - 其次，从技术上讲，必须采用额外的技巧用ad-hoc piecewise function来克服计算余弦相似度时的非单调性困难。

{% asset_img 8.webp %}

***

#### Large Margin Cosine Loss (LMCL)（也是AMSoftmax）

- SphereFace：Multiplicative Angular Margin，让θ乘以m
- CosFace：additive cosine margin，让cos(θ)加上m，m是cosine margin，余弦空间上。注意图2的坐标轴是cos(θ)
- LMCL（大间隔余弦损失函数）：权重L2归一化，输入向量归一化到一个固定值s，让cos(θ)加上m。对LMCL来说，s需要足够大。
    - θj是Wj和xi之间的角度，有决策间隔margin>0

{% asset_img 9.webp %}

- 决策边界(decision boundary)：虚线表示决策边界(decision boundary)，灰色区域是决策间隔(decision margins)

{% asset_img 10.webp %}

- 几何上的LMCL特征：与NSL相比，LMCL具有更紧凑的特征区域

{% asset_img 11.webp %}

***

### margin对损失的影响

- 在具有2D特征的8个身份上进行了不同损失函数的实验。第一行将2D特性映射到欧几里得(Euclidean)空间，而第二行将2D特性映射到角度(angular)空间。随着margin项m的增加，差距变得更明显了。
- margin=0.35 时准确率最高。
- LMCL中归一化的目的是推导余弦损失函数的形式和消除半径方向上的变化。我们同时归一化权重向量和特征向量，因此，其特征会分布在一个超球面上，其中缩放参数（scaling parameter）s 控制着半径大小。

{% asset_img 12.webp %}
{% asset_img 13.webp %}

***

### 实验细节

- 预处理：首先脸部区域和landmark通过MTCNN得到，然后通过5个kps（眼睛2个，鼻子1个，嘴角两个）进行相似度变换。然后将分离出来的面部resize到112*96，接着将RGB图片中的每一个像素减去127.5，再除以128。
- 训练：CNN框架选用的是和sphereFace一样，s设为64，优化函数为sgd，batch size为64，gpu8，weight decay=0.0005,对于小型数据集。学习率初始值为0.1，在16k次迭代时，学习率为0.01，24k时0.001，28k时0.0001，迭代一共30k。而在大型数据集上，迭代一共240k次，初始学习率为0.05，在80k，140k，200k时一次下降。
- 在测试阶段，原图片和翻转图片的特征进行拼接组成人脸的特征表示，特征之间的余弦距离即为相似度，最后通过阈值筛选和结果分数排名进行识别。

***

### 测试结果

- LFW上99.73%，YTF上97.6%，角度间隔损失系列首次超越FaceNet。数据集使用了多个公开数据集和一个私有数据集共500万张9万个人

{% asset_img 14.webp %}

- 损失函数的比较，这里都用了相同的数据集CASIA WebFace，和相同的64层CNN架构。LFW效果不如SphereFace，但也差不多。

{% asset_img 15.webp %}

- 人脸识别和验证比较，在MF1 (MegaFace Challenge 1)、MF2 （MegaFace Challenge 2）上

{% asset_img 16.webp %}

- 有没有进行输入特征归一化的比较

{% asset_img 17.webp %}

***

### 参考资料

> <https://zhuanlan.zhihu.com/p/76540469>
> <https://www.jiqizhixin.com/articles/tencent-ai-lab-lmcl>
> <https://zhuanlan.zhihu.com/p/59736735>
> [TF代码](https://github.com/yule-li/CosFace)
> [Pytorch推理](https://github.com/MuggleWang/CosFace_pytorch)
