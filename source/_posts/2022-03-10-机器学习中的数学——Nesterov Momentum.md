---
title: 机器学习中的数学——Nesterov Momentum
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨④最优化理论
abbrlink: 1e0b397
date: 2022-03-10 20:14:23
---

受Nesterov Accelerated Gradient算法的启发，Sutskever提出了动量算法的一个变种。这种情况的更新规则如下：

$$v=\alpha v-\epsilon\nabla_\theta[\frac{1}{m}\sum_{i=1}^mL(f(x^{(i)});\theta+\alpha v), y^{(i)}]\\ \quad\\ \theta=\theta+v$$

<!--more-->

其中参数$\alpha$和$\epsilon$发挥了和标准动量方法中类似的作用。Nesterov动量和标准动量之间的区别体现在梯度计算上。Nesterov动量中，梯度计算在施加当前速度之后。因此，Nesterov动量可以解释为往标准动量方法中添加了一个校正因子。

```
Nesterov Momentum第$k$次迭代

输入：学习率$\epsilon$；初始化参数$\theta_0$或第$k-1$次输出参数$\theta_{k-1}$；动量参数$\alpha$；第$k-1$次输出速度$v_{k-1}$

输出：第$k$次迭代后的参数$\theta_k$
(1) while$\quad\text{停止准则未满足}$
(2) $\quad$从训练集中采包含$m$个样本$\{x^{(1)}, x^{(2)}, \cdots, x^{(m)}\}$的小批量，其中$x^{(i)}$对应目标为$y^{(i)}$
(3) $\quad$计算梯度估计：$g_k = \frac{1}{m}\nabla_{\theta+\alpha v}\sum_iL(f(x^{(i)}; \theta+\alpha v), y^{(i)})$
(4) $\quad v_k = \alpha v_{k-1} - \epsilon g_k$
(5) $\quad\theta_k = \theta_{k-1}+ v$
(6) $\quad k = k + 1$
(7) return $\theta_k$
```

在凸批量梯度的情况下，Nesterov Momentum将额外误差收敛率从$O(\frac{1}{k})$（k步后）改进到$O(\frac{1}{k^2})$。可惜，在随机梯度的情况下，Nesterov Momentum没有改进收敛率。

***

### 原文链接

> <https://machinelearning.blog.csdn.net/article/details/123362497>
