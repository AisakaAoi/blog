---
title: >-
  论文阅读-BERT论文逐段精读-《BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding》
categories:
  - 🌙进阶学习
  - ⭐论文带读
  - 💫精读经典
abbrlink: 5f1c011a
date: 2022-01-21 02:46:11
tags:
---

### 原文

{% pdf ./file/paper/2018-BERT-Pre-training-of-Deep-Bidirectional-Transformers-for-Language-Understanding.pdf %}

**BERT** 论文链接：<https://aclanthology.org/N19-1423.pdf>

BERT: 近 3 年 NLP 最火

CV: 大数据集上的训练好的 NN 模型，提升 CV 任务的性能 —— ImageNet 的 CNN 模型

NLP: BERT 简化了 NLP 任务的训练，提升了 NLP 任务的性能

BERT 如何站在巨人的肩膀上的？使用了哪些 NLP 已有的技术和思想？哪些是 BERT 的创新？

<!--more-->

***

### 标题 + 作者

**BERT**: Pre-training of Deep Bidirectional Transformers for Language Understanding

pre-training: 在一个大的数据集上训练好一个模型 pre-training，模型的主要任务是用在其它任务 training 上。

deep bidirectional transformers: 深的双向 transformers

language understanding: 更广义，transformer 主要用在机器翻译 MT

BERT: 用深的、双向的、transformer 来做预训练，用来做语言理解的任务。

作者：Google AI Language，写作时间短（几个月）

***

### 摘要

新的语言表征模型 BERT: **B**idirectional **E**ncoder **R**epresentations from **T**ransformers，基于 ELMo
Transformers 模型的双向编码表示

与 ELMo 和 GPT 不同，BERT 从无标注的文本中（jointly conditioning 联合左右的上下文信息）预训练得到 无标注文本的 deep bidirectional representations

pre-trained BERT 可以通过加一个输出层来 fine-tune，在很多任务（问答、推理）有 SOTA 效果，而不需要对特定任务的做架构上的修改。

GPT unidirectional，使用左边的上下文信息 预测未来
BERT bidirectional，使用左右侧的上下文信息

ELMo based on RNNs, down-stream 任务需要调整一点点架构
BERT based on Transformers, down-stream 任务只需要调整最上层。
GPT, down-stream 任务 只需要改最上层。

摘要第一段：和哪两篇工作相关，区别是什么？
BERT 是在 GPT 和 ELMo 的基础上的改动。

**摘要第二段：BERT 的好处**
simple and empirically powerful, 11 NLP 任务的SOTA, 绝对精度 + 相对精度（比别人好多少）

摘要写法：
第一段：我和另外 2 篇相关工作的区别，改进在哪里？
第二段：我的结果特别好，好在什么地方？

Note: BERT 论文写作好 --> 经典 
工作质量：创新性、效果好 -->  经典

***

### 导言

导言第一段：本篇论文关注的研究方向的一些上下文关系
Language model pre-training 可以提升 NLP 任务的性能 
NLP任务分两类：sentence-level tasks 句子情绪识别、两个句子的关系； token-level tasks NER (人名、街道名) 需要 fine-grained output

NLP 预训练很早之前存在，BERT 使 NLP 预训练 出圈了。

导言第二段：摘要第一段的扩充

pre-trained language representations 两类策略：
**基于特征的 ELMo** (构建和每一个下游任务相关的 NN 架构；训练好的特征（作为额外的特征） 和 输入 一起放进模型)

**基于微调参数的 GPT**
所有的权重参数根据新的数据集进行微调。

介绍别人工作的目的：铺垫自己方法的好

ELMo 和 GPT 预训练时 使用 unidirectional langugage model，使用相同的目标函数
语言模型是单向的、预测未来。不是给第 一句、第三句，预测第二句

导言第三段：
当前技术的局限性：标准语言模型是 unidirectional 单向的，限制了模型架构的选择。

GPT 从左到右的架构，只能将输入的一个句子从左看到右。句子情感分类任务：从左看到右、从右看到左 都应该是合法的。

token-level tasks：问答 qa 看完整个句子选答案，不是从左往右一步一步看。

如果能 incorporate context from both directions 看两方向的信息，能提升 任务性能。

相关工作的局限性，+ 解决局限性的想法 -- > 导言第四段： 如何解决？

BERT 通过 MLM 带掩码的语言模型 作为预训练的目标，来减轻 语言模型的单向约束。inspired by the Close task 1953 

MLM 带掩码的语言模型做什么呢？
每次随机选输入的词源 tokens, 然后 mask 它们，目标函数是预测被 masked 的词；类似挖空填词、完形填空。

MLM 和 standard language model （只看左边的信息）有什么区别？
MLM 可以看 左右的上下文信息, pre-train deep bidirectional transformer 的基础。

BERT 除了 MLM 还有什么？ 
NSP: next sentence prediction 
判断两个句子是随机采样的 or 原文相邻，学习 sentence-level 的信息。

**文章 3点 贡献：**
1.  bidirectional 双向信息的重要性
GPT 只用了 unidirectional 信息；另外 Peter 2018 把从左看到右 和 从右看到左的模型独立训练 + shallow concatenation 拼在一起；BERT 在 bidirectional pre-training 的应用更好

2. BERT 首个 微调模型，在 sentence-level and token-level task效果好
好的预训练模型，不用对特定任务做一些模型架构的改动

3. BERT 开源，随便用。

***

### 结论

近期实验表明，非监督的预训练模型很好，low-resource 任务也能享受 benefit from 深的神经网络。
本文贡献：拓展前任的结果到 deep bidirectional architectures，使同样的预训练模型能够处理大量的 NLP 任务

**本文故事：**

2个相关工作：ELMo 用了 bidirectional 信息，但架构 RNN 老；GPT 架构 Transformer 新，但只用了 unidirectional 信息。

BERT = ELMo 的 bidirectional 信息 + GPT 的新架构 transformer

How?
Language model 任务：不是预测未来，而是完形填空。

写作：两个算法的结合，主要工作 -- 证明 双向有用

A + B 缝合工作 or C 技术解决 D 领域的问题，不要觉得想法小、不值得写出来；简单朴实的写出来。简单好用 说不定会出圈

***

### 相关工作

2.1 Unsupervised Feature-based approaches
非监督的基于特征表示的工作：词嵌入、ELMo等

2.2 Unsupervised Fine-tuning approaches
非监督的基于微调的工作：GPT等

2.3 Transfer Learning from Supervised Data
在有标号的数据上做迁移学习。

NLP 有标号 的大数据集：natural language inference and machine translation

CV做的还不错，ImageNet 训练好、再做迁移。

NLP 表现不那么好：CV 和 NLP 任务的区别，NLP 数据的不足。

**BERT 的作用：**
NLP 中，在无标号的大量数据集上训练的模型效果 > 有标号、但数据量少一些的数据集上训练效果

CV 采用 BERT 的想法嘛？
Yes，在大量无标号的图片上训练的模型，可能比 有标号的 ImageNet 百万图片 效果更好。

***

### BERT 模型

BERT 有哪两步？预训练 + 微调
pre-training: 使用 unlabeled data 训练 
fine-tuning: 微调的 BERT 使用 预训练的参数 初始化，所有的权重参数通过 下游任务的 labeled data 进行微调。
每一个下游任务会创建一个 新的 BERT 模型，（由预训练参数初始化），但每一个下游任务会根据自己任务的 labeled data 来微调自己的 BERT 模型。

预训练和微调不是 BERT 的创新，CV里用的比较多。

**作者关于预训练和微调的介绍 好吗？**
好！如果假设读者都知道论文的技术，而只一笔带过（给Ref），不太好。论文写作要自洽，简单的说明就好，避免读者不知道预训练和微调，增加理解文章的障碍。

{% asset_img 1.webp %}

预训练的输入：unlabelled sentence pair
训练 BERT 的权重

下游任务：创建同样的 BERT 的模型，权重的初始化值来自于 预训练好 的权重。
MNLI, NER, SQuAD 下游任务有 自己的 labeled data, 对 BERT 继续训练，得到各个下游任务自己的的 BERT 版本。

**Model Architecture**

multi-layer bidirectional Transformer encoder 
一个多层双向 Transformer 的解码器，基于 transfomer 的论文和代码。

写作：第三章这里不讲可以；在第二章相关工作做一定的介绍, i.e., L H

模型调了哪 3 个参数?
L: transform blocks的个数
H: hidden size 隐藏层大小
A: 自注意力机制 multi-head 中 head 头的个数

调了 BERT_BASE （1亿参数）和 BERT_LARGE （3.4亿参数）

Large 模型 层数 L 翻倍 12 -- 24；宽度 H 768 -- 1024
BERT 模型复杂度和层数 L 是 linear, 和宽度 H 是 平方关系。
因为 深度 变成了 以前的两倍，在宽度上面也选择一个值，使得这个增加的平方大概是之前的两倍。

H = 16，因为每个 head 的维度都固定在了64。因为你的宽度增加了，所以 head 数也增加了。

BERT_base 的参数选取 和 GPT 差不多，比较模型；BERT_large 刷榜。

**超参数换算成可学习参数的大小，transformer架构的回顾**

可学习参数的来源：嵌入层 30k * H、transformer块 L * H^2 * 12

嵌入层： 输入是词的字典大小 30k，输出是 H
参数：30k （字典大小） * H （hidden size）

嵌入层的输出会进入 transformer 块。

transformer blocks（H^2 * 12）: self-attention mechanism （H^2 * 4）+ MLP（H^2 * 8）

self-attention mechanism 本身无可学习参数; multi-head self-attention mechanism 要对 q, k, v 做投影，每一次投影维度=64 --> A * 64 = H。
每一个 q, k, v 都有自己的投影矩阵，合并每个 head 的投影矩阵 --> q, k, v 分别的 H * H 矩阵。

得到输出后还会有一次 H * H 的投影。

Transformer block 里的 self-attention 可学习参数 = H^ 2 * 4

MLP 的 2个全连接层：
第一个全连接层输入是 H，输出是 4 * H；
第二个全连接层输入是 4 * H，输出是 H。

每一个参数矩阵大小 H * 4H，MLP 中的可学习参数 H^2 * 8

一个 transformer block 的参数量 H^2 * 12，L 个 blocks，L * H^2 * 12

**Input/Output Representations**

下游任务有处理一个句子 or 处理 2 个句子，BERT 能处理不同句子数量的下游任务，使输入可以是 a single sentence and a pair of sentences (Question answer)

a single sentence: 一段连续的文字，不一定是真正上的语义上的一段句子，它是我的输入叫做一个序列 sequence。

A "sequence" 序列可以是一个句子，也可以是两个句子。

BERT 的输入和 transformer 区别？
transformer 预训练时候的输入是一个序列对。编码器和解码器分别会输入一个序列。
BERT 只有一个编码器，为了使 BERT 能处理两个句子的情况，需要把两个句子并成一个序列。

**BERT 如何切词？**

WordPiece, 把一个出现概率低的词切开，只保留一个词出现频率高的子序列，30k token 经常出现的词（子序列）的字典。
否则，空格切词 --> 一个词是一个 token。数据量打的时候，词典会特别大，到百万级别。可学习的参数基本都在嵌入层了。

BERT 的输入序列如何构成？ [ CLS ]  +  [ SEP ]

序列开始: [ CLS ] 输出的是句子层面的信息 sequence representation
BERT 使用的是 transformer 的 encoder，self-attention layer 会看输入的每个词和其它所有词的关系。
就算 [ CLS ] 这个词放在我的第一个的位置，他也是有办法能看到之后所有的词。所以他放在第一个是没关系的，不一定要放在最后。

区分 两个合在一起的句子 的方法：
- 每个句子后 + [ SEP ] 表示 seperate
- 学一个嵌入层 来表示 整个句子是第一句还是第二句

[ CLS ] [Token1] …… [Token n] [SEP] [Token1'] …… [Token m]

每一个 token 进入 BERT 得到 这个 token 的embedding 表示。
对于 BERT，输入一个序列，输出一个序列。

最后一个 transformer 块的输出，表示 这个词源 token 的 BERT 的表示。在后面再添加额外的输出层，来得到想要的结果。

{% asset_img 2.webp %}

For a given token, 进入 BERT 的表示 = token 本身的表示 + segment 句子的表示 + position embedding 位置表示

BERT 嵌入层：一个词源的序列 --> 一个向量的序列 --> 进入 transformer 块

Token embeddings:  词源的embedding层，整成的embedding层， 每一个 token 有对应的词向量。
Segement embeddings: 这个 token 属于第一句话 A还是第二句话 B。
Position embeddings: 输入的大小 = 这个序列最长有多长？ i.e., 1024 
Position embedding 的输入是 token 词源在这个序列 sequence 中的位置信息。从0开始 1 2 3 4 --> 1024

{% asset_img 3.webp %}

BERT input representation = token embeddings + segment embeddings + position embeddings 

BERT 的 segment embedding （属于哪个句子）和 position embedding （位置在哪里）是学习得来的，transformer 的 position embedding 是给定的。

BERT 关于 pre-train 和 fine-tune 同样的部分 == end

**3.1 Pre-training BERT**

预训练的 key factors: 目标函数，预训练的数据

**Task 1 MLM**
为什么 bidirectional 好？ MLM 是什么？完形填空

由 WordPiece 生成的词源序列中的词源，它有 15% 的概率会随机替换成一个掩码。但是对于特殊的词源不做替换，i.e., 第一个词源 [ CLS ] 和中间的分割词源 [SEP]。

如果输入序列长度是 1000 的话，要预测 150 个词。

MLM 带来的问题：**预训练和微调看到的数据不一样**。预训练的输入序列有 15% [MASK]，微调时的数据没有 [MASK].

15% 计划被 masked 的词: 80% 的概率被替换为 [MASK], 10% 换成 random token,10% 不改变原 token。但 T_i 还是被用来做预测。

80%, 10%, 10% 的选择，有 ablation study in appendix

unchanged 和 微调中的数据应该是一样的。

**Task 2 NSP Next Sentence Prediction**

在问答和自然语言推理里都是**句子对**。
如果 BERT 能学习到 sentence-level 信息，很棒。

输入序列有 2 个句子 A 和 B，50% 正例，50%反例
50% B 在 A 之后，50% 是 a random sentence 随机采样的。

正例：这个人要去一个商店，然后他买了一加仑的牛奶。IsNext
反例：这个人去了商店，然后企鹅是一种不能飞的鸟。NotNext

flight ## less, flightless 出现概率不高，WordPiece 分成了 2 个出现频率高的子序列，## 表示 less 是 flightless 的一部分。

**Pre-training data**

2 个数据集：BooksCorpus (800 M) + English Wikipedia (2500 M)
使用一篇一篇文章，而不是随机打断的句子。 a document-level corpus rather than a shuffled sentence-level corpus

transformer 可以处理较长的序列，一整个文本的输入，效果会好一些。

**3.2 Fine-tuning BERT**

用 BERT 做微调的一般化的介绍。

BERT 和一些基于encoder-decoder的架构为什么不一样？transformer 是encoder-decoder。

整个句子对被放在一起输入 BERT，self-attention 能够在两个句子之间相互看。BERT 更好，但代价是 不能像 transformer 做机器翻译。

在encoder-decoder的架构，编码器看不到解码器的东西。

**BERT 做 下游任务**

根据下游任务，设计我们任务相关的输入和输出。

好处：模型不怎么变，加一个输出层 softmax 得到 标号 label

**怎么样把输入改成想要的句子对？**
- 有两个句子的话，当然就是句子 A 和 B。
- 只有一个句子的话，要做句子分类的话， B 没有。根据下游任务的要求，要么是 [CLS] representation is fed into an output layer for classification 拿到第一个词源 [CLS] 对应的输出做分类 such as entailment or sentiment analysis，或者是 the token representations are fed into an output layer for token-level tasks 拿到对应那些词源的输出做 sequence tagging or question answering 输出。

微调比预训练便宜。TPU 1 hour, GPU a few hours.

**Section 4 具体对每一个下游任务是怎么样构造输入输出**

***

### 实验

**4.1 GLUE General Language Understanding Evaluation**
- 多个数据集
- sentence-level tasks

[CLS] 的 BERT 输出表示 + 一个输出层 W，softmax 分类得到 label
log(softmax(CW^T)

**4.2 SQuAD v1.1**
Standford Question Answering Dataset

QA 问答：给一段文字，问一个问题，摘录答案。--> 判断答案的开始和结尾。
对每个词源 token，判断是不是答案的开始or结尾

学 2 个向量 S 和 E，分别对应这个词源 token 是答案开始词的概率 和 是答案结尾词的概率。

具体计算 每个 token 是答案开始的概率，结尾词类似 E。
S 和 第二句话的每个词源 token 相乘 + softmax，得到归一化的概率。
P_i = e ^ ( S * T_i ) / \sigma_j ( e ^ ( S * T_j ) )

本文微调时，数据扫三遍，epochs = 3, lr = 5e-5, batch_size = 32

大家实验发现：用 BERT 做微调的时候，结果非常不稳定。同样的参数，同样的数据集，训练 10 遍，variance 方差特别大。

其实很简单，epochs 不够，3 太小了，可能要多学习几遍会好一点。

adam 的不完全版 在长时间训练的 BERT 没问题，训练时间不够，需要 adam 的完全版。

**4.3 SQuAD v2.0  表现也很不错**

**4.4 SWAG**

Situations With Adversarial Generations 判断两个句子之间的关系，BERT 和之前的训练没多大区别，效果好。

总结：BERT 在不一样的数据集上，用起来很方便，效果很好。
输入表示成“一对句子的形式”，最后拿到 BERT 对应的输出，然后加一个输出层 softmax，完事了。

BERT 对 NLP 整个领域的贡献非常大，有大量的任务用一个相对简单、只改数据输入形式和最后加一个输出层，就可以效果很不错。

**5 Ablation studies**

看 BERT 每一个组成部分的贡献。

没有 NSP
LTR 从左看到右（无 MLM ） & 没有 NSP
LTR 从左看到右（无 MLM ） & 没有 NSP + BiLSTM （从ELMo来的想法）

去掉任何一个组成部分，BERT的效果都会有打折，特别是 MRPC。

**5.2 Effect of Model Size**

BERT_base 110 M 可学习参数
BERT_large 340 M 可学习参数

NLP界认为 模型越大，效果越好。BERT 首先证明了大力出奇迹，引发了模型“大”战

现在：GPT-3 1000 亿可学习参数

**5.3 Feature-based Approach with BERT**

没有微调的 BERT，将pre-trained 得到的 BERT 特征作为一个静态的特征输入，效果没有 + 微调好

卖点：用 BERT 需要微调。

***

### 评论

写作：
- 先写 BERT 和 ELMo (bidirectional + RNN)、GPT (unidirectional + transformer) 的区别
- 介绍 BERT 模型
- BERT 实验设置、效果好
- 结论突出 'bidirectional' 贡献
- 文章 1个卖点，容易记。

**但 BERT 是否要选择  'bidirectional'  双向性呢？**
可以写，但也要写 双向性带来的不足是什么？

选择有得有失。
GPT 用的是 decoder
BERT 用的是 encoder，不好做generative tasks：机器翻译、文本摘要。

分类问题在 NLP 更常见。
NLP 研究者喜欢 BERT，较容易的应用在 NLP 中自己想解决的问题。

BERT，完整的解决问题的思路 ---- 大家对 DL 的期望
训练一个很深、很宽的模型，在一个很大的数据集上预训练好；训练好的模型参数可以解决很多小的问题，通过微调提升小数据集上的性能。

这个模型拿出来之后可以用在很多小的问题上，能够通过微调来全面提升这些小数据上的性能。这个在计算机视觉里面我们用了很多年了。

BERT 把 CV 的套路搬到了 NLP，1个3亿参数的模型，展示：模型越大、效果越好。大力出奇迹。

为什么 BERT 被记住？
BERT 用了 ELMo, GPT 更大的训练数据集，效果更好；BERE 也被更大的训练数据集和更大的模型超越。
BERT 的引用率是 GPT 的 10 倍，影响力 ✔
