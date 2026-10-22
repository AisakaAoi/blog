---
title: 机器学习中的数学——蓄水池抽样算法（Reservoir Sampling Algorithm）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《机器学习中的数学》
  - ✨②概率论与数理统计
abbrlink: f18df406
date: 2022-10-18 21:03:35
---

蓄水池抽样算法（Reservoir Sampling Algorithm）解决了**未知长度数据的均匀抽样问题**，即：给定一个数据流，数据流长度$N$很大，且$N$直到处理完所有数据之前都不可知，请问如何在只遍历一遍数据的情况下，能够随机选取出$n$个不重复的数据，且每个数据被取到的概率都为$\frac{n}{N}$？

<!--more-->

这个问题有3个主要难点：

- 数据流长度$N$很大且不可知，不能一次性存入内存
- 算法时间复杂度为$O(N)$
- 随机选取$n$个数，每个数被选中的概率为$\frac{n}{N}$

第1点主要说明由于我们无法直接确定$N$，导致我们无法直接求出每个数被取到的概率$\frac{n}{N}$，也就不能直接取$N$内的$n$个随机数，然后按索引取出数据。第2点限制了不能先遍历一遍得到数据总量$N$，然后分块存储数据，再随机选取。第3点是数据选取绝对随机的保证。

<div class="pseudocode">
蓄水池抽样算法（Reservoir Sampling Algorithm）<br>
输入：数组$Arr$<br>
（1）初始化长度为$n$结果数组$A$<br>
（2）初始化数组读入索引$i=0$<br>
（3） while 数组$Arr$未遍历到末尾<br>
（4） $\quad$ if $i< n$<br>
（5） $\qquad$ 将$Arr[i]$加入到结果数组$A$<br>
（6） $\quad$ else<br>
（7） $\qquad$ 在$[0, i]$随机取一个整数$d$，若$d$在$[0, n-1]$范围内，则将$Arr[i]$存入$A[d]$<br>
（8） $\quad$ $i=i+1$<br>
（9）return 数组$A$
</div>

蓄水池抽样算法（Reservoir Sampling Algorithm）的精妙之处在于，对于未知长度$N$的数组，其每个数被选中的概率都为$\frac{n}{N}$。设$i$为未知长度数组的数据索引（从0开始），则：

- 若$i<n$：这些数据直接被存入结果数组$A$，遍历结束时仍留在结果数组$A$的概率为：

$$P=\frac{n}{n+1}\times\frac{n+1}{n+2}\times\cdots\times\frac{N-1}{N}=\frac{n}{N}$$

- 若$i\geq n$：这些数据被存入数组的概率为$\frac{n}{i+1}$，被存入数组的概率为且遍历结束时仍留在结果数组$A$的概率为：

$$P=\frac{n}{i+1}\times\frac{i+1}{i+2}\times\cdots\times\frac{N-1}{N}=\frac{n}{N}$$

若数据量过于庞大，需要使用$K$台机器处理数据，则可以使用分布式蓄水池抽样算法：

<div class="pseudocode">
分布式蓄水池抽样算法<br>
输入：数据流$Arr$；机器总数$K$<br>
（1）将数据流分成$K$份：$Arr_1$、$Arr_2$、$\cdots$、$Arr_k$或依次向$K$台机器输入数据<br>
（2）每台机器单独使用蓄水池抽样算法，抽样$n$个数据$A_1$、$A_2$、$\cdots$、$A_K$，并统计单台机器的数据总量$N_1$、$N_2$、$\cdots$、$N_K$<br>
（3） 计算数据总量$N=N_1+N_2+\cdots+N_K$并初始化长度为$n$最终结果数组$A$<br>
（4） for$\ \ i=1:n$<br>
（5） $\quad$ 在$[1, N]$随机取一个整数$d$<br>
（6） $\quad$ 若$d\leq N_1$，则从$A_1$中无放回的随机抽取一个数据放入最终结果数组$A$；若$N_1<d\leq N_1+N_2$，则从$A_2$中无放回的随机抽取一个数据放入最终结果数组$A$；$\cdots$；若$N_1 + N_2 + \cdots + N_{K-1}<d\leq N_1 + N_2 + \cdots + N_K$，则从$A_K$中无放回的随机抽取一个数据放入最终结果数组$A$<br>
（7）return 最终结果数组$A$
</div>

我们现在来验证一下分布式蓄水池抽样算法每个数据被抽到的概率是否为$\frac{n}{N}$:

- 对于第$k$台机器中的数据，被抽中到第$k$台机器的结果数组$A_k$的概率为$\frac{n}{N_k}$
- $n$次循环后，每个数据被选入最终结果数组$A$的概率为$n\times\frac{n}{N_k}\times\frac{N_k}{N}\times\frac{1}{n}=\frac{n}{N}$

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/127376833>
