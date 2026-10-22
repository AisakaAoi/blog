---
title: Transformer前世今生——原理与矩阵计算（三）
date: 2025-10-23 03:32
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: 5c9b59c3
tags:
---

随着AI市场，生成模型的投资热，小编在这里也开了一个Transformer的讲解系列，因为目前主流的大模型其核心都是Transformer，attention is all you need.本系列将介绍Transformer的算法原理以及使用pytorch的实现.

### 1. 前置概念：Q、K、V 三个矩阵

在自注意力的公式中，我们经常看到三个符号：

**Q（Query）查询向量 K（Key）键向量 V（Value）值向量**

这三个词最早来自 数据库（Database） 的术语：

Query（查询）：你要搜索的内容。

Key（键）：数据库中已有的条目。

Value（值）：数据库返回的结果。

<!--more-->

{% asset_img 2.webp %}

{% asset_img 3.webp %}

举例：

假设数据库里有一张表，存放旅客的“姓氏 → 房间号”：

Starmer → 537 Jones → 402 Kim → 215

现在 Squatch 打错了名字，输入 Stammer。 计算机会尝试比较输入（Query）与所有 Key 的相似度：

Stammer vs Starmer → 最相似 于是返回对应的房间号 537（Value）。

**在 Transformer 中，模型会计算每个词与其他词之间的“相似度”， 这就是注意力分数的本质**。

### 2. 在 Transformer 中如何得到 Q、K、V

假设句子是：

“Write a poem.”

**每个词首先被转换为 词嵌入向量（Embedding）**。 例如，为了方便手算，这里每个词只用两个数字表示（实际中通常是 512 维）。

接着我们会分别乘以三个不同的权重矩阵：

乘以 Wᵩ (Query Weights) → 得到 Q

乘以 Wₖ (Key Weights) → 得到 K

乘以 Wᵥ (Value Weights) → 得到 V

这样，每个词都有三种表示方式。

Transformer 在训练时会通过反向传播（Backpropagation）误差，更新所有参数：

- 包括词嵌入矩阵（**Embedding Matrix**）
- 包括各层的 **WQ**, **WK**, **WV**
- 还包括输出层的权重等

注意： 若每个词有 2 个数值，则权重矩阵为 2×2； 若每个词有 512 维，则权重矩阵为 512×512。 **只要矩阵维度能对齐，计算就能进行**。

### 3. 计算相似度：Q × Kᵀ

将 Q 与 K 的转置矩阵相乘： Q × Kᵀ

**为什么要转置 K？**

如果不转置，矩阵维度不匹配，没法相乘。

**更重要的是，Kᵀ 可以让每一行的 Query 与所有 Key 做“点积”比较**。

例子：

假设我们取“write”的 Query，与

“write”的 Key → 点积 = -0.09

“a”的 Key → 点积 = 0.06

“poem”的 Key → 点积 = -0.61

{% asset_img 4.webp %}

{% asset_img 5.webp %}

这些结果称为未缩放的相似度（Unscaled Similarities）。 本质上，**这些点积（dot product）表示了词之间的语义相关性**。

### 4. 缩放（Scaling）

因为点积值可能随维度变大而失控，所以 Transformer 使用缩放操作：

将结果除以 √dₖ

其中 dₖ 是每个 Key 的维度（例子中是 2）。 也就是说：

**Scaled Scores = (Q × Kᵀ) / √dₖ**

这能让模型更稳定，防止梯度过大。

缩放不会改变相对关系，但能改善训练效果。

原论文作者指出，这一步显著提升了性能。

{% asset_img 6.webp %}

{% asset_img 7.webp %}

### 5. Softmax：将相似度转为权重

接下来对每一行做 Softmax 操作：

Attention Weights = softmax(Scaled Scores)

Softmax 会把所有分数转换为概率，使每一行的和为 1。

举例：

对“write”这一行：

比较对象 相似度（经 softmax） 含义 write 36% 自身最相关 a 40% 与后续词稍相关 poem 24% 语义相关较弱

{% asset_img 8.webp %}

这些百分比代表每个词对“write”最终表示的贡献权重。

### 6. 乘以 V：得到最终自注意力输出

最后一步，将这些注意力权重与 V 相乘：

Self-Attention = softmax(QKᵀ / √dₖ) × V

这一步的含义是：

每个词的最终表示，是所有词的 Value 的加权和。

举例： 生成“write”的新表示时：

{% asset_img 9.webp %}

= 0.36×V(write) + 0.40×V(a) + 0.24×V(poem)

{% asset_img 10.webp %}

这样模型就能把上下文关系整合进每个词的向量表示中。

最终我们得到每个词的自注意力结果，也就是新的上下文语义表示。

### 原文链接

> <https://mp.weixin.qq.com/s/SicTmLc_1lYL3fGqK9G0bw>
