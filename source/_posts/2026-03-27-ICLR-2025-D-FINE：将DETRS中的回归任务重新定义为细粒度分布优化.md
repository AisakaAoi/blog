---
title: "ICLR 2025 | D-FINE：将DETRS中的回归任务重新定义为细粒度分布优化"
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫学习报告
abbrlink: f32c27d8
date: 2026-03-27 14:08:00
tags:
---

{% asset_img 0.webp %}

**该论文发表于International Conference on Learning Representations (ICLR) 2025，题目为《D-FINE: Redefine Regression Task in DETRs as Fine-grained Distribution Refinement》。**

**中国科学技术大学（USTC）** **的彭岩松** **和李和倍为此文共同第一作者。**

**论文链接**

**https://openreview.net/forum?id=MFZjrTFE7h**

<!--more-->

### 论文概要

本文提出了一种强大的实时目标检测器D-FINE，旨在解决当前DETR类模型在边界框回归任务中的局限性。传统的实时检测器（如YOLO系列和RT-DETR）通常将边界框预测视为确定性的坐标回归，这种方式忽略了定位的不确定性且难以优化。

D-FINE通过引入两个核心组件——细粒度分布细化（Fine-grained Distribution Refinement, FDR）和全局最优定位自蒸馏（Global Optimal Localization Self-Distillation, GO-LSD），重新定义了这一任务。FDR将坐标预测转化为概率分布的迭代细化过程，而GO-LSD则通过自蒸馏机制将深层网络的定位知识传递给浅层网络。

实验结果表明，D-FINE在COCO数据集上超越了YOLOv10和RT-DETR等最先进模型。例如，D-FINE-L在保持124 FPS的高推理速度下达到了54.0%的AP，在经过Objects365预训练后更是达到了59.3%的AP，证明了该方法在精度和效率上的双重优势。

### 研究背景

实时目标检测在自动驾驶、视频监控等领域有着广泛应用。长期以来，YOLO系列因其高效性占据主导地位，而基于Transformer的DETR架构虽然消除了NMS和Anchor的依赖，但在实时性上曾面临挑战。

尽管RT-DETR和LW-DETR等工作成功将DETR推向了实时应用，但它们在边界框回归（Bounding Box Regression）的建模上仍存在不足。 现有的检测器大多将边界框边缘视为固定数值（狄拉克δ分布），利用L1损失或IoU损失进行优化。这种僵化的表示方式难以建模定位的不确定性，且在预测接近真实值时，微小的坐标变化难以通过损失函数提供足够的指导，导致收敛缓慢。虽然已有工作（如GFocal）尝试引入概率分布，但往往依赖于Anchor且缺乏迭代细化。

此外，为了追求极致的实时性，检测器通常限制了计算量，传统的知识蒸馏（Knowledge Distillation）方法在检测任务中效率低下。为此，本文提出了D-FINE，通过分布建模和自蒸馏策略，在不增加额外推理成本的前提下显著提升了检测性能。

### 研究方法

本文提出了一种端到端的实时目标检测框架D-FINE，在架构上对RT-DETR进行了轻量化改进，并集成了两大核心创新模块。如图1所示，D-FINE主要由混合编码器、FDR模块和GO-LSD策略组成：

{% asset_img 7.webp %}
<div align='center'>图1 D-FINE 与 FDR 概览</div>

**一、细粒度分布细化（Fine-grained Distribution Refinement, FDR）**

传统的回归头直接预测{x, y, w, h}，而FDR将其转化为预测边界框四条边（上、下、左、右）的概率分布。这并非一次性预测，而是一个残差式的迭代过程：

1. 初始分布： 第一层解码器生成初始的边界框和概率分布。
2. 迭代优化： 后续每一层解码器基于上一层的输出，预测"残差logits"，对分布进行修正。
3. 加权函数 W(n)： 为了实现精准定位，D-FINE设计了一个非均匀加权函数 W(n)。该函数在中心区域变化平缓，允许对接近目标的预测进行微调；在边缘区域变化剧烈，允许对偏差较大的预测进行快速修正。FDR的数学表达为：

$$W(n)=\begin{cases}
2\cdot W(1)=-2a & n=0 \\
c-c\left(\frac{a}{c}+1\right)^{\frac{N-2n}{N-2}} & 1\leq n<\frac{N}{2} \\
-c+c\left(\frac{a}{c}+1\right)^{\frac{-N+2n}{N-2}} & \frac{N}{2}\leq n\leq N-1 \\
2\cdot W(N-1)=2a & n=N
\end{cases}
$$

其中 Pr^l(n) 是第l层细化后的概率分布。这种方法将回归任务从"猜数字"变成了"调整分布"，显著提高了定位精度。

**二、全局最优定位自蒸馏（Global Optimal Localization Self-Distillation, GO-LSD）**

由于Transformer解码器的深层通常能产生更准确的定位，GO-LSD利用最后一层的精细分布作为"软标签"来指导浅层网络的学习。然后将解耦蒸馏焦点损失 DDF 表述为：

$$\mathcal{L}_{\mathsf{DDF}}=T^2\sum_{l=1}^{L-1}\left(\sum_{k=1}^{K_m}\alpha_k\cdot\mathbf{KL}\left(\mathbf{Pr}^l(n)_k,\mathbf{Pr}^L(n)_k\right)+\sum_{k=1}^{K_u}\beta_k\cdot\mathbf{KL}\left(\mathbf{Pr}^l(n)_k,\mathbf{Pr}^L(n)_k\right)\right)$$

$$\alpha_k=\mathsf{IoU}_k\cdot\frac{\sqrt{K_m}}{\sqrt{K_m}+\sqrt{K_u}},\quad \beta_k=\mathsf{Conf}_k\cdot\frac{\sqrt{K_u}}{\sqrt{K_m}+\sqrt{K_u}}$$

1. 统一匹配（Union Matching）： 传统的DETR在每一层单独进行匈牙利匹配，导致各层学习目标不一致。GO-LSD聚合所有层的匹配结果，确保所有层都能学习到全局最优的候选框。
2. 解耦蒸馏焦点损失（Decoupled Distillation Focal Loss, DDF）： 考虑到部分预测框虽然定位准但置信度低，DDF损失将定位知识的蒸馏与分类置信度解耦，确保浅层网络能够充分吸收深层的定位知识，且不增加额外的训练参数或推理负担。

**三、轻量化网络设计**

为了平衡速度与精度，D-FINE还对骨干网络和编码器进行了优化，例如采用HGNetv2作为骨干，引入GELAN结构替代CSP层，并移除了冗余的解码器投影层，使得模型更加轻量高效。

### 实验结果

本文在COCO 2017 val数据集和Objects365数据集上进行了广泛的实验，并将D-FINE与YOLOv10、RT-DETR、LW-DETR等主流实时检测器进行了对比，如表1所示：

<div align='center'>表1 COCO val2017上的实时目标检测器性能比较</div>
{% asset_img 10.webp %}

如表1所示，D-FINE在各项指标上均优于竞品。D-FINE-L 仅用31M参数和91 GFLOPs就达到了54.0% AP，相比YOLOv10-L（53.2% AP）和RT-DETR-R50（53.1% AP），不仅精度更高，而且计算成本显著降低。D-FINE-X 则以55.8% AP刷新了实时检测的SOTA记录。

此外，在Objects365预训练后，D-FINE-X的性能进一步提升至59.3% AP，远超同等预训练设置下的YOLOv10-X（54.9%）和RT-DETR-R101（56.2%），证明了其在大规模数据下的极强扩展性。

**消融实验与可视化：** 为了验证各组件的有效性，文章进行了详细的消融研究（ Ablation Study ）。

**FDR的影响：** 引入FDR模块后，模型AP从基线的53.0%提升至53.5%。可视化结果（原文图4）显示，加权后的分布曲线在真实值附近更加尖锐，有效降低了定位的不确定性。

**GO-LSD的影响：** 加入GO-LSD后，AP进一步提升至54.0%。与传统的Logit Mimicking（AP降至52.6%）和Feature Imitation（AP 52.9%）相比，GO-LSD是唯一能显著带来正向收益的蒸馏策略。

FDR和GO-LSD的影响如表2所示：

<div align='center'>表2 FDR和GO-LSD在各种DETR模型上于COCO val2017的有效性</div>
{% asset_img 11.webp %}

### 结论

本文提出了一种全新的实时目标检测器D-FINE，通过细粒度分布细化（FDR）和全局最优定位自蒸馏（GO-LSD）重构了DETR中的边界框回归任务。该方法成功克服了传统固定坐标回归的优化难题，并解决了知识蒸馏在检测任务中的效率瓶颈。实验表明，D-FINE在COCO和Objects365数据集上均取得了最先进的性能，在保持极低延迟的同时实现了卓越的检测精度。D-FINE不仅为实时目标检测设立了新的基准，也证明了概率分布建模和自蒸馏机制在端到端检测框架中的巨大潜力。

撰稿人：周文旭

审稿人：梁瑾

***

### 原文链接

> <https://mp.weixin.qq.com/s/7S_V-4_BHXcK_RqYuiOenQ>
