---
title: 机器学习中的数学——距离定义（五）：标准化的欧几里得距离（Standardized Euclidean Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨线性代数
abbrlink: 79e605e6
date: 2022-01-01 15:12:46
---

我们在《距离定义（一）：欧几里得距离（Euclidean Distance）》中介绍了欧几里得距离，而标准化的欧几里得距离是针对简单欧几里得距离的缺点而作的一种改进方案。

<!--more-->

标准化的欧几里得距离的思路：将各个分量都“标准化”到均值、方差相等的区间，即：

$$X^*=\frac{X-m}{s}$$

$X^*$ 为标准化后的值，$X$ 为原值，$m$ 为分量的均值，$s$ 为分量的标准差。所以n维空间中标准化的欧几里得距离为：

$$d(x, y)=\sqrt{\sum_{i=1}^n(\frac{x_i-y_i}{s_i})^2}$$

如果将方差的倒数看成是一个权重，这个公式可以看成是一种加权欧氏距离(Weighted Euclidean Distance)。

下面我们来看一下标准化的欧几里得距离的Python实现：

```python
def StandardizedEuclideanDistance(x, y):
    import numpy as np
    x = np.array(x)
    y = np.array(y)

    X = np.vstack([x,y])
    sigma = np.var(X, axis=0, ddof=1)
    return np.sqrt(((x - y) ** 2 /sigma).sum())
```

上述代码中需要避免某个分量取值一致，即该分量 $\sigma=0$。

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/121730738>
