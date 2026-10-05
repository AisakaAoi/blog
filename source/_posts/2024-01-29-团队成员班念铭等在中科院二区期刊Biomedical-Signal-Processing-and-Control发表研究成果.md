---
title: 团队成员班念铭等在中科院二区期刊Biomedical Signal Processing and Control发表研究成果
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫团队成果
abbrlink: 51cf93ac
date: 2024-01-29 20:14:02
tags:
---

近日，团队成员班念铭等同学在潘家辉教授和曲超老师的指导下，在SCI期刊Biomedical Signal Processing and Control（影响因子：5.1，中科院二区）发表研究论文“Multifunctional robot based on multimodal brain-machine interface”。该论文于2023年4月23日投稿，2024年1月29日录用。

<!--more-->

BMI（brain-machine interface）系统经常用于恢复运动障碍的患者与外界设备交互的能力，但目前的研究依然存在着控制的准确率较低、命令数量不足以及机器功能单一等问题。为了解决这些问题，这项研究提出了一种融合多模态脑机接口的多功能机器人控制系统（图一），将SSVEP、EOG和陀螺仪三种不同模态的信号进行融合来对机器人进行控制。其中SSVEP用于控制机器人进行前进、左转、右转、停止、举起左臂、放下左臂、抓握、寻球抓取一共八个操作，陀螺仪信号来控制左臂肘部关节的运动，EOG信号用于控制SSVEP范式的切换。此外，我们还为机器人增加了机器视觉的功能，使得控制更加智能化。

{% asset_img 1.webp %}
<div align='center'>图1：融合多模态脑机接口的多功能机器人控制系统整体框架</div>

{% asset_img 2.webp %}
<div align='center'>图2：基于注意力机制的CNN-BiLSTM网络框架</div>

在SSVEP分类实验中，我们提出了一种基于注意力机制的CNN-BiLSTM网络（图二）来对SSVEP信号进行分类，并且我们在公开数据集和自采数据集分别与其他六种SSVEP分类方法进行了对比，实验结果表明我们的模型均达到了最高的准确率。  在控制机器人的在线实验中，16受试者均完成了复杂的任务，并且控制的平均准确率为93.78%，平均FPR为2.3event/min，平均RT为2.9s，平均ITR为45.23bit/min。

{% asset_img 3.webp %}
<div align='center'>图3：机器人在线控制实验整体流程</div>

本研究的系统具有较好的性能，并解决了以往研究中的一些不足，具有广阔的应用前景。主要贡献包括（1）提出一种基于多模态脑机接口的控制系统，解决了以往研究中控制命令数量不足的问题。（2）提出一种基于注意力模型的CNN-BiLSTM改进网络，来对SSVEP进行分类，准确率均优于现有网络模型。（3）提出一种融合EOG信号的新型SSVEP范式，以更少刺激块而提供更多指令，从而减轻受试者的视觉疲劳。（4）提出一种融合计算机视觉技术和机器智能的控制策略，使机器人完成更复杂的任务，解决了以往BMI系统中机器人功能简单的问题。

本项目由科技创新2030-“脑科学与类脑研究”重点项目《面向运动和意识障碍康复的双向-闭环脑机接口》（2022ZD0208900）和国家自然基金（62076103）进行资金支持。

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=15106>
