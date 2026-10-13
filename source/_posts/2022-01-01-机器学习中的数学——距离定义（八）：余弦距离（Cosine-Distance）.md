---
title: 机器学习中的数学——距离定义（八）：余弦距离（Cosine Distance）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
abbrlink: b3d811ef
date: 2022-01-01 22:56:47
---

余弦距离(Cosine Distance)也可以叫余弦相似度。 几何中夹角余弦可用来衡量两个向量方向的差异，机器学习中借用这一概念来衡量样本向量之间的差异。相比距离度量，余弦相似度更加注重两个向量在方向上的差异，而非距离或长度上。

<!--more-->

n维空间中的余弦距离为：

$$\cos(x, y)=\frac{x\cdot y}{|x|\cdot|y|}=\frac{\sum_{i=1}^nx_iy_i}{\sqrt{\sum_{i=1}^nx_i^2}\sqrt{\sum_{i=1}^ny_i^2}}$$

余弦取值范围为 $[-1,1]$，求得两个向量的夹角，并得出夹角对应的余弦值，此余弦值就可以用来表示这两个向量的相似性。夹角越小，趋近于0度，余弦值越接近于1，它们的方向更加吻合，则越相似；当两个向量的方向完全相反夹角余弦取最小值-1；当余弦值为0时，两向量正交，夹角为90度。因此可以看出，余弦相似度与向量的幅值无关，只与向量的方向相关。

下面我们来看一下余弦距离的Python实现：

```python
def CosineDistance(x, y):
    import numpy as np
    x = np.array(x)
    y = np.array(y)
    return np.dot(x,y)/(np.linalg.norm(x)*np.linalg.norm(y))
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122271927>
