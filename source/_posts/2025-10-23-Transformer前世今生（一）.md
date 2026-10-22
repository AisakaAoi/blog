---
title: Transformer前世今生（一）
date: 2025-10-23 02:34
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: 2cc85b2f
tags:
---

**随着AI市场，生成模型的投资热，小编在这里也开了一个Transformer的讲解系列，因为目前主流的大模型其核心都是Transformer，attention is all you need.本系列将介绍Transformer的算法原理以及使用pytorch的实现.**

### 1.起源

Transformer 架构和注意力算法在大型语言模型的发展中非常重要。

2014 年，研究人员在研究**机器翻译（machine translation**问题——即输入一段英文句子，并将其翻译成法语。

他们最初的做法是：取一个英文单词，然后查找它对应的法语单词。

<!--more-->

{% asset_img 1.webp %}

但效果不好。 ——英语和法语的词序不同（如 “The European Economic Area was …” 在法语中顺序会变化）；

——句子长度不同（例如英语 “They arrived late.” 仅三个词，而法语翻译要用五个词）。 这意味着，模型需要能“理解上下文”，而不仅是一个个独立单词。

### 2.发现

2014 年，蒙特利尔大学 Yoshua Bengio 团队和斯坦福大学 Chris Manning 团队，几乎同时提出了相似的想法—— 他们发明了Attention（注意力）机制，论文就是视频中提到的那几篇。

这两组研究者都提出：

**编码器-解码器（Encoder–Decoder**结构”对翻译非常有效。

**编码器（Encoder）**：逐个读取输入句子中的词，生成一系列向量表示。

**解码器（Decoder）**：再根据这些向量，一个词一个词地生成输出（如法语翻译）。

### 3.从静态向量到上下文向量（Contextual Embeddings）

早期模型会将整句转换为一个单一向量（Dense Vector）来表示其含义。 但新的研究保留了每个词的独立向量，并让解码器可以访问它们。

这意味着每个词的表示依赖于上下文，也就是我们今天所说的：

**“上下文嵌入（Contextual Embedding）” 即：词的表示不仅取决于它自身，还取决于它前后的词。**

{% asset_img 2.webp %}

### 4.注意力机制的核心思想

在生成输出时，解码器可以**对每个输入词分配不同的“注意力权重**”：

生成第一个法语词时，可能最关注输入句子的第一个英文词；

生成第二个法语词时，由于词序变化，可能最关注第四个英文词。

这就形成了“**动态聚焦**”的过程： 模型在每一步翻译时关注最相关的输入词向量，从而理解复杂语序关系。 这就是早期注意力机制（Early Attention Mechanism）。

### 5.Transformer 的诞生（2017）

2017 年，Google Brain 团队的论文《Attention is All You Need》正式提出了：

Transformer 架构 —— 一种完全基于注意力机制（不再依赖 RNN 或 CNN）的模型。

他们在设计时的首要目标是：

**让模型能在 GPU 上高效扩展（scalable on GPU）**。

事实证明，这是一个极具远见的决定。

### 6.Transformer 的双结构

Transformer 同样由 Encoder 和 Decoder 两部分组成：

**Encoder：一次性读取整句，生成每个词的上下文向量； Decoder：逐词生成输出，每一步都考虑：已生成的前文；**

编码器提供的上下文向量。

### 7.BERT 与 GPT 的分化

BERT（Bidirectional Encoder Representations from Transformers） → 只使用 Encoder 部分，用于理解与表示（embedding）任务。 → 是当前几乎所有语义搜索、RAG（检索增强生成）和推荐系统嵌入模型的基础。

GPT（Generative Pre-trained Transformer） → 只使用 Decoder 部分，用于文本生成。 → 是 OpenAI（ChatGPT）及其他如 Anthropic、Google、Mistral、Meta 等公司大型语言模型的核心。

原始 Transformer 模型仅有 6 层注意力结构， 而如今的 Llama 3.2-405B（Meta） 已扩展到 126 层， 但其核心架构仍与最初完全一致。

### 原文链接

> <https://mp.weixin.qq.com/s/ZOBNP1_qp3HSY9cQ3X5A4Q>
