---
title: 'SFFAI 125 | 点云补全专题《张俊哲：ShapeInversion: 基于GAN逆映射的无监督点云补全方法》'
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
  - 💫SFFAI
abbrlink: a65fdaab
date: 2021-10-25 02:03:06
tags:
---

<iframe src="//player.bilibili.com/player.html?isOutside=true&aid=211505935&bvid=BV1ca41117xd&cid=508467887&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>

<!--more-->

SFFAI论坛网站已开放注册，详情点击查看：https://bbs.sffai.com/d/312

关注公众号：【人工智能前沿讲习】，回复【SFFAI125】获取讲者PPT资料，入交流群，推荐论文下载。

点云补全是众多3D视觉任务重要模块。大多数点云补全方法在很大程度上依赖于成对的残缺-完整点云并以全监督方式进行学习。尽管它们在域内数据上的表现令人印象深刻，但泛化到其他形式的残缺点云或现实世界的残缺扫描时，由于域的差距，往往无法获得令人满意的结果。本期论坛我们邀请到了来自新加坡南阳理工大学的张俊哲同学，他提出了基于GAN逆映射的无监督点云补全方法ShapeInversion，不再需要成对的训练数据，并具有了显著的泛化能力。

***

### 讲者介绍

**张俊哲：**来自新加坡南洋理工大学S-Lab 和MMLab@NTU的博士生，师从吕健勤(Chen Change Loy)副教授和 Chai Kiat Yeo 副教授。研究领域包括多相机关联与融合，异常检测，和深度学习框架。当前主要研究兴趣包括三维重建和生成，点云补全等。在CVPR/ECCV/ICCV计算机视觉顶级会议上发表多篇论文。

**报告题目：**ShapeInversion: 基于GAN逆映射的无监督点云补全方法

**报告摘要：**本工作提出了ShapeInversion，将生成对抗网络(GAN)逆映射引入到点云补全中。ShapeInversion使用一个在完整点云上预训练的GAN，搜索一个潜码，该代码给出一个完整点云的点云，能最好地重建给定的残缺输入。通过这种方式，ShapeInversion不再需要成对的训练数据，能纳入训练好的生成模型中捕获的丰富先验。在ShapeNet基准上，ShapeInversion优于SOTA无监督方法，可与用配对数据学习的有监督方法相媲美，还展示了显著的泛化能力，对现实世界的扫描和各种形式的残缺输入以及不完整程度给出了鲁棒的结果。由于预训练GAN的参与，ShapeInversion自然地实现了一系列额外的能力，例如为一个模糊的残缺输入产生多个合理的完整点云，以及点云的扰动和内插。

**分享亮点：**
1. 我们在点云补全任务上第一次提出了基于GAN逆映射的框架ShapeInversion；
2. ShapeInversion 框架解决了一些3D数据结构固有的问题，从而更充分的利用了GAN的知识；
3. ShapeInversion 在真实数据上展现了很好的泛化效果。

***

### 论文推荐

1. 3D Point Cloud Generative Adversarial Network Based on Tree Structured Graph Convolutions

    **推荐理由：**tree-GAN是一篇点云的生成对抗网络，能够学到比较好的几何先验知识。我们的ShapeInversion工作是基于一个预训练的tree-GAN.
 
2. PCN Point Completion Network

    **推荐理由：**这是点云补全的第一篇工作，在此之前的3D形状不全都是以voxel的形式，而点云作为常见3D初始数据，直接在点云上做形状补全具有更大意义。
 
3. UNPAIRED POINT CLOUD COMPLETION ON REAL SCANS USING ADVERSARIAL TRAINING

    **推荐理由：**这篇文章首次讨论无监督的点云补全任务，该方法虽然很大程度上借鉴了首个点云的对抗生成网络，其解决思路仍然可以给我们比较大的启发。
 
4. Multimodal Shape Completion via Conditional Generative Adversarial Networks

    **推荐理由：**这篇文章第一次在点云补全任务上实现了一题多解，即给定一个残缺点云，该框架可以同时生成多个合理的完整点云。

5. PF-Net Point Fractal Network for 3D Point Cloud Completion

    **推荐理由：**这篇点云补全的工作尝试把一些2D上面比较有效的方法用到基于点云数据的框架上，由此取得了更精确的补全效果。这种解决思路比较有借鉴意义。

6. Variational Relational Point Completion Network

    **推荐理由：**全监督点云补全的SOTA，双路径的网络结构同时保证了mean shape和细节可以获得的很好。

***

### 参考资料

> <https://www.bilibili.com/video/BV1ca41117xd/>
