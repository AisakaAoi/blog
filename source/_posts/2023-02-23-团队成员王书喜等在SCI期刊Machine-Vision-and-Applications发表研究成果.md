---
title: 团队成员王书喜等在SCI期刊Machine Vision and Applications发表研究成果
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫团队成果
abbrlink: c9a685b0
date: 2023-02-23 21:54:31
tags:
---

近日，团队成员王书喜，黄彬源，刘平治等，在周成菊副研究员和潘家辉教授的共同指导下，在CCF推荐国际学术期刊Machine Vision and Applications上发表学术成果《ICE-GCN: An interactional channel excitation enhanced graph convolutional network for skeleton-based action recognition》（大类学科：计算机科学，小类学科：人工智能，影响因子：2.983）。该论文于2022年10月投稿，2023年2月被录用。

<!--more-->

{% asset_img 1.webp %}
<div align='center'>图1 ICE模块对“踢东西”动作骨架时空序列作用示意图</div>

动作识别在计算机视觉领域引起了越来越多的关注，并在人机交互、视频监控、虚拟现实等方面得到了广泛应用。最近，随着高精度深度传感器以及先进的人体姿态估计算法的出现，可以准确而经济地获得骨架坐标。由于骨架数据对身材、视角和复杂背景变化的鲁棒性，以及在存储和计算成本方面的效率，与其他方式（如传统的RGB视频）相比，骨架数据已成为动作识别任务的主流输入。

但现有的大部分工作都是基于时空图卷积网络框架，这些框架对不同通道下的时空特征的学习和处理都是一视同仁的，忽略了与通道维度的交互作用来探索不同时空模式沿通道方向的不同贡献，从而失去了区分具有细微差别的混淆动作的能力。事实上，通道和时空信息是高度相关的，不同通道中的时空表征表示不同的运动模式。

因此，我们提出了交互式通道激励（interactional channel excitation，ICE）模块，通过跨维度的交互将时空信息嵌入到通道注意力中，通过沿通道维度自适应地重新校准时空感知的注意力图，帮助网络集中于更精细的辨别性时空表征，以区分混乱的动作。更具体地说，ICE 包含 channel-wise spatial excitation ( CSE ) 和 channel-wise temporal excitation ( CTE ) 两个子模块 ，CSE捕捉关键的身体全局结构模式来激励空间敏感的通道，CTE学习时间上的帧间动态信息以激励时间敏感通道。ICE 可以作为一个即插即用的模块增强现有时空骨架动作识别网络性能。此外，我们系统地研究了关节点拓扑图策略，并认为互补的关节点拓扑图对描述复杂动作是必要的。最后，我们提出了一个具有互补拓扑图和交互通道激励的时空图卷积网络（An interactional channel excitation enhanced graph convolutional network for skeleton-based action recognition，ICE-GCN），并在三个大规模的数据集上进行了评估，即 NTU RGB+D 60、NTU RGB+D 120 和 Kinetics-Skeleton。充分的实验结果和可视化验证了我们方法的有效性，并且模型整体性能优于其他SOTAs。

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=13192>
