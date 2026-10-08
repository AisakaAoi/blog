---
title: 科研绘图哪家强？GPT Image2 vs Nano Banana
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐学术杂谈
abbrlink: 58e496d4
date: 2026-05-25 12:00:00
tags:
---

这两天看到不少人在讨论一个问题：

**现在做科研绘图，到底哪家模型更好用？**

有人觉得 GPT Image 2 性价比高，有人觉得 Nano Banana 速度快、风格好，也有人说科研图不能只看“好不好看”，关键要看能不能真的用于论文、综述、组会和基金本子。

这次我们通过**实测**来给出结论。

<!--more-->

整个流程是这样：

1. 我先选出 10 个真实科研绘图场景，尽量覆盖医学、生物、材料、能源、化学、AI、环境和社会科学。
2. 用 Codex 执行整套评测流程，分别调用两个图像模型生成图片。
3. 两个模型使用同一套提示词，避免因为 prompt 不公平导致偏差。
4. **最后让 Claude 扮演一位「 Nature 编辑」，从科研论文图的角度给每张图打分。**

### 科研图最怕的，从来不是不够炫

很多同学第一次用 AI 画科研图，都会被那种“哇，好高级”的视觉冲击骗到。背景很亮，光效很多，细胞很立体，颜色很梦幻。

但你真的把它放进论文或者组会 PPT 里，问题马上就来了。期刊编辑更关注专业性和准确性。

这次评测的评委是Claude 。按下面 8 个维度打分：科学逻辑、信息层级、论文布局、文字可读性、箭头和因果关系、学科表达可信度、科研图感，以及后续修改成本等。

每项 1-5 分，总分 40 分。

下面我们具体看一下各个场景下的结果：

***

### 01｜生物医学机制图：炎症促进组织纤维化及药物干预

这一类图最常见于医学、药理、病理、肿瘤、免疫方向。

它的核心不是“画几个细胞”，而是要把上游炎症、中游信号、下游纤维化结果画清楚。

**GPT Image 2 效果图**

{% asset_img 1.webp %}

**Nano Banana 效果图**

{% asset_img 2.webp %}

**本次提示词**

```
Create a professional scientific mechanism figure about inflammation-driven tissue fibrosis and pharmacological intervention. Show inflammatory cell recruitment, macrophage activation, cytokine release, fibroblast activation, extracellular matrix deposition, and a drug blocking the TGF-beta signaling axis. Use a layered left-to-right causal layout with clear activation and inhibition arrows, restrained colors, sparse academic labels, and a publication-ready white-background schematic style.
```

**Nature 编辑评价**

GPT Image 2 的优势在于机制链条更完整。它不仅画出了炎症细胞、巨噬细胞、成纤维细胞、ECM 沉积，还把 TGF-β/Smad 这种分子层级的通路拆出来了。

Nano Banana 的图更像一个概念概览，视觉上也能看，但机制深度明显不够。

**这一组小结**

生物医学机制图最重要的是因果链。谁激活谁，谁抑制谁，最后导致什么病理结果，都要画得足够清楚。

***

### 02｜分子生物机制图：CRISPR-Cas9 基因编辑

这一类图考验的是分支逻辑。

CRISPR 图不能只画 Cas9 和 DNA，它必须表达：识别 PAM、结合目标 DNA、产生双链断裂，以及 NHEJ / HDR 两条修复路径。

**GPT Image 2 效果图**

{% asset_img 3.webp %}

**Nano Banana 效果图**

{% asset_img 4.webp %}

**本次提示词**

```
Create a publication-ready CRISPR-Cas9 genome editing mechanism figure. Show Cas9-guide RNA complex formation, PAM recognition, target DNA binding, double-strand break formation, and two downstream repair branches: NHEJ leading to indels and HDR leading to precise insertion or correction. Use a clean layered mechanism layout, concise labels, clear branch arrows, and a flat vector-like scientific style on a white background.
```

**Nature 编辑评价**

这一组 GPT Image 2 得分 39，几乎接近满分。

Claude 认为它的编号、分支路径、NHEJ/HDR 区分、PAM 标注都比较清楚。Nano Banana 的问题主要是布局比较散，视觉层级不稳定，看的人需要自己“猜”顺序。

**这一组小结**

分子机制图不能只画对象，要画出步骤和分支。尤其是 NHEJ / HDR 这种路径差异，必须用明确的分叉结构表达出来。

***

### 03｜实验流程图：单细胞 RNA-seq 从样本到分析

流程图最怕的不是画不出仪器，而是步骤顺序乱。

单细胞 RNA-seq 至少要能表达：组织处理、单细胞悬液、微流控捕获、建库测序、UMAP 聚类、marker gene 分析和细胞类型注释。

**GPT Image 2 效果图**

{% asset_img 5.webp %}

**Nano Banana 效果图**

{% asset_img 6.webp %}

**本次提示词**

```
Create a stepwise experimental workflow figure for single-cell RNA sequencing. Show tissue dissociation, viable single-cell suspension, microfluidic droplet capture, barcoding and library preparation, sequencing, UMAP clustering, marker gene analysis, and cell-type annotation. Use a left-to-right modular workflow with separate visual zones, clear arrows, minimal text, and a journal methods-figure style.
```

**Nature 编辑评价**

GPT Image 2 的流程更像论文 methods overview，一路从左到右走，读者不太会迷路。

Nano Banana 给了更多生物学上下文，比如组织、动物、细胞状态，但两行式布局打断了流程感。对于组会汇报，Nano 的图可能也能讲；但对于论文方法图，GPT 更稳。

**这一组小结**

实验流程图的第一原则是顺序。读者不应该猜下一步在哪里。

***

### 04｜Graphical Abstract：LNP-mRNA 递送与免疫激活

Graphical Abstract 最难的是“一张图讲完整故事”。

不是元素越多越好，而是要让读者知道：左边是什么策略，中间发生什么过程，右边得到什么生物学结果。

**GPT Image 2 效果图**

{% asset_img 7.webp %}

**Nano Banana 效果图**

{% asset_img 8.webp %}

**本次提示词**

```
Create a scientific graphical abstract for lipid nanoparticle mRNA delivery and immune activation. Show ionizable lipid nanoparticle assembly around mRNA cargo, intramuscular injection, cellular uptake, endosomal escape, mRNA release into cytoplasm, antigen translation, MHC presentation, B-cell antibody response, and CD8 T-cell activation. Use a balanced graphical-abstract composition with clear causal flow, sparse labels, and a polished biomedical vector style.
```

**Nature 编辑评价**

GPT 用编号把 LNP 组装、注射、摄取、内体逃逸、抗原翻译、免疫激活串起来。

Nano Banana 内容也不少，甚至补充了淋巴结等背景，但画面明显更挤，文字和箭头更容易互相打架。

**这一组小结**

Graphical Abstract 的关键不是把所有元素都塞进去，而是让读者一眼看懂研究故事。

***

### 05｜材料科学机制图：光热抗菌材料破坏生物膜

材料图很容易翻车。

因为你不能只画“材料”和“细菌”，必须画出材料怎么伤害细菌。

**GPT Image 2 效果图**

{% asset_img 9.webp %}

**Nano Banana 效果图**

{% asset_img 10.webp %}

**本次提示词**

```
Create a publication-ready mechanism schematic for a photothermal antibacterial nanomaterial disrupting bacterial biofilm. Show nanomaterial attachment to biofilm, near-infrared light irradiation, local heat generation, bacterial membrane damage, increased permeability, intracellular leakage, and biofilm collapse. Include one small zoom-in inset for membrane rupture, use blue-green for bacteria and orange-red for heat damage, with clean arrows and a white background.
```

**Nature 编辑评价**

这一组 GPT 得分 39。Claude 特别提到，GPT 的膜破裂局部放大图、808 nm 近红外照射、升温、细胞内容物泄漏这些细节都比较到位。

Nano Banana 的图科学方向没错，但圆形布局让阅读顺序不够明确。

**这一组小结**

材料机制图不能只画结果，要把材料、刺激、局部反应、细胞损伤和最终效果串起来。

***

### 06｜能源器件结构图：锂硫电池穿梭效应与抑制策略

能源器件图考验的是剖面结构和过程箭头。

锂硫电池如果只画几个电极，那不够；它要把多硫化物穿梭、锂离子迁移、隔膜或中间层抑制机制讲清楚。

**GPT Image 2 效果图**

{% asset_img 11.webp %}

**Nano Banana 效果图**

{% asset_img 12.webp %}

**本次提示词**

```
Create a scientific device schematic of a lithium-sulfur battery showing the polysulfide shuttle effect and suppression strategy. Show sulfur cathode, separator, electrolyte, lithium metal anode, lithium-ion migration, polysulfide diffusion, shuttle pathway, and a modified interlayer or catalytic host suppressing polysulfides. Use a clean cross-sectional layout with arrows for ion transport and shuttle inhibition, suitable for an energy materials review figure.
```

**Nature 编辑评价**

GPT Image 2 的图更像 review 文章里的 schematic，主图加对比 panel，读起来轻松。

Nano Banana 给了更多机制细节，但有点太满，标签和箭头堆在一起，反而降低了信息传达效率。

**这一组小结**

能源器件图要同时讲结构和传输。结构不清楚，传输路径就没有落点；箭头不清楚，机制就讲不出来。

***

### 07｜化学合成路线图：小分子药物多步合成

这一组是 Nano Banana 翻车最明显的一组。

化学路线图不是“画几个分子”就行，它对反应条件、结构变化、产率、催化循环都有比较高要求。

**GPT Image 2 效果图**

{% asset_img 13.webp %}

**Nano Banana 效果图**

{% asset_img 14.webp %}

**本次提示词**

```
Create a professional chemistry research figure showing a multi-step synthetic route for a hypothetical small-molecule kinase inhibitor. Show starting material, three key intermediates, reaction arrows, concise reaction conditions, catalysts, yields, and final target compound. Add a small side panel summarizing a key catalytic cycle. Use a clean white-background journal reaction-scheme layout with compact spacing, consistent typography, and restrained colors.
```

**Nature 编辑评价**

Claude 给 GPT 33 分，Nano 只有 16 分。

这也提醒我们：化学图、真实数据图、精确结构图，AI 目前仍然不能直接当最终稿。它可以帮你搭视觉方案，但最终还是要回到专业工具里核对。

**这一组小结**

越是精确学科图，越不能只看“像不像”。结构、条件、产率、原子连接这些内容，都需要人工专业校对。

***

### 08｜AI 架构图：科研 Agent 从文献检索到报告生成

这类图对 AI 模型其实很友好。

因为它本质上是模块、箭头、输入输出、反馈环。

**GPT Image 2 效果图**

{% asset_img 15.webp %}

**Nano Banana 效果图**

{% asset_img 16.webp %}

**本次提示词**

```
Create a professional AI research-agent architecture diagram. Show user research question input, literature search module, paper retrieval and ranking, citation graph analysis, note extraction, evidence synthesis, draft report generation, human review, and final manuscript-ready output. Use a modular system-architecture layout with boxes, arrows, data stores, and feedback loops. Keep it clean, publication-ready, and suitable for an AI methods paper.
```

**Nature 编辑评价**

GPT 的优势在于阶段编号和颜色分区。

Nano Banana 也画出了核心模块，但箭头走向、反馈环、数据存储的表达没有那么清楚。如果是 AI 论文方法图，我会更倾向 GPT 这一版。

**这一组小结**

AI 架构图不要追求“科技感”。真正重要的是输入是什么、模块有哪些、数据流怎么走、输出是什么。

***

### 09｜环境科学过程图：微塑料从城市径流进入河流和海洋

环境过程图考验“大尺度叙事”。

从城市源头到河流，再到海洋和食物网，读者必须一眼看到空间路径。

**GPT Image 2 效果图**

{% asset_img 17.webp %}

**Nano Banana 效果图**

{% asset_img 18.webp %}

**本次提示词**

```
Create a scientific process overview figure showing microplastic transport from urban runoff into rivers and the ocean. Show sources such as road dust, synthetic textiles, plastic waste, stormwater drains, wastewater treatment, river transport, sediment deposition, marine uptake, and food-web exposure. Use a landscape process-flow layout from city to river to ocean, with clear arrows, restrained colors, and sparse academic labels.
```

**Nature 编辑评价**

GPT 这张比较符合“从城市到海洋”的空间阅读顺序。

Nano Banana 内容也丰富，但切成多个 panel 后，连续迁移路径被打断了。对于环境科学这类“大过程”，连续性很重要。

**这一组小结**

环境过程图最好写清楚来源、传输路径、沉积或暴露位置，以及最终生态结果。

***

### 10｜社会科学研究设计图：在线学习干预随机对照实验

最后我特意选了一个非理工场景。

很多人以为科研绘图只属于医学、材料、生物，其实社会科学、教育心理、管理学也经常需要研究设计图。

**GPT Image 2 效果图**

{% asset_img 19.webp %}

**Nano Banana 效果图**

{% asset_img 20.webp %}

**本次提示词**

```
Create a clean research design diagram for a randomized controlled trial of an online learning intervention. Show participant recruitment, baseline survey, random assignment, intervention group using an adaptive learning platform, control group using standard materials, post-test assessment, follow-up survey, and outcome analysis for learning gains and engagement. Use a CONSORT-inspired flowchart style with clear branches, minimal labels, and a professional social-science journal aesthetic.
```

**Nature 编辑评价**

GPT Image 2 这里又赢得比较明显。它更像 CONSORT 风格研究流程图，随机分组、干预组、对照组、随访、结局分析都比较规整。

Nano Banana 的人物插画更亲和，但占了太多空间，对严肃研究设计图来说，信息密度不够。

**这一组小结**

社会科学研究设计图也需要科研图逻辑。招募、随机分组、干预、随访、结局分析，这些节点必须清楚。

***

### 这轮测试给我的最大感受

但如果你把标准换成 Nature 编辑视角，就会发现 AI 科研图真正难的不是生成，而是：能不能把科研逻辑稳定地画清楚。

这次 GPT Image 2 的优势主要集中在三点。

第一，流程更稳。它更容易按编号、分支、模块去组织画面。

第二，文字和标注更可控。虽然还不能说完全没有问题，但整体比 Nano Banana 更接近论文图需求。

第三，论文感更强。白底、低饱和配色、简洁结构、稀疏标注，这些都更接近真正可以放进文章或综述里的图。

Nano Banana 的优势则在于：它生成速度通常更轻快，画面更有概念感，对一些早期脑暴、视觉草图、风格探索仍然有价值。

我在实际的科研场景不会只锁定一个大模型的能力，对于画图场景，我往往会同时使用两个模型，通过「赛马」机制选取最符合自己品味和要求的那张图。

***

### 但问题来了：科研人真的要自己到处切模型吗？

这也是我做完这次评测后，最想说的一点。

今天 GPT Image 2 在这 10 个场景里表现更稳，但这并不代表我们以后永远只用一个模型。

因为模型会更新，任务也会变化。

有的场景可能需要 GPT 的结构能力，有的场景可能需要 Nano Banana 的速度和风格探索，有的场景可能还要用其他图像模型来做参考风格、局部重绘、草图扩展。

除了大模型「选择恐惧症」以外，我还观察到我们实验室的同学存在以下「困境」：

1. 没有一个稳定的GPT和Gemin账号；
2. 多个平台充值，成本太高；
3. GPT和Gemini生成的图没有办法微调；每次修改一部分都需要重新「抽卡」。
4.无法导出图片为SVG；导出为可编辑PPT。
5. 不会写准确的提示词

***

### 原文链接

> <https://mp.weixin.qq.com/s/tqtTeUn8GOiiUn2FgjqFeA>
