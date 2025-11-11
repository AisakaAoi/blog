---
title: CSIG云上微表情-第46期-ACM MM23 FME workshop-论文分享
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
abbrlink: bce2fbd1
date: 2023-11-30 05:20:17
tags:
---

<iframe src="//player.bilibili.com/player.html?isOutside=true&aid=281552072&bvid=BV1bc411q7JB&cid=1349405397&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>

<!--more-->

微表情是一种短暂的、微弱的、无意识的面部微表情，持续时间往往在0.5s内，能够揭示人类试图隐藏的真实情绪。微表情识别的研究旨在让机器有足够的智能，能够从人脸视频序列中识别人类的真实情绪。然而由于微表情持续时间短、面部肌肉运动强度低，对其进行准确的表征与识别是一项极具挑战性的任务。为了促进心理学领域和计算机视觉领域针对微表情的进一步研究，由中国图象图形学学会（CSIG）和中国科学院心理研究所举办、CSIG机器视觉专业委员会、CSIG情感计算与理解专业委员会和中科院青促会心理所小组联合承办，中国科学院心理研究所的王甦菁博士组织一系列云上微表情的学术活动。
第四十六期云上微表情于2023年11月30日晚上7点进行，由中国科学院心理研究所王甦菁老师团队的李婧婷博士主持。此次讲座的主题为“ACM MM23 FME workshop-论文分享”，邀请到三位研讨会接收论文的第一作者来进行论文分享。


郭存涵：中国科学院大学应急管理科学与工程学院在读博士，导师为黄河燕教授，主要研究方向：计算机视觉，多模态认知。
报告题目：GLEFFN: A Global-Local Event Feature Fusion Network for Micro-Expression Recognition
报告摘要：
微表情是指持续时间短、幅度小的面部动作，分析微表情可以揭示真实的人类情绪。然而，基于帧的相机的低帧率阻碍了微表情识别（MER）的进一步发展。事件相机具有高帧率和低延迟等优秀特性，适合用于MER任务，但目前获取的成本极高。受到事件相机的启发，我们提出了一种局部事件特征，该特征是从上采样得到的视频中计算出来的。针对局部特征，我们还精心设计了局部区域关系提取模块以及全局-局部事件特征融合网络，以更好的进行信息融合与抽取。实验结果表明，我们的方法在多个数据集上取得了优秀的成绩。这项工作是首次从事件角度成功解决MER任务，对于事件相机的未来在微表情领域推广和使用具有一定的探索意义，并为未来相关领域的研究工作提供了灵感。

参考文献： GLEFFN: A Global-Local Event Feature Fusion Network For Micro-Expression Recognition.

Machinery.

许曼璐，天津师范大学计算机与信息工程学院硕士三年级在读，研究方向是计算机视觉，情感计算，图像处理等。主要研究兴趣为微表情分析与识别。
报告题目：Nonlinear Deep Subspace Network for Micro-expression Recognition
报告摘要：
深度学习模型在微表情识别领域得到了广泛的研究。然而，微表情样本数量少，难以提取细微和瞬态的特征，导致识别性能的提高有限。此外，深度学习模型容易出现过拟合问题，且难以从微表情图像或序列中提取面部动作的判别特征。为了解决这些问题，我们提出了一种将非线性深度子空间网络和光流特征相结合的微表情识别方法。首先，面部使用光流计算捕获运动特征，然后将光流特征输入到核主成分分析网络（KPCANet）中，以进一步学习更深层次的时空特征。最后，使用线性支持向量机（SVM）对微表情进行分类。在SMIC、CASME、CASME II和SAMM四个公共自发ME数据集上进行的实验验证了该方法的有效性。实验结果表明，该方法与现有的最先进的微表情识别方法相比，实现了更好的识别性能。

参考文献：
Nonlinear Deep Subspace Network for Micro-expression Recognition

杨行鹏，江苏科技大学计算机学院研究生三年级在读，导师黄树成教授。实习于中国科学院心理研究所微表情应用研究中心，在王甦菁副研究员的指导下开展微表情检测相关研究。

报告题目：Simple but Effective In-the-wild Micro-Expression Spotting Based on Head Pose Segmentation

报告摘要：
微表情往往发生在高风险情况下，目前研究数据集大都在实验室环境下捕获。但是在不受约束的场景中，头部的运动是不可避免的。本研究通过将三维空间中视频中的头部姿态进行估计，建立其与二维矢量（平移变量和旋转变量）之间的映射关系，选取合适的阈值将长视频划分为短视频序列，进而得到头部姿态相对固定的视频序列。本研究方法在MEVIEW数据集中验证了其是简单并且有效的。

参考文献：
Simple but Effective In-the-wild Micro-Expression Spotting Based on Head Pose Segmentation
