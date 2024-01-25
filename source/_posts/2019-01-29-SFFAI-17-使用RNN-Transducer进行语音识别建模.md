---
title: SFFAI 17 | 使用RNN-Transducer进行语音识别建模
categories:
  - 🌙进阶学习
  - ⭐讲座
abbrlink: 4b221ed7
date: 2019-01-29 23:37:34
tags:
---

<iframe src="//player.bilibili.com/player.html?aid=42009946&bvid=BV1yb411C7VX&cid=73752676&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

关注微信公众号：人工智能前沿讲习班，公众号对话框回复“田正坤2”获取PPT。

基于联结时序分类(CTC)的声学模型不再需要对训练的音频序列和文本序列进行强制对齐，实际上已经初步具备了端到端的声学模型建模能力。但是CTC模型进行声学建模存在着两个严重的瓶颈，一是缺乏语言模型建模能力，不能整合语言模型进行联合优化，二是不能建模模型输出之间的依赖关系。RNN-Transducer针对CTC的不足，进行了改进，使得模型具有了端到端联合优化、具有语言建模能力、便于实现Online语音识别等突出的优点。

<!--more-->

***

### 参考资料

> <https://www.bilibili.com/video/BV1yb411C7VX/>
