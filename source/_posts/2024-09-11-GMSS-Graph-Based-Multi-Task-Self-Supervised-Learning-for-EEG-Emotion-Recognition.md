---
title: >-
  GMSS Graph-Based Multi-Task Self-Supervised Learning for EEG Emotion
  Recognition
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫研究领域 Research Area
  - 🛰️脑机接口 Brain-computer Interface
tags:
  - ☄️情绪识别 Emotion Recognition
abbrlink: 30c3a1aa
date: 2024-09-11 08:35:07
---

**提出的方法**：一个基于图的多任务自监督模型
**对比方法**：RGNN、BiHDM、A-LSTM、BiDANN、DANN、DGCNN、SeqCLR、SSL-EEG
**实验使用数据集**：SEED，SEED-IV，MPED
**官方代码**：https://github.com/CHEN-XDU/GMSS

注：第一篇在EEG情绪识别领域采用**多任务自监督方法**来改善模型泛化能力并避免过拟合的工作

***

### 问题

之前的基于EEG的情绪识别都是单任务学习，这会导致过拟合且学到的情绪特征**缺乏泛化能力**

多数基于EEG的情绪识别方法基本上都面临三个挑战：
1. 怎么去泛化模型？对于新的数据进行准确分类
2. 怎么全面利用EEG特性来得到更加可分的数据表征进行情绪识别
3. 怎么去解决情绪噪声标签的问题

***

### 方法

提出了一个基于图的多任务自监督模型（GMSS:a graph-based multi-task self-supervised learning model）

该模型能够通过结合多种自监督任务来学到更多的通用特征，任务包括空间和频率的拼图任务以及对比学习任务

通过同时学习多种任务，GMSS能够得到所有任务的一个表征来降低在原任务上过拟合的概率，如情绪识别任务

具体地，空间拼图任务是为了得到不同脑区的空间联系；频率拼图任务是为了得到较为重要的频带

为了进一步规范特征来促使网络学到本质的特征，通过对比学习任务来将转换后的数据映射到一个共同特征空间

{% asset_img 1.webp %}

#### 空间拼图任务

{% asset_img 2.webp %}

#### 频率拼图任务

{% asset_img 3.webp %}

#### 对比学习任务

{% asset_img 4.webp %}

#### 训练模式 

两种模式分别是无监督和监督模式，两种模式下特征提取器都是一样的，区别在于是否出现真实标签

监督模式采用了一种联合训练策略

{% asset_img 5.webp %}

#### 特征提取器

{% asset_img 6.webp %}
{% asset_img 7.webp %}

***

### 实验

对比了几种流行的非监督和监督学习方法，在数据集SEED，SEED-IV，MPED上进行了实验证明了GMSS模型对EEG情绪信号能够学到更加可分且通用的特征

作者进行了比较完善的实验

1. 非监督模式下对比了基于EEG情绪识别领域的两种自监督模型SSL-EEG和SeqCLR，同时还对比了比较流行的别的自监督方法如DeepCluster、MoCo等；

{% asset_img 8.webp %}

2. 监督模式

{% asset_img 9.webp %}

3. 作者还分析了相应的混淆矩阵，包括非监督/监督的是否跨被试的；

{% asset_img 10.webp %}

4. 作者还进行消融实验以及可视化展示

{% asset_img 11.webp %}
{% asset_img 12.webp %}

5. Chebyshv filter sizes超参的分析

{% asset_img 13.webp %}

***

### 展望

将多任务自监督学习更多地用于改善EEG情绪识别中

***

### 本人见解

脑电情绪识别的三个挑战：
1. 对情绪识别模型进行泛化，对新数据也能分类
2. 充分利用EEG特征，获取更具判别性的数据表征
3. 如何解决情感噪声标签的问题

过往：
1. 使用域适应DA（BiDANN，适用于有标签训练和无标签测试
2. 手工特征（PSD、统计度量、离散小波变换，但并不是专门为脑电设计的特征。也有用DBN的。手工特征不够充分利用特定情绪的相关信息，有必要提取高级特征
3. 收集的数据中，情绪标签可能是嘈杂且不一致的，不一定诱发一致的情绪

本文的DMSS是这样解决的：
GMSS采用多个脑电情绪任务来共享学习到的知识，从而产生通用性特征，包括两个基于图的拼图任务和一个对比学习任务，研究空间和频率信息的影响。
- 空间拼图任务：利用图，可以使预定义远的电极成为相邻电极，学习空间信息
	把电极参照脑区分为10个区，原有的数据找出汉明距离最大的k个当作增广数据并给予伪标签（将原有的电极数据进行分区排列拼图，多找k个跟原本不一样的排列）
- 频率拼图任务：探索脑电情绪识别的关键频段
	类似上述任务，脑电分为5个频段共5!=120种，多找这120种频率组合
- 对比学习：利用两个拼图任务的增广样本，标准化特征空间
	将上述任务的增广数据进行对比学习，n个样本的各自m个增广数据，就有m-1个正样本对和(n-1)×m个负样本对，利用与SimCLR类似的对比学习。数据间的相似性通过计算点积得到。

数据集：
SEED和SEED-IV输入差分熵DE，MPED输入短时傅里叶变换STFT，输入尺寸为62×5，输出尺寸为32

贡献：
1. 使用多任务学习提高泛化能力
2. 通过两个拼图代理任务和对比学习，解决情绪噪声标签问题
3. 无监督和有监督学习方法的结果证明GMSS在多个数据集上SOTA

***

### 参考链接

> Y. Li et al., "GMSS: Graph-Based Multi-Task Self-Supervised Learning for EEG Emotion Recognition," in IEEE Transactions on Affective Computing, doi: 10.1109/TAFFC.2022.3170428.
> <https://blog.csdn.net/qq_41191024/article/details/124956571>
