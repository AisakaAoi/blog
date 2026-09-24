---
title: SFFAI 37 | 王亦宁：Multilingual Neural Machine Translation
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
  - 💫SFFAI
abbrlink: d9f55ff7
date: 2019-06-30 07:20:43
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=58326796&bvid=BV1n4411F7c2&cid=101740002&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

本次分享会上：
1. 首先对基于自注意力机制的神经网络机器翻译框架和多语言翻译进行了回顾；
2. 介绍了多语言翻译的主流方法和近期的相关工作；
3. 分享我们录用在ACL 2019上的工作A Compact and Language-Sensitive Multilingual Translation Method。

<!--more-->

***

### 讲者介绍

**王亦宁：**中国科学院自动化研究所模式识别国家重点实验室16级博士生。目前研究兴趣为低资源和多语言机器翻译。博士期间在ACL，EMNLP，IJCNLP等国际会议上发表多篇论文。

**报告题目：**Multilingual Neural Machine Translation

**报告摘要：**随着神经网络机器翻译的快速发展，为了实现多语言之间的相互翻译，通常需要构建多个一对一的翻译模型。一方面每个翻译模型需要大规模存储和计算资源，从而多语言翻译的存储和计算消耗非常巨大；另一方面多语言翻译在独立模型下无法实现知识共享。近年来，使用一套框架解决多语言机器翻译任务受到人们越来越多的关注。多语言机器翻译不仅可以有效的解决资源消耗和知识共享问题，同时由于参与翻译语言对的扩充，对于低资源和零资源翻译任务上有了一定程度的提升。本次报告将回顾过去一年多里多语言机器翻译的相关工作，并分享我们在ACL2019上提出的一种结构紧凑且语言敏感的多语言机器翻译方法。

**Spotlight：**
1. 多语言神经机器翻译方法介绍；
2. 多语言机器翻译在低资源和零资源上面的应用；
3. 语言相关的模块对多语言翻译的影响。

***

### 论文推荐

1. Three Strategies to Improve One-to-Many Multilingual Translation

    **推荐理由：**这篇文章发表于EMNLP2018，提出了三种不同的策略提升多语言翻译质量。该工作主要对于不同语言的特性设计了三种不同的策略，改进了多语言翻译框架来提升多语言神经翻译模型的翻译质量。其主要思想在于针对不同的语言提出了特有的模块，从而在训练和解码过程中对不同的翻译任务加以区分。该工作主要在大规模的一到多数据集上进行的验证，其结果表明这三种策略对于多语言翻译任务是有效且互补的。

2. Parameter Sharing Methods for Multilingual Self-Attentional Translation Models

    **推荐理由：**该工作是CMU团队发表于WMT2018的文章，其思路与我们EMNLP2018的工作非常类似。该工作将基于Transformer的多语言翻译模型进行了分解。最终在一对多的实验结果表明，当目标语言较为相似的情况下，将编码器和解码器的全部参数进行共享能取得最好的翻译性能，而目标语言相差较大的情况下，仅共享编码器和解码器的自注意力机制和注意力机制的K，Q矩阵，能得到最好的翻译质量。

3. Multilingual Neural Machine Translation with Knowledge Distillation

    **推荐理由：**该文章发表于2019年的ICLR，在多语言翻译任务上应用了知识蒸馏的技术。该工作把仅依赖双语平行数据得到的模型当作teacher模型，把多语言翻译模型认为是student模型。在训练多语言翻译模型中，teacher模型规范并指导student模型的生成，从而得到更优的翻译质量。该工作在WMT和IWSLT数据集上都有了一定的提升，证明了知识蒸馏技术在多语言翻译任务上有效性。

4. Multilingual Neural Machine Translation With Soft Decoupled Encoding

    **推荐理由：**该文章同样发表于2019年的ICLR，不同于之前的工作，其主要在词级别的表示层上对多语言翻译进行重新设计。该工作提出了一种软解耦的编码方式，这种编码方式可以认为是词语表示和词语内在含义的一个结合，实验结果表明这种软解耦的编码方式在多语言翻译任务上优于传统基于亚词的编码方式，在翻译质量上有了显著的提升。

5. The Missing Ingredient in Zero-Shot Neural Machine Translation

    **推荐理由: **该文章发表于2019年的NAACL，其主要分析了零资源翻译任务在多语言翻译任务中的应用。该工作首先分析了在零资源翻译任务中通常会出现的语种预测错误的情况，统计结果表明仅有60%的情况下，能对语种正确预测。针对这一现状，该工作提出了两种不同的方法使得Encoder的表征具备语言不变性，更好的表征句子内在的含义。实验结果表明，该方法在保证多语言翻译任务结果基本不变的前提下，对于零资源翻译的情况帮助很大，有了极大程度的提升。

***

### 参考资料

> <https://www.bilibili.com/video/BV1n4411F7c2/>
> <https://bbs.sffai.com/d/90-multilingual-neural-machine-translation>
