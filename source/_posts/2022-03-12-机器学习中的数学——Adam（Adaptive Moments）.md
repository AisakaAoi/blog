---
title: 机器学习中的数学——Adam（Adaptive Moments）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨④最优化理论
abbrlink: b6568ebc
date: 2022-03-12 21:27:42
---

Adam是另一种学习率自适应的优化算法：

<!--more-->

```
Adam算法

输入：步长$\epsilon$（建议默认为0.001）；矩估计的指数衰减速率$\rho_1, \rho_2\in[0, 1)$（建议默认为：$\rho_1=0.9,\rho_2=0.999$）；初始参数$\theta$；用于数值稳定的小常数$\delta$（为了数值稳定大约设为$10^{-8}$）；

输出：神经网络参数$\theta$
(1) 初始化一阶和二阶矩变量$s=0, r=0$
(2) 初始化时间步$t=0$
(3) while$\quad\text{停止准则未满足}$
(4) $\quad$从训练集中采包含$m$个样本$\{x^{(1)}, x^{(2)}, \cdots, x^{(m)}\}$的小批量，其中$x^{(i)}$对应目标为$y^{(i)}$
(5) $\quad$计算梯度估计：$g = \frac{1}{m}\nabla_\theta\sum_iL(f(x^{(i)}; \theta), y^{(i)})$
(6) $\quad$更新时间步：$\quad t = t + 1$
(7) $\quad$更新有偏一阶矩估计：$s=\rho_1 s +(1-\rho_1)g$
(8) $\quad$更新有偏二阶矩估计：$r=\rho_2 r +(1-\rho_2)g\odot g$
(9) $\quad$修正一阶矩的偏差：$\hat{s}=\frac{s}{1-\rho_1^2}$
(10)$\quad$修正二阶矩的偏差：$\hat{r}=\frac{r}{1-\rho_2^2}$
(11)$\quad$更新参数：$\theta=\theta-\epsilon\frac{\hat{s}}{\delta+\sqrt{\hat{r}}}\odot g$
(12) return $\theta$
```

“Adam”这个名字派生自短语“Adaptive Moments”。早期算法背景下，它也许最好被看作结合RMSProp和具有一些重要区别的Momentum的变种。首先，在Adam中，Momentum直接并入了梯度一阶矩（指数加权）的估计。将Momentum加入RMSProp最直观的方法是将Momentum应用于缩放后的梯度。结合缩放的Momentum使用没有明确的理论动机。其次，Adam包括偏置修正，修正从原点初始化的一阶矩（Momentum项）和（非中心的）二阶矩的估计。RMSProp也采用了（非中心的）二阶矩估计，然而缺失了修正因子。因此，不像Adam, RMSProp二阶矩估计可能在训练初期有很高的偏置。Adam通常被认为对超参数的选择相当鲁棒，尽管学习率有时需要从建议的默认修改。

***

### 原文链接

> <https://machinelearning.blog.csdn.net/article/details/123450258>
