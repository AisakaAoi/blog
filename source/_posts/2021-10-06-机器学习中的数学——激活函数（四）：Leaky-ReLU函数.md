---
title: 机器学习中的数学——激活函数（四）：Leaky ReLU函数
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨③数值分析
abbrlink: e22ff9a0
date: 2021-10-06 00:00:15
---

它是一种专门设计用于解决Dead ReLU问题的激活函数：

<!--more-->

$$Leaky\ ReLU(x)=\left\{\begin{aligned} x & \quad ,x > 0 \\ \alpha x & \quad , x\leq 0\\ \end{aligned} \right.$$

Leaky ReLU函数的特点：

- Leaky ReLU函数通过把$x$的非常小的线性分量给予负输入$0.01x$来调整负值的零梯度问题。
- Leaky有助于扩大ReLU函数的范围，通常$\alpha$的值为0.01左右。
- Leaky ReLU的函数范围是负无穷到正无穷。

Leaky ReLU函数的图像：

{% asset_img 1.webp %}

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/120617996>
