---
title: 基于单通道EEG-SSVEP的BCI的机械臂控制
categories:
  - 🌙进阶学习
  - ⭐脑机接口与混合智能研究团队（BCI团队）
  - 💫学习报告
abbrlink: f4d3d8fc
date: 2021-10-18 15:24:52
tags:
---

本篇学习报告的内容为：基于单通道EEG-SSVEP的BCI的机械臂控制，所参考的文献是《Single-Channel EEG SSVEP-based BCI for Robot Arm Control》,该文献发布时间为2021年。在本文中，实现了一种低成本、单通道、基于 SSVEP 的 BCI 系统来控制机器人手臂的手腕和抓手的运动。本文目的主要是为了识别用户生成控制命令的意图，提出了一种基于 SSVEP 快速傅立叶变换 (FFT) 频谱的突出峰值之间的欧几里德距离测量，以及刺激频率的基波和谐波频谱含量分类的算法。

<!--more-->

***

### 简介

基于 SSVEP 的 BCI 系统中使用的信号处理算法侧重于传统的平均方法、滤波、频谱参数、典型相关分析、深度学习等。算法的复杂程度取决于 EEG 通道的数量和应用。与多通道系统相比，单通道SSVEP 系统具有简单性和计算成本低的优点。此外，单通道系统可确保将用户的不适感降至最低，这在照顾残疾人时是一个关键因素。当结合 SSVEP 频谱的 FFT 特征时，通过为分类任务提供更多信息来区分多个谐波分量是有利的，因为某些对象可能不会显示基本刺激频率分量，而仅显示获得的 SSVEP 频谱中的谐波。本研究中提出的新分类方法通过最小欧几里德距离计算将 SSVEP FFT 频谱的突出峰值位置与刺激频率的基频和谐波频率分量位置进行比较。在本文中，提出了一种基于单通道 EEG 的 SSVEP BCI 系统，用于控制机器人手臂的手腕和抓手。四个闪烁频率的四个 LED 用作刺激以生成四个用户命令，用于上下旋转手腕和收紧-松开抓握功能。该系统可以在没有任何重要用户培训的情况下恢复残疾人的四种基本手部动作。每个刺激频率下的凝视持续时间定义了运动的程度。引入了基于欧几里得距离的 SSVEP 信号频谱方法来识别用户命令。这种分类方法考虑了高达三次谐波的特征。该论文提出了一种低成本的基于 SSVEP 的 BCI，其信号处理的复杂性最小，并提出了一种更简单的分类算法。这单通道系统的最小不适，该算法的简单性和较低的计算能力要求，以及考虑多个谐波的优势，使得所提出的系统便于实际和实时应用。

***

### 实验方法

所实现的 BCI 系统的基本设计和概述包含一个输入：受试者对刺激的 EEG 响应、一种获取 EEG 信号的方法、特征提取和分类算法以将用户意图转换为控制命令，以及机械臂控制作为应用，如图 1 所示。选择一组预定义频率的闪烁 LED 作为本研究的 SSVEP 刺激。系统的主要操作如图 2 所示，如刺激生成、脑电图采集、特征提取、分类、机械臂控制命令生成和机械臂控制。在特征提取下，对采集到的脑电信号进行高通滤波和FFT计算。分类算法基于检测到的 FFT 频谱突出峰值与 LED 闪烁频率的频谱分量之间的欧几里德距离测量。

{% asset_img 1.webp %}
<div align='center'>图 1. 脑机接口系统概述</div>

{% asset_img 2.webp %}
<div align='center'>图2.系统操作流程</div>

***

#### 信号处理

首先进行特征提取，使用 FFT 在 MATLAB 上离线分析所获得信号的光谱参数。截止频率为 2.5 Hz 的 10 阶高通数字巴特沃斯滤波器用于过滤由于伪影和基线漂移而产生的直流和低频分量。

接着进行信号分类，采集数据的分类是在 MATLAB 中对过滤光谱进行的。信号被缓冲到两秒的时间窗口中，每个窗口以两秒的时间间隔进行分类以模拟实时分类。所使用的分类方法基于SSVEP 频谱的突出峰值与刺激的基波和谐波分量之间的欧几里德距离测量。从用一个刺激频率分量得到的最小欧几里得距离，可以识别出相应的刺激基频，如图 5 所示。两点 p、q 之间的欧氏距离 d 定义为：（？？？）

{% asset_img 3.webp %}

要与突出峰值进行比较的刺激频率分量矩阵 F 可以构造如下，包含本研究中所有理论上可能的 SSVEP 频率分量，直到三次谐波：

{% asset_img 4.webp %}

其中 f1= 6.5 Hz、f2= 7.5 Hz、f3= 8.2 Hz 和 f4= 9.3 Hz。

考虑检测到的 SSVEP 光谱的突出峰值位置为 fx。根 据(1)，刺激频率分量与fx之间的欧氏距离矩阵D为：

{% asset_img 5.webp %}
{% asset_img 6.webp %}

从（2）（3）（4）可以得出

{% asset_img 7.webp %}

通过确定矩阵 D 中最小欧几里得距离 d 分钟的指数，可以识 别出最接近突出 SSVEP 频谱分量的刺激频率分量，从而得到相应的刺激频率。

***

#### 机械臂控制

Lynxmotion AL5D – PLTW 机械臂（ RobotShop Inc., Mirabel, QC, Canada），图 5 中的 5-DoF 机械臂用作 BCI 控 制的应用程序。在这项研究中，只实施了手腕和末端执行器（夹具）控制。因此，控制命令仅限于手腕向上和向下旋转以及夹具 的松开和收紧。表 1中给出了机械臂控制命令的刺激频率分配。

{% asset_img 8.webp %}
<div align='center'>图 5  Lynxmotion AL5D – PLTW（5 自由度）机器人手臂</div>

<div align='center'>表1. 机器人控制命令分配给刺激频率</div>
{% asset_img 9.webp %}

机器人手臂由MATLAB命令控制。机器人手臂和计算机之间的通信被中断通过USART（通用同步和异步）完成与SSC-32U的串行通信USB（通用串行总线）伺服控制器。机器人手臂机械手的控制是从每两秒时间间隔获得的分类结果。这些命令是针对已识别的对象逐步执行的每个时间窗口的频率。机器人机械手控制的决策基于分类的结果如图6所示。

{% asset_img 10.webp %}
<div align='center'>图 6. 机器人控制指令执行流程图</div>

***

### 实验结果

当 30 秒 SSVEP 信号进行 FFT 时，观察到刺激频率的基频和谐波频率处的峰值。然而，由于伪影、基线漂移、眨眼、面部肌肉运动等，观察到较大的直流值和明显突出的低频分量。在从截止频率为 2.5 Hz 的 10 阶巴特沃斯滤波器进行高通滤波后，在有用的 SSVEP 频谱分量中观察到显着的突出，如图 7 所示。从所有三个对象的离线数据的分类中获得的结果，缓冲到两秒的时间窗口，作为 30 秒信号长度的平均检测概率在表 2中呈现。检测的平均概率决定了准确的机器人控制命令执行的成功与否。据观察，并非所有受试者对每个刺激频率的表现都相同。总体而言，在两秒的时间窗口内观察到的概率值小于50%。在表3中，呈现了针对每个刺激频率的受试者的SSVEP数据的不同时间窗口长度的平均检测概率之的比较。仅考虑了 2-5 秒的窗口长度，因为运动控制应用需要较短的响应时间才能被视为有效。当时间窗口长度增加时，概率的整体增加是明显的。

{% asset_img 11.webp %}
<div align='center'>图7 对 6.5 Hz 刺激频率从对象 I 获得的响应的滤波和未滤波快速傅立叶变换 – FF频谱以蓝色给出，以及刺激的基频和谐波频率分量（6.5、13、19.5 和26 Hz）被标记并用绿色虚线标记。红色星号标记重合的 SSVEP 峰。</div>

<div align='center'>表2 每个刺激频率的平均检测概率</div>
{% asset_img 12.webp %}

<div align='center'>表3 改变时间窗口长度的影响</div>
{% asset_img 13.webp %}

***

### 参考链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=10633>
> [1] S. -C. Chen, C. -M. Wu, I. A. E. Zaeni and Y. -J. Chen, “Applying fuzzy decision for a single channel SSVEP-based BCI on automatic feeding robot,” Microsyst. Technol., vol. 24, no.1, pp. 199-207, 2018.
> [2] S. -C. Chen, Y. -J. Chen, I. A. E. Zaeni and C. -M. Wu, “A single channel SSVEP based BCI with a fuzzy feature threshold algorithm in a maze game,” Int. J. Fuzzy Syst., vol. 19, no. 2, pp. 553-565, 2017.
> [3] T. Nguyen and W. Chung, “A single-channel SSVEP-based BCI speller using deep learning,” IEEE Access, vol. 7, pp. 1752-1763, 2019.
> [4] X. Duart, E. Quiles, F. Suay, N. Chio, E. García and F. Morant,“Evaluating the effect of stimuli color and frequency on SSVEP,” Sensors, vol. 21, no.1, p. 117, 2021.
