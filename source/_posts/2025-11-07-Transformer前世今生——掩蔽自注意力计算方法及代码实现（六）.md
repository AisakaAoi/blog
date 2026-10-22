---
title: Transformer前世今生——掩蔽自注意力计算方法及代码实现（六）
date: 2025-11-07 02:37
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: ea0c352e
tags:
---

随着AI市场，生成模型的投资热，小编在这里也开了一个Transformer的讲解系列，因为目前主流的大模型其核心都是Transformer，attention is all you need.本系列将介绍Transformer的算法原理以及使用pytorch的实现.

本节我们要学习掩蔽自注意力**masked self-attention**的计算方法。

<!--more-->

### Step1.

和之前一样，我们首先要计算三个矩阵：

**查询矩阵 Q (Query) 键矩阵 K (Key) 值矩阵 V (Value)**

例如，对于提示词（prompt）：

“write a poem”（写一首诗）

{% asset_img 2.webp %}

Transformer 首先为每个词生成词嵌入（word embeddings）， 然后添加位置编码（positional encoding），得到最终的编码向量。

接下来，我们计算：

Q（查询矩阵）、K（键矩阵）和 V（值矩阵）

### Step2.

我们像以前一样计算查询和键之间的相似度矩阵（similarities）， 再将它们进行缩放（scale）。

接着，将**掩码矩阵 M** 加到缩放后的相似度矩阵上。

掩码矩阵的作用是：

**防止某个 token（词）在计算注意力时看到它后面的内容**。

举个例子：

Prompt: “write a poem”

我们希望：

第一个 token “write” 只能看到自己，不能看到 “a poem”

第二个 token “a” 能看到 “write” 和自己，但不能看到 “poem”

第三个 token “poem” 能看到所有词（因为它是最后一个）

掩码矩阵 M 的结构

掩码矩阵看起来大致如下：

0 表示保留（不掩盖）

−∞（负无穷） 表示掩盖（mask）

当我们把这个掩码矩阵加到缩放相似度矩阵上时：

加 0 的位置保持不变；

加 −∞ 的位置变成 −∞。

### Step3.

接下来，我们对每一行应用 Softmax 函数。 由于 **Softmax 会让 −∞ 的位置变为 0 权重**：

第一个 token “write”： 只有对自己的相似度为 100%，对后面的词为 0%。

第二个 token “a”： 对自己和“write”有相似度，对“poem”为 0%。

第三个 token “poem”： 对所有词都有相似度。

### Step4.

最后，我们将这些注意力权重乘以值矩阵 V，得到最终的掩蔽自注意力输出。

结果如下：

“write” 的输出只包含它自己；

“a” 的输出包含 “write” 和 “a”；

“poem” 的输出包含全部词的信息。

### Step5.

{% asset_img 3.webp %}

首先添加需要用到的库

```python
import torch # torch let's us create tensors and also provides helper functions
import torch.nn as nn # torch.nn gives us nn.module() and nn.Linear()
import torch.nn.functional as F # This gives us the softmax()
```

编写掩码注意力代码

```python
class MaskedSelfAttention(nn.Module):
def __init__(self, d_model=2,  
                 row_dim=0, 
                 col_dim=1):

        super().__init__()

        self.W_q = nn.Linear(in_features=d_model, out_features=d_model, bias=False)
        self.W_k = nn.Linear(in_features=d_model, out_features=d_model, bias=False)
        self.W_v = nn.Linear(in_features=d_model, out_features=d_model, bias=False)

        self.row_dim = row_dim
        self.col_dim = col_dim

def forward(self, token_encodings, mask=None):

        q = self.W_q(token_encodings)
        k = self.W_k(token_encodings)
        v = self.W_v(token_encodings)

        sims = torch.matmul(q, k.transpose(dim0=self.row_dim, dim1=self.col_dim))

        scaled_sims = sims / torch.tensor(k.size(self.col_dim)**0.5)

if mask is not None:
## Here we are masking out things we don't want to pay attention to
##
## We replace values we wanted masked out
## with a very small negative number so that the SoftMax() function
## will give all masked elements an output value (or "probability") of 0.
            scaled_sims = scaled_sims.masked_fill(mask=mask, value=-1e9) 
# I've also seen -1e20 and -9e15 used in masking
        attention_percents = F.softmax(scaled_sims, dim=self.col_dim)
        attention_scores = torch.matmul(attention_percents, v)
return attention_scores
```

计算掩码注意力

```python
## create a matrix of token encodings...
encodings_matrix = torch.tensor([[1.16, 0.23],
                                 [0.57, 1.36],
                                 [4.41, -2.16]])

## set the seed for the random number generator
torch.manual_seed(42)

## create a masked self-attention object
maskedSelfAttention = MaskedSelfAttention(d_model=2,
                               row_dim=0,
                               col_dim=1)

## create the mask so that we don't use
## tokens that come after a token of interest
mask = torch.tril(torch.ones(3, 3))
mask = mask == 0
mask # print out the mask
```

输出

```
tensor([[False,  True,  True],
        [False, False,  True],
        [False, False, False]])
```

```python
## calculate masked self-attention
maskedSelfAttention(encodings_matrix, mask)
```

输出

```
tensor([[ 0.6038,  0.7434],
        [-0.0062,  0.6072],
        [ 3.4989,  2.2427]], grad_fn=<MmBackward0>)
```

打印权重值并验证计算结果

```python
## print out the weight matrix that creates the queries
maskedSelfAttention.W_q.weight.transpose(0, 1)
输出
tensor([[ 0.5406, -0.1657],
        [ 0.5869,  0.6496]], grad_fn=<TransposeBackward0>)

## print out the weight matrix that creates the queries
maskedSelfAttention.W_q.weight.transpose(0, 1)
输出
tensor([[ 0.5406, -0.1657],
        [ 0.5869,  0.6496]], grad_fn=<TransposeBackward0>)


## print out the weight matrix that creates the keys
maskedSelfAttention.W_k.weight.transpose(0, 1)
输出
tensor([[-0.1549, -0.3443],
        [ 0.1427,  0.4153]], grad_fn=<TransposeBackward0>)


## print out the weight matrix that creates the values
maskedSelfAttention.W_v.weight.transpose(0, 1)
tensor([[ 0.6233,  0.6146],
        [-0.5188,  0.1323]], grad_fn=<TransposeBackward0>)

## calculate the queries
maskedSelfAttention.W_q(encodings_matrix)
tensor([[ 0.7621, -0.0428],
        [ 1.1063,  0.7890],
        [ 1.1164, -2.1336]], grad_fn=<MmBackward0>)

## calculate the keys
maskedSelfAttention.W_k(encodings_matrix)
tensor([[-0.1469, -0.3038],
        [ 0.1057,  0.3685],
        [-0.9914, -2.4152]], grad_fn=<MmBackward0>)

## calculate the values
maskedSelfAttention.W_v(encodings_matrix)
tensor([[ 0.6038,  0.7434],
        [-0.3502,  0.5303],
        [ 3.8695,  2.4246]], grad_fn=<MmBackward0>)

q = maskedSelfAttention.W_q(encodings_matrix)
q
输出
tensor([[ 0.7621, -0.0428],
        [ 1.1063,  0.7890],
        [ 1.1164, -2.1336]], grad_fn=<MmBackward0>)

k = maskedSelfAttention.W_k(encodings_matrix)
k
tensor([[-0.1469, -0.3038],
        [ 0.1057,  0.3685],
        [-0.9914, -2.4152]], grad_fn=<MmBackward0>)

sims = torch.matmul(q, k.transpose(dim0=0, dim1=1))
sims
tensor([[-0.0990,  0.0648, -0.6523],
        [-0.4022,  0.4078, -3.0024],
        [ 0.4842, -0.6683,  4.0461]], grad_fn=<MmBackward0>)


scaled_sims = sims / (torch.tensor(2)**0.5)
scaled_sims
tensor([[-0.0700,  0.0458, -0.4612],
        [-0.2844,  0.2883, -2.1230],
        [ 0.3424, -0.4725,  2.8610]], grad_fn=<DivBackward0>)

masked_scaled_sims = scaled_sims.masked_fill(mask=mask, value=-1e9)
masked_scaled_sims
tensor([[-6.9975e-02, -1.0000e+09, -1.0000e+09],
        [-2.8442e-01,  2.8833e-01, -1.0000e+09],
        [ 3.4241e-01, -4.7253e-01,  2.8610e+00]],
       grad_fn=<MaskedFillBackward0>)

attention_percents = F.softmax(masked_scaled_sims, dim=1)
attention_percents
tensor([[1.0000, 0.0000, 0.0000],
        [0.3606, 0.6394, 0.0000],
        [0.0722, 0.0320, 0.8959]], grad_fn=<SoftmaxBackward0>)

torch.matmul(attention_percents, maskedSelfAttention.W_v(encodings_matrix))
tensor([[ 0.6038,  0.7434],
        [-0.0062,  0.6072],
        [ 3.4989,  2.2427]], grad_fn=<MmBackward0>)
```

### 原文链接

> <https://mp.weixin.qq.com/s/DDJXuPv_jSM-7OGzAcPllw>
