---
title: 机器学习中的数学——常用概率分布（十一）：狄利克雷分布（Dirichlet分布）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨②概率论与数理统计
abbrlink: b9013ad
date: 2021-10-04 18:50:41
---

狄利克雷分布是关于一组$d$个连续变量$x_i\in[0, 1]$的概率分布，$\sum_ix_i=1$。令$\mu=(\mu_1, \mu_2, \cdots, \mu_d)$，参数$\alpha=(\alpha_1, \alpha_2, \cdots, \alpha_d)$，其中$\alpha_i>0$且$\hat{\alpha}=\sum_i\alpha_i$。

<!--more-->

$$Dir(x|\alpha)=\frac{\Gamma(\hat{\alpha})}{\Gamma(\alpha_1)\Gamma(\alpha_2)\cdots\Gamma(\alpha_i)}\prod_{i=1}^dx_i^{\alpha_i-1}$$

狄利克雷分布有如下性质：

- $E[x_i]=\frac{\alpha_i}{\hat{\alpha}}$
- $Var(x_i)=\frac{\alpha_i(\hat{\alpha}-\alpha_i)}{\hat{\alpha}^2(\hat{\alpha}+1)}$
- $Cov(x_i, x_j)=\frac{\alpha_i\alpha_j}{\hat{\alpha}^2(\hat{\alpha}+1)}$

当$d=2$时，狄利克雷分布退化为贝塔分布。

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/120606649>
