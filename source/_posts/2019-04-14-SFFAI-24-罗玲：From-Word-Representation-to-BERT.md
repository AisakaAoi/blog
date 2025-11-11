---
title: SFFAI 24 | 罗玲：From Word Representation to BERT
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
abbrlink: 72d40aef
date: 2019-04-14 00:15:57
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=50772422&bvid=BV1Z4411b7dc&cid=88876278&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

本次分享主要是通过简要介绍预训练词向量研究历程(word2vec，glove，ELMo等)，重点介绍BERT的主要贡献。作为刷新GLUE榜单11项NLP任务（句子关系判断，分类任务，序列标注任务等）成绩的预训练模型，BERT不仅沿袭将词向量和下游任务结合在一起实现上下文相关的优点，并且通过masked语言模型实现了真正的深度双向模型。这使得BERT不仅能更好的处理sentence-level的任务

<!--more-->

***

### 讲者介绍

**罗玲：**2018年获南开大学工学学士学位，专业计算机科学与技术，现保送至中国科学院计算科学技术研究所智能信息处理实验室，研究兴趣为自然语言处理、语义分析，意⻅挖掘，文本摘要等。2018年在IJCAI会议一作发表论文1篇，大四于计算所实习期间参与债券舆情分析与金融风险感知等多个项目，并于2018年暑期入选腾讯犀牛鸟精英人才计划，赴腾讯AI Lab交流合作。

**报告题目：**From Word Representation to BERT

**报告摘要：**本次分享主要是通过简要介绍预训练词向量研究历程(word2vec，glove，ELMo等)，重点介绍BERT的主要贡献。作为刷新GLUE榜单11项NLP任务（句子关系判断，分类任务，序列标注任务等）成绩的预训练模型，BERT不仅沿袭将词向量和下游任务结合在一起实现上下文相关的优点，并且通过masked语言模型实现了真正的深度双向模型。这使得BERT不仅能更好的处理sentence-level的任务，在token-level的语言任务上也达到了不错的效果。本次分享还将简要介绍BERT的相关应用以及一些近期的相关工作，探讨BERT对NLP任务的影响和未来发展。

**Spotlight：**
1. 分享预训练词向量研究历程；
2. 介绍BERT的背景知识，模型思路和重大贡献以及相关应用；
3. 介绍近期相关工作，谈谈未来发展和感想。

***

### 论文推荐

1. deep contextualized word representations

    **推荐理由：**一般来说，词向量在NLP的任务中需要解决两个问题：（1）词使用的复杂特性，如句法和语法；（2）如何在具体的语境下使用词，比如多义词的问题（在“我买了一个苹果手机”和“我买了5斤苹果”中的“苹果”的embedding应该是不同的）。该论文提出了ELMo模型，以基于多层双向LSTM语言模型为基础，用各层之间的线性组合来动态表示词向量，这样来解决多义词问题。ELMo训练即是通过计算前向和后向的语言模型的对数似然函数来优化模型。ELMo的使用即是将通过ELMo得到的所有词向量的线性组合运用到下游任务中。本文在Question answering、Textual entailment、Semantic role labeling、Coreference resolution、Named entity extraction、Sentiment analysis六个方向都做了实验，得到了很不错的提升。此外训练效率很高，使用ELMO词向量可以少98%epoch就能训练好，对于数据量越少的情况，使用ELMo效果好的越多。在BERT出现之前ELMo模型也算是小火了一把，读懂ELMo，以及对比各个主流模型的优缺点，会更能理解词向量和语义间的关系。

2. BERT Pre-training of Deep Bidirectional Transformers for Language Understanding

    **推荐理由：**作为截止2018年10月刷新了GLUE榜单上11项NLP任务的预训练模型，BERT可谓是在自然语言处理研究带来了一股浪潮。BERT使用了masked语言模型，实现了真正深度双向模型，不仅能更好地处理sentence-level的自然语言任务，而且在token-level的任务上也达到了不错的效果。BERT的预训练思想与结构，都值进一步的关注和探讨。
 
3. Linguistically-Informed Self-Attention for Semantic Role Labeling

    **推荐理由：**Transformer提出之后，多头注意力机制现在广泛的运用在了各个NLP的任务上。本文就是基于多头注意力机制等，在语义角色标签任务上得到提升，获得了EMNLP 2018的最佳长篇论文。目前最先进的语义角色标签使用的是没有外部语言特征的深度神经网。但此前的研究表明黄金语法树可以极大地提高语义角色标签的解码。这篇文章提出了一种神经网络模型，名为linguistically-informed self-attention，它结合了多头注意力和多任务学习，能够预测检测结果和语义角色标签。这篇论文有很多亮点：一个共同训练句法和语义任务的转换器；在测试时注入高质量解析的能力；和范围外评估。同时还通过训练一个注意力头来关注每个token的句法父项，使Transformer的多头注意力对句法更加敏感。

4. A robust self-learning method for fully unsupervised cross-lingual mappings of word embeddings

    **推荐理由：**在面对在迁移学习中，源和目标设置之间的差异(例如，领域适应、持续学习和多任务学习中的任务)的时候，稳健的无监督方法是很有必要的。而对于跨语种嵌入映射任务的核心思想：分别训练单个语种语料，再通过线性变换映射到shared space，该文章研究的无监督方法self-learning。但self-learning初始化不好时，易陷入差的局部最优。本文通过观察到不同语种中相同的词有相似的相似度分布，于是提出了一种更有鲁棒性的初始化的方法。所以，利用领域专业知识和分析见解可以使模型更加稳健，这也是做NLP task的一种启发。

5. Meta-Learning for Low-Resource Neural Machine Translation

    **推荐理由：**元学习在少样本学习、强化学习和机器人学习中得到了广泛的应用，最突出的例子是与模型无关的元学习。在解决样本数量有限的问题上，元学习非常有用。对机器翻译领域来说，特别是一些小语种，可能收集的数据样本比较少，那么这个时候我们又希望这个翻译系统也能达到不错的效果，那就只能在小样本上面处理了。该论文（1）构造一个translation task generator用来生成不同的翻译task用于meta-train和meta-test，这就是一般Few-Shot Learning的构造；（2）将采集的task用于MetaNMT的训练，使用MAML训，目的就是为了得到一个好的初始化参数用于Meta-Test的task实现Fast Adaptation；（3）使用了一个Universal Lexical Representation 来表征不同的语种的特征，从而得到合适的embedding用于MetaNMT的训练。这篇paper是第一篇使用Meta Learning在Few-Shot NLP问题上的paper，相信Meta Learning未来还能更好地运用到更多NLP的任务中。

***

### 参考资料

> <https://www.bilibili.com/video/BV1Z4411b7dc/>
> <https://bbs.sffai.com/d/61-bert-nlp>
