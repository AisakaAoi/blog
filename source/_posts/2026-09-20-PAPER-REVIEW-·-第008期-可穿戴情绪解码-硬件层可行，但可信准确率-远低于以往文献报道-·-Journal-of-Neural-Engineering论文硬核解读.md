---
title: >-
  PAPER REVIEW · 第008期 "可穿戴情绪解码"硬件层可行，但可信准确率"远低于以往文献报道 · Journal of Neural
  Engineering论文硬核解读
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫学习报告
abbrlink: 466f593f
date: 2026-09-20 12:00:00
tags:
---
一篇*Journal of Neural Engineering*2026 论文的硬核解读 · 伦敦玛丽女王大学 + 奥胡斯大学 Winnard/Pearce 团队 · 31 名被试 · 5 种数据分割 × 8 种深度学习模型

TL;DR · 一句话总结

伦敦玛丽女王大学 + 奥胡斯大学 Winnard / Pearce 团队*J. Neural Eng.*2026：用 31 名被试的 scalp + cEEGrid 双通道 EEG 音乐情绪数据集 DAAMEE，对 5 种数据分割 × 8 种深度学习模型做"系统性打假"——同一份数据下 K-fold 准确率 75%，LOSO 跌到 50%，与机会水平无显著差异；同时验证了耳周 EEG 与 scalp EEG 性能等价，为可穿戴情绪监测的硬件可行性背书。

<!--more-->

论文卡片

| 标题 | Music emotion recognition with cEEGrid |
|---|---|
| 作者 | Chris Winnard¹, Kaare Mikkelsen², Preben Kidmose², Marcus T. Pearce¹ *通讯 |
| 单位 | 1. Queen Mary University of London, School of EECS 2. Aarhus University, Department of Electrical & Computer Engineering |
| 期刊 | Journal of Neural Engineering |
| 卷期 | Vol. 23, No. 4, 046057 (2026) |
| DOI | https://doi.org/10.1088/1741-2552/ae94b1 |
| 发表 | 2026 年 8 月 20 日（在线） · 接收 2026-08-04 |
| 资助 | （原文未列具体资助编号） · 计算在 Queen Mary HPC 完成 |
| 被试 | 31 名（11 男 + 2 跨性别男 + 18 女，平均 26 岁，3 名左利手） |
| PMID | 42551462 |

一、研究背景：当"AI 能听懂你情绪"被报道时，先问一句"它怎么评估的"

过去几年，"AI + EEG + 情绪"方向的研究呈现一种虚假的繁荣——*IEEE Transactions on Affective Computing*、*Journal of Neural Engineering*、*Interspeech*频繁报道 90%、95% 乃至 99% 的情绪分类准确率。但当你把同样的数据用更严格的方式拆分，得到的结果却常常回到二选一的 50%（机会水平）。

这不是阴谋论。**Brookshire 等（2025）**做过一个著名实验：同一份阿尔茨海默 EEG 数据，用 LOSO（Leave-One-Subject-Out）评估时准确率**53%**，但只要把同一被试的相邻样本分到不同折，准确率直升**99.8%**——这中间的 +46.8 个百分点完全来自数据泄漏，不是任何模型改进。**TorchEEG 库**原版报告 DEAP 数据集 CCNN 效价二分类 KF 准确率**93.20%**，换成交叉 trial 分割（KFCT）后跌到**53.66%**——又是 +39.54 个百分点的通胀。

Winnard / Pearce 团队这篇*J. Neural Eng.*2026 的研究就是这个背景下的"系统性打假"：他们用自己新发布的**DAAMEE**数据集（含 scalp EEG + around-the-ear cEEGrid 两种记录），系统比较了 5 种数据分割 × 8 种深度学习模型 × 3 种情绪维度（valence / arousal / dominance）。****

**两条主要发现**：

·**耳周 EEG 的绝对性能跟 scalp EEG 几乎没差别**——这意味着"可穿戴情绪解码"在硬件层是可行的。

·**可穿戴情绪解码的"可信准确率"远低于以往文献报道**——只有用严格分割（KFCT / KFCS / LOSO）时才能得到接近机会水平的真实数字。

而这一切，又是用**音乐**作为情绪诱发刺激得到的结果——这让"AI 音乐情绪识别"这个赛道普遍高估的现状变得更加刺眼。

二、实验设计：让被试听 16 段原创音乐、用 VAD 量表打分

① 数据集 DAAMEE

研究的核心交付物之一是新发布的**DAAMEE（Decoding Auditory Attention and Musical Emotions with Ear-EEG）**——首个公开的、同时含 scalp EEG 与 cEEGrid 的情绪解码数据集。

·**被试**：32 名招募，**1 名因技术故障剔除**，剩余**31 名**进入分析（11 男 + 2 跨性别男 + 18 女，平均 26 岁，3 名左利手）

·**cEEGrid 子集**：其中 2 名被试因设备连接问题数据不可用，因此**DAAMEE-c 仅 29 名被试**；DAAMEE-s（scalp）保持 31 名

·**刺激**：4 位作曲家原创的 12 首三部组合曲（harmonica / vibraphone / piano），每首切出 3 个独奏轨，共**36 段**；每位被试听其中一半（**16 段**，含 1 段练习），每段**30 秒**，分析时取中间**28.42 秒**（去掉 0.6 秒淡入淡出与眼动缓冲）

② 实验流程（每名被试）

PsychoPy 呈现，整体分三段：

1.**听力校准**：用滑动条居中每个乐器的立体声平衡并设定舒适音量

2.**人口学问卷 + 当下 VAD 自评（0–10 连续量表）**+ Goldsmiths Musical Sophistication Index 部分子量表

3.**情绪解码任务**：每 trial 前要求**闭眼**减少眼电伪影；听完后用 0–10 量表分别对 valence / arousal / dominance 打分

③ 模型与数据分割

**模型**：8 种深度学习架构——CCNN（Continuous CNN）、DGCNN（Dynamic Graph CNN）、LGGNet、Vanilla Transformer、SimpleViT、ViT、ArjunViT、LSTM。

**数据分割**：5 种——

·**KF**：标准 K-fold（随机）

·**KFGbT**：按 trial 分组后的 K-fold（防止同一 trial 完整泄漏到不同折）

·**KFCT**：cross-trial（同被试不同 trial 分开）

·**KFCS**：cross-subject（同被试不泄漏，跨被试）

·**LOSO**：被试外留一（最强约束）

**对比基线**：经典 DEAP 数据集 scalp EEG 数据（Koelstra et al. 2011）。

在 EEG 情绪解码领域，"准确率 75%"通常不是说"我能读懂你的情绪"，而是说"我能识别你前 5 秒脑电里是否还残留着 5 秒前的痕迹"——这两件事不是同一件事。

{% asset_img 1.webp %}
<div align='center'>图1 · DAAMEE 五步实验流程：听力校准 → 问卷 → 情绪任务（scalp + cEEGrid 同时记录）→ VAD 自评 → 深度学习分类</div>

三、关键发现：准确率的"75%"与"50%"可能描述的是同一份数据

① 耳周 EEG 跟 scalp EEG 性能持平——这是好消息

按跨分割平均的效价二分类准确率，**cEEGrid（DAAMEE-c）与 scalp EEG（DAAMEE-s）在统计上没差别**：

| 数据集 | GNN 类模型平均 | Transformer 类模型平均 | 最佳模型 |
|---|---|---|---|
| DEAP（scalp） | 59.1% | 55.6% | CCNN 60.4% |
| DAAMEE-s（scalp） | 60.0% | 57.1% | DGCNN 61.5% |
| DAAMEE-c（cEEGrid） | 60.2% | 57.6% | DGCNN 61.4% |

DAAMEE-c 的最佳模型（DGCNN）和 DAAMEE-s 的最佳模型（DGCNN）平均下来，**耳周 EEG 反而略高 0.2 个百分点**。这为"用耳机/耳塞做情绪监测"打开了一扇现实的门。

② 但"75% vs 50%"的鸿沟才是坏消息

**这才是论文的主菜**。同一个 DGCNN 模型，仅改变数据分割方式，准确率就能从 75% 跌到 50%：

| 模型 × 数据集 | KF | KFGbT | KFCT | LOSO | 跌幅 |
|---|---|---|---|---|---|
| DGCNN × DEAP | 69.4 | 69.6 | 58.7 | 51.6 | −17.8 pp |
| DGCNN × DAAMEE-s | 73.8 | 74.0 | 57.5 | 51.9 | −22.1 pp |
| DGCNN × DAAMEE-c（cEEGrid） | 75.0 | 75.0 | 59.2 | 50.2 | −24.8 pp |

这一组数据里几个值得划重点的细节：

·**DGCNN × DAAMEE-s 的"模式落差"**：从 KFGbT 74.0% 到 KFCT 57.5% 跌了**16.5 个百分点**，但 KFCT 到 LOSO 只再跌**5.6 pp**——这强烈提示**最大的通胀来源是 trial 内时间相关性泄漏，不是被试间变异性**

·**DEAP × CCNN**：从 KF 69.0% 到 LOSO 53.2% 跌**15.8 pp**

·**cEEGrid 比 scalp 更脆弱**：在 DAAMEE-c 上 DGCNN 跌 24.8 pp，比 scalp 的 22.1 pp 多——可能因为 cEEGrid 样本点更多更密，时间相关性更强

当一篇 EEG 论文只汇报"K-fold 准确率"，它汇报的不是"模型能力"，而是"模型记住时间的能力"。

{% asset_img 2.webp %}
<div align='center'>图2 · 四种数据分割对样本归属的影响（红色 = 同 trial 同时存在于 train/test，绿色 = 完全隔离）</div>

③ arousal / dominance / 8 分类 VAD 同样有此现象

研究者把最佳模型拓展到三种情绪维度的更多任务上：

·在**arousal**上，DGCNN on DAAMEE-c 从 KF 74.2% → LOSO 54.3%，跌**19.9 pp**

·在**dominance**上，DGCNN on DAAMEE-c 从 KF 71.3% → LOSO 50.2%，跌**21.1 pp**

·在**8 分类 VAD**（情绪三维度联合）上，DGCNN on DAAMEE-c 从 KF 49.2% → LOSO 18.4%（机会水平 16.2%）——多分类任务上几乎完全回到机会

④ 二项检验与 ANOVA：几乎所有 KF 模型都"显著高于机会"

研究者用二项检验（p < 0.05）确认：在 DEAP 上 40 个模型 × 分割组合中有**35 个**显著高于机会（51.2%）；DAAMEE-s 上也有多数组合显著。但当分割换成 LOSO 后，**多个组合不再显著**（如 DGCNN on DAAMEE-c LOSO 50.2% < 机会 51.5%，未加粗）。

三种数据集上不同分割方法间性能差异**全部 ANOVA 显著**：

| 数据集 | DEAP | DAAMEE-s | DAAMEE-c |
|---|---|---|---|
| ANOVA F 值（分割间差异） | 10.9 | 16.9 | 9.48 |
| 全部 p < 0.05 | ✓ | ✓ | ✓ |

**统计含义**：不同数据分割下的准确率差异全部显著——但这种显著差异主要来自"哪个分割更宽松"，而不是"模型能力本身"。

{% asset_img 3.webp %}
<div align='center'>图3 · 准确率从 KF 的 75% 跌到 LOSO 的 50%（DGCNN × DAAMEE-c），红色双头箭头标记的"性能通胀"约 25 个百分点；水平虚线为机会水平 51%</div>

四、个体差异视角：cEEGrid 不只是"性能等效"

把 LOSO 当作"严苛场景下的真实泛化能力"基准，cEEGrid 与 scalp EEG 在 valence / arousal / dominance 三个维度上的 LOSO 准确率差距都不超过 1-3 个百分点（多数在统计上不显著）。这一稳定对等让 cEEGrid 的**可穿戴性优势**变得更值得讨论：

·**佩戴舒适度**：耳周电极可以做成耳机/耳塞形态，长时间佩戴不显眼

·**日常可行性**：相比 32 通道的 scalp EEG 帽，cEEGrid 不需要导电胶、不需要洗头

·**与音频硬件重叠**：cEEGrid 的物理位置恰好就是音乐播放设备的物理位置

研究者也注意到一个微妙但重要的现象：**cEEGrid 适合的模型子集更窄**。因为耳周电极无法排成 2D 网格，需要空间图输入的 CCNN、SimpleViT、ViT 在 DAAMEE-c 分析中被排除，最终只用 DGCNN、LGGNet、Vanilla Transformer、ArjunViT、LSTM 五种。这也是为什么工业上做 cEEGrid 模型时**图神经网络（GNN）更受偏爱**。

五、学术争议、局限与可证伪的未来

作者的局限部分写得相当坦诚，加上从方法学角度可补的几点：

1.**LOSO 准确率近机会**：作者承认"40 个 DEAP 模型管道里只有 8 个达到 60%"，提示绝对性能偏低，远未达到"可部署情绪识别"的门槛

2.**泄漏与跨被试噪声无法解耦**：作者明确说"无法自信判断 KFCT vs KFCS/LOSO 之差，多少来自被试间负向噪声、多少来自正向泄漏"

3.**刺激泄漏未系统研究**：本文聚焦时间/被试泄漏，刺激级泄漏（如同一首乐曲的相同段同时出现在 train/test）作者标为未来工作

4.**cEEGrid 模型池受限**：需空间图的模型被排除于 DAAMEE-c，所以 cEEGrid 上的"最佳模型"结论未必通用

5.**绝对性能被"跨分割均值"低估或高估**：用平均准确率选最佳模型，可能偏向利用泄漏的模型（DGCNN 在 KF/KFGbT 虚高）

6.**强制偏差设计缺位**：作者建议未来用强制偏差设计或多数据集学习来厘清个体差异方向

值得研究者更警惕的几点：

·**数据集规模小（N=31）**：达到 LOSO 稳定的置信区间需要的样本量远超此数

·**刺激同质化**：只用 12 首三部组合曲，无法外推到流行、摇滚、电子、噪音等更广的音乐生态

·**录音时长有限**：每位被试只听约 8 分钟音乐，跨时段稳定性未知

·**"机会水平"基线在不同分割下不同**：DEAP 51.2% / DAAMEE-s 51.2% / DAAMEE-c 51.5% / arousal 51.7-51.9%——比较时要小心基线漂移

·**缺少"留出数据集"评估**：本研究用同一被试池内部做 LOSO，未来应该跨数据集做 generalization test

**最后一点最值得 AI 音乐同行反思**：本文没有直接测量"音乐情绪识别 AI 的精度"，但方法学结论直接影响到几乎所有 MERT（MERT、Music2Emotion、DAMER、Memo2496）中汇报的"情绪一致性"指标的可信度——如果 EEG 这类有真实时间戳的连续信号都被 KF 严重高估，那基于"生成音频"的预测情绪一致性指标，又有多少是真实信号、多少是参考音频的时间相关性？

在 EEG 情绪解码领域，怀疑某种"准确率通胀"是美德，把它显式测出来才是学问。

{% asset_img 4.webp %}
<div align='center'>图4 · cEEGrid → 预处理 → 深度学习 → 多维情绪输出的端到端管道。珊瑚红重点标注模型块与反馈环，提示"硬件可行但模型评估需重做"</div>

写给你

这篇*J. Neural Eng.*给了我们三件事：

**给研究者**：本文的最大方法学价值是给出了"5 种数据分割 × 报告准确率"的完整对比表——这是任何 EEG 情绪识别新论文都该模仿的报告标准。如果你做 AI 音乐情绪识别（MERT / MER / Music2Emotion 等）也建议照搬这套评估范式：**主指标用 LOSO 或 KFCS 报告**，KF/KFGbT 数字可以作为上限放在附录。

**给关注音乐 × 心理 × AI 产品的人**：耳周 EEG（cEEGrid）在本文中显示**与 32 通道 scalp EEG 在性能上等价**——这意味着耳机形态的"情绪监测"硬件已经成熟，最大的瓶颈反而是**算法侧**：当你给用户报告"你现在比较焦虑"时，这个数字背后可能并没有超越机会水平的模型能力。**做产品要先做反幻觉**。

**给一个想理解自己的人**：你今天听一首歌时的情绪状态，跟你 5 秒前听同一首歌时的状态，有相当一部分"重合"在脑电里——这种**短时情绪惯性**既是我们能感受到"情绪氛围"的神经基础，也是 AI 模型在 K-fold 评估下"看起来很准"的原因。如果你想真的"读懂自己的情绪"，**别相信耳机直接告诉你的百分比**，试试用 30 秒后的自己复述刚才的感觉——这种离样本验证比 LOSO 评估更接近真实可用性。

DISCUSSION

这篇*J. Neural Eng.*论文的研究者下一步想做的事包括"刺激级泄漏的系统性研究"和"强制偏差设计厘清个体差异方向"。

**最想问他们什么问题？**

如果改用流行、摇滚、电子、噪音等更广的音乐生态，cEEGrid 跟 scalp 的等价性还能保持吗？ / LOSO 准确率近机会这件事，能否靠"先用大批量被试预训练 + 个体微调"的迁移学习缓解？ / 在可穿戴 EEG 上做"情绪识别"是否应该彻底放弃分类指标，改用"情绪连续回归 + 校准曲线"？ / 这套数据分割诊断方法，是否同样适用于音乐以外的 EEG 任务（运动想象、P300 BCI）？

CITATION · 如何引用本文

Winnard, C., Mikkelsen, K., Kidmose, P., & Pearce, M. T. (2026). Music emotion recognition with cEEGrid.*Journal of Neural Engineering*, 23(4), 046057. https://doi.org/10.1088/1741-2552/ae94b1

***

### 原文链接

> https://mp.weixin.qq.com/s?__biz=MzA3ODA4OTMwMg==&mid=2257497551&idx=1&sn=48c6a9ad22c6a07c4fd38fda890fdfe4
