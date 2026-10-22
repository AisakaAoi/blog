---
title: 深入理解深度学习——Word Embedding（三）：Skip-Gram模型
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《深入理解深度学习》
abbrlink: 8e1f5f91
date: 2021-12-11 23:27:24
---

Skip-Gram模型与连续词袋模型（CBOW）类似，同样包含三层：输入层、映射层和输出层。具体架构如下图所示：

{% asset_img 1.webp %}

<!--more-->

Skip-Gram模型中的$w(t)$为输入词，在已知词$w(t)$的前提下预测词$w(t)$的上下文$w(t-n)$、$\cdots$、$w(t-2)$、$w(t-1)$、$w(t+1)$、$w(t+2)$、$\cdots$、$w(t+n)$，条件概率写为$p(\text{context}(w)|w)$。目标函数为：

$$L=\sum_{w\in C}\log p(\text{context}(w)|w)$$

我们通过一个简单的例子来说明Skip-Gram的基本思想。假设有一句话：

> The quick brown fox jumped over the lazy dog.

接下来，我们根据Skip-Gram模型的基本思想，按这条语句生成一个由序列（输入，输出）构成的数据集。首先，我们对一些单词以及它们的上下文环境建立一个数据集。可以以任何合理的方式定义“上下文”，这里是把目标单词的左右单词视作一个上下文，使用大小为1的窗口定义，也就是说，仅选输入词前后各1个词和输入词进行组合，就得到一个由（上下文，目标单词）组成的数据集，具体如下图所示：

{% asset_img 2.webp %}

***

### 原文链接

> <https://machinelearning.blog.csdn.net/article/details/121800555>
