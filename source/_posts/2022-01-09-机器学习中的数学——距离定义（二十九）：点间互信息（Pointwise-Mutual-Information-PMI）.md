---
title: 机器学习中的数学——距离定义（二十九）：点间互信息（Pointwise Mutual Information, PMI）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨线性代数
abbrlink: 853411a5
date: 2022-01-09 23:51:48
---

在机器学习实践中，经常会用到点间互信息（Pointwise Mutual Information, PMI）来衡量两个变量的相关性：

$$\text{PMI}(x, y)=\log{\frac{p(x, y)}{p(x)p(y)}=\log{\frac{p(x|y)}{p(x)}}}=\log{\frac{p(y|x)}{p(y)}}$$

若 $x$ 和 $y$ 不相关，则 $p(x,y)=p(x)p(y)$。二者相关性越大，则 $p(x,y)$ 就相比于 $p(x)p(y)$ 越大。同理，在 $y$ 出现的情况下 $x$ 出现的条件概率 $p(x|y)$ 本身出现的概率 $p(x)$，自然就表示 $x$ 跟 $y$ 的相关程度。

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122401324>
