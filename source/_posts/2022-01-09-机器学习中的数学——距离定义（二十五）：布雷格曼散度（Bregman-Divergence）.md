---
title: 机器学习中的数学——距离定义（二十五）：布雷格曼散度（Bregman Divergence）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
abbrlink: 999dca88
date: 2022-01-09 17:22:36
---

F-散度已经可以表达我们提到的所有散度，目前为止它是最通用的散度形式。但很多文章也会出现另一种叫做Bregman的散度，它和F-散度不太一样，是另一大类散度。

我们以欧几里得距离举例，即 $n$ 维空间中的欧几里得距离：

$$d(x, y)=\sqrt{\sum_{i=1}^n(x_i-y_i)^2}$$

我们将其平方：

$$d^2(x, y)=\sum_{i=1}^n(x_i-y_i)^2$$

如果我们定义内积 $<x, y>=\sum_{i-1}^nx_iy_i$ 和欧式模 $||x||=\sqrt{<x, x>}$，则上式可以写为如下形式：

$$d^2(x, y)=\sum_{i=1}^n(x_i-y_i)^2=<x-y, x-y>=||x||^2-(||y||^2+<2y, x-y>)$$

注意到，$2y$ 是 $y^2$ 的导数，因此上式的后一项 $(||y||^2+<2y, x-y>)$ 是函数 $f(z)=||z||^2$ 在 $y$ 点的切线在 $x$ 处的取值。所以均方欧几里得距离的几何描述便是欧式模函数在点 $x$ 和其在 $y$ 点切线在 $x$ 点估计的差。如下图绿线所示：

{% asset_img 1.webp %}
<div align='center'>均方欧几里得距离</div>

那么一个很自然的想法就是把这个定义拓展，即对任意 $R^n$ 的函数 $f(x)$，我们都可以定义：

$$d(x, y)=f(x)-(f(y)+<\nabla f(y), x-y>)$$

若 $f(x)$ 是凸函数，则可以保证 $d(x, y)\geq0$，上式也是Bregman散度（Bregman Divergence）的定义。

和F-散度类似，Bregman散度也是一大类散度的通用表达形式，具体的，根据 $f(x)$ 取不同的函数，它可以表示不同的散度，其中KL散度也是它的一个特例：

{% asset_img 2.webp %}
<div align='center'>Bregman散度</div>

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122395719>
