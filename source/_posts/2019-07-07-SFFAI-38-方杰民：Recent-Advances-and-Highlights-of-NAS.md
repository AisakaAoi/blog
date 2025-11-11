---
title: SFFAI 38 | 方杰民：Recent Advances and Highlights of NAS
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
abbrlink: 53fb70e5
date: 2019-07-07 07:27:32
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=59379123&bvid=BV1pt411G7Zj&cid=103465370&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

《SFFAI38期-网络结构搜索-单目标跟踪》讲者之一方杰民本次报告介绍、讨论了最近NAS的一些进展和闪光点，并分享他们在NAS领域所做的相关工作。主要内容包括：
1. NAS算法的发展与创新；
2. NAS的加速方法；
3. 搜索空间的探索和进展。

<!--more-->

***

### 讲者介绍

**方杰民：**华中科技大学电子信息与通信学院媒体与通信实验室研究生在读，地平线算法实习生，主要研究方向为网络结构搜索、模型结构优化。

**报告题目：**Recent advances and highlights of NAS

**报告摘要：**近年来网络结构搜索（NAS）在自动化设计神经网络结构方面获得了较大的成功，也成为模型结构优化领域不可忽视的重要研究课题。NAS不仅减轻了人们设计、调优模型结构的重重负担，而且相较于人工设计的网络结构，NAS搜索出的模型性能有了进一步提升。最近NAS取得了巨大的进展，搜索代价从最初的万级GPU hours降低到和普通训练模型同等水平，NAS的算法更能在优化精度的同时提高模型速度，NAS的应用也从分类向分割、检测等领域进一步扩展。本次报告将介绍、讨论最近NAS的一些进展和闪光点，并分享我们在NAS领域所做的相关工作。

**Spotlight：**
1. NAS算法的发展与创新；
2. NAS的加速方法；
3. 搜索空间的探索和进展。

***

### 论文推荐

1. DARTS ：Differentiable Architecture Search

    **推荐理由：**该工作在NAS领域有极大的推进作用，由CMU和DeepMind发表于ICLR2019。DARTS与之前的各类NAS算法不同在于，基于RL或EA的搜索算法对网络结构的处理均在离散空间中进行，这使得整个搜索、优化过程的计算代价巨大。DARTS首次提出将搜索空间映射为连续可微的表示，整个搜索过程直接通过梯度下降和反向传播来进行结构的优化。DARTS在保持结构性能的条件下极大减少了搜索代价，后续一系列优秀的gradient-based NAS工作也均基于DARTS的思路。

2. MnasNet： Platform-Aware Neural Architecture Search for Mobile

    **推荐理由：**该工作由Google产出，被收录于CVPR2019. 该方法的两大创新点被后续NAS工作广泛采纳，在NAS领域也具有重要作用。第一，Mnas提出直接在搜索过程中优化目标硬件上网络结构的latency，通过多目标优化的方法基于RL取得了优秀的结果。第二，Mnas提出基于MobileNet的级联block的搜索空间，摒弃了之前基于Cell拓扑结构复杂的搜索空间，Mnas的搜索空间在latency上更为友好，并在精度上也有很大的优势，该搜索空间被后来工作广泛应用。

3. PROXYLESSNAS：DIRECT NEURAL ARCHITECTURE SEARCH ON TARGET TASK AND HARDWARE

    **推荐理由：**该工作由MIT Song Han实验室产出，被收录于ICLR2019. 本工作还是以减少搜索代价为出发点，对NAS算法进行改进。虽然Differentiable NAS的方法可以极大缩短搜索时间，但是由于其搜索空间由一个连续可微超大网络的表示，传统的Differentiable NAS方法需要占用较多的GPU显存。ProxylessNAS的方法在于优化super network的参数每次只通过一条或部分路径，从而极大减少了显存占用。该工作还针对硬件优化结构，获得了非常优秀的结果。

4. Auto-DeepLab： Hierarchical Neural Architecture Search for Semantic Image Segmentation

    **推荐理由：**Auto-DeepLab获得了CVPR2019 oral。该工作基于gradient-based NAS方法在分割任务上取得了优秀的结果。该工作创新性的提出了一个针对分割任务的网络层次的搜索空间，Auto-DeepLab的搜索空间主要包含分割网络backbone部分可能的结构，其包含了更多空间分辨率操作的可能性。在backbone中Auto-DeepLab会搜索出一条更适合分割任务的上/下采样的路径，路径上每个节点基于之前工作广泛使用的cell结构。该方法搜索时间较短，性能卓越。

***

### 参考资料

> <https://www.bilibili.com/video/BV1pt411G7Zj/>
> <https://bbs.sffai.com/d/93-recent-advances-and-highlights-of-nas>
