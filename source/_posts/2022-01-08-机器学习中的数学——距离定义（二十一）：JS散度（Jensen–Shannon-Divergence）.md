---
title: 机器学习中的数学——距离定义（二十一）：JS散度（Jensen–Shannon Divergence）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
abbrlink: 5b63ff48
date: 2022-01-08 22:42:33
---

JS散度度量了两个概率分布的相似度，是KL散度的变体，JS散度解决了KL散度非对称的问题。一般地，JS散度是对称的，其取值是0到1之间：

$$\text{JS}(p,q)=\frac{1}{2}\text{KL}(p||\frac{p+q}{2})+\frac{1}{2}\text{KL}(q||\frac{p+q}{2})$$

下面我们来看一下JS散度的Python实现：

```python
def JensenShannonDivergence(p, q):
    p = np.array(p)
    q = np.array(q)
    M = (p + q)/2
    return 0.5 * np.sum(p*np.log(p/M)) + 0.5 * np.sum(q*np.log(q/M))
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122387046>
