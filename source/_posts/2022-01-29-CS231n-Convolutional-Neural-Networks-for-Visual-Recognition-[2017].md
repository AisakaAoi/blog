---
title: 'CS231n: Convolutional Neural Networks for Visual Recognition [2017]'
categories:
  - 🌙优秀学习资源
abbrlink: 7e88b2e5
date: 2022-01-29 18:06:57
tags:
---

### CS231n简介

CS231n的全称是[CS231n: Convolutional Neural Networks for Visual Recognition](http://vision.stanford.edu/teaching/cs231n/index.html)，即面向视觉识别的卷积神经网络。该课程是[斯坦福大学计算机视觉实验室](http://vision.stanford.edu/index.html)推出的课程。

**课程描述：**请允许我们引用课程主页上的官方描述如下。

计算机视觉在社会中已经逐渐普及，并广泛运用于搜索检索、图像理解、手机应用、地图导航、医疗制药、无人机和无人驾驶汽车等领域。而这些应用的核心技术就是图像分类、图像定位和图像探测等视觉识别任务。近期神经网络（也就是“深度学习”）方法上的进展极大地提升了这些代表当前发展水平的视觉识别系统的性能。

本课程将深入讲解深度学习框架的细节问题，聚焦面向视觉识别任务（尤其是图像分类任务）的端到端学习模型。在10周的课程中，学生们将会学习如何实现、训练和调试他们自己的神经网络，并建立起对计算机视觉领域的前沿研究方向的细节理解。最终的作业将包括训练一个有几百万参数的卷积神经网络，并将其应用到最大的图像分类数据库（ImageNet）上。我们将会聚焦于教授如何确定图像识别问题，学习算法（比如反向传播算法），对网络的训练和精细调整（fine-tuning）中的工程实践技巧，指导学生动手完成课程作业和最终的课程项目。本课程的大部分背景知识和素材都来源于[ImageNet Challenge](https://image-net.org/challenges/LSVRC/2014/index)竞赛。

<!--more-->

**课程内容：**课程视频请在Youtube上查看Andrej Karpathy创建的[播放列表](https://www.youtube.com/playlist?list=PLkt2uSq6rBVctENoVBg1TpCC7OQi31AlC)，或是B站搜索。通过查看官方课程表，我们可以看到：CS231n课程资源主要由**授课视频与PPT**，**授课知识详解笔记**和**课程作业**三部分组成。其中：

- **授课视频15课。**每节课时约1小时左右，每节课一份PPT。
- **授课知识详解笔记共9份。**光看课程视频是不够的，深入理解课程笔记才能比较扎实地学习到知识。
- **课程作业3次。**其中每次作业中又包含多个小作业，完成作业能确保对于课程关键知识的深入理解和实现。
- **课程项目1个。**这个更多是面向斯坦福的学生，组队实现课程项目。
- **拓展阅读若干。**课程推荐的拓展阅读大多是领域内的经典著作节选或论文，推荐想要深入学习的同学阅读。

**课程评价：**具体如何，大家搜搜CS231n在网络在知乎上的评价！个人认为：入门深度学习CV方向的一门良心课。适合绝大多数想要学习深度学习CV知识的人。

**课程不足：**课程后期从RCNN开始就没有课程笔记。

***

### 课程学习方法

三句话总结：

- **看授课视频形成概念，发现个人感兴趣方向。**
- **读课程笔记理解细节，夯实工程实现的基础。**
- **码课程作业实现算法，积累实验技巧与经验。**

引用一下学习金字塔的图，意思大家都懂的：

{% asset_img 1.png %}

***

### CS231n 授课视频

#### Lecture 1

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447695714&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 2

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447560804&page=2" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 3

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447563868&page=3" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 4

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447556732&page=4" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 5

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447555993&page=5" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 6

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447568935&page=6" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 7

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447612655&page=7" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 8

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447677759&page=8" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 9

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447667193&page=9" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 10

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447674151&page=10" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 11

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447668946&page=11" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 12

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447691092&page=12" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 13

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447688695&page=13" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 14

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447684396&page=14" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 15

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447695286&page=15" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

#### Lecture 16

<iframe src="//player.bilibili.com/player.html?aid=976948078&bvid=BV1D44y1Y7v8&cid=447695292&page=16" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

***

### CS231n 课程笔记

#### Note 1

原文：[python/numpy tutorial](https://cs231n.github.io/python-numpy-tutorial/)

翻译：[Python Numpy教程](https://zhuanlan.zhihu.com/p/20878530)

我们将使用Python编程语言来完成本课程的所有作业。Python是一门伟大的通用编程语言，在一些常用库（numpy, scipy, matplotlib）的帮助下，它又会变成一个强大的科学计算环境。我们期望你们中大多数人对于Python语言和Numpy库比较熟悉，而对于没有Python经验的同学，这篇教程可以帮助你们快速了解Python编程环境和如何使用Python作为科学计算工具。

#### Note 2

原文：[image classification notes](https://cs231n.github.io/python-numpy-tutorial/)

翻译：图像分类笔记[（上）](https://zhuanlan.zhihu.com/p/20894041)[（下）](https://zhuanlan.zhihu.com/p/20900216)

该笔记是一篇介绍性教程，面向非计算机视觉领域的同学。教程将向同学们介绍图像分类问题和数据驱动方法，内容列表：
- 图像分类、数据驱动方法和流程
- Nearest Neighbor分类器
- k-Nearest Neighbor 译者注：上篇翻译截止处
- 验证集、交叉验证集和超参数调参
- Nearest Neighbor的优劣
- 小结：应用kNN实践
- 拓展阅读

#### Note 3

原文：[linear classification notes](https://cs231n.github.io/linear-classify/)

翻译：线性分类笔记[（上）](https://zhuanlan.zhihu.com/p/20918580)[（中）](https://zhuanlan.zhihu.com/p/20945670)[（下）](https://zhuanlan.zhihu.com/p/21102293)

我们将要实现一种更强大的方法来解决图像分类问题，该方法可以自然地延伸到神经网络和卷积神经网络上。这种方法主要有两部分组成：一个是**评分函数（score function）**，它是原始图像数据到类别分值的映射。另一个是**损失函数（loss function）**，它是用来量化预测分类标签的得分与真实标签之间一致性的。该方法可转化为一个最优化问题，在最优化过程中，将通过更新评分函数的参数来最小化损失函数值。内容列表：
- 线性分类器简介
- 线性评分函数
- 阐明线性分类器
- 损失函数
  - 多类SVM
  - Softmax分类器
  - SVM和Softmax的比较
- 基于Web的可交互线性分类器原型
- 小结

#### Note 4

原文：[optimization notes](https://cs231n.github.io/optimization-1/)

翻译：最优化笔记[（上）](https://zhuanlan.zhihu.com/p/21360434)[（下）](https://zhuanlan.zhihu.com/p/21387326)

该笔记介绍了图像分类任务的第三个关键部分：最优化。内容列表如下：
- 简介
- 损失函数可视化
- 最优化
  - 策略#1：随机搜索
  - 策略#2：随机局部搜索
  - 策略#3：跟随梯度 译者注：上篇截止处
- 梯度计算
  - 使用有限差值进行数值计算
  - 微分计算梯度
- 梯度下降
- 小结

#### Note 5

原文：[backprop notes](https://cs231n.github.io/optimization-2/)

翻译：[反向传播笔记](https://zhuanlan.zhihu.com/p/21407711)

该笔记本将帮助读者**对反向传播形成直观而专业的理解**。反向传播是利用链式法则递归计算表达式的梯度的方法。理解反向传播过程及其精妙之处，对于理解、实现、设计和调试神经网络非常关键。内容里列表如下：
- 简介
- 简单表达式和理解梯度
- 复合表达式，链式法则，反向传播
- 直观理解反向传播
- 模块：Sigmoid例子
- 反向传播实践：分段计算
- 回传流中的模式
- 用户向量化操作的梯度
- 小结

#### Note 6

原文：[Neural Nets notes 1](https://cs231n.github.io/neural-networks-1/)

翻译：神经网络笔记1[（上）](https://zhuanlan.zhihu.com/p/21462488)[（下）](https://zhuanlan.zhihu.com/p/21513367)

该笔记介绍了神经网络的建模与结构，内容列表如下：
- 不用大脑做类比的快速简介
- 单个神经元建模
  - 生物动机和连接
  - 作为线性分类器的单个神经元
  - 常用的激活函数
- 神经网络结构
  - 层组织
  - 前向传播计算例子
  - 表达能力
  - 设置层的数量和尺寸
- 小节
- 参考文献

#### Note 7

原文：[Neural Nets notes 2](https://cs231n.github.io/neural-networks-2/)

翻译：[神经网络笔记2](https://zhuanlan.zhihu.com/p/21560667)

该笔记介绍了数据的预处理，正则化和损失函数，内容列表如下：
- 设置数据和模型
  - 数据预处理
  - 权重初始化
  - 批量归一化（Batch Normalization）
  - 正则化（L2/L1/Maxnorm/Dropout）
- 损失函数
- 小结

#### Note 8

原文：[Neural Nets notes 3](https://cs231n.github.io/neural-networks-3/)

翻译：神经网络笔记3[（上）](https://zhuanlan.zhihu.com/p/21741716)[（下）](https://zhuanlan.zhihu.com/p/21798784)

该笔记讲解了神经网络的动态部分，即神经网络学习参数和搜索最优超参数的过程。内容列表如下：

- 梯度检查
- 合理性（Sanity）检查
- 检查学习过程
  - 损失函数
  - 训练集与验证集准确率
  - 权重：更新比例
  - 每层的激活数据与梯度分布
  - 可视化 译者注：上篇翻译截止处
- 参数更新
  - 一阶（随机梯度下降）方法，动量方法，Nesterov动量方法
  - 学习率退火
  - 二阶方法
  - 逐参数适应学习率方法（Adagrad，RMSProp）
- 超参数调优
- 评价
  - 模型集成
- 总结
- 拓展引用

#### Note 9

原文：[ConvNet notes](https://cs231n.github.io/convolutional-networks/)

翻译：[卷积神经网络笔记](https://zhuanlan.zhihu.com/p/22038289)

内容列表：

- 结构概述
- 用来构建卷积神经网络的各种层
  - 卷积层
  - 汇聚层
  - 归一化层
  - 全连接层
  - 将全连接层转化成卷积层
- 卷积神经网络的结构
  - 层的排列规律
  - 层的尺寸设置规律
  - 案例学习（LeNet / AlexNet / ZFNet / GoogLeNet / VGGNet）
  - 计算上的考量
- 拓展资源

***

### CS231n 课程作业

#### Assignment 1

原文：[Assignment #1](https://cs231n.github.io/assignments2016/assignment1/)

翻译：[CS231n课程作业#1简介](https://zhuanlan.zhihu.com/p/21441838)

作业内容：实现k-NN，SVM分类器，Softmax分类器和两层神经网络，实践一个简单的图像分类流程。

#### Assignment 2

原文：[Assignment #2](https://cs231n.github.io/assignments2016/assignment2/)

翻译：[CS231n课程作业#2简介](https://zhuanlan.zhihu.com/p/21941485)

作业内容：练习编写反向传播代码，训练神经网络和卷积神经网络。

#### Assignment 3

原文：[Assignment #3](https://cs231n.github.io/assignments2016/assignment3/)

翻译：[CS231n课程作业#3简介](https://zhuanlan.zhihu.com/p/21946525)

作业内容：实现循环网络，并将其应用于在微软的COCO数据库上进行图像标注。实现DeepDream等有趣应用。

***
