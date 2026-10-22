---
title: Transformer前世今生——Pytorch代码实现（四）
date: 2025-10-23 03:52
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: b77dd16f
tags:
---

随着AI市场，生成模型的投资热，小编在这里也开了一个Transformer的讲解系列，因为目前主流的大模型其核心都是Transformer，attention is all you need.本系列将介绍Transformer的算法原理以及使用pytorch的实现.

在本教程中，我们将使用 PyTorch 编写 自注意力（Self-Attention） 模块。

<!--more-->

注意力机制（Attention）是神经网络中 Transformer 架构的关键组成部分，而 Transformer 正是当前大型语言模型（LLM）和人工智能（AI）热潮的核心驱动力。

特别是，下面所示的这种仅包含编码器（Encoder-Only）的 Transformer 架构，构成了知名模型 BERT 的基础。

{% asset_img 2.webp %}

BERT 的核心是 自注意力机制（Self-Attention）。 它使模型能够在输入中的单词、字符和符号之间建立联系，这些元素统称为 Token（标记）。

{% asset_img 3.webp %}

例如，在下图的示例中，单词 “it” 可能指代 “pizza” 或 “oven”。 通过注意力机制（Attention），Transformer 可以帮助模型正确地建立 “it” 与 “pizza” 之间的语义关联。

```
class SelfAttention(nn.Module): 
    def __init__(self, d_model=2,  
                 row_dim=0, 
                 col_dim=1):
        ## d_model = the number of embedding values per token.
        ##           Because we want to be able to do the math by hand, we've
        ##           the default value for d_model=2.
        ##           However, in "Attention Is All You Need" d_model=512
        ##
        ## row_dim, col_dim = the indices we should use to access rows or columns
        super().__init__()
        ## Initialize the Weights (W) that we'll use to create the
        ## query (q), key (k) and value (v) for each token
        ## NOTE: A lot of implementations include bias terms when
        ##       creating the the queries, keys, and values, but
        ##       the original manuscript that described Attention,
        ##       "Attention Is All You Need" did not, so we won't either
        
#我们用
 nn.Linear 创建三个线性层，分别计算 Query、Key、Value
        self.W_q = nn.Linear(in_features=d_model, out_features=d_model, bias=False)
        self.W_k = nn.Linear(in_features=d_model, out_features=d_model, bias=False)
        self.W_v = nn.Linear(in_features=d_model, out_features=d_model, bias=False)
        self.row_dim = row_dim
        self.col_dim = col_dim
    def forward(self, token_encodings):
        ## Create the query, key and values using the encoding numbers
        ## associated with each token (token encodings)
        q = self.W_q(token_encodings)
        k = self.W_k(token_encodings)
        v = self.W_v(token_encodings)
        ## 计算相似度 Q × KᵀCompute similarities scores: (q * k^T) 
        sims = torch.matmul(q, k.transpose(dim0=self.row_dim, dim1=self.col_dim))
        #
#按
 √d_k 缩放 Scale the similarities by dividing by sqrt(k.col_dim)
        scaled_sims = sims / torch.tensor(k.size(self.col_dim)**0.5)
        ## Apply softmax to determine what percent of each tokens' value to
        ## 用权重加权 Vuse in the final attention values.
        attention_percents = F.softmax(scaled_sims, dim=self.col_dim)
        ## Scale the values by their associated percentages and add them up.
        attention_scores = torch.matmul(attention_percents, v)
        return attention_scores

# Create a matrix of token encodings
# 创建一个 token 编码矩阵（每行表示一个词的编码向量）
encodings_matrix = torch.tensor([
    [1.16, 0.23],   # 第1个词的 embedding 向量 (token 1)
    [0.57, 1.36],   # 第2个词的 embedding 向量 (token 2)
    [4.41, -2.16]   # 第3个词的 embedding 向量 (token 3)
])
# Set the seed for the random number generator
# 设置随机数种子，以便结果可复现
torch.manual_seed(42)
# Create a basic self-attention object
# 创建一个基本的自注意力（Self-Attention）对象
selfAttention = SelfAttention(
    d_model=2,   # 模型维度（每个 token 的 embedding 大小为 2）
    row_dim=0,   # 行索引（可选参数，仅用于演示）
    col_dim=1    # 列索引（可选参数，仅用于演示）
)
# Calculate basic attention for the token encodings
# 对 token 编码矩阵执行自注意力计算
output = selfAttention(encodings_matrix)
# Print the output
# 打印自注意力的输出结果
print(output)
Output
tensor([[1.0100, 1.0641],
        [0.2040, 0.7057],
        [3.4989, 2.2427]], grad_fn=<MmBackward0>)

## print out the weight matrix that creates the queries
## 打印用于生成 Query 的权重矩阵（显示为转置后，便于与讲解一致）
selfAttention.W_q.weight.transpose(0, 1)  # Show W_q^T so its shape aligns with math notation / 为与数学记号对齐显示 W_q^T
# Output
# tensor([[ 0.5406, -0.1657],
#         [ 0.5869,  0.6496]], grad_fn=<TransposeBackward0>)
# ↑ These are the learned (currently random-initialized) linear weights for Q after transpose.
#   这是线性层 Q 的权重（当前为随机初始化）在转置后的数值表示。
## print out the weight matrix that creates the keys
## 打印用于生成 Key 的权重矩阵（同样以转置形式展示）
selfAttention.W_k.weight.transpose(0, 1)  # Show W_k^T / 显示 W_k^T
# tensor([[-0.1549, -0.3443],
#         [ 0.1427,  0.4153]], grad_fn=<TransposeBackward0>)
# ↑ Weights used to project embeddings into Key space.
#   用于将嵌入向量投影到 Key 空间的权重。
## print out the weight matrix that creates the values
## 打印用于生成 Value 的权重矩阵（转置）
selfAttention.W_v.weight.transpose(0, 1)  # Show W_v^T / 显示 W_v^T
# tensor([[ 0.6233,  0.6146],
#         [-0.5188,  0.1323]], grad_fn=<TransposeBackward0>)
# ↑ Weights used to project embeddings into Value space.
#   用于将嵌入向量投影到 Value 空间的权重。
## calculate the queries
## 计算 Query 矩阵 Q
selfAttention.W_q(encodings_matrix)  # Q = X @ W_q  / 通过线性层将编码投影到 Query 空间
## calculate the queries
## 再次计算 Q（结果相同；线性层是确定性的，未训练时权重不变）
selfAttention.W_q(encodings_matrix)  # Recompute Q; same weights -> same result / 重算 Q；权重相同所以结果一致
## calculate the queries
## 第三次计算 Q（演示重复调用的一致性）
selfAttention.W_q(encodings_matrix)  # Third computation for consistency / 第三次计算以示一致性
# tensor([[ 0.7621, -0.0428],
#         [ 1.1063,  0.7890],
#         [ 1.1164, -2.1336]], grad_fn=<MmBackward0>)
# ↑ Q has shape [3, 2] because we have 3 tokens and d_model=2.
#   Q 的形状是 [3, 2]，因为有 3 个 token 且 d_model=2。
## calculate the keys
## 计算 Key 矩阵 K
selfAttention.W_k(encodings_matrix)  # K = X @ W_k  / 通过线性层将编码投影到 Key 空间
# tensor([[-0.1469, -0.3038],
#         [ 0.1057,  0.3685],
#         [-0.9914, -2.4152]], grad_fn=<MmBackward0>)
# ↑ K has shape [3, 2] matching tokens × key_dim.
#   K 的形状为 [3, 2]，与“token 数 × key 维度”一致。
## calculate the values
## 计算 Value 矩阵 V
selfAttention.W_v(encodings_matrix)  # V = X @ W_v  / 通过线性层将编码投影到 Value 空间
# tensor([[ 0.6038,  0.7434],
#         [-0.3502,  0.5303],
#         [ 3.8695,  2.4246]], grad_fn=<MmBackward0>)
# ↑ V has shape [3, 2] (tokens × value_dim), used for weighted sum later.
#   V 的形状为 [3, 2]（token 数 × value 维度），用于后续加权求和。
q = selfAttention.W_q(encodings_matrix)  # Cache Q for reuse / 计算并缓存 Q，便于后续使用
q  # Inspect Q / 查看 Q
# tensor([[ 0.7621, -0.0428],
#         [ 1.1063,  0.7890],
#         [ 1.1164, -2.1336]], grad_fn=<MmBackward0>)
# ↑ Same Q as before; stored in variable `q`.
#   与前面一致的 Q，并存入变量 q。
k = selfAttention.W_k(encodings_matrix)  # Compute K / 计算 K
k = selfAttention.W_k(encodings_matrix)  # Recompute K (idempotent without training) / 再算一次 K（未训练时结果不变）
k  # Inspect K / 查看 K
# tensor([[-0.1469, -0.3038],
#         [ 0.1057,  0.3685],
#         [-0.9914, -2.4152]], grad_fn=<MmBackward0>)
# ↑ K ready for similarity computation (QK^T).
#   K 已就绪，用于相似度计算（QK^T）。
sims = torch.matmul(q, k.transpose(dim0=0, dim1=1))  # Compute unscaled similarities: Q @ K^T / 计算未缩放的相似度 QK^T
sims  # Inspect similarity scores / 查看相似度分数
# tensor([[-0.0990,  0.0648, -0.6523],
#         [-0.4022,  0.4078, -3.0024],
#         [ 0.4842, -0.6683,  4.0461]], grad_fn=<MmBackward0>)
# ↑ Each row i, column j is dot(Q_i, K_j): similarity of token i querying token j.
#   第 i 行第 j 列是 dot(Q_i, K_j)：第 i 个词对第 j 个词的相似度。
scaled_sims = sims / (torch.tensor(2)**0.5)  # Scale by sqrt(d_k); here d_k=2 / 按 √d_k 缩放，这里 d_k=2
scaled_sims  # Inspect scaled similarities / 查看缩放后的相似度
# tensor([[-0.0700,  0.0458, -0.4612],
#         [-0.2844,  0.2883, -2.1230],
#         [ 0.3424, -0.4725,  2.8610]], grad_fn=<DivBackward0>)
# ↑ Scaling stabilizes gradients and avoids overly peaky softmax.
#   缩放有助于稳定梯度，避免 softmax 过于尖锐。
attention_percents = F.softmax(scaled_sims, dim=1)  # Row-wise softmax -> attention distribution / 按行 softmax 得到注意力分布
attention_percents  # Inspect attention weights (rows sum to 1) / 查看注意力权重（每行和为 1）
# tensor([[0.3573, 0.4011, 0.2416],
#         [0.3410, 0.6047, 0.0542],
#         [0.0722, 0.0320, 0.8959]], grad_fn=<SoftmaxBackward0>)
# ↑ Row i gives how much token i attends to each token j (including itself).
#   第 i 行表示第 i 个词对各个词（含自身）的注意力权重。
torch.matmul(attention_percents, selfAttention.W_v(encodings_matrix))  # Weighted sum of V / 用注意力权重加权 V（得到输出）
# tensor([[1.0100, 1.0641],
#         [0.2040, 0.7057],
#         [3.4989, 2.2427]], grad_fn=<MmBackward0>)
# ↑ Final self-attention outputs per token (contextualized embeddings).
#   每个 token 的最终自注意力输出（上下文化后的表示）。
```

sims 是未缩放相似度，scaled_sims 为缩放后相似度，attention_percents 为注意力权重，最后乘以 V 得到上下文增强表示。

重复调用 W_q(X) / W_k(X) 的结果一致，是因为权重未更新（未训练阶段）。

### 原文链接

> <https://mp.weixin.qq.com/s/zUJtxTxy-u8-DRypkaGsPA>
