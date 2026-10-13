---
title: 机器学习中的数学——距离定义（一）：欧几里得距离（Euclidean Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
abbrlink: 5b0bcc
date: 2021-12-08 23:45:00
---

欧几里得距离或欧几里得度量是欧几里得空间中两点间的即直线距离。使用这个距离，欧氏空间成为度量空间，相关联的范数称为欧几里得范数。

<!--more-->

n维空间中的欧几里得距离：

$$d(x, y)=\sqrt{\sum_{i=1}^{n}(x_i-y_i)^2}=\sqrt{(x_1-y_1)^2+(x_2-y_2)^2+\cdots+(x_n-y_n)^2}$$

2维空间中的欧几里得距离：

$$d(x, y)=\sqrt{(x_1-y_1)^2+(x_2-y_2)^2}$$

下面我们来看一下欧几里得距离的Python实现：

```python
def EuclideanDistance(x, y):
    import numpy as np
    x = np.array(x)
    y = np.array(y)
    return np.sqrt(np.sum(np.square(x-y)))
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/121461909>
