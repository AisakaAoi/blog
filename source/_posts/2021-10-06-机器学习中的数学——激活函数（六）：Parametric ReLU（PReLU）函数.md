---
title: 机器学习中的数学——激活函数（六）：Parametric ReLU（PReLU）函数
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨③数值分析
abbrlink: 42b53225
date: 2021-10-06 00:35:45
---

PReLU 也是 ReLU 的改进版本：

<!--more-->

$$PReLU(x)=\left\{ \begin{aligned} x & \quad ,x > 0 \\ \alpha_i x & \quad , x\leq 0\\ \end{aligned} \right.$$

PReLU函数中，参数$\alpha$通常为0到1之间的数字，并且通常相对较小。

- 如果$\alpha_i=0$，则PReLU(x)变为 ReLU。
- 如果$\alpha_i>0$，则PReLU(x)变为Leaky ReLU。
- 如果$\alpha_i$是可学习的参数，则PReLU(x)为PReLU函数。

PReLU函数的特点：

- 在负值域，PReLU的斜率较小，这也可以避免Dead ReLU问题。
- 与ELU相比，PReLU 在负值域是线性运算。尽管斜率很小，但不会趋于0。

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/120618417>
