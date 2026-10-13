---
title: 机器学习中的数学——距离定义（十二）：编辑距离（Edit Distance，Levenshtein Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
abbrlink: cb18af87
date: 2022-01-02 14:10:51
---

编辑距离（Edit Distance，Levenshtein Distance）是一个度量两个字符序列之间差异的字符串度量标准，两个单词之间的编辑距离是将一个字符串转换为另一个字符串所需的单字符编辑（插入、删除或替换）的最小数量。编辑距离由苏联数学家Vladimir Levenshtein发明。

<!--more-->

对于两个字符串 $x$ 和 $y$，长度分别为 $|x|$ 和 $|y|$，字符串 $i$ 个字符和字符串 $j$ 个字符的编辑距离为：

$$\text{ED}_{x, y}(i, j)= \left\{ \begin{aligned} &\max{(i, j)} &, \min{(i, j)}=0\\ &\min{ {(\text{ED}_{x, y}(i-1, j)+I(i, j), \text{ED}_{x, y}(i, j-1)+I(i, j), \text{ED}_{x, y}(i, j)+I(i, j))}} &, \min{(i, j)}\neq0\\ \end{aligned} \right.$$

其中，当 $x_i=y_j$，$I(i, j)=0$，否则 $I(i, j)=1$

下面我们来看一下编辑距离的Python实现：

```python
def EditDistance(x, y):
    dp = np.zeros((len(x) + 1,len(y) + 1))
    for i in range(len(x) + 1):
        dp[i][0] = i
    for j in range(len(y) + 1):
        dp[0][j] = j

    for i in range(1, len(x) + 1):
        for j in range(1, len(y) + 1):
            delta = 0 if x[i-1] == y[j-1] else 1
            dp[i][j] = min(dp[i - 1][j - 1] + delta, min(dp[i-1][j] + 1, dp[i][j - 1] + 1))
    return int(dp[len(x)][len(y)])
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122272609>
