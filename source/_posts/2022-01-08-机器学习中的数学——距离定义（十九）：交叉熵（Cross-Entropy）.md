---
title: 机器学习中的数学——距离定义（十九）：交叉熵（Cross Entropy）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
abbrlink: d32f3765
date: 2022-01-08 00:06:08
---

交叉熵（Cross Entropy）是香农信息论中一个重要概念，主要用于度量**两个概率分布间的差异性信息**。在信息论中，交叉熵是表示两个概率分布 $p,q$，其中 $p$ 表示真实分布，$q$ 表示非真实分布，则交叉熵用来**衡量在给定的真实分布下，使用非真实分布所指定的策略消除系统的不确定性所需要付出的努力的大小**：

$$\begin{aligned} &\text{离散值：}H(p, q)=-\sum_{i=1}^np_i\log{q_i}=\sum_{i=1}^np_i\log\frac{1}{q_i}\\ &\text{连续值：}H(p, q)=E_p[\log{q}]=-\int_xp(x)\log{q(x)}\text{d}x \end{aligned}$$

假设现在有一个样本集中两个概率分布 $p,q$，其中 $p$ 表示真实分布，$q$ 表示非真实分布。假如，按照真实分布 $p$ 来衡量识别一个样本所需要的编码长度的期望为：

$$H(p)=-\sum_{i=1}^np_i\log{p_i}$$

但是，如果采用错误的分布 $q$ 来表示来自真实分布 $p$ 的平均编码长度，则应该是：

$$H(p, q)=-\sum_{i=1}^np_i\log{q_i}=\sum_{i=1}^np_i\log\frac{1}{q_i}$$

此时就将 $H(p,q)$ 称之为交叉熵。

下面我们来看一下交叉熵的Python实现：

```python
def CrossEntropy(p, q):
	import numpy as np
    return -np.sum(p*np.log(q))
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122355256>
