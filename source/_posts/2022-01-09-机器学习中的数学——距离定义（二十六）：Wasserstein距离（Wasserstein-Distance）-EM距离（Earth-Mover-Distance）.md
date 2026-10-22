---
title: 机器学习中的数学——距离定义（二十六）：Wasserstein距离（Wasserstei Distance）/EM距离（Earth-Mover Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: 92fe2d8c
date: 2022-01-09 23:09:04
---

Wasserstein距离也被称为推土机距离（Earth Mover’s Distance，EMD），用来表示两个分布的相似程度。Wasserstein距离衡量了把数据从分布 $p$ 移动成”分布 $q$ 时所需要移动的平均距离的最小值。Wasserstein距离是2000年IJCV期刊文章《The Earth Mover’s Distance as a Metric for Image Retrieval》提出的一种直方图相似度量。如果两个分布 $p$ 和 $q$ 离得很远，完全没有重叠的时候，那么KL散度值是没有意义的，而JS散度值是一个常数。这在学习算法中是比较致命的，这就意味这这一点的梯度为0，即梯度消失，而Wasserstein距离可以解决这个问题。

我们将两个分布 $p$ 和 $q$ 看成两堆土，如下图所示，希望把其中的一堆土移成另一堆土的位置和形状，有很多种可能的方案。推土代价被定义为移动土的量乘以土移动的距离，在所有的方案中，存在一种推土代价最小的方案，这个代价就称为两个分布的Wasserstein距离。

{% asset_img 1.webp %}
<div align='center'>Wasserstein距离</div>

Wasserstein距离的形式化的表达式如下：

$$W(p, q)=\inf_{\gamma\sim\prod(p,q)}E_{x, y\sim\gamma}[||x-y||]$$

其中，$\prod(p,q)$ 表示分布 $p$ 和 $q$ 组合起来的所有可能的联合分布的集合。对于每一个可能的联合分布 $\gamma$ 可以从中采样 $(x, y)\sim\gamma$ 得到一个样本 $x$ 和 $y$，并计算出这对样本的距离 $||x-y||$，所以可以计算该联合分布 $\gamma$ 下，样本对距离的期望值 $E_{x, y\sim\gamma}[||x-y||]$。在所有可能的联合分布中能够对这个期望值取到的下界就是Wasserstein距离。用推土的方式理解就是，$E_{x, y\sim\gamma}[||x-y||]$ 是 $\gamma$ 这种路径规划下，把 $p$ 这堆土，移成 $q$ 的样子的消耗，而Wasserstein距离就是在”最优路径规划“下的最小消耗。

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122396193>
