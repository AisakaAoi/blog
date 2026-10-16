---
title: 机器学习中的数学——距离定义（十一）：汉明距离（Hamming Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: 896bb119
date: 2022-01-02 00:05:33
---

汉明距离（Hamming Distance）是应用于数据传输差错控制编码的距离度量方式，它表示两个（相同长度）字符串对应位不同的数量。对两个字符串进行异或运算，并统计结果为1的个数，那么这个数就是汉明距离。我们也可以将汉明距离理解为两个等长字符串之间将其中一个变为另外一个所需要作的最小替换次数。

<!--more-->

下面我们来看一下汉明距离的Python实现：

```python
def HammingDistance(x, y):
    return sum(x_ch != y_ch for x_ch, y_ch in zip(x, y))
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122272472>
