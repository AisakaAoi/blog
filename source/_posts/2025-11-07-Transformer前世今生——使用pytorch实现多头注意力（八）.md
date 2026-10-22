---
title: Transformer前世今生——使用pytorch实现多头注意力（八）
date: 2025-11-07 02:58
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: 80690fd3
tags:
---

随着AI市场，生成模型的投资热，小编在这里也开了一个Transformer的讲解系列，因为目前主流的大模型其核心都是Transformer，attention is all you need.本系列将介绍Transformer的算法原理以及使用pytorch的实现.

本节我们要学习如何使用pytorch实现多头注意力。

<!--more-->

## 用 PyTorch 实现多头注意力（Multi-Head Attention）

### 🧠 一、概念简介：我们要实现什么？

在本教程中，我们将一步步用 PyTorch 实现：

1. 一个通用的 **Attention 类** → 可执行三种注意力：

  - 自注意力（Self-Attention）
  - 掩蔽自注意力（Masked Self-Attention）
  - 编码器-解码器注意力（Encoder-Decoder Attention）

2. 一个 **Multi-Head Attention 类** → 模拟 Transformer 中多个“头”同时计算注意力的机制。

### 🧩 二、导入 PyTorch 模块

```python
import torch
import torch.nn as nn
import torch.nn.functional as F
```

torch: 提供张量和计算操作
torch.nn: 提供网络模块（nn.Module, nn.Linear）
torch.nn.functional: 提供函数接口（如 F.softmax()）

### 🏗️ 三、实现 Attention 类

该类可执行三种注意力机制：

Self-Attention

Masked Self-Attention

Encoder-Decoder Attention

```python
class Attention(nn.Module):
def __init__(self, d_model=2, row_dim=0, col_dim=1):
        super().__init__()

# 定义线性变换矩阵 W_Q, W_K, W_V
        self.W_q = nn.Linear(d_model, d_model, bias=False)
        self.W_k = nn.Linear(d_model, d_model, bias=False)
        self.W_v = nn.Linear(d_model, d_model, bias=False)
        self.row_dim = row_dim
        self.col_dim = col_dim

def forward(self, encodings_for_q, encodings_for_k, encodings_for_v, mask=None):
# 1️⃣ 生成 Q, K, V
        q = self.W_q(encodings_for_q)
        k = self.W_k(encodings_for_k)
        v = self.W_v(encodings_for_v)

# 2️⃣ 计算相似度矩阵 Q × Kᵀ
        sims = torch.matmul(q, k.transpose(dim0=self.row_dim, dim1=self.col_dim))

# 3️⃣ 缩放（Scale）
        scaled_sims = sims / torch.tensor(k.size(self.col_dim)**0.5)

# 4️⃣ 掩蔽（Masked Attention）
if mask isnotNone:
            scaled_sims = scaled_sims.masked_fill(mask=mask, value=-1e9)

# 5️⃣ Softmax 归一化
        attention_percents = F.softmax(scaled_sims, dim=self.col_dim)

# 6️⃣ 加权求和输出
        attention_scores = torch.matmul(attention_percents, v)

return attention_scores
```

### 🧩 核心思想：

使用 Query、Key、Value 三个矩阵计算注意力权重：

Attention(Q,K,V) = softmax\left(\frac{QK^T}{\sqrt{d_k}}\right)V ]

QKᵀ 计算相关性，Softmax 转为权重，乘以 V 得出上下文表示。

### 🧮 四、测试 Encoder-Decoder Attention

#### 4.1 三组输入编码（Query, Key, Value）

```python
encodings_for_q = torch.tensor([[1.16, 0.23],
                                [0.57, 1.36],
                                [4.41, -2.16]])
encodings_for_k = torch.tensor([[1.16, 0.23],
                                [0.57, 1.36],
                                [4.41, -2.16]])
encodings_for_v = torch.tensor([[1.16, 0.23],
                                [0.57, 1.36],
                                [4.41, -2.16]])
torch.manual_seed(42)
```

#### 4.2 创建 Attention 对象

```python
attention = Attention(d_model=2, row_dim=0, col_dim=1)
```

#### 4.3 计算 Encoder-Decoder Attention

```python
print(attention(encodings_for_q, encodings_for_k, encodings_for_v))
```

输出结果：

```
lua
Copy code
tensor([[1.0100, 1.0641],
        [0.2040, 0.7057],
        [3.4989, 2.2427]])
```

成功计算 Encoder-Decoder Attention！

### 🧠 五、实现 Multi-Head Attention 类

多头注意力（Multi-Head Attention） 的原理：

同时创建多个独立的 Attention 头，每个头学习不同的注意力模式，最后将结果拼接（concatenate）在一起。

```python
class MultiHeadAttention(nn.Module):
def __init__(self, d_model=2, row_dim=0, col_dim=1, num_heads=1):
        super().__init__()

# 创建多个注意力头（Attention 实例）
        self.heads = nn.ModuleList(
            [Attention(d_model, row_dim, col_dim) for _ in range(num_heads)]
        )

        self.col_dim = col_dim

def forward(self, encodings_for_q, encodings_for_k, encodings_for_v):
# 将输入依次传入各个 head，并拼接结果
return torch.cat(
            [head(encodings_for_q, encodings_for_k, encodings_for_v)
for head in self.heads],
            dim=self.col_dim
        )
```

### 🔢 六、验证 Multi-Head Attention

（1）单头测试

```python
torch.manual_seed(42)
multiHeadAttention = MultiHeadAttention(d_model=2, row_dim=0, col_dim=1, num_heads=1)
print(multiHeadAttention(encodings_for_q, encodings_for_k, encodings_for_v))
```

输出：

```
lua
Copy code
tensor([[1.0100, 1.0641],
        [0.2040, 0.7057],
        [3.4989, 2.2427]])
```

结果与单个 Attention 一致 ✅


（2）双头测试

```python
torch.manual_seed(42)
multiHeadAttention = MultiHeadAttention(d_model=2, row_dim=0, col_dim=1, num_heads=2)
print(multiHeadAttention(encodings_for_q, encodings_for_k, encodings_for_v))
```

输出：

```
lua
Copy code
tensor([[ 1.0100,  1.0641, -0.7081, -0.8268],
        [ 0.2040,  0.7057, -0.7417, -0.9193],
        [ 3.4989,  2.2427, -0.7190, -0.8447]])
```

✅ 输出列数翻倍（每个头输出 2 个值）

说明两个注意力头成功并行计算。

### 七、核心思想回顾

多头注意力 = 多个独立的 Attention + 拼接输出 每个头学习不同的语义模式，如：

一个头关注短距离关系；

一个头关注句法结构；

一个头关注情感或上下文。

最终通过线性层组合结果，让模型能从多个视角理解输入。

### 一句话总结

多头注意力让模型拥有多双“眼睛”， 每个头专注不同的语义视角， 最终融合成更全面的理解 —— 这就是 Transformer 的强大之处。

### 📘 参考资料

Vaswani et al. (2017) Attention Is All You Need

Josh Starmer: Coding Attention in PyTorch

Jay Alammar: Illustrated Transformer

《动手学深度学习》第10章 注意力机制

### 原文链接

> <https://mp.weixin.qq.com/s/OqQFRyANdSi2cen5jkG3jA>
