---
title: 机器学习中的数学——距离定义（十五）：Dice系数（Dice Coefficient）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: '935421e6'
date: 2022-01-02 20:10:01
---

Dice系数（Dice Coefficient）用于度量两个集合的相似性，因为可以把字符串理解为一种集合，因此Dice系数也会用于度量字符串的相似性：

$$\text{Dice}(A, B)=\frac{2|A\cap B|}{|A| + |B|}$$

其中，分子是 $A$ 与 $B$ 的交集数量的两倍，分母为 $A$ 和 $B$ 的长度之和，所以他的范围也在0到1之间。从公式看，Dice系数和杰卡德相似系数非常的类似。杰卡德相似系数是在分子和分母上都减去了 $|A\cap B|$

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122279880>
