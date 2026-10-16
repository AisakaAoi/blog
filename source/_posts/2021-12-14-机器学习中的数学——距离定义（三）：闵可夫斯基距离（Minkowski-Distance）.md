---
title: 机器学习中的数学——距离定义（三）：闵可夫斯基距离（Minkowski Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: 73596a55
date: 2021-12-14 23:14:13
---

闵可夫斯基距离不是一种距离，而是一组距离的定义，是对多个距离度量公式的概括性的表述，它包含了我们在《距离定义（一）：欧几里得距离》《距离定义（二）：曼哈顿距离》中的欧几里得距离（$p=2$）和曼哈顿距离（$p=1$）就是闵可夫斯基距离的一种特殊情况：

<!--more-->

$$d(x, y)=(\sum_{i=1}^n|x_i-y_i|^p)^{\frac{1}{p}}$$

下面我们来看一下闵可夫斯基距离的Python实现，其中 $p$ 为闵可夫斯基距离的参数：

```python
def MinkowskiDistance(x, y, p):
    import math
    import numpy as np
    zipped_coordinate = zip(x, y)
    return math.pow(np.sum([math.pow(np.abs(i[0]-i[1]), p) for i in zipped_coordinate]), 1/p)
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/121723106>
