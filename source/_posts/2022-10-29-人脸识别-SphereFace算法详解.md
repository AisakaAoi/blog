---
title: 人脸识别-SphereFace算法详解
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: e62a374d
date: 2022-10-29 06:37:25
---

论文：SphereFace: Deep Hypersphere Embedding for Face Recognition
论文链接：<https://arxiv.org/abs/1704.08063>
代码地址：<https://github.com/wy1iu/sphereface>

这篇是CVPR2017的文章，用改进的softmax做人脸识别，改进点是提出了 angular softmax loss（A-softmax loss）用来改进原来的softmax loss。如果你了解large margin softmax loss（作者和A-softmax loss是同一批人），**那么A-softmax loss简单讲就是在large margin softmax loss的基础上添加了两个限制条件||W||=1和b=0，使得预测仅取决于W和x之间的角度。**

<!--more-->

***

Figure2中展示的是用一个CNN网络提取特征，然后将提取到的特征在类别间的分布展示出来。（a）和（b）是softmax loss的结果；（c）和（d）是限制W1和W2向量的模等于1，而且b1和b2偏置等于0，称为modified softmax loss；（e）和（f）是本文的angular softmax loss，后面详细介绍。接下来介绍Figure2图的含义：图中特征是2维的，对应横坐标，毕竟二维的容易观察，这可以通过将最后一个提特征层（假设最后一个特征提取层是卷积层，那么就将卷积核数量设置为2）就能得到，因此对于一张输入图像，就能得到1 * 2维度的特征向量，就可以在二维坐标空间中画出来这个点了，对应Figure2（a）、（c）、（e）中的点。最后接一个全连接层，对于Figure2中的二分类而言（一个类别是黄色点，另一个类别是红色点），全连接层的维度就是2 * 2，后面一个2就是类别的意思。再看看（b），W1和W2分别是I * 2的向量，合在一起就是2 * 2的全连接层参数，因此W1和W2的箭头位置所在的坐标就是1 * 2向量的值，这样就可以画出图中的红色箭头了，至于中间的红色线，就是分类界限。同理（d）中W1和W2的模等于1，特征点之所以类似圆形是将（c）中的特征点变换成模为1的特征点；（e）、（f）的含义和（c）、（d）的含义同理。

{% asset_img 1.jpg %}

接下来介绍A-softmax loss的内容。还是先从softmax loss开始讲起。假设一个二分类问题，那么下面的公式1和2分别表示样本x属于类别1和类别2的概率，这个计算的过程就是softmax。**这里的W1和W2都是向量，二者合在一起组成全连接层的参数矩阵W，也就是W=[W1，W2]，全连接层的输出也就是Wx。**假设输出的尺寸是m*n，那么m就表示batch size，n表示类别数，所以这里的W1x和W2x就分别是Wx的两列。偏置b比较简单就不详细说了。因此如果p1大于p2，那么x属于类别1。

$$p_1 = \frac{\exp(W_1^T x + b_1)}{\exp(W_1^T x + b_1) + \exp(W_2^T x + b_2)}$$

$$p_2 = \frac{\exp(W_2^T x + b_2)}{\exp(W_1^T x + b_1) + \exp(W_2^T x + b_2)}$$

这个时候可以联想到文章前面提到的一个公式：

$$(W_1 - W_2)x + b_1 - b_2 = 0$$

文章说这是softmax的decision boundary，怎么理解呢？**其实就是p1=p2的情况，此时W1x+b1=W2x+b2。如果p1>p2，从p1和p2的公式可以看出二者的分母是一样的，分子都是以e为底的指数函数，是递增的，因此就相当于W1x+b1>W2x+b2。**

公式1和2只是softmax，并不是softmax loss，这两者是有差别的，一个是概率，一个是损失。softmax loss的公式如下：

$$L = \frac{1}{N} \sum_i L_i = \frac{1}{N} \sum_i -\log\left(\frac{e^{f_{y_i}}}{\sum_j e^{f_j}}\right)$$

**公式3的log函数的输入就是前面公式1和2的p1和p2，只不过不需要分开写成W1和W2，而是用W就行。这里yi表示某个类别，j表示所有类别。**

公式4是将Li展开来写，并且引入了角度参数：

$$L_i = -\log\left(\frac{e^{W_{y_i}^T x_i + b_{y_i}}}{\sum_j e^{W_j^T x_i + b_j}}\right) = -\log\left(\frac{e^{\|W_{y_i}\| \|x_i\| \cos(\theta_{y_i,i}) + b_{y_i}}}{\sum_j e^{\|W_j\| \|x_i\| \cos(\theta_{j,i}) + b_j}}\right)$$

为什么公式4的上下两个等式是成立的？因为可以将矩阵相乘：

$$W_i^T x + b_i$$

写成：

$$\|W_i^T\| \|x\| \cos(\theta_i) + b_i$$

非常容易理解吧。

那么如果引入下面这两个限制条件呢？

$$\|W_1\| = \|W_2\| = 1$$

和

$$b_1 = b_2 = 0$$

那么公式3（结合公式4和上面两个限制条件看）就会变成：

$$L_{modified} = \frac{1}{N} \sum_i -\log\left(\frac{e^{\|x_i\| \cos(\theta_{y_i,i})}}{\sum_j e^{\|x_i\| \cos(\theta_{j,i})}}\right)$$

**那么为什么要引入这两个限制条件呢？**原来的decision boundary是这样的：

$$(W_1 - W_2)x + b_1 - b_2 = 0$$

如果有上面的两个限制条件，那么decision boundary就变成了：

$$\|x\|(\cos\theta_1 - \cos\theta_2) = 0$$

**也就是说边界的确定变成只取决于角度了，这样就能简化很多问题。**而且从Figure2也可以看出这种操作对分类结果有促进作用。

在这两个限制条件的基础上，作者又添加了和large margin softmax loss一样的角度参数，使得公式5变成如下的公式6：

$$L_{ang} = \frac{1}{N} \sum_i -\log\left(\frac{e^{\|x_i\| \cos(m\theta_{y_i,i})}}{e^{\|x_i\| \cos(m\theta_{y_i,i})} + \sum_{j \neq y_i} e^{\|x_i\| \cos(\theta_{j,i})}}\right)$$

这部分可以参考[损失函数改进之Large-Margin Softmax Loss](https://blog.csdn.net/u014380165/article/details/76864572)，基本一样。显然m值越大，优化的难度也越大，但类别之间的angular margin也越大，也就是类间距离越大，同时类内距离越小，因此模型效果越好。本文中参数m默认取4。

因为在公式6中需要限定θy的范围为[0, π/m]，因此为了去掉这个限制，就有了公式7这种能够在CNN网络中优化的公式。

$$L_{ang} = \frac{1}{N} \sum_i -\log\left(\frac{e^{\|x_i\| \psi(\theta_{y_i,i})}}{e^{\|x_i\| \psi(\theta_{y_i,i})} + \sum_{j \neq y_i} e^{\|x_i\| \cos(\theta_{j,i})}}\right)$$

in which we define $\psi(\theta_{y_i,i}) = (-1)^k \cos(m\theta_{y_i,i}) - 2k$, $\theta_{y_i,i} \in \left[ \frac{k\pi}{m}, \frac{(k+1)\pi}{m} \right]$ and $k \in [0, m-1]$. $m \geq 1$ is an integer that controls the size of angular margin. When $m=1$, it becomes the modified softmax loss.

**公式7也就是作者文中最终使用的loss公式。因此A-softmax loss可以看成是large margin softmax loss的改进版，也就是在large margin softmax loss的基础上添加了两个限制条件。**

Table1是关于本文提到的3个loss的分类界限（decision boundary）对比，可以看出softmax loss的优化是对W和x的内积进行的；modified softmax loss（也就是限制Wi的模为1，bi为0）的优化是对角度θi进行的；A-softmax loss的优化也是对θi进行，而且优化目标更加难（引入m参数，优化后在类别之间会得到angular margin）。

{% asset_img 15.jpg %}

Figure3表示从几何角度看A-softmax loss。

{% asset_img 16.jpg %}

后面作者还通过数学公式证明了对于**二分类**，m的最小值要满足下面这个不等式：

$$m_{min} \geq 2 + \sqrt{3}$$

对于**多分类**，m的最小值要满足下面这个不等式：

$$m_{min} \geq 3$$

***

### 参考资料

> 版权声明：本文为CSDN博主「AI之路」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
> 原文链接：https://blog.csdn.net/u014380165/article/details/76946380
