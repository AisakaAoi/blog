---
title: 深入理解深度学习——Item Embedding
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《深入理解深度学习》
abbrlink: e028b4f6
date: 2022-01-31 16:25:57
---

随着Word Embedding在NLP很多领域取得不错的成果，人们开始考虑把这一思想推广到其他领域。从word2vec模型的实现原理可以看出，它主要依赖一条条语句，而每条语句就是一个序列。由此，只要有序列特征的场景应该都适合使用这种Embedding思想。下图表示了不同用户在一定时间内查询物品形成的序列图形，可以看出，物品形成的序列与词形成的序列（语句）有很多相似的地方，因此，人们把Word Embedding这种思想引入物品序列中，推广到推荐、搜索、广告等领域，并学习得到Item Embedding。

{% asset_img 1.webp %}

<!--more-->

### 微软推荐系统的Item Embedding

微软写了一篇实用性很强的关于将word2vec应用于推荐领域的论文。该论文中的方法简单易用，可以说极大拓展了word2vec的应用范围，使其从NLP领域直接扩展到推荐、广告、搜索排序等任何可以生成序列的领域。

Embedding是一种很好的思想，它不局限于自然语言处理领域，还可以应用到其他很多领域。微软研究人员把这种思想应用到推荐系统中，并将其研究成果发表在论文《Item2Vec：Neural Item Embedding for Collaborative Filtering》中。论文中，他们主要参照了把Word Embedding应用到推荐场景的相似度计算中的方法，把item视为word，把用户的行为序列视为一个集合。通过把word2vec的Skip-Gram和Negative Sampling（SGNS）的算法思路迁移到基于物品的协同过滤（Item-Based CF）上，以物品的共现性作为自然语言中的上下文关系，构建神经网络并学习出物品在隐空间的向量表示，让使用效果得到较大提升。

### Airbnb推荐系统使用Item Embedding

作为全世界最大的短租网站，Airbnb的主要业务是在房主挂出的短租房和以旅游为主要目的的租客之间构建一个中介平台，以更好地为房主和租客服务。这个中介平台的交互方式比较简单，即客户输入地点、价位、关键词等，Airbnb给出租房的搜索推荐列表。所以，借助这个推荐列表提升客户订购率显得非常关键。

Airbnb发表的论文《Real-time Personalization using Embeddings for Search Ranking at Airbnb》提到了具体解决思路。论文中提出了两种通过Embedding分别捕获用户的短期兴趣和长期兴趣的方法，即利用用户点击会话和预定会话序列，如下图所示：

{% asset_img 2.webp %}

如上图所示，这里浏览点击的房源之间存在强时序关系，即前面房源会对后面房源产生很大的影响，可以把一段时间内连续发生的房源序列看作句子，把序列中的房源看作句子中的词，这样的结构看上去与word2vec的训练数据的构造并没什么区别，因此可以直接按照word2vec的方法（这里采用Skip-Gram模型）进行Embedding训练。

训练生成Listing Embedding和User-type&Listing-type Embedding，并将Embedding特征输入搜索场景下的rank模型，以提升模型效果。Airbnb将业务模式与Embedding相结合的实践案例可以说是应用word2vec思想于公司业务的典范。具体来说，它通过客户点击或预定方式生成租客类型、房租类型等的Embedding，来获取用户对短期租赁和长期租赁的兴趣。

***

### 原文链接

> <https://machinelearning.blog.csdn.net/article/details/122136467>
