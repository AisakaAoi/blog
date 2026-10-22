---
title: Transformer前世今生——自注意力（self-attention）与掩蔽自注意力（五）
date: 2025-10-31 05:12
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: 1ed61e37
tags:
---

随着AI市场，生成模型的投资热，小编在这里也开了一个Transformer的讲解系列，因为目前主流的大模型其核心都是Transformer，attention is all you need.本系列将介绍Transformer的算法原理以及使用pytorch的实现.

这节课将深入探讨**自注意力（self-attention）与掩蔽自注意力（masked self-attention**的优缺点。

虽然两者的区别看似细微，但却对模型能解决的问题类型产生巨大影响。

我们之前学过注意力机制的主要思想——它帮助模型建立单词之间的关系。
例如这句话：

“The pizza came out of the oven and it tasted good.”
（披萨从烤箱里出来，它味道很好。）

其中 “it” 可能指的是 “pizza”，也可能指 “oven”。
而注意力机制（尤其是自注意力）通过计算单词之间的相似性，帮助模型正确地判断 “it” 指代的是 “pizza

<!--more-->

### 1. Word Embedding

Transformer 需要把单词转换成数字。
最简单的方式是为每个单词随机分配一个数字，比如：

“pizza is great” → 每个词随机分配数字。
“pizza is awesome” → “pizza” 和 “is” 使用同样的数字，“awesome” 分配新的数字。

但这样的问题是：
虽然 “great” 和 “awesome” 意思相近，但却被赋予了完全不同的数字。
因此模型在学习 “great” 的用法时，并不能帮助它理解 “awesome”。

理想情况下，相似的词应该有相似的数字表示，这样学习一个词时，也能帮助学习另一个。

此外，同一个词在不同语境下也会有不同含义，例如：

“pizza is great”（积极）

“my phone’s broken, great.”（讽刺、消极）

所以最好**每个词有多个数字表示，用以适应不同语境**。

### 2. 如何生成词向量

在 Transformer 之前，人们已经发明了独立的神经网络来生成词向量。
例如用两句话训练：

“pizza is great”
“pizza is awesome”

为每个唯一单词创建输入与输出；

使用两个激活函数（意味着每个词用两个数字表示）；

初始权重为随机数；

训练网络让每个词预测下一个词。

例如：

输入 “pizza” → 期望输出 “is”；

输入 “is” → 期望输出 “great” 或 “awesome”。

经过训练后，**“great” 和 “awesome” 的词向量会更接近**，因为它们出现在相似的语境中。

### 3. 位置编码（Positional Encoding）

到目前为止，我们的模型没有考虑单词顺序。
例如：

“the pizza came out of…”
和
“pizza out came the of”

在模型中是一样的。
但显然，“Squatch eats pizza” 和 “Pizza eats Squatch” 意思完全相反。

因此 Transformer 引入了位置编码层（Positional Encoding），**用来在词向量中加入位置信息。**
之后再通过**自注意力层（Self-Attention**建立词与词之间的关系。

### 4. 上下文感知嵌入（Context-Aware Embedding）

当自注意力同时考虑前后所有词时，得到**的词向量被称为上下文感知嵌入**。
它不仅能聚类相似的单词，还能聚类相似的句子或文档。

例如：

Encoder-only Transformer（只使用自注意力）能生成这种 Context-Aware Embedding。

这些嵌入可用于文本分类，如判断推文对“pizza”的情感是正面还是负面。

这种嵌入还可作为逻辑回归或神经网络的输入，进行分类任务。

### 5. Decoder-only Transformer 与掩蔽自注意力

{% asset_img 1.webp %}

另一种 Transformer 是 Decoder-only Transformer。
它同样使用**词向量和位置编码**，但用的是 掩蔽自注意力（Masked Self-Attention）。

区别在于：

**自注意力（Self-Attention）：可看前后所有词**。

**掩蔽自注意力（Masked Self-Attention）：只能看当前词和之前的词，不能看后面的词**。

举例：

计算 “the” 的注意力时，自注意力会看“the”及其后所有词；

掩蔽自注意力只看“the”及其之前的内容。

这种结构使得 Decoder-only Transformer 能逐步生成文本。
例如在训练时给出句子前半部分：“The pizza came out of the oven and it”，
模型学习生成后半部分 “tasted good”。

这正是 ChatGPT 的工作原理：
ChatGPT 是一个 Decoder-only Transformer，**专门被训练来生成文本。**
**因此它被称为生成式模型（Generative Model）**。

这篇文章的关键知识点：

自注意力能同时看到前后文；

掩蔽自注意力只能看到之前的词；

这个小小的区别，决定了两种 Transformer 在任务上的巨大差异。

Encoder-only 用于理解（理解语义、分类）；
Decoder-only 用于生成（生成文本、补全句子）。

### 原文链接

> <https://mp.weixin.qq.com/s/2oMYH-qXAatKqMNN_h7yFg>
