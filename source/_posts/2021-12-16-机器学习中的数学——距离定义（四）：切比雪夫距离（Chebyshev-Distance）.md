---
title: 机器学习中的数学——距离定义（四）：切比雪夫距离（Chebyshev Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨线性代数
abbrlink: da10513f
date: 2021-12-16 21:02:41
---

切比雪夫距离（Chebyshev Distance）为 $L_\infty$ 度量，是向量空间中的一种度量，二个点之间的距离定义是其各坐标数值差绝对值的最大值。以数学的观点来看，切比雪夫距离是由一致范数（或称为上确界范数）所衍生的度量，也是超凸度量的一种：

<!--more-->

$$D(x, y)=\max(|x_i-y_i|)$$

国际象棋棋盘上二个位置间的切比雪夫距离是指王要从一个位子移至另一个位子需要走的步数。由于王可以往斜前或斜后方向移动一格，因此可以较有效率的到达目的的格子。下图是棋盘上所有位置距王位置的切比雪夫距离。

{% asset_img 1.webp %}
<div align='center'>切比雪夫距离</div>

下面我们来看一下切比雪夫距离的Python实现：

```python
def ChebyshevDistance(x, y):
    import numpy as np
    x = np.array(x)
    y = np.array(y)
    return np.max(np.abs(x-y))
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/121728668>
