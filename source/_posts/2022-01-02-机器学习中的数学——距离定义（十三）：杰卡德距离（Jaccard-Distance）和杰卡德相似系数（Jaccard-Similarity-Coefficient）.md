---
title: >-
  机器学习中的数学——距离定义（十三）：杰卡德距离（Jaccard Distance）和杰卡德相似系数（Jaccard Similarity
  Coefficient）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨①线性代数
abbrlink: 4472df4d
date: 2022-01-02 19:38:44
---

两个集合 $A$ 和 $B$ 的交集元素在 $A$ 和 $B$ 的并集中所占的比例，称为两个集合的杰卡德相似系数（Jaccard Similarity Coefficient），用符号 $J(A,B)$ 表示：

<!--more-->

$$J(A,B)=\frac{|A\cap B|}{|A\cup B|}$$

杰卡德相似系数是衡量两个集合的相似度一种指标。与杰卡德相似系数相反的概念是杰卡德距离（Jaccard Distance）：

$$J_\delta(A,B)=1 - J(A,B) = \frac{|A\cup B| - |A\cap B|}{|A\cup B|}$$

杰卡德距离用两个集合中不同元素占所有元素的比例来衡量两个集合的区分度。

下面我们来看一下杰卡德距离的Python实现：

```python
def JaccardDistance(x, y):
    import numpy as np

    x=np.asarray(x, np.int32)
    y=np.asarray(y, np.int32)

    return np.double(np.bitwise_and((x!=y), np.bitwise_or(x!=0, y!=0)).sum())/np.double(np.bitwise_or(x!=0, y!=0).sum())
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122279515>
