---
title: 机器学习中的数学——拟牛顿法（Quasi-Newton Methods）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨④最优化理论
abbrlink: 9674de58
date: 2022-03-07 20:15:53
---

与一阶方法相比，二阶方法使用二阶导数改进了优化。最广泛使用的二阶方法是牛顿法。在牛顿法的迭代中，需要计算Hessian矩阵的逆矩阵$H^{-1}$，这一计算比较复杂，考虑用一个$n$阶矩阵$G_k=G(\theta^{(k)})$来近似代替$H^{-1}_k(\theta^{(k)})$，这就是拟牛顿法的基本想法。

<!--more-->

先看牛顿法迭代中Hessian矩阵$H_k$满足的条件。首先，$H_k$满足以下关系：

$$g_{k+1}-g_k=H_k(\theta^{(k+1)}-\theta^{(k)})$$

令$y_k=g_{k+1}-g_k$和$\delta_k=\theta^{(k+1)}-\theta^{(k)}$则：

$$y_k=H_k\delta_k\quad\text{或}\quad H_k^{-1}y_k=\delta_k$$

上式就是拟牛顿条件。

如果$H_k$是正定的（$H_k^{-1}$也是正定的），那么可以保证牛顿法搜索方向$p_k$是下降方向。这是因为搜索方向是$p_k=-\lambda g_k$，所以$f(\theta)$在$\theta$的泰勒展开式可以近似写成：

$$f(\theta)=f(\theta^{(k)})-\lambda g_k^TH^{-1}_kg_k$$

因$H^{-1}$正定，故有$g_k^TH^{-1}_kg_k>0$。当$\lambda$为一个充分小的正数时，总有$f(\theta)<f(\theta^{(k)})$，也就是说$p_k$是下降方向。

拟牛顿法将$G_k$作为$H^{-1}_k$的近似，要求矩阵$G_k$满足同样的条件。首先，每次迭代矩阵$G_k$是正定的。同时，$G_k$满足下面的拟牛顿条件：

$$G_{k+1}y_k=\delta_k$$

按照拟牛顿条件选择$G_k$作为$H^{-1}_k$的近似或选择$B_k$作为$H_k$的近似的算法称为拟牛顿法。按照拟牛顿条件，在每次迭代中可以选择更新矩阵$G_{k+1}$：

$$G_{k+1}=G_k+\Delta G_k$$

这种选择有一定的灵活性，因此有多种具体实现方法。

### DFP（Davidon-Fletcher-Powell）算法

DFP算法选择$G_{k+1}$的方法是，假设每一步迭代中矩阵$G_{k+1}$是由$G_k$，加上两个附加项构成的，即：

$$G_{k+1}=G_k+P_k+Q_k$$

其中$P_k$和$Q_k$是特定矩阵：

$$G_{k+1}y_k=G_ky_k+P_ky_k+Q_ky_k$$

为了使$G_{k+1}$满足拟牛顿的条件，可使$P_k$和$Q_k$满足：

$$P_ky_k=\delta_k \\ Q_ky_k=-G_ky_k$$

事实上，不难找出这样的$P_k$和$Q_k$，比如：

$$P_k=\frac{\delta_k\delta_k^T}{\delta_k^Ty_k}\\ Q_k=\frac{-G_ky_ky_k^TG_k}{y_kG_ky_k^T}$$

可以证明，如果初始矩阵$G_0$是正定的，则迭代过程中的每个矩阵$G_k$，都是正定的。

```
DFP算法

输入：目标函数$f(\theta)$；精度要求$\epsilon$

输出：$f(\theta)$的极小值点$\theta^*$
(1) 取初始点$\theta^{(0)}$，取$G_0$为正定对称矩阵，并置$k=0$
(2) $g_k=g(\theta^{(0)})=\nabla f(\theta^{(0)})$
(3) while$\quad||g_k||>\epsilon$
(4) $\quad p_k=-G_kg_k$
(5) $\quad \lambda_k=\arg\min_\lambda f(\theta^{(k)}+\lambda p_k)$
(6) $\quad \theta^{(k+1)} = \theta^{(k)}+\lambda_kp_k$
(7) $\quad g_{k+1}=g(\theta^{(k+1)})=\nabla f(\theta^{(k+1)})$
(8) $\quad k=k+1$
(9) return$\quad \theta^*=\theta^{(k)}$
```

### BFGS（Broyden-Fletcher-Goldfarb-Shanno）算法

可以考虑用$G_k$逼近Hessian矩阵的逆矩阵$H^{-1}$，也可以考虑用$B_k$逼近海赛矩阵$H$，这时，相应的拟牛顿条件是：

$$B_{k+1}\delta_k=y_k$$

可以用同样的方法得到另一迭代公式。首先令：

$$B_{k+1}=B_k+P_k+Q_k\\ B_{k+1}\delta_k=B_k\delta_k+P_k\delta_k+Q_k\delta_k$$

考虑$P_k$和$Q_k$满足：

$$p_k\delta_k=y_k\\ Q_k\delta_k=-B_k\delta_k$$

找出合适的$P_k$和$Q_k$，就得到了BFGS算法矩阵$B_{k+1}$的迭代公式：

$$B_{k+1}=B_k+\frac{y_ky_k^T}{y_k^T\delta_k}-\frac{B_k\delta_k\delta_k^TB_k}{\delta_k^TB_k\delta_k}$$

可以证明，如果初始矩阵$B_0$是正定的，则迭代过程中的每个矩阵$B_k$都是正定的。

```
BFGS算法

输入：目标函数$f(\theta)$；精度要求$\epsilon$

输出：$f(\theta)$的极小值点$\theta^*$
(1) 取初始点$\theta^{(0)}$，取$B_0$为正定对称矩阵，并置$k=0$
(2) $g_k=g(\theta^{(0)})=\nabla f(\theta^{(0)})$
(3) while$\quad||g_k||>\epsilon$
(4) $\quad p_k=-g_kB_k^{-1}$
(5) $\quad \lambda_k=\arg\min_\lambda f(\theta^{(k)}+\lambda p_k)$
(6) $\quad \theta^{(k+1)} = \theta^{(k)}+\lambda_kp_k$
(7) $\quad g_{k+1}=g(\theta^{(k+1)})=\nabla f(\theta^{(k+1)})$
(8) $\quad k=k+1$
(9) return$\quad \theta^*=\theta^{(k)}$
```

### Broyden类算法

我们可以从BFGS算法矩阵$B_k$的迭代公式得到BFGS算法关于$G_k$的迭代公式。事实上，若记$G_k=B_k^{-1}$和$G_{k+1}=B_{k+1}^{-1}$，那么两次应用Sherman-Morrison公式即得：

$$G_{k+1}=(I-\frac{\delta_ky_k^T}{\delta_k^Ty_k})G_k(I-\frac{\delta_ky_k^T}{\delta_k^Ty_k})^T+\frac{\delta_k\delta_k^T}{\delta_k^Ty_k}$$

上式称为BFGS算法关于$G_k$的迭代公式。

由DFP算法$G_k$的迭代公式得到的$G_{k+1}$，记作$G^{\text{DFP}}$，由BFGS算法$G_k$的迭代公式得到的$G_{k+1}$，记作$G^{\text{BFGS}}$，它们都满足拟牛顿条件式，所以它们的线性组合：

$$G_{k+1}=\alpha G^{\text{DFP}}+(1-\alpha)G^{\text{BFGS}}$$

也满足拟牛顿条件式，而且是正定的。其中$0\leq\alpha\leq1$。这样就得到了一类拟牛顿法，称为Broyden类算法。

***

### 原文链接

> <https://machinelearning.blog.csdn.net/article/details/123296903>
