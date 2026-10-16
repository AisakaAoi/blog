---
title: 机器学习中的数学——距离定义（二十）：相对熵（Relative Entropy）/KL散度（Kullback-Leibler Divergence）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨线性代数
abbrlink: 14886bf3
date: 2022-01-08 00:06:47
---

相对熵（Relative Entropy），又被称为KL散度（Kullback-Leibler Divergence）或信息散度（Information Divergence），是两个概率分布间差异的**非对称性度量**。在信息理论中，相对熵等价于两个概率分布的信息熵的差值。

相对熵也是一些优化算法，例如最大期望算法的损失函数。此时参与计算的一个概率分布为真实分布，另一个为非真实（拟合）分布，相对熵表示使用非真实分布拟合真实分布时产生的信息损耗。设 $p(x)$、$q(x)$ 是随机变量 $x$ 上的两个概率分布，则在离散和连续随机变量的情形下，相对熵的定义分别为：

$$\begin{aligned} &\text{离散值：KL}(p||q)=\sum_xp(x)\log{\frac{p(x)}{q(x)}}\\ &\text{连续值：KL}(p||q)=\int_xp(x)\log{\frac{p(x)}{q(x)}}\text{d}x \end{aligned}$$

在信息理论中，相对熵是用来度量**使用基于 $q$ 的编码来编码来自 $p$ 的样本平均所需的额外的比特个数**。典型情况下，$p$ 表示数据的真实分布，$q$ 表示数据的理论分布/模型分布或 $p$ 的近似分布。给定一个字符集的概率分布，我们可以设计一种编码，使得表示该字符集组成的字符串平均需要的比特数最少。假设这个字符集是 $X$，$x\in X$，其出现概率为 $p(x)$，那么其最优编码平均需要的比特数等于这个字符集的信息熵：

$$H(x)=-\sum_xp_(x)\log{p_(x)}$$

在同样的字符集上，假设存在另一个概率分布 $q_(x)$，如果用概率分布 $p_(x)$ 的最优编码（即字符 $x$ 的编码长度等于 $-\log{p_(x)}$），来为符合分布 $p_(x)$ 的字符编码，那么表示这些字符就会比理想情况多用一些比特数。相对熵就是用来衡量这种情况下平均每个字符多用的比特数，因此可以用来衡量两个分布的距离，即：

$$\text{KL}(p||q)=\sum_xp(x)\log{\frac{p(x)}{q(x)}}=\sum_xp(x)\log{p(x)}-\sum_xp(x)\log{q(x)}$$

下面我们来看一下相对熵的Python实现：

```python
def RelativeEntropy(p, q):
    import numpy as np
    p = np.array(p)
    q = np.array(q)
    return np.sum(p * np.log(p/q))
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122374006>
