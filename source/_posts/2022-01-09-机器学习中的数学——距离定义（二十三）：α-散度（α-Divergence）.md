---
title: 机器学习中的数学——距离定义（二十三）：α-散度（α-Divergence）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: b917bfe
date: 2022-01-09 16:37:42
---

α-散度表达式如下：

$$D_\alpha(p||q)=\frac{4}{1-\alpha^2}(1-\int p(x)^{\frac{1+\alpha}{2}}q(x)^{\frac{1-\alpha}{2}}\text{d}x)$$

其中，$-\infty<\alpha<+\infty$ 是一个连续参数。KL散度 $D_{KL}(p||q)$ 对应于极限 $\alpha\rightarrow1$，而 $D_{KL}(q||p)$ 对应于极限 $\alpha\rightarrow-1$。对于所有的 $\alpha$ 值，我们有 $D_{\alpha}(p||q)\geq0$，当且仅当 $p(x)=q(x)$ 时等号成立。假设 $p(x)$ 是一个固定的分布，我们关于某个概率分布 $q(x)$ 的集合最小化 $D_{\alpha}(p||q)$。那么对于 $\alpha\leq-1$ 的情况，散度是零强制的(Zero Forcing)，即对于使得 $p(x)=0$ 成立的任意 $x$ 值，都有 $q(x)=0$，通常 $q(x)$ 会低估 $p(x)$ 的支持，因此倾向于寻找具有最大质量的峰值。相反，对于 $\alpha\geq-1$ 的情况，散度是零避免的(Zero Avoiding)，即对于使得 $p(x)>0$ 成立的任意 $x$ 值，都有 $q(x)>0$，通常 $q(x)$ 会进行拉伸来覆盖到所有的 $p(x)$ 值，从而高估了 $p(x)$ 的支持。当 $\alpha=0$ 时，我们得到了一个对称的散度，它与Hellinger距离线性相关：

$$D_H(p||q)=\int (p(x)^{\frac{1}{2}}+q(x)^{\frac{1}{2}})\text{d}x)$$

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122395398>
