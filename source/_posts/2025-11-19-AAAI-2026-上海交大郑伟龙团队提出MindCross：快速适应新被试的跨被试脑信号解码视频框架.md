---
title: AAAI 2026 | 上海交大郑伟龙团队提出MindCross：快速适应新被试的跨被试脑信号解码视频框架
categories:
  - 🌙进阶学习
  - ⭐脑机接口与混合智能研究团队（BCI团队）
  - 💫学习报告
abbrlink: e15a525c
date: 2025-11-19 11:37:21
tags:
---

{% asset_img 1.webp %}

{% asset_img 2.webp %}
<div align='center'>图1. 跨被试脑解码示意图</div>

近年来脑机接口(BCI)技术飞速发展，从脑信号解码视频成为了其中一个热点问题。近期，上海交通大学郑伟龙团队提出了一种基于共享-特定结构的快速适应新被试的跨被试脑信号解码视频框架MindCross, 相关成果发表于人工智能顶级会议（CCF-A类**AAAI 2026**上，标题为“**MindCross: Fast New Subject Adaptation with Limited Data for Cross-subject Video Reconstruction from Brain Signals**”。如图1所示，现有的脑解码框架主要基于被试依赖范式，需要采集每个受试者大量的脑数据，导致难以快速适应一个数据较少的新被试，毕竟脑视频数据的采集成本高昂，而MindCross为所有被试训练一个通用模型，该模型能够快速适应数据有限的新被试。

<!--more-->

{% asset_img 3.webp %}
<div align='center'>图2.MindCross框架：包括训练、校准和测试三个阶段</div>

如图2所示， MindCross包含三个阶段：训练、校准和测试。在训练阶段，使用所有N个被试的数据训练N个特定编码器和一个共享编码器。如果出现数据有限的新受试者，则在校准阶段训练一个新的特定编码器，同时MindCross中的其他模块则保持冻结状态。也就是说，校准阶段只更新新的特定编码器和重构器，从而大大加速了适应新被试的调试速度。在测试阶段，新受试者的最终输出由其自身的特定编码器和一个Top-K协作模块获得。

从表1可以看出MindCross方法在语义层面上仅使用一个模型，即可达到与基于每个被试每个模型的方法相当的性能，并且略优于其余跨被试解码方法。表2更是说明了在适应数据较少的新被试时，MindCross显著减少了适应时间和更新参数（尤其是在受试者数量较大时），同时优于或与基线持平，证明了 MindCross 在新受试者适应方面的优越性。图3和图4展示了一些定性结果的比较。

<div align='center'>表1.MindCross与其他方法在脑解码方面的定量比较。</div>
{% asset_img 4.webp %}

{% asset_img 5.webp %}
<div align='center'>图3.EEG-to-video定性的重建结果比较</div>

{% asset_img 6.webp %}
<div align='center'>图4.fMRI-to-video定性的重建结果比较</div>

<div align='center'>表2.新被试适应比较，用时和更新参数量。</div>
{% asset_img 7.webp %}

MindCross旨在从原始脑信号中分离出与受试者相关的成分和受试者不变的成分。图5左边展示了这19名受试者的原始脑数据，他们的脑数据彼此之间存在显著差异。经过 MindCross 处理后，受试者相关成分和受试者不变成分被成功提取，如图5右边所示。

{% asset_img 8.webp %}
<div align='center'>图5.学习特征可视化</div>

这项研究由郑伟龙老师指导，博士生刘轩豪担任论文第一作者，刘彦楷，周天逸，和吕宝粮等老师和同学也为论文工作做出了重要贡献。

***

### 原文链接

> <https://mp.weixin.qq.com/s/7tAs-hZWZayRz6LXKrTa-A>
