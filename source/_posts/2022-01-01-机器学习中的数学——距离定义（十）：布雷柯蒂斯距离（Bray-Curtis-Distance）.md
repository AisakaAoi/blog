---
title: 机器学习中的数学——距离定义（十）：布雷柯蒂斯距离（Bray Curtis Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: 6adb3b77
date: 2022-01-01 23:42:15
---

布雷柯蒂斯距离（Bray Curtis Distance）主要用于生态学和环境科学，计算坐标之间的距离。该距离取值在 $[0,1]$ 之间，也可以用来计算样本之间的差异。

<!--more-->

n维空间中的布雷柯蒂斯距离为：

$$d(x, y)=\frac{\sum_{i=1}^n|x_i-y_i|}{\sum_{i=1}^nx_i+\sum_{i=1}^ny_i}$$

下面我们来看一下布雷柯蒂斯距离的Python实现：

```python
def BrayCurtisDistance(x, y):
    import numpy as np
    x = np.array(x)
    y = np.array(y)
    return np.sum(np.abs(x-y))/(np.sum(x)+np.sum(y))
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122272378>
