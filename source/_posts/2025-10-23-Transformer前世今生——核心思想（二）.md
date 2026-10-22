---
title: Transformer前世今生——核心思想（二）
date: 2025-10-23 02:46
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: 54527aac
tags:
---

随着AI市场，生成模型的投资热，小编在这里也开了一个Transformer的讲解系列，因为目前主流的大模型其核心都是Transformer，attention is all you need.本系列将介绍Transformer的算法原理以及使用pytorch的实现.

<!--more-->

### 1.ChatGPT 的核心基础是 Transformer

如今，人们都在谈论 ChatGPT。 但 ChatGPT 背后的根本原理，其实基于一种模型结构——Transformer。

Transformer 看起来复杂，但从本质上来说，它由三个关键部分组成：

（1）Word Embedding（词嵌入） （2）Positional Encoding（位置编码） （3）Attention（注意力机制）

{% asset_img 2.webp %}

### 2.Word Embedding —— 把词语转成数字

计算机无法直接理解文字，只能处理数字。 Transformer 是一种神经网络（Neural Network），因此它需要数字输入。所以，词嵌入层的作用是把输入的词（甚至词的一部分）转换成向量形式的数字。

例如输入句子：

“tell me about pizza（告诉我关于披萨的事）”

经过词嵌入层后，每个单词都会被转化成一组数值向量。 就像在说： “语言 → 数学世界” 的第一步！

### 3.Positional Encoding —— 让模型知道词序

仅仅知道有哪些词还不够，模型还得知道词的顺序。

例如：

“Squatch eats pizza.”（史阔奇吃披萨） → 意思正常

“Pizza eats Squatch.”（披萨吃史阔奇） → 意思完全反了

两句话用了完全相同的词，但顺序不同，含义却天差地别。 这说明：

理解词序至关重要！

于是，研究者发明了 位置编码（Positional Encoding）， 让每个词除了自身的词向量外，还包含它在句子中**位置的信息**。 （实现方式有多种，例如正弦余弦函数、可学习向量等，这里不展开。）

### 4.Attention —— 建立词与词之间的关系

现在我们知道：

词嵌入 → 把词变成数字；

位置编码 → 让模型知道顺序。

那模型如何理解句子中词与词之间的联系呢？**注意力机制（Attention）**

举例：

句子：“The pizza came out of the oven and it tasted good.” 这里的 “it” 可能指 “pizza”，也可能指 “oven”。 但人类知道，“好吃的烤箱”没意义 ，所以 “it” 一定指披萨。

{% asset_img 3.webp %}

{% asset_img 4.webp %}

Transformer 就通过 Attention 来判断这一点： 它会学习到 “it” 与 “pizza” 的语义关系更强。

### 5.Self-Attention（自注意力）是如何工作的

在 Transformer 中，最基础的一种注意力叫 自注意力（Self-Attention）。 它的核心思想是：

**每个词都会与句子中所有其他词（包括自己）计算“相似度”**

举例来说：

它计算 “the” 与每个词的相似度；

然后计算 “pizza” 与每个词的相似度；

以此类推。

这些**相似度（similarity scores）会作为权重**，决定每个词在句子表示中**被关注的程度**。

因此： 如果模型在大量语料中发现 “it” 常常指向 “pizza”， 那么在编码时，Transformer 会给 “pizza” 更高的权重， 从而更准确地捕捉语义。

### 原文链接

> <https://mp.weixin.qq.com/s/Q48YqsW--J-c9kohZDu0lQ>
