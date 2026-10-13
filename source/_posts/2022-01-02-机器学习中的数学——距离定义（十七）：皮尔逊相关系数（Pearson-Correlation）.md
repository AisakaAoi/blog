---
title: 机器学习中的数学——距离定义（十七）：皮尔逊相关系数（Pearson Correlation）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
abbrlink: 7921ffe4
date: 2022-01-02 22:20:33
---

在统计学中，皮尔逊相关系数（Pearson Correlation），又称皮尔逊积矩相关系数（Pearson Product-moment Correlation Coefficient，PPMCC/PCCs），是用于度量两个变量 $x$ 和 $y$ 之间的线性相关性，其值介于-1与1之间。前文提到的余弦相似度只与向量方向有关，但它会受到向量的平移影响，在夹角余弦公式中如果将 $x$ 平移到 $x+1$，余弦值就会改变。皮尔逊相关系数（Pearson Correlation）就不会受到这种情况的影响，有时候也皮尔逊相关系数也直接被称为相关系数。

$n$ 维空间中的皮尔逊相关系数为：

$$\rho(x, y)=\frac{\text{cov}(x, y)}{\sigma(x)\cdot\sigma(y)}=\frac{E[(x-\mu_x)(y-\mu_y)]}{\sigma(x)\cdot\sigma(y)}$$

我们对皮尔逊相关系数做一些简单的变换就可以得到皮尔逊相关系数与余弦相似度之间的关系：

$$\rho(x, y)=\frac{\text{cov}(x, y)}{\sigma(x)\cdot\sigma(y)}=\frac{\sum_{i=1}^n(x-\bar{x})(y-\bar{y})}{|x-\bar{x}|\cdot|y-\bar{y}|}=\cos{(x-\bar{x}, y-\bar{y})}$$

下面我们来看一下皮尔逊相关系数的Python实现：

```python
def PearsonCorrelation(x, y):
    import numpy as np
    x = np.array(x)
    y = np.array(y)
    x_ = x-np.mean(x)
    y_ = y-np.mean(y)
    return np.dot(x_,y_)/(np.linalg.norm(x_)*np.linalg.norm(y_))
```

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122277511>
