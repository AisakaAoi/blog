---
title: 深入理解深度学习——Word Embedding（四）：Skip-Gram模型的数学原理
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《深入理解深度学习》
abbrlink: 5451db50
date: 2021-12-18 18:50:16
---

我们在《Word Embedding（三）：Skip-Gram模型》中简单介绍了Skip-Gram的原理及架构，至于Skip-Gram如何把输入转换为词嵌入、其间有哪些关键点、面对大语料库可能出现哪些瓶颈等，并没有展开说明。而了解Skip-Gram的具体实现过程，有助于更好地了解word2vec以及其他预训练模型，如ELMo、BERT、ALBERT等。所以，本文将详细介绍Skip-Gram的实现过程，加深读者对其原理与实现的理解。对于CBOW模型，其实现机制与Skip-Gram模型类似，后续文章将不再赘述。

<!--more-->

### 预处理语料库

```python
text = "natural language processing and machine learning is fun and exciting"
corpus = [[word.lower() for word in text.split()]]
```

这个语料库就是一句话，共10个单词，其中`and`出现两次，共有9个不同单词。因单词较少，这里暂不设置停用词，而是根据空格对语料库进行分词，分词结果如下：

```python
["natural", "language", "processing", "and", "machine","learning", "is", "fun","and", "exciting"]
```

### Skip-Gram模型架构图

使用Skip-Gram模型，设置`window-size=2`，以目标词确定其上下文，即根据目标词预测其左边2个和右边2个单词。具体模型如下图所示：

{% asset_img 1.webp %}

在上图中，这里语料库只有9个单词`V-dim=9`，词嵌入维度为10，即`N-dim=10`，且C=4（该值为`2*window-size`）。如果用矩阵来表示上图，可写成如下图所示的形式：

{% asset_img 2.webp %}

实际嵌入过程中，涉及的单词量较大，本文为便于说明，仅使用一句话作为语料。在一些文章中，又将矩阵$W_{V\times N}$称为查找表（Lookup Table）。

### 生成中心词及其上下文的数据集

根据语料库及`window-size`，生成中心词与预测上下文的数据集，如下图所示：

{% asset_img 3.webp %}

图中共有10对数据，$X_k$对应的词为中心词，其左边或右边的词为上下文。

### 生成训练数据

为便于训练word2vec模型，首先需要把各单词数值化。这里把每个单词转换为独热编码。在前面提到的语料库中，上图显示了10对数据，每个窗口都由中心词及其上下文单词组成。把上图中的每个词转换为独热编码后，可以得到如下图所示的训练数据集：

{% asset_img 4.webp %}

### Skip-Gram模型的正向传播

上述步骤完成了对数据的预处理，接下来开始数据的正向传播，包括输入层到隐藏层、隐藏层到输出层。

从输入层到隐藏层，用图来表示就是输入向量与权重矩阵$W_1$的内积，如下图所示：

{% asset_img 5.webp %}

我们一般将矩阵$W_{9\times 10}$先随机初始化为-1到1之间的数。

从隐藏层到输出层，其实就是求隐含向量与权重矩阵$W_2$的内积，然后使用Softmax激活函数、得到预测值，如下图所示：

{% asset_img 6.webp %}

损失值是预测值与实际值的差，这里以选择数据集#1为例，即中心词为`natural`，然后计算对应该中心词的输出，即预测值，再计算预测值与实际值的差，得到损失值$El$。中心词`natural`的上下文（这里只有下文）为`language`和`processing`，它们对应的独热编码为`w_c=1`，`w_c=2`，具体计算过程如下图所示。

{% asset_img 7.webp %}

### Skip-Gram模型的目标函数

我们使用反向传播函数，根据目标词计算的损失值$EI$，反向更新$W_1$和$W_2$。假设输出值为$u$，即$hW=u$，则预测值为：

$$y_j=\text{Softmax}(u_j)=\frac{e^{u_j}}{\sum_{k=1}^Ve^{u_k}}$$

对于长度为$N$的训练文本且词库词数为$V$，在`window-size`指定为$w$后，第$i$个字符的前后`window-size`个字符组成第$i$个字符的上下文文本$\text{context}(i)$，则目标函数为：

$$\begin{aligned} E&=\argmax_{W, W'}\prod_{i=1}^N\prod_{j=i-w}^{i+w}P(y_j|y_i)\\ &=\argmax_{W, W'}\log\prod_{i=1}^N\prod_{j=i-w}^{i+w}P(y_j|y_i)\\ &=\argmax_{W, W'}\sum_{i=1}^N\sum_{j=i-w}^{i+w}\log P(y_j|y_i)\\ &=\argmax_{W, W'}\sum_{i=1}^N\sum_{j=i-w}^{i+w}\log \frac{e^{u_i}}{\sum_{k=1}^Ve^{u_i}}\\ &=\argmax_{W, W'}\sum_{i=1}^N\sum_{j=i-w}^{i+w}(e^{u_i}-\log \sum_{k=1}^Ve^{u_i}) \end{aligned}$$

目标函数表示最大化已知中心词$y_i$时上下文单词$y_j$的概率，随后再通过深度学习中的反向传播算法优化目标函数即可实现Skip-Gram模型，得到各个单词的词向量。

***

### 原文链接

> <https://machinelearning.blog.csdn.net/article/details/121982045>
