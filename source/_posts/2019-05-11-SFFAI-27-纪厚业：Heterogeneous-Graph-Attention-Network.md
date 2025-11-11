---
title: SFFAI 27 | 纪厚业：Heterogeneous Graph Attention Network
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
abbrlink: '71814466'
date: 2019-05-11 03:32:38
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=53418944&bvid=BV164411L7T7&cid=93455067&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

异质图在真实世界无处不在，异质图的分析也是数据挖掘的热门方向。作者设计了一种异质图神经网络，同时在节点和语义级别利用注意力机制来对邻居信息和语义信息进行加权融合，进而学习到更加细致全面的节点表示。同时，通过对两层的注意力机制进行分析，所提模型具有较好的可解释性。

<!--more-->

***

### 讲者介绍

**纪厚业：**北京邮电大学计算机科学与技术专业博士研究生。研究兴趣包括异质图分析，网络表示学习，图神经网络等。

**报告题目：**Heterogeneous Graph Attention Network

**报告摘要：**图神经网络是近年来图数据挖掘领域的热门研究方向之一，被誉为是新一代深度学习。图神经网络可以将端到端学习与归纳推理相结合，有望解决深度学习无法进行关系推理的问题。以Graph Convolutional Network，Graph Attention Network为代表的图神经网络已经引起了学术界与工业界的广泛关注。然而，目前的图神经网络主要针对同质图（节点类型和边类型单一）设计，但真实世界中的图大部分都可以被自然地建模为异质图（多种类型的节点和边）。如何设计可以处理真实世界图数据的异质图神经网络是一个迫切需要解决的问题。

本次分享将介绍我们在异质图神经网络上的最新工作，这是第一篇基于注意力机制的异质图神经网络的工作。本文围绕异质图数据中一些基础性结构（多种类型的节点/边和元路径结构），分别设计了节点级别注意力和语义级别注意力来实现对节点全面且细致的表示。相对于现有的工作，我们的模型可以处理更加复杂的结构和语义信息也具有更强的现实意义。

**Spotlight：**
1. Node-Level Attention可以学习元路径邻居的重要性并通过聚合操作得到节点表示；
2. Semantic-Level Attention 可以针对不同任务来学习语义信息的重要性并对语义进行融合。

***

### 论文推荐

1. Semi-Supervised Classification with Graph Convolutional Networks

    **推荐理由：**图神经网络领域最经典的论文之一，也是Graph Convolutional Network的代表。本文对谱域的图卷积进行了分析，并对傅里叶变换后的频域图卷积进行了一阶近似。通过一个简单高效的传播模型在节点分类任务上取得最优效果。

2. Graph Attention Networks

    **推荐理由：**在实际图数据中，两个节点建立连接的原因不同，连接强度也各不相同。本文所提出的Graph Attention Network将注意力机制引入到图神经网络中来学习节点邻居的重要性。GAT可以更好的处理桥节点和噪音邻居具有更好的鲁棒性。同时，通过对注意力权重进行分析，GAT具有更好的可解释性。

3. Deeper Insights into Graph Convolutional Networks for Semi-Supervised Learning

    **推荐理由：**本文对Graph Convolutional Network进行了理论分析，证明了Graph Convolutional Network本质是一种Laplacian smoothing。多层GCN效果下降的原因是over-smoothing。最后本文提出了co-training和self-training来克服GCN的局限并通过实验验证了其效果。

4. Predict then Propagate Graph Neural Networks meet Personalized PageRank

    **推荐理由：**对Graph Convolutional Network的局限性进行了分析。本文首先分析了PageRank和Graph Convolutional Network之间的联系与区别，并利用Personalized PageRank的角度来解决Graph Convolutional Network中存在的问题。本文提出的算法在经过多层传播后依然不会出现过平滑问题，并随着层数的增加，模型效果有了一定的提升。

***

### 参考资料

> <https://www.bilibili.com/video/BV164411L7T7/>
> <https://bbs.sffai.com/d/68>
