---
title: Pytorch设置随机种子Seed来保证训练结果可复现性
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫_深度学习基本概念 Deep Learning Basic Concepts
abbrlink: 552b9941
date: 2023-07-10 03:43:39
tags:
---

### 什么是随机种子

<iframe src="//player.bilibili.com/player.html?aid=358179189&bvid=BV13X4y1e7cS&cid=1190965930&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

如何保证实验结果的可复现性。实验中的随机值主要来自网络的初始化、数据增强和数据读取等方面,而随机种子则可以固定这些随机值,从而实现网络训练结果的可复现性。通过设置随机种子可以固定生成值的序列,避免每次实验结果的差异。在下一个视频中,我们将详细介绍如何在训练过程中设置随机种子
- 如何保证实验结果的可复现性，包括随机权重网络、随机数据增强和随机数据读取等因素，以及如何使用随机种子来固定这些随机情况。
    - 00:01 了解如何在多次实验中保证实验结果的可复现性
    - 00:30 网络训练结果的不同原因
    - 01:50 如何通过设置随机种子来固定随机情况，保证网络可复现性

<!--more-->

### 训练中设置随机种子

<iframe src="//player.bilibili.com/player.html?aid=358179189&bvid=BV13X4y1e7cS&cid=1190967908&p=2" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

在Pytorch训练中如何设置各类随机种子的方法。在训练过程中，我们需要对多个库中的随机相关内容进行设置，包括torch库、numpy库和random库。中提供了一个函数来设置所有的随机种子并介绍了如何在网络初始化前调用该函数来保证网络随机种子的确定性。此外我们还讲解了如何设置data loader的随机种子以及如何调用work init函数来保证多进程数据加载时的数据准确性
- 在Pytorch训练中如何设置各类随机种子的方法，包括对torch、numpy和random库的设定。
    - 00:01 了解如何在Pytorch训练中设置随机种子
    - 01:09 使用torch库和numpy库的随机种子
    - 02:50 使用函数设置所有随机种子的步骤
- 在深度学习中如何正确设置随机种子，以保证网络训练的准确性和效率。
    - 04:00 网络的效率就很容易降低
    - 04:49 使用data loader自带的work init函数来初始化多进程
    - 07:33 在数据加载时设置work init函数，传入当前的rank值和seed
- 如何通过设置随机种子来实现随机数生成，并分别在全局和数据加载时进行设置。
    - 08:00 设置全局和数据加载的随机数种子
    - 08:22 分别调用两个函数来设置种子
    - 08:39 在训练时多次调用全局和数据加载的种子设置函数来保证可复现性

***

博客地址：https://blog.csdn.net/weixin_44791964/article/details/131622957
GIthub地址：https://github.com/bubbliiiing/yolov4-pytorch

***

### 学习前言

好多同学每次训练结果不同，最大的指标可能会差到3-4%这样，这是因为随机种子没有设定导致的，我们一起看看怎么设定吧。

{% asset_img 1.webp %}

***

### 为什么每次训练结果不同

模型训练中存在很多随机值，最常见的有：
1. 随机权重，网络有些部分的权重没有预训练，它的值则是随机初始化的，每次随机初始化不同会导致结果不同。
2. 随机数据增强，一般来讲网络训练会进行数据增强，特别是少量数据的情况下，数据增强一般会随机变化光照、对比度、扭曲等，也会导致结果不同。
3. 随机数据读取，喂入训练数据的顺序也会影响结果。
……
应该还有别的随机值，这里不一一列出，这些随机都很容易影响网络的训练结果。

如果能够固定权重、固定数据增强情况、固定数据读取顺序，网络理论上每一次独立训练的结果都是一样的。

***

### 什么是随机种子

随机种子（Random Seed）是计算机专业术语。一般计算机的随机数都是伪随机数，以一个真随机数（种子）作为初始条件，然后用一定的算法不停迭代产生随机数。

按照这个理解，我们如果可以设置最初的**真随机数（种子）**，那么后面出现的随机数将会是固定序列。

以random库为例，我们使用如下的代码，前两次为随机生成，后两次为设置随机数生成器种子后生成。

``` python
import random

# 生成随机整数
print("第一次随机生成")
print(random.randint(1,100))
print(random.randint(1,100))

# 生成随机整数
print("第二次随机生成")
print(random.randint(1,100))
print(random.randint(1,100))

# 设置随机数生成器种子
random.seed(11)

# 生成随机整数
print("第一次设定种子后随机生成")
print(random.randint(1,100))
print(random.randint(1,100))

# 重置随机数生成器种子
random.seed(11)

# 生成随机整数
print("第二次设定种子后随机生成")
print(random.randint(1,100))
print(random.randint(1,100))
```

结果如下，前两次随机生成的序列不同，后两次设定种子后随机生成的序列相同：

``` console
第一次随机生成
66
37
第二次随机生成
93
56
第一次设定种子后随机生成
58
72
第二次设定种子后随机生成
58
72
```

***

### 训练中设置随机种子

一般训练会用到多个库包含有关random的内容。

在pytorch构建的网络中，一般都是使用下面三个库来获得随机数，我们需要对三个库都设置随机种子：
1. torch库
2. numpy库
3. random库

在这里写了一个函数：

``` python
#---------------------------------------------------#
#   设置种子
#---------------------------------------------------#
def seed_everything(seed=11):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False
```

这里面写到了cuda、cudnn这类gpu才会用到的东西，实测发现cpu版本的pytorch也可以正常运行。

torch.backends.cudnn.deterministic=True**用于保证CUDA 卷积运算的结果确定。**
torch.backends.cudnn.benchmark=False**是用于保证数据变化的情况下，减少网络效率的变化。为True的话容易降低网络效率。**

只需要在所有初始化前，调用该seed初始化函数即可。

另外，Pytorch一般使用Dataloader来加载数据，Dataloader一般会使用多worker加载多进程来加载数据，此时我们需要使用Dataloader自带的worker_init_fn函数初始化Dataloader启动的多进程，这样才能保证多进程数据加载时数据的确定性。

``` python
#---------------------------------------------------#
#   设置Dataloader的种子
#---------------------------------------------------#
def worker_init_fn(worker_id, rank, seed):
    worker_seed = rank + seed
    random.seed(worker_seed)
    np.random.seed(worker_seed)
    torch.manual_seed(worker_seed)
```

版权声明：本文为CSDN博主「Bubbliiiing」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_44791964/article/details/131622957

***

### 参考资料

> <https://www.bilibili.com/video/BV13X4y1e7cS>
> <https://blog.csdn.net/weixin_44791964/article/details/131622957>
> <https://github.com/bubbliiiing/yolov4-pytorch>
