---
title: >-
  CS231n: Convolutional Neural Networks for Visual Recognition [2017] 课程笔记 Note
  5
categories:
  - 🌙学习资源
  - ⭐Stanford CS231n
abbrlink: cee81982
date: 2022-03-07 18:06:57
tags:
---

### Note 5

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

<!--more-->

***
