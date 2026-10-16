---
title: 机器学习中的数学——距离定义（二十七）：巴氏距离（Bhattacharyya Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: d654cbdd
date: 2022-01-09 23:26:46
---

在统计中，巴氏距离（Bhattacharyya Distance）测量两个离散或连续概率分布的相似性。它与衡量两个统计样品或种群之间的重叠量的巴氏系数密切相关。巴氏距离和巴氏系数以20世纪30年代曾在印度统计研究所工作的一个统计学家A. Bhattacharya命名。同时，巴氏系数可以被用来确定两个样本被认为相对接近的，它是用来测量中的类分类的可分离性。

首先，我们先定义离散和连续情况下的巴氏系数：

$$\begin{aligned} &\text{离散值：}BC(p, q)=\sum\sqrt{p(x)q(x)}\\ &\text{连续值：}BC(p, q)=\int\sqrt{p(x)q(x)}\text{d}x \end{aligned}$$

在得到了巴氏系数后巴氏距离被定义为：

$$D_B(p, q)=-\ln(BC(p, q))$$

从公式可以看出，巴氏系数 $BC(p, q)$ 海林格距离联系起来，此时海林格距离可以被定义为：

$$H(p, q)=\sqrt{1-BC(p,q)}$$

接下来，我们来看一下求 $BC(p, q)$ 的Python实现以及求出 $BC(p, q)$ 后求解海林格距离和巴氏距离的Python实现：

```python
def BC(p,q):
    import numpy as np
    p = np.array(p)
    q = np.array(q)
    return np.sum(np.sqrt(p * q))

def HellingerDistance(p, q):
    import numpy as np
    bc = BC(p,q)
    return np.sqrt(1 - bc)

def BhattacharyyaDistance(p, q):
    import numpy as np
    bc = BC(p,q)
    return np.log(bc)
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122400635>
