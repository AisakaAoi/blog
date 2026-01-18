---
title: ACL 2025最佳论文奖：北大与 DeepSeek 联合打造 NSA 全新注意力机制
categories:
  - 🌙进阶学习
  - ⭐脑机接口与混合智能研究团队（BCI团队）
  - 💫学习报告
abbrlink: 38c82fcd
date: 2025-08-19 07:30:53
tags:
---

{% asset_img 1.webp %}

该论文发表于计算机语言学顶级会议 Association for Computational Linguistics (ACL) 2025年主会长文 （CCF-A）并荣获 ACL 2025会议最佳论文奖，题目为 《Native Sparse Attention: Hardware-Aligned and Natively Trainable Sparse Attention》。

第一作者为来自 北京大学计算机学院 的 袁境阳博士，通讯作者包括 北京大学计算机学院 的 张铭教授 以及 DeepSeek-AI 的 梁文锋 和 曾旺钉。

论文链接： https://aclanthology.org/2025.acl-long.1126/

<!--more-->

***

### 论文概要

该研究针对下一代语言模型中长上下文处理的效率瓶颈，即标准注意力机制带来的巨大计算挑战，提出了一个名为NSA (Natively trainable Sparse Attention) 的全新稀疏注意力方案。现有稀疏注意力方法虽有前景，但在实际应用中常面临理论与实践速度不匹配、且大多不支持高效训练的问题。为解决此困境，NSA通过算法与硬件的协同设计，首创性地提出了一种动态分层稀疏策略。该策略结合了粗粒度的token压缩（Token Compression）与细粒度的token选择（Token Selection），在保持全局上下文感知力的同时，确保了局部信息的精确性。研究团队通过该机制不仅在模型性能上媲美甚至超越了全注意力（Full Attention）基线，更重要的是，在解码、前向和后向传播等各个阶段均实现了数倍的计算加速，验证了其在模型整个生命周期中的高效性与实用价值。

***

### 研究背景

近年来，长上下文建模能力已成为衡量下一代大语言模型（LLM）核心竞争力的关键指标，其应用遍及深度推理、代码库级别生成和多轮智能体系统等多个前沿领域。然而，随着序列长度的增加，标准注意力机制的二次方复杂度（O(n2)）成为制约模型延迟和成本的主要原因。理论分析指出，在处理64k长度的上下文时，注意力计算的耗时占比可高达70%-80%。

利用注意力矩阵的内在稀疏性，选择性地计算关键的“查询-键”（Query-Key）对，是解决该问题的自然思路。尽管社区已提出多种稀疏化方案，如KV缓存驱逐、块状选择、哈希采样等，但它们普遍存在两大局限性：
1. 硬件协同的推理加速不足：许多方法虽然在理论上减少了计算量，但由于其内存访问模式不规则，难以充分利用现代GPU（如Tensor Core）的计算能力，导致实际推理速度提升有限。
2. 缺乏训练意识的算法设计：绝大多数稀疏方法仅在推理阶段应用，模型本身仍在全注意力模式下预训练。这不仅导致训练成本高昂，也使得模型无法在训练阶段学习和适应稀疏模式，可能引发性能下降。

这些局限性导致现有方法难以在真实世界的长上下文训练和推理任务中实现高效部署。

***

### 方法

{% asset_img 2.webp %}
<div align='center'>图 1 NSA 架构概述。</div>

1. 核心思路

如图1所示，NSA的核心思想是设计一种原生可训练的稀疏注意力架构 (Natively trainable Sparse Attention)，通过层级化的token建模 (hierarchical token modeling) 和硬件对齐的优化 (hardware-aligned optimizations)，实现高效的长文本建模。该方法的灵感源于两个关键洞察：首先是注意力分数的内在稀疏性，即仅有少数query-key对是重要的；其次是对硬件效率的追求，旨在充分利用现代GPU的特性（如Tensor Core）和FlashAttention的设计原则。

其主要创新点体现在两个方面：

硬件对齐的系统 (Hardware-aligned system)：通过平衡算术强度 (arithmetic intensity-balanced) 的算法设计，优化块状稀疏注意力，以最大化Tensor Core利用率和内存访问效率。

训练感知的设计 (Training-aware design)：通过高效的算法和可微分的反向传播算子，实现稳定的端到端训练，从而降低预训练成本且不牺牲模型性能。

2. 方案与技术

**整体框架：**

NSA的整体框架将输入的键（key）和值（value）组织成时间块（temporal blocks），并通过三个并行的注意力分支进行处理：压缩的粗粒度token (compressed coarse-grained tokens)、选择性保留的细粒度token (selectively retained fine-grained tokens) 和 滑动窗口 (sliding windows)。最终，各分支的输出通过一个学习到的门控机制进行聚合。为了最大化实际效率，该框架还配备了专门设计的计算内核（Kernel）。

**三大核心模块：**

- **token压缩 (Token Compression)**：此模块将连续的key/value块聚合为块级别的表示，旨在“捕获粗粒度的语义信息，并减少计算负担 (capture coarser-grained higher-level semantic information and reduce computational burden)”。
- **token选择 (Token Selection)**：此模块有选择地保留重要的原始token，以“弥补压缩可能带来的细粒度信息损失 (might lose important fine-grained information)”。其实现包含以下几个关键步骤：
- **块状选择 (Blockwise Selection)**：基于空间连续的块来处理key和value序列，而非单个token。这既符合硬件高效访问的原则，也顺应了注意力分数呈现块状分布的内在模式。
- **重要性分数计算 (Importance Score Computation)**：其核心创新在于，直接“利用压缩token的注意力计算所产生的中间注意力分数，来作为选择块的重要性评分 (leverage intermediate attention scores from compression tokens to induce selection block importance scores)”，从而避免了任何额外计算。
- **Top-n 块选择 (Top-n Block Selection)**：根据计算出的块重要性分数进行排序，并保留排名最高的n个稀疏块内的所有token参与后续的注意力计算。
- **滑动窗口 (Sliding Window)**：此模块通过一个专门处理局部上下文的滑动窗口分支，来解决“局部模式可能主导学习过程 (local patterns typically adapt faster and can dominate the learning process)”的问题。它维护一个包含最近token的窗口，并将局部、压缩、选择这三种不同信息源的注意力计算隔离到独立的分支中，最后通过门控机制聚合，确保了学习的稳定性。

**内核设计 (Kernel Design)：**

为了在训练和预填充阶段达到FlashAttention级别的速度，团队基于Triton实现了一个硬件对齐的稀疏注意力内核，尤其针对GQA和MQA架构下的稀疏选择注意力进行了专门设计。

其主要特点包括：
- **以GQA组为中心的加载 (Group-Centric Data Loading)**：在循环中，一次性加载GQA组内所有头的查询（queries）及其共享的稀疏key/value块索引。
- **共享的KV获取 (Shared KV Fetching)**：根据索引，顺序加载连续的key/value块到SRAM中，以最小化内存加载开销。
- **基于Grid的外部循环 (Outer Loop on Grid)**：将query/output循环置于Triton的Grid调度器中，以简化和优化内核，因为内部循环的长度（即选择的块数量）对于不同query块几乎是恒定的。

***

### 结果

研究团队在一个27B参数、采用GQA和MoE架构的骨干网络上，对NSA和全注意力基线进行了270Btoken的预训练，并在多个维度进行了评测。

<div align='center'>表 1 在一般基准上对完全注意力基线和 NSA 进行预训练性能比较。</div>
{% asset_img 3.webp %}

1. 通用基准评测 (表1)

**内容解读**：该表比较了NSA与全注意力基线在9个通用基准上的表现，涵盖知识（MMLU）、推理（GSM8K, MATH）和代码（HumanEval）等多个方面。

**核心发现**：“尽管具有高稀疏性，NSA在大多数基准上取得了优越的平均性能”。具体而言，NSA在9项指标中的7项上超越了全注意力模型，尤其在DROP（+4.2%）和GSM8K（+3.4%）等需要复杂推理的任务上优势明显。这表明，NSA的稀疏预训练机制迫使模型关注最重要的信息，可能通过过滤无关注意力路径的噪声来提升性能。

<div align='center'>表 2 NSA 与 LongBench 上的基准性能比较。</div>
{% asset_img 4.webp %}

2. 长上下文评测 (表2)

**内容解读**：该表在LongBench基准上将NSA与包括H2O、InfLLM、Quest在内的多种SOTA稀疏方法及全注意力模型进行对比。为保证公平，所有稀疏方法的token激活数量被设定为相同水平。

**核心发现**：NSA取得了最高的平均分（0.469），显著超越了全注意力（+3.2%）和表现次优的Exact-Top（+4.6%）。这一优势源于其原生稀疏训练使得注意力模块与模型其他部分能够协同适应，以及其分层机制在局部和全局信息处理间取得了更好的平衡。特别地，NSA在需要复杂推理的长上下文任务上表现卓越，如多跳问答（HPQ, 2Wiki）和代码理解（LCC）。此外，在“大海捞针”测试中，NSA在64k上下文中实现了100%的完美检索成功率。

<div align='center'>表 3 监督微调后的基于 AIME 指令的评估。</div>
{% asset_img 5.webp %}

3. 思维链推理评测 (表3)

**内容解读**：为了评估NSA对下游高级训练范式的兼容性，该表比较了经过10B数学推理数据微调后的NSA-R与Full Attention-R模型在AIME数学竞赛基准上的表现。

**核心发现**：在8k和16k两种生成长度限制下，NSA-R的准确率均显著高于Full Attention-R（分别高出7.5%和5.4%）。“这些结果验证了预训练的稀疏注意力能够有效捕捉对复杂数学推导至关重要的长距离逻辑依赖 (These results validate the pretrained sparse attention enable efficient capture of long-range logical dependencies)”。

<div align='center'>表 4 解码过程中每次注意操作的内存访问量。</div>
{% asset_img 6.webp %}

4. 效率分析 (表4)

**内容解读**：表4量化了在不同上下文长度下，单步解码操作所需的内存访问量（以等效token数计）。图5则展示了基于Triton实现的NSA内核与FlashAttention-2内核在前向和后向传播上的耗时对比。

**核心发现**：

**解码速度** (表4)：解码过程是内存带宽受限的。NSA通过将64k序列的KV缓存加载量从65536个token锐减至5632个，实现了高达11.6倍的理论解码加速。

**训练与预填充速度**：得益于硬件协同的内核设计，在处理64k长度的序列时，NSA实现了惊人的9.0倍前向传播加速和6.0倍后向传播加速。加速比随序列增长而愈发显著

***

### 结论

本研究通过构建一个硬件感知、原生可训练的稀疏注意力架构NSA，成功解决了长上下文建模中的核心效率瓶颈。研究证明，通过算法与硬件的深度协同设计，稀疏注意力不仅可以在训练和推理的全生命周期中实现数量级的加速，还能在模型性能上达到甚至超越密集的全注意力模型。

NSA的贡献在于，它不仅为学术界和工业界提供了一个兼具高性能和高效率的实用长上下文解决方案，更重要的是，它证明了原生稀疏训练是释放大模型长程推理潜力的关键路径。这项工作为下一代高效、强大的长上下文LLM的研发设定了新的标准，并指明了前进的方向。

***

### 原文链接

> <https://www.scholat.com/teamwork/showPostMessage.html?id=17255>
