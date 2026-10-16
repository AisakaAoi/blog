---
title: 机器学习中的数学——距离定义（十六）：豪斯多夫距离（Hausdorff Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: 5fe90e07
date: 2022-01-02 20:40:27
---

豪斯多夫距离（Hausdorff Distance）是在度量空间中任意两个集合之间定义的一种距离。给定欧氏空间中的两点集 $A=\{a_1, a_2, \cdots, a_n\}$ 和 $B=\{b_1, b_2, \cdots, b_m\}$，则豪斯多夫距离为：

$$H(A, B)=\max{(h(A, B), h(B, A))}$$

其中，$h(A, B)=\max_{a\in A}\min_{b\in B}||a - b||$，$H(A, B)$ 称为称为双向豪斯多夫距离，$h(A, B)$ 称为从点集 $A$ 到点集 $B$ 的单向豪斯多夫距离。相应地，$h(B, A)$ 称为从点集 $B$ 到点集 $A$ 的单向豪斯多夫距离。

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122280344>
