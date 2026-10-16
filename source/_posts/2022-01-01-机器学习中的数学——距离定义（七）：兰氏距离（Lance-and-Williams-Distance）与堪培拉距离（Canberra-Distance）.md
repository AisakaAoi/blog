---
title: 机器学习中的数学——距离定义（七）：兰氏距离（Lance and Williams Distance）/堪培拉距离（Canberra Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: 65c10962
date: 2022-01-01 22:28:29
---

兰氏距离（Lance and Williams Distance）又称为堪培拉距离（Canberra Distance），被认为曼哈顿距离（Manhattan Distance）的加权版本。通常兰氏距离对于接近于0（大于等于0）的值的变化非常敏感。与马氏距离一样，兰氏距离对数据的量纲不敏感。不过兰氏距离假定变量之间相互独立，没有考虑变量之间的相关性。

<!--more-->

n维空间中的堪培拉距离为：

$$d(x, y)=\sum_{i=1}^n\frac{|x_i-y_i|}{|x_i|+|y_i|}$$

下面我们来看一下兰氏距离（Lance and Williams Distance）/堪培拉距离（Canberra Distance）的Python实现：

```python
def CanberraDistance(x, y):
    import numpy as np
    x = np.array(x)
    y = np.array(y)
    n = len(x)
    d = 0
    for i in range(len(x)):
        if x[i] == 0 and y[i] == 0:
            d += 0
        else:
            d += abs(x[i] - y[i]) / (abs(x[i]) + abs(y[i]))
    return d
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122271656>
