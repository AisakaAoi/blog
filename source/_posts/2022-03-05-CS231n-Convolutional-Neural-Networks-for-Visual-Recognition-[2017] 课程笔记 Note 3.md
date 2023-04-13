---
title: >-
  CS231n: Convolutional Neural Networks for Visual Recognition [2017] 课程笔记 Note
  3
categories:
  - 🌙学习资源
  - ⭐Stanford CS231n [2017]
abbrlink: 278bbcb7
date: 2022-03-05 18:06:57
tags:
---

### Note 3

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

<!--more-->

***
