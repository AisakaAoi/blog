---
title: 机器学习中的数学——距离定义（二十八）：最大均值差异（Maximum Mean Discrepancy, MMD）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: 697f4f82
date: 2022-01-09 23:43:44
---

最大均值差异（Maximum Mean Discrepancy，MMD）是迁移学习，尤其是域适应（Domain Adaptation）中使用最广泛的一种损失函数，主要用来度量两个不同但相关的分布的距离。最大均值差异还可以用来测试两个样本，是否来自两个不同分布 $p$ 和 $q$，如果均值差异达到最大，就说明采样的样本来自完全不同的分布。

最大均值差异度量了在再生希尔伯特空间中两个分布的距离，是一种核学习方法。通过寻找在样本空间上的连续函数 $f:x\rightarrow R$ 随机投影后，分别求这两个分布的样本在 $f$ 上的函数值均值，并对两个均值做差得到这两个分布对应于 $f$ 的均值差（Mean Discrepancy）。最大均值差异的目标是寻找一个 $f$ 使得均值差最大，即得到最大均值差异。

$$\text{MMD}(F, p, q)=\sup_{||f||_H\leq1}{E_p[f(x)]-E_q[f(y)]}$$

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122401205>
