---
title: 机器学习中的数学——牛顿迭代法（Newton's Method）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨④最优化理论
abbrlink: 6a07a7ef
date: 2022-03-07 20:15:21
---

牛顿迭代法（Newton's Method）又称为牛顿-拉夫逊（拉弗森）方法（Newton-Raphson Method），它是牛顿在17世纪提出的一种在实数域和复数域上近似求解方程的方法。与一阶方法相比，二阶方法使用二阶导数改进了优化，其中最广泛使用的二阶方法是牛顿法。

<!--more-->

考虑无约束最优化问题：

$$\min_{\theta\in R^n}f(\theta)$$

其中$\theta^*$为目标函数的极小点，假设$f(\theta)$具有二阶连续偏导数，若第$k$次迭代值为$\theta^{(k)}$，则可将$f(\theta)$在$\theta^{(k)}$附近进行二阶泰勒展开：

$$f(\theta)=f(\theta^{(k)})+g_k^T(\theta-\theta^{(k)})+\frac{1}{2}(\theta-\theta^{(k)})^TH(\theta^{(k)})(\theta-\theta^{(k)})$$

这里，$g_k=g(\theta^{(k)})=\nabla f(\theta^{(k)})$是$f(\theta)$的梯度向量在点$\theta^{(k)}$的值，$H(\theta^{(k)})$是$f(\theta)$的Hessian矩阵：

$$H(\theta)=[\frac{\partial^2f}{\partial \theta_i\partial \theta_j}]_{m\times n}$$

在点$\theta^{(k)}$的值。函数$f(\theta)$有极值的必要条件是在极值点处一阶导数为0，即梯度向量为0，特别是当$H(\theta)$是正定矩阵时，函数$f(\theta)$的极值为极小值。牛顿法利用极小点的必要条件：

$$\nabla f(\theta)=0$$

每次迭代中从点$\theta^{(k)}$开始，求目标函数的极小点，作为第$k+1$次迭代值$\theta^{(k+1)}$。具体地，假设$\theta^{(k+1)}$满足：

$$\nabla f(\theta^{(k+1)})=0$$

则有：

$$\nabla f(\theta)=g_k+H_k(\theta-\theta^{(k)})$$

其中$H_k=H(\theta^{(k)})$。这样，我们可以得：

$$g_k+H_k(\theta^{(k+1)}-\theta^{(k)})=0$$

则：

$$\theta^{(k+1)}=\theta^{(k)}-H_k^{-1}g_k=\theta^{(k)}+p_k$$

这就是牛顿迭代法。

```
牛顿迭代法

输入：目标函数$f(\theta)$；Hessian矩阵$H(\theta)$；精度要求$\epsilon$
输出：$f(\theta)$的极小值点$\theta^*$
(1) 取初始点$\theta^{(0)}$并置$k=0$
(2) 计算$g_k=g(\theta^{(0)})=\nabla f(\theta^{(0)})$
(3) while$\quad||g_k||>\epsilon$
(4) $\quad H_k=H(\theta^{(k)})$
(5) $\quad \theta^{(k+1)}=\theta^{(k)}-H_k^{-1}g_k$
(6) $\quad g_k=g(\theta^{(0)})=\nabla f(\theta^{(0)})$
(7) $\quad k=k+1$
(8) return$\quad \theta^*=\theta^{(k)}$
```

迭代过程可参考下图：

{% asset_img 1.gif %}

在《优化技术：深度学习优化的挑战-[高原、鞍点和其他平坦区域]》我们讨论了牛顿法只适用于Hessian矩阵是正定的情况。在深度学习中，目标函数的表面通常非凸（有很多特征），如鞍点。因此使用牛顿法是有问题的。如果Hessian矩阵的特征值并不都是正的，例如，靠近鞍点处，牛顿法实际上会导致更新朝错误的方向移动。这种情况可以通过正则化Hessian矩阵来避免。常用的正则化策略包括在Hessian矩阵对角线上增加常数$\alpha$。正则化更新变为：

$$\theta^*=\theta_0-[H(f(\theta_0))+\alpha I]^{-1}\nabla_\theta f(\theta_0)$$

这个正则化策略用于牛顿法的近似，例如Levenberg-Marquardt算，只要Hessian矩阵的负特征值仍然相对接近零，效果就会很好。在曲率方向更极端的情况下，$\alpha$的值必须足够大，以抵消负特征值。然而，如果$\alpha$持续增加，Hessian矩阵会变得由对角矩阵$\alpha I$主导，通过牛顿法所选择的方向会收敛到普通梯度除以$\alpha$。当很强的负曲率存在时，α可能需要特别大，以至于牛顿法比选择合适学习率的梯度下降的步长更小。

除了目标函数的某些特征带来的挑战，如鞍点，牛顿法用于训练大型神经网络还受限于其显著的计算负担。Hessian矩阵中元素数目是参数数量的平方，因此，如果参数数目为$k$（甚至是在非常小的神经网络中$k$也可能是百万级别），牛顿法需要计算$k\times k$矩阵的逆，计算复杂度为$O(k^3)$。另外，由于参数将每次更新都会改变，每次训练迭代都需要计算Hessian矩阵的逆。其结果是，只有参数很少的网络才能在实际中用牛顿法训练。在本节的剩余部分，我们将讨论一些试图保持牛顿法优点，同时避免计算障碍的替代算法。

***

### 原文链接

> <https://machinelearning.blog.csdn.net/article/details/123293625>
