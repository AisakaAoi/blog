---
title: 机器学习中的数学——RMSProp（Root Mean Square Prop）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨④最优化理论
abbrlink: 8a708de3
date: 2022-03-12 20:42:16
---

RMSProp算法修改AdaGrad以在非凸设定下效果更好，改变梯度积累为指数加权的移动平均。

AdaGrad旨在应用于凸问题时快速收敛。当应用于非凸函数训练神经网络时，学习轨迹可能穿过了很多不同的结构，最终到达一个局部凸的区域。AdaGrad根据平方梯度的整个历史收缩学习率，可能使得学习率在达到这样的凸结构前就变得太小了。RMSProp使用指数衰减平均以丢弃遥远过去的历史，使其能够在找到凸碗状结构后快速收敛，它就像一个初始化于该碗状结构的AdaGrad算法实例。相比于AdaGrad，使用移动平均引入了一个新的超参数$\rho$，用来控制移动平均的长度范围。

<!--more-->

```
RMSProp算法

输入：全局学习率$\epsilon$；衰减速率$\rho$；初始参数$\theta$；小常数$\delta$(为了数值稳定大约设为$10^{-6}$；

输出：神经网络参数$\theta$
(1) 初始化梯度累积变量$r=0$
(2) while$\quad\text{停止准则未满足}$
(1) $\quad$从训练集中采包含$m$个样本$\{x^{(1)}, x^{(2)}, \cdots, x^{(m)}\}$的小批量，其中$x^{(i)}$对应目标为$y^{(i)}$
(2) $\quad$计算梯度估计：$g = \frac{1}{m}\nabla_\theta\sum_iL(f(x^{(i)}; \theta), y^{(i)})$
(3) $\quad$累积平方梯度：$r=\rho r+(1-\rho)g\odot g$
(4) $\quad$更新参数：$\theta=\theta-\frac{\epsilon}{\sqrt{\delta+r}}\odot g$
(5) return $\theta$
```

以及使用Nesterov Momentum的RMSProp算法：

```
使用Nesterov Momentum的RMSProp算法

输入：全局学习率$\epsilon$；衰减速率$\rho$；初始参数$\theta$；小常数$\delta$(为了数值稳定大约设为$10^{-6}$；动量系数$\alpha$；$v$

输出：神经网络参数$\theta$
(1) 初始化梯度累积变量$r=0$
(2) while$\quad\text{停止准则未满足}$
(1) $\quad$从训练集中采包含$m$个样本$\{x^{(1)}, x^{(2)}, \cdots, x^{(m)}\}$的小批量，其中$x^{(i)}$对应目标为$y^{(i)}$
(2) $\quad$计算梯度估计：$g_k = \frac{1}{m}\nabla_{\theta+\alpha v}\sum_iL(f(x^{(i)}; \theta+\alpha v), y^{(i)})$
(3) $\quad$累积平方梯度：$r=\rho r+(1-\rho)g\odot g$
(4) $\quad$计算速度更新：$v=\alpha v-\frac{\epsilon}{\sqrt{r}}\odot g$
(4) $\quad$更新参数：$\theta=\theta-\frac{\epsilon}{\delta+r}\odot g$
(5) return $\theta$
```

经验上，RMSProp已被证明是一种有效且实用的深度神经网络优化算法。目前它是深度学习从业者经常采用的优化方法之一。

***

### 原文链接

> <https://machinelearning.blog.csdn.net/article/details/123449497>
