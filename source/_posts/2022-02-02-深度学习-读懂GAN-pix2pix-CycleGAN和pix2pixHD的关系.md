---
title: "'深度学习-读懂GAN, pix2pix, CycleGAN和pix2pixHD的关系'"
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫未分类
abbrlink: 70ef60f6
date: 2022-02-02 01:05:57
tags:
---

### 机器学习的时代

计算机视觉（Computer Vision, CV）领域近年来发生了巨大的变化。在2012年之前，CV的主要研究方法是使用**人工设计（hand-designed）**的特征完成各种任务。

{% asset_img 1.webp %}

2012年使用**深度神经网络（Deep Neural Network, DNN）**在ImageNet的分类任务上取得了巨大成功。

{% asset_img 2.webp %}

从此**深度学习（Deep Learning）**的相关研究如火如荼地展开了，比如说下面这三个例子：

1. **物体识别（Object detection）** [Redmon etal., 2018]
2. **对人体的理解（Human understanding）** [Guler et al., 2018]
3. **自动驾驶（Autonomous driving）** [Zhao et al., 2017]

{% asset_img 3.webp %}

<!--more-->

***

### 图形学中的尝试：趁手的武器 or 白费功夫

在传统的图形学管线（pipeline）中，输出图像需要经过建模、材质贴图、光照、渲染等一系列繁琐的步骤。

{% asset_img 4.webp %}

现在大家看到了Deep Learning的潜力，那我们自然的就有个想法：有没有可能使用Deep Learning简化计算机图形学（Computer Graphics）的研究呢？

一个直接的想法是把DNN“倒过来用”。之前的DNN可能是输入一幅图像，输出一个标签（比如说猫），那我们能不能输入“猫”这个字，输出一张猫的照片呢？

{% asset_img 5.webp %}

很遗憾，答案是No！因为这种任务实在太复杂啦！我们很难让DNN凭空输出图像这样的**高维数据（High dimensional data）**（这里的“高维”可以理解成数据量大）。实际上，在很长一段时间里，DNN只能输出数字这种简单的、低分别率的小图像，就像下面这样：

{% asset_img 6.webp %}

而想要生成想游戏场景这类的图片，这种方法根本没用。所以，我们必须得想出更厉害的东西完成这项任务！

***

### GAN就完了？Naive！

于是，一个叫做**生成对抗网络（Generative Adversarial Network）**——也就是大名鼎鼎的**GAN**——的东西横空出世。作者是下面这位小哥：

{% asset_img 7.webp %}

那么，我们该怎么GAN出图像呢？

一般来说，GAN中包含两种类型的网络 G 和 D。其中，G 为**Generator**，它的作用是生成图片，也就是说，在输入一个**随机编码（random code）** z 之后，它将输出一幅由神经网络**自动生成的、假的图片** G(z)。

另外一个网络 D 为**Discriminator**是用来判断的，它接受 G 输出的图像作为**输入**，然后判断这幅图像的真假，真的输出1，假的输出0。

{% asset_img 8.webp %}

在两个网络互相博弈的过程中，两个网络的能力都越来越高：G 生成的图片越来越像真的图片，D 也越来越会判断图片的真假。到了这一步，我们就能“卸磨杀驴”——丢掉 D 不要了，把 G 拿来用作图片生成器。

正式一点儿讲，我们就是要在最大化 D 的能力的前提下，最小化 D 对 G 的判断能力，这是一个最小最大值问题，它的学习目标是：

{% asset_img 9.webp %}

为了增强 D 的能力，我们分别考虑输入真的图像和假的图像的情况。上式中第一项的 D(G(z)) 处理的是**假图像** G(z)，这时候评分 D(G(z)) 需要尽力**降低**；第二项处理的是**真图像** x，这时候的评分要高。

***

### GAN的局限性

即便如此，传统的GAN也不是万能的，它有下面两个不足：

1. **没有用户控制（user control）能力**

在传统的GAN里，输入一个**随机**噪声，就会输出一幅**随机**图像。

{% asset_img 10.webp %}

但假如用户是有想法，我们想输出的图像是我们想要的那种图像，和我们的输入是**对应的、有关联的**。比如输入一只猫的草图，输出同一形态的猫的真实图片（这里对形态的要求就是一种用户控制）。

{% asset_img 11.webp %}

2. **低分辨率（Low resolution）和低质量（Low quality）问题**

尽管生成的图片看起来很不错，但如果你放大看，就会发现**细节相当模糊**。

{% asset_img 12.webp %}

***

### 改善

前面说过传统的GAN的种种局限，那么现在，我们相应的目标就是：

- 提高 GAN 的**用户控制**能力
- 提高 GAN 生成图片的**分辨率和质量**

为了达到这样的目标，总共分三步：

1. **pix2pix：**有条件地使用用户输入，它使用**成对的数据（paired data）**进行训练。
2. **CycleGAN：**使用**不成对的数据（unpaired data）**的就能训练。
3. **pix2pixHD：**生成高分辨率、高质量的图像。

{% asset_img 13.webp %}

***

### pix2pix

**pix2pix** 对传统的 GAN 做了个小改动，它不再输入随机噪声，而是输入用户给的图片：

{% asset_img 14.webp %}

但这也就产生了新的问题：我们怎样建立输入和输出的**对应关系**。此时 G 的输出如果是下面这样，D 会判断是真图：

{% asset_img 15.webp %}

但如果 G 的输出是下面这样的，D 拿来一看，也会**认为是真的图片**。也就是说，这样做并不能训练出输入和输出对应的网络 G，因为是否对应根本不影响 D 的判断。

{% asset_img 16.webp %}

为了体现这种对应关系，解决方案也很简单，你可以也已经想到了：我们把 G 的输入和输出一起作为 D 的输入不就好了？于是现在的优化目标变成了这样：

{% asset_img 17.webp %}

这项研究还是挺成功的，大家可以去[这里](https://affinelayer.com/pixsrv/)在线体验一下demo，把草图（sketch）变成图片。

{% asset_img 18.webp %}

当然，有些比较皮的用户输入了奇形怪状的草图，然后画风就变成了这样：

{% asset_img 19.webp %}

***

### 应用

pix2pix的核心是有了**对应关系**，这种网络的应用范围还是比较广泛的，比如：

1. 草图变图片[Isola, Zhu, Zhou, Efros, 2016]：

{% asset_img 20.webp %}

2. 灰度图变彩色图[Isola, Zhu, Zhou, Efros, 2016]：

{% asset_img 21.webp %}

3. 自动着色 Data from [Russakovsky et al. 2015]：

{% asset_img 22.webp %}

4. 交互式着色[Zhang*, Zhu*, Isola, Geng, Lin, Yu, Efros, 2017]：

{% asset_img 23.webp %}

***

### CycleGAN

pix2pix必须使用成对的数据进行训练。

{% asset_img 24.webp %}

但很多情况下成对数据是很难获取到的，比如说，我们想把马变成斑马，现实生活中是不存在对应的真实照片的：

{% asset_img 25.webp %}

现在我们就用Cycle-constraint Adversarial Network也就是**CycleGAN**解决这个问题。这种网络**不需要成对的数据**，只需要输入数据的一个集合（比如一堆马的照片）和输出数据的一个集合（比如一堆斑马的照片）就可以了。

{% asset_img 26.webp %}

但是（没错我又要说但是了），直接使用不成对的数据是不奏效的。网络会直接**忽略输入，随机产生输出**。所以，我们还得对网络增加**限制（constraint）**才行。

那怎么加限制呢？我们来思考一个现实问题。马克吐温认为，如果一把一段话从英文翻译成法文，再从法文翻译回英文，那么你应该得到跟之前原始输入的英文一样的内容。这里也是一样，如果我们把马变成斑马，然后再变回马，那么最后的马和开始输入的马应该是一样的。

{% asset_img 27.webp %}

下面讲一下具体技术细节。除了之前提到的把**马变成斑马**的网络 G，我们还需要一个把**斑马变回马**的网络  F。
那么，一匹马 x 用 G 变成斑马 s = G(x)，然后再用 F 把它变回马 F(s)，得到的马和一开始的马应该是一样的，也就是 x = F(G(x))。

{% asset_img 28.webp %}

反过来，斑马变马再变回斑马也要满足要求，注意这一步最好不要省略。虽然理论上只用一个条件是可以的，但是现实实现中，有很多因素，比如计算的准备度，优化的问题，应用中都是把所有约束都加上。比如说 a = b = c，理论上我们只要要求 (a-b)^2 + (a-c)^2 = 0，但现实中我们都是做 (a-b)^2 + (a-c)^2 + (b-c)^2 = 0。

{% asset_img 29.webp %}

我们同时优化 G 和 F，最后就能拿到一个想要的网络 G。

***

### CycleGAN为什么有效

CycleGAN成功的原因在于它分离了**风格（Style）和内容（content）**。人工设计这种分离的算法是很难的，但有了神经网络，我们很容易让它学习者去自动**保持内容而改变风格**。

**马变斑马：**

两张图片分别是原来的马和 G 变出的斑马：

{% asset_img 30.webp %}
{% asset_img 31.webp %}

**橘子变苹果：**

{% asset_img 32.webp %}
{% asset_img 33.webp %}

可以看到，CycleGAN能够比较准确的找到橘子的位置，并把它变成苹果。

**图像风格的迁移：**

{% asset_img 34.webp %}
{% asset_img 35.webp %}

**游戏场景替换：**

这个应用就很酷了，它以一些德国城市的照片作为输入，成功替换了游戏GTA5中的场景！

{% asset_img 36.webp %}
{% asset_img 37.webp %}

**失败例子**

在输入骑马的普京大帝照片时，输出图像里把普京也变成了斑马。

{% asset_img 38.webp %}

这是因为，训练图像里并没有骑马的人，所以网络就傻掉了。

目前暂且的解决办法是先用Mask R-CNN做图像分割之后再针对马进行变化，不过这个效果也不好，因为人和马在图像上有重叠的部分。

***

### 源代码

这里给出[CycleGAN和pix2pix的github项目](https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix)，这是2017年github最受欢迎的项目之一。

不过这里存在一个严重的问题：CycleGAN只能输出256p/512p的低分辨率图像。

***

### pix2pixHD

我们还剩一个悬而未决的问题：分辨率和图像质量。pix2pixHD就是用来解决这个问题的！

假设我们输入一张高分辨率的草图：

{% asset_img 39.webp %}

使用pix2pix，结果很差（之前说过，让网络产生高维数据输出很难）：

{% asset_img 40.webp %}

pix2pixHD采取了**金字塔式**的方法：

1. 先输出低分辨率的图片。
2. 将之前输出的低分辨率图片作为另一个网络的输入，然后生成分辨率更高的图片。

{% asset_img 41.webp %}

这样，就把一个困难的问题拆分成了两个相对简单的问题~

最终的效果是，给定下面的高分辨率草图：

{% asset_img 42.webp %}

pix2pixHD可以**实时（real time）**产生这样的效果：

{% asset_img 43.webp %}

pix2pixHD也支持用户交互，比如加一辆车、添几棵树之类的：

{% asset_img 44.webp %}
{% asset_img 45.webp %}

pix2pixHD还有许多有趣的应用。

比如用草图生成高分辨率人脸：

{% asset_img 46.webp %}
{% asset_img 47.webp %}

再比如：

- 图像增强（Image Enhancement）
- 图像去雾（Image Dehazing）
- 非监督动作重定向 [Neural Kinematic Networks for Unsupervised Motion Retargetting](https://arxiv.org/abs/1804.05653)

***

### 其他问题

目前生成的斑马视频帧与帧之间的纹理变化较大，为了解决帧之间的连续性问题，新的研究工作应运而生：[Video-to-Video Synthesis](https://arxiv.org/abs/1808.06601)。
它主要的解决思路有下面三个：

1. 输入一段视频中的几帧，检查真假
2. 把前面的帧当做后面帧的输入
3. 使用“optical flow”，具体请看paper

***

### 总结

本文介绍了怎样用神经网络生成图片，我们使用pix2pix完成了基本任务，使用CycleGAN解决了输入数据不成对的问题，最后用pix2pixHD解决了图像分辨率和图像质量的问题。

***

### 参考资料

> <https://blog.csdn.net/gdymind/article/details/82696481>
