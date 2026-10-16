---
title: 机器学习中的数学——距离定义（十八）：卡方距离（Chi-square Measure）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: 20b1675b
date: 2022-01-02 23:00:45
---

卡方距离（Chi-square Measure）由 $\chi^2$ 统计量得到。统计学上的 $\chi^2$ 统计量，最初由英国统计学家Karl Pearson在1900年首次提出的，因此也称之为Pearson $\chi^2$ 统计量。$\chi^2$ 检验经常用来检验某一种观测分布是不是符合某一类典型的理论分布。观察频数与期望频数越接近，两者之间的差异越小，$\chi^2$ 值越小。如果两个分布完全一致，$\chi^2$ 值为0，反之观察频数与期望频数差别越大，两者之间的差异越大，$\chi^2$ 值越大。换言之，大的 $\chi^2$ 值表明观察频数远离期望频数，即表明远离假设。小的 $\chi^2$ 值表明观察频数接近期望频数，接近假设。因此，$\chi^2$ 是观察频数与期望频数之间距离的一种度量指标，也是假设成立与否的度量指标。$\chi^2$ 统计量的计算公式如下：

$$\chi^2=\sum_{i=1}^n\frac{(A_i-E_i)^2}{E_i}=\sum_{i=1}^k\frac{(A_i-np_i)^2}{kp_i}$$

其中，$A_i$ 为 $A$ 在水平 $i$ 的观察频数，$E_i$ 为 $E$ 在水平 $i$ 的期望频数，$n$ 为总频数，$p_i$ 为水平 $i$ 的期望频率。水平 $i$ 的期望频数 $E_i$ 等于总频数乘以期望概率 $p_i$。当 $n$ 比较大时，$\chi^2$ 统计量近似服从 $n-1$ 个自由度的卡方分布。

下面我们来看一下卡方距离的Python实现：

```python
def ChiSquare(x, y):
    import numpy as np

    x = np.asarray(x, np.int32)
    y = np.asarray(y, np.int32)

    return np.sum(np.square(x-y)/y)
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122282038>
