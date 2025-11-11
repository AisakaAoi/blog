---
title: SFFAI 120 | 文本理解专题《李家琦：Molweni：面向多人对话的机器阅读理解与语篇结构分析数据集》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
abbrlink: 7fafe431
date: 2021-08-29 01:13:16
tags:
---

<iframe src="//player.bilibili.com/player.html?isOutside=true&aid=635960815&bvid=BV1xb4y1n7d9&cid=491569402&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>

<!--more-->

SFFAI论坛已开放注册，详情点击查看：https://bbs.sffai.com/d/312

关注公众号：【人工智能前沿讲习】，回复【SFFAI120】获取讲者PPT资料，入交流群，推荐论文下载。

大多数现有的机器阅读理解 (MRC) 数据集都采用散文段落或历史题作为输入，而为了适应话语解析和会议摘要等多方对话的应用，对话阅读理解这个领域开始受到关注。本期我们邀请到了来自哈尔滨工业大学的李家琦同学，分享他提出的面向多人对话的机器阅读理解与语篇结构分析数据集Molweni。

***

### 讲者介绍

**李家琦：**哈尔滨工业大学计算机专业博士生，研究方向为多人对话语篇结构分析和多人对话机器阅读理解，以第一作者发表CCF推荐国际会议和ESI期刊论文3篇。

**报告题目：**Molweni：面向多人对话的机器阅读理解与语篇结构分析数据集

**报告摘要：**在本文中，我们提出了构建于多人对话的英文机器阅读理解（MRC）数据集——Molweni，并覆盖了对话语篇结构。Molweni源自于Ubuntu聊天语料库，包括10,000个对话，共计88,303条话语（utterance）。我们共标注了30,066个问题，包括可回答和不可回答的问题。Molweni独特地为其多人对话提供了语篇结构信息，共标注了78,245个语篇关系实例，为多人对话语篇结构分析（Discourse parsing）贡献了大规模数据。实验表明，Molweni对于现有的MRC模型是一个具有挑战性的数据集；SQuAD 2.0数据集上的强大模型BERT-wwm在Molweni数据集上只取得67.7%的F1值，相比于其在SQuAD 2.0上的表现有20+%的显著下降。

**论文题目：**Molweni: A Challenge Multiparty Dialogue-based Machine Reading Comprehension Dataset with Discourse Structure

**分享亮点：**
1. 我们发布了首个包含语篇结构信息的大规模多人对话机器阅读理解数据集Molweni；
2. Molweni数据集为多人对话语篇结构分析任务提供了大规模数据标注。

***

### 论文推荐

1. Discourse Structure and Dialogue Acts in Multiparty Dialoguethe STAC Corpus

    **推荐理由：**这篇论文发布了面向于多人对话的语篇结构（discourse structure）与对话行为（dialogue act）数据集STAC，该数据集基于游戏在线交流标注，含有约1000个对话。
 
2. A Deep Sequential Model for Discourse Parsing on Multi-Party Dialogues

    **推荐理由：**这篇论文是STAC数据集上多人对话语篇结构分析的SOTA模型，提出了DeepSequential模型来建模对话，在该任务上首次引入深度神经网络和说话人机制。
 
3. DREAM A Challenge Data Set and Models for Dialogue-Based Reading Comprehension

    **推荐理由：**该论文中发布了数据集DREAM，源自英语听力考试中的两方对话。
 
4. FriendsQA Open-Domain Question Answering on TV Show Transcripts

    **推荐理由：**该论文发布了基于电视剧Friends（老友记）标注的面向于多人对话的开放域问答数据集FriendsQA。
 
5. The Ubuntu Dialogue Corpus A Large Dataset for Research in Unstructured Multi-Turn Dialogue Systems

    **推荐理由：**该论文发布了著名的Ubuntu Dialogue数据集，我们的Molweni数据集在该数据集的基础上进行标注。
 
6. Know What You Don’t Know Unanswerable Questions for SQuAD

    **推荐理由：**该论文发布了著名的SQuAd 2.0数据集，相比于SQuAd数据集引入了不可回答问题。参考了SQuAd 2.0，我们在标注Molweni数据集时也标注了不可回答问题来提升任务难度。

***

### 参考资料

> <https://www.bilibili.com/video/BV1xb4y1n7d9/>
