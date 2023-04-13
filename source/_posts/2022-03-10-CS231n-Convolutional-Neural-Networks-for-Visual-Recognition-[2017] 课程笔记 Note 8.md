---
title: >-
  CS231n: Convolutional Neural Networks for Visual Recognition [2017] 课程笔记 Note
  8
categories:
  - 🌙学习资源
  - ⭐Stanford CS231n [2017]
abbrlink: b059653f
date: 2022-03-10 18:06:57
tags:
---

### Note 8

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

<!--more-->

***
