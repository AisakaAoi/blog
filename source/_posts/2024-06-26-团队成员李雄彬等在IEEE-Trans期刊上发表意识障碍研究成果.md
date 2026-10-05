---
title: 团队成员李雄彬等在IEEE Trans期刊上发表意识障碍研究成果
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫团队成果
abbrlink: 34feccd
date: 2024-06-26 21:00:29
tags:
---

近日，脑机团队成员李雄彬等在梁艳老师和潘家辉老师的指导下，与广东省南方医科大学珠江医院谢秋幼主任团队合作的研究成果“Assessing Consciousness in Patients with Disorders of Consciousness Using a Facial Action Unit Intensity Estimation Method Based on a Hybrid Similar Feature Network”被SCI期刊IEEE Transactions on Instrumentation and Measurement（影响因子: 5.6, 中科院二区Top）正式录用。本论文于2023年11月30日投稿，2024年6月24日录用。

<!--more-->

意识障碍（disorders of consciousness, DOC）患者的意识状态评估是临床检查中常见且至关重要的问题，但目前基于行为量表的主流诊断方法耗时长，且误诊率高。面部表情蕴含着与意识相关的信息，使用面部表情能够绕过肢体运动，为评估患者的意识评估提供了一种更方便、客观的手段。本文设计了一种基于面部表情的DOC患者意识评估方法。具体来说，本文提出了一种混合相似特征网络（Hybrid similar feature network, HSFN），该网络结合了由人脸对齐网络（Facial alignment network, FAN）和热图回归网络（Heatmap regression network）产生的多个特征，用于动作单元（Action unit, AU）强度估计；随后，采用疼痛刺激诱发DOC患者产生疼痛相关的AU强度变化，利用改进的Prkachin和Solomon疼痛指数PSPI-R量化患者在疼痛状态下面部表情的变化程度；最后，根据PSPI-R得分对DOC患者进行意识水平评估。

{% asset_img 1.webp %}
<div align='center'>图1混合相似特征网络的结构</div>

现有的AU强度估计方法依赖于单个网络生成的特征进行训练，在数据有限的情况下，网络学习任务相关特征的能力有限。为了丰富AU相关的特征，我们通过引入一个由人脸对齐网络初始化的综合块（Comprehensive Block），将FAN中的知识注入到我们的网络中。由于FAN的任务与AU强度估计相似，因此综合块产生的特征有利于我们的网络，显著增强了学习更多任务相关特征的能力。此外，本文探索了多种融合策略，以最大限度地利用这些丰富的特征。在基准模型上，我们的方法使用了更丰富的特征，并最终采用拼接的特征融合方式，该方法取得了更好的结果，并且比当前大部分方法都要优越。

使用HSFN，我们获取了24例最小意识状态（minimal conscious state, MCS）患者和26例植物状态（vegetative state, VS）患者的AU强度信息，并得到其在疼痛刺激下的PSPI-R得分。我们进一步验证了MCS和VS的PSPI-R平均得分存在显著差异，并建议使用PSPI-R的阈值为3.5分，以区分MCS和VS。在26例VS患者中，有6例患者超过该阈值，其中4例患者在3个月后，昏迷恢复量表修订版（Coma Recovery Scale-Revised, CRS-R）评分提高了，并且有1名VS患者被判定为MCS，这些数据证明了该方法的有效性。

总的来说，本文旨在利用AU强度估计量化患者对疼痛刺激反应时面部表情的变化，从而提高DOC患者意识检测的准确性。我们的研究结果有望提高这一具有挑战性的临床领域的诊断能力。本文的主要贡献如下：

- 我们提出了一种混合的相似特征网络（HSFN），它结合了由面部对齐网络（FAN）的浅层产生的多个特征和热图回归网络，以解决由单一网络获取的AU强度估计数据不足和缺乏详细知识的问题。
- 我们基于Prkachin和Solomon的PSPI公式，提出了更适合DOC患者的PSPI-R公式，在不依赖依赖肢体运动的情况下，量化患者在疼痛刺激下的面部变化。
- 我们提出的方法首次用于评估50例DOC患者的意识水平，证明了其在临床中的可行性和有效性。

该方法具有操作简便、快速、成本低等优点，对于辅助评估DOC患者意识水平具有广阔的应用前景。

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=15840>
