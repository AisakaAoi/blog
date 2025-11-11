---
title: 'SFFAI 137 | 视觉问答专题《黄佳妮：Scallop: From Probabilistic Deductive Databases to ...》'
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
abbrlink: cf2f8f34
date: 2022-02-20 02:22:43
tags:
---

<iframe src="//player.bilibili.com/player.html?isOutside=true&aid=637101335&bvid=BV1qb4y1W74Y&cid=543889268&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>

<!--more-->

SFFAI论坛网站已开放注册，详情点击查看：https://bbs.sffai.com/d/312

关注公众号：【人工智能前沿讲习】，回复【SFFAI137】获取讲者PPT资料，入交流群，推荐论文下载。

报告题目：Scallop: From Probabilistic Deductive Databases to Scalable Differentiable Reasoning

深度学习和符号推理是智能系统中的互补技术，本期论坛讲者黄佳妮提出了Scallop系统，在概率演绎数据库上结合了两种技术，在需要多跳推理的视觉问答任务展现出了独特优势。

***

### 讲者介绍

**黄佳妮：**宾夕法尼亚大学博四学生，导师是Mayur Naik。主要研究方向是机器学习和编程语言的交叉领域：运用PL的方法，以及神经符号方法，使学习的过程更加强健，数据的使用更加高效。目前在NeurIPS和ICML会议上发表论文2篇。

**报告题目：**Scallop: From Probabilistic Deductive Databases to Scalable Differentiable Reasoning

**报告摘要：**Deep learning and symbolic reasoning are complementary techniques for an intelligent system. However, principled combinations of these techniques are typically limited in scalability, rendering them ill-suited for real-world applications. We propose Scallop, a system that builds upon probabilistic deductive databases, to bridge this gap. On synthetic tasks involving mathematical and logical reasoning, Scallop scales significantly better without sacrificing accuracy compared to DeepProbLog, a principled neural logic programming approach. Scallop also scales to a real-world Visual Question Answering (VQA) benchmark that requires multi-hop reasoning, achieving 84.22% accuracy and outperforming two VQA-tailored models based on Neural Module Networks and transformers by 12.42% and 21.66% respectively.

**论文题目：**Scallop: From Probabilistic Deductive Databases to Scalable Differentiable Reasoning

**分享亮点：**
1. We introduce the notion of top-k proofs which generalizes exact probabilistic reasoning, asymptotically reduces computational cost, and provides relative accuracy guarantees.
2. We design and implement a framework, Scallop, which introduces a tunable parameter k and efficiently implements the computation of top-k proofs using provenance in Datalog, while retaining the benefits of neural and symbolic approaches.
3. We empirically evaluate Scallop on synthetic tasks as well as a real-world task, VQA with multi-hop reasoning, and demonstrate that it significantly outperforms baselines.

***

### 论文推荐

#### DeepProbLog（DPL）系列work

1. Problog: A probabilistic prolog and its application in link discovery. [DE RAEDT, L., KIMMIG, A., AND TOIVONEN, H.] (2007)

    这一篇paper是这个系列工作的第一篇paper，要清晰地了解这系列作品的core就看这篇。它清晰地阐述了weighted model counting如何能够被用来计算一个logic program的不同查询结果的概率。Problog有个很有意思的网站：https://dtai.cs.kuleuven.be/problog/editor.html 大家可以自己写点program试着玩一下。

2. DeepProbLog: Neural Probabilistic Logic Programming. [R. Manhaeve, S. Dumancic, A. Kimmig, T. Demeester and L. De Raedt.] (2018)

    这一篇paper是这个系列工作里把Problog这个engine改造成一个可以被用于learning的engine。它提出的主要改变是把weighted model counting增加一个带gradient的semiring，使得整个reasoning过程differentiable。

#### Tensorlog: A differentiable deductive database. [COHEN, W. W.] (2016)

    这篇paper的program execution过程是soft的。作者首先把一个program转换成一个factor graph，然后再利用message passing去代替logic program 执行的过程。

#### Neural Theorem Prover (NTP) 系列work

1. End-to-end differentiable proving. (NTP) [ROCKTÄSCHEL, T., AND RIEDEL, S.] (2017)

    这篇paper引入了两个neural module，一个是Unification Module，另一个是Or module去替代deterministic execution中的unification和or operation。这篇paper 的方法非常expensive，需要考虑所有possible reasoning paths。

2. Differentiable reasoning on large knowledge bases and natural language (Greedy NTP) [MINERVINI, P., BOSNJAK, M., ROCKTÄSCHEL, T., RIEDEL, S., AND GREFENSTETTE, E.] (2019).

    这篇paper在NTP的基础上使用了beam search，让reasoning path selection的过程变得更加efficient·。

3. Learning reasoning strategies in end-to-end differentiable proving (CTP) [MINERVINI, P., RIEDEL, S., STENETORP, P., GREFENSTETTE, E., AND ROCKTÄSCHEL, T.]

    这篇paper在NTP的基础上使用了一个neural module，来选择需要考虑的reasoning paths，使得reasoning过程更加efficient。

***

### 参考资料

> <https://www.bilibili.com/video/BV1qb4y1W74Y/>
