---
title: 机器学习中的数学——距离定义（二十四）：F-散度（F-Divergence）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
abbrlink: 18fbfb5b
date: 2022-01-09 16:49:45
---

F-散度（F-Divergence）是KL散度的一个推广：

$$D_F(p||q)=\int q(x)f(\frac{p(x)}{q(x)})$$

其中，函数 $f(x)$ 需要满足下列2个性质：

1. $f(x)$ 是一个凸函数
2. $f(1)=0$

若 $f(x)=x\log{x}$，则F-散度退化为KL散度；若 $f(x)=-\log{x}$，则F-散度退化为reverse KL散度。甚至，当 $f(x)$ 取某些值时，还可以表达 $\alpha$-散度。下面的表格给出了F-散度的一些特例：

| 散度（Divergence） | 对应的 $f(x)$ |
| --- | --- |
| KL散度 | $x\log{x}$ |
| reverse KL散度 | $-\log{x}$ |
| 海林格距离 | $(\sqrt{x}-1)^2$ |
| 卡方距离 | $(t-1)^2$ |
| $\alpha$-散度 | $\frac{4}{1-\alpha^2}(1-x^{\frac{1+\alpha}{2}})\quad(\alpha\neq\pm1)$ |
| KL散度 | $x\log{x}$ |
| KL散度 | $x\log{x}$ |

下面我们来看一下F-散度的Python实现：

```python
def f(t):
    return t*np.log(t)

def F_Divergence(p, q):
    import numpy as np
    p = np.array(p)
    q = np.array(q)
    M = (p + q)/2
    return np.sum(q*f(p/q))
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122394497>
