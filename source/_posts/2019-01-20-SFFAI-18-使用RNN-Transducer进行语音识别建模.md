---
title: SFFAI 18 | 使用RNN-Transducer进行语音识别建模
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
abbrlink: 4b221ed7
date: 2019-01-20 23:37:34
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=42009946&bvid=BV1yb411C7VX&cid=73752676&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

关注微信公众号：人工智能前沿讲习班，公众号对话框回复“田正坤2”获取PPT。

基于联结时序分类(CTC)的声学模型不再需要对训练的音频序列和文本序列进行强制对齐，实际上已经初步具备了端到端的声学模型建模能力。但是CTC模型进行声学建模存在着两个严重的瓶颈，一是缺乏语言模型建模能力，不能整合语言模型进行联合优化，二是不能建模模型输出之间的依赖关系。RNN-Transducer针对CTC的不足，进行了改进，使得模型具有了端到端联合优化、具有语言建模能力、便于实现Online语音识别等突出的优点。

<!--more-->

***

### 讲者介绍

**田正坤**：中国科学院自动化研究所智能交互团队，直博二年级，目前主要研究兴趣集中在端到端语音识别以及低资源语音识别。

**报告题目**：使用RNN-Transducer进行声学建模

**报告摘要**：基于联结时序分类(CTC)的声学模型不再需要对训练的音频序列和文本序列进行强制对齐，实际上已经初步具备了端到端的声学模型建模能力。但是CTC模型进行声学建模存在着两个严重的瓶颈，一是缺乏语言模型建模能力，不能整合语言模型进行联合优化，二是不能建模模型输出之间的依赖关系。RNN-Transducer针对CTC的不足，进行了改进，使得模型具有了端到端联合优化、具有语言建模能力、便于实现Online语音识别等突出的优点, 更加适合语音任务，值得引起大家的重视。

**Spotlight：**
1. CTC模型与不足；
2. RNN-Transducer模型；
3. RNN-Transducer模型的改进。

***

### 论文推荐

1. Exploring Neural Transducers for End-to-End Speech Recognition

    **推荐理由：**这是百度硅谷实验室的一篇文章，比较了CTC、RNN-Transducer以及Attention模型在原理以及实验性能上的差异，对于想利用端到端模型进行语音识别建模的同学，具有很好的指导意义。 文章显示没有额外语言模型的注意力模型以及RNN-Transducer模型性能都超过了基线CTC模型。同时文章还研究了怎么样选取编码器结构。

2. Exploring Architectures, Data and Units For Streaming End-to-End Speech Recognition with RNN-Transducer

    **推荐理由：**这是Google2018年的一个工作，文章讲述了丰富的细节来帮助我们如何训练好一个RNN-Transducer网络。文章探索了多种模型结构以及如何利用外部数据。文中使用多级CTC来辅助模型训练，获得了很好的效果。

***

### 参考资料

> <https://www.bilibili.com/video/BV1yb411C7VX/>
> <https://bbs.sffai.com/d/48-rnn-transducer>
