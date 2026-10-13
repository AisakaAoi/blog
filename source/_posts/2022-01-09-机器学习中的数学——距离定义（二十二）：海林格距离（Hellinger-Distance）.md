---
title: 机器学习中的数学——距离定义（二十二）：海林格距离（Hellinger Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
abbrlink: cef4a782
date: 2022-01-09 16:35:36
---

我们假设 $p$ 和 $q$ 是两个概率测度，并且它们对于第三个概率测度 $\lambda$ 来说是绝对连续的，则 $p$ 和 $q$ 的海林格距离（Hellinger Distance）的平方被定义如下：

$$H^2(p,q)=\frac{1}{2}\int(\sqrt{\frac{\text{d}p}{\text{d}\lambda}}-\sqrt{\frac{\text{d}q}{\text{d}\lambda}})^2\text{d}\lambda$$

这里的 $\frac{\text{d}p}{\text{d}\lambda}$ 和 $\frac{\text{d}q}{\text{d}\lambda}$ 分别是 $p$ 和 $q$ 的Radon–Nikodym微分。这里的定义是与 $\lambda$ 无关的，因此当我们用另外一个概率测度替换 $\lambda$ 时，只要 $p$ 和 $q$ 关于它绝对连续，那么上式就不变。为了简单起见，我们通常把上式改写为：

$$H^2(p,q)=\frac{1}{2}\int(\sqrt{\text{d}p}-\sqrt{\text{d}q})^2\text{d}\lambda$$

为了在经典的概率论框架下定义Hellinger距离，我们通常将 $\lambda$ 定义为Lebesgue度量，此时 $\frac{\text{d}p}{\text{d}\lambda}$ 和 $\frac{\text{d}q}{\text{d}\lambda}$ 就变为了我们通常所说的概率密度函数，那么可以用以下的积分形式表示Hellinger距离：

$$H^2(p,q)=\frac{1}{2}\int(\sqrt{\frac{\text{d}p}{\text{d}\lambda}}-\sqrt{\frac{\text{d}q}{\text{d}\lambda}})^2\text{d}\lambda=1-\int\sqrt{\frac{\text{d}p}{\text{d}\lambda} \frac{\text{d}q}{\text{d}\lambda}}\text{d}\lambda$$

上述等式可以通过展开平方项得到，注意到任何概率密度函数在其定义域上的积分为1,根据柯西-施瓦茨不等式（Cauchy-Schwarz Inequality），Hellinger距离满足如下性质：

$$0\leq H(p,q)\leq 1$$

对于两个离散概率分布 $p=(p_1, p_2, \cdots, p_n)$ 和 $q=(q_1, q_2, \cdots, q_n)$，它们的Hellinger距离可以定义如下：

$$H(p, q)=\frac{1}{\sqrt{2}}\sqrt{\sum_{i=1}^n(\sqrt{p_i}-\sqrt{q_i})^2}$$

上式也可以被看作两个离散概率分布平方根向量的欧几里得距离

$$H(p, q)=\frac{1}{\sqrt{2}}||\sqrt{p}-\sqrt{q}||_2$$

也可以写成：

$$1 - H^2(p, q)=\sum_{i=1}^n\sqrt{p_iq_i}$$

下面我们来看一下海林格距离的Python实现：

```python
def HellingerDistance(p, q):
	import numpy as np
    p = np.array(p)
    q = np.array(q)
    M = (p + q)/2
    return 1/np.sqrt(2)*np.linalg.norm(np.sqrt(p)-np.sqrt(q))
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122394607>
