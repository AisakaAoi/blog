---
title: 图像修复-详解Partial Convolution （二） | 图像修复领域经典之作 | PyTorch模型搭建，训练细节及实验效果
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
abbrlink: 9d77de93
date: 2022-06-06 05:16:33
---

### 论文信息

- 论文标题：《Image Inpainting for Irregular Holes Using Partial Convolutions》
- 论文链接：[ECCV 2018 Open Access Repository](https://openaccess.thecvf.com/content_ECCV_2018/html/Guilin_Liu_Image_Inpainting_for_ECCV_2018_paper.html)

<!--more-->

***

### PyTorch模型搭建

#### PConv卷积层搭建

上一篇Partial Convolution（PConv）博文中[1]中，我们介绍了PConv的运作机制。其公式可以写为：

$$x' = \begin{cases} \mathbf{W}^T(\mathbf{X} \odot \mathbf{M}) \frac{\mathrm{sum}(\mathbf{1})}{\mathrm{sum}(\mathbf{M})} + b, & \text{if } \mathrm{sum}(\mathbf{M}) > 0 \\ 0, & \text{otherwise} \end{cases}$$

$$m' = \begin{cases} 1, & \text{if } \mathrm{sum}(\mathbf{M}) > 0 \\ 0, & \text{otherwise} \end{cases}$$

其中包括两个步骤：PConv卷积运算和Mask更新过程。我们看[NVIDIA的源代码](https://github.com/NVIDIA/partialconv)是如何实现PConv卷积的:

``` python
class PartialConv2d(nn.Conv2d):
    def __init__(self, *args, **kwargs):
        # whether the mask is multi-channel or not
        if 'multi_channel' in kwargs:
            self.multi_channel = kwargs['multi_channel']
            kwargs.pop('multi_channel')
        else:
            self.multi_channel = False  
        if 'return_mask' in kwargs:
            self.return_mask = kwargs['return_mask']
            kwargs.pop('return_mask')
        else:
            self.return_mask = False
        super(PartialConv2d, self).__init__(*args, **kwargs)
        if self.multi_channel:
            self.weight_maskUpdater = torch.ones(self.out_channels, self.in_channels, self.kernel_size[0], self.kernel_size[1])
        else:
            self.weight_maskUpdater = torch.ones(1, 1, self.kernel_size[0], self.kernel_size[1])
            
        self.slide_winsize = self.weight_maskUpdater.shape[1] * self.weight_maskUpdater.shape[2] * self.weight_maskUpdater.shape[3]
        self.last_size = (None, None, None, None)
        self.update_mask = None
        self.mask_ratio = None

    def forward(self, input, mask_in=None):
        assert len(input.shape) == 4
        if mask_in is not None or self.last_size != tuple(input.shape):
            self.last_size = tuple(input.shape)
            with torch.no_grad():
                if self.weight_maskUpdater.type() != input.type():
                    self.weight_maskUpdater = self.weight_maskUpdater.to(input)
                if mask_in is None:
                    # if mask is not provided, create a mask
                    if self.multi_channel:
                        mask = torch.ones(input.data.shape[0], input.data.shape[1], input.data.shape[2], input.data.shape[3]).to(input)
                    else:
                        mask = torch.ones(1, 1, input.data.shape[2], input.data.shape[3]).to(input)
                else:
                    mask = mask_in
                self.update_mask = F.conv2d(mask, self.weight_maskUpdater, bias=None, stride=self.stride, padding=self.padding, dilation=self.dilation, groups=1)

                # for mixed precision training, change 1e-8 to 1e-6
                self.mask_ratio = self.slide_winsize/(self.update_mask + 1e-8)
                # self.mask_ratio = torch.max(self.update_mask)/(self.update_mask + 1e-8)
                self.update_mask = torch.clamp(self.update_mask, 0, 1)
                self.mask_ratio = torch.mul(self.mask_ratio, self.update_mask)
        raw_out = super(PartialConv2d, self).forward(torch.mul(input, mask) if mask_in is not None else input)
        if self.bias is not None:
            bias_view = self.bias.view(1, self.out_channels, 1, 1)
            output = torch.mul(raw_out - bias_view, self.mask_ratio) + bias_view
            output = torch.mul(output, self.update_mask)
        else:
            output = torch.mul(raw_out, self.mask_ratio)
        if self.return_mask:
            return output, self.update_mask
        else:
            return output
```

我们看到其实是继承了PyTorch中nn.Conv2d的类，在其基础上进行编写。调用方法非常简单，基本和nn.Conv2d一样，除了多了一个multi_channel的开关，一般设置为multi_channel = True。那么定义一层3×3，步长和padding都为1的PConv层可以如下定义：

``` python
self.conv = PartialConv2d(in_channels, out_channels, kernel_size=3, stride=1, padding=1, bias=bias, multi_channel = True)
```

在执行forward时，由于还有mask参与运算，因此有images, masks两个入参和出参：

``` python
images, masks = self.conv(images, masks)
```

***

#### 整体网络搭建

定义好了PartialConv2d后，我们便很容易搭建网络：

{% asset_img 2.webp %}
<div align='center'>Partial Convolutional U-Net 网络结构。图片出自[2]</div>

``` python
# --------------------------
# PConv-BatchNorm-Activation
# --------------------------
class PConvBNActiv(nn.Module):
    def __init__(self, in_channels, out_channels, bn=True, sample='none-3', activ='relu', bias=False):
        super(PConvBNActiv, self).__init__()
        if sample == 'down-7':
            self.conv = PartialConv2d(in_channels, out_channels, kernel_size=7, stride=2, padding=3, bias=bias, multi_channel = True)
        elif sample == 'down-5':
            self.conv = PartialConv2d(in_channels, out_channels, kernel_size=5, stride=2, padding=2, bias=bias, multi_channel = True)
        elif sample == 'down-3':
            self.conv = PartialConv2d(in_channels, out_channels, kernel_size=3, stride=2, padding=1, bias=bias, multi_channel = True)
        else:
            self.conv = PartialConv2d(in_channels, out_channels, kernel_size=3, stride=1, padding=1, bias=bias, multi_channel = True)
        if bn:
            self.bn = nn.BatchNorm2d(out_channels)
        if activ == 'relu':
            self.activation = nn.ReLU()
        elif activ == 'leaky':
            self.activation = nn.LeakyReLU(negative_slope=0.2)

    def forward(self, images, masks):
        images, masks = self.conv(images, masks)
        if hasattr(self, 'bn'):
            images = self.bn(images)
        if hasattr(self, 'activation'):
            images = self.activation(images)

        return images, masks

# ------------
# Double U-Net
# ------------
class PUNet(nn.Module):
    def __init__(self, in_channels=3, out_channels=3, up_sampling_node='nearest', init_weights=True):
        super(PUNet, self).__init__()
        self.freeze_ec_bn = False
        self.up_sampling_node = up_sampling_node
        self.ec_images_1 = PConvBNActiv(in_channels, 64, bn=False, sample='down-7')
        self.ec_images_2 = PConvBNActiv(64, 128, sample='down-5')
        self.ec_images_3 = PConvBNActiv(128, 256, sample='down-5')
        self.ec_images_4 = PConvBNActiv(256, 512, sample='down-3')
        self.ec_images_5 = PConvBNActiv(512, 512, sample='down-3')
        self.ec_images_6 = PConvBNActiv(512, 512, sample='down-3')
        self.ec_images_7 = PConvBNActiv(512, 512, sample='down-3')
        self.dc_images_7 = PConvBNActiv(512 + 512, 512, activ='leaky')
        self.dc_images_6 = PConvBNActiv(512 + 512, 512, activ='leaky')
        self.dc_images_5 = PConvBNActiv(512 + 512, 512, activ='leaky')
        self.dc_images_4 = PConvBNActiv(512 + 256, 256, activ='leaky')
        self.dc_images_3 = PConvBNActiv(256 + 128, 128, activ='leaky')
        self.dc_images_2 = PConvBNActiv(128 + 64, 64, activ='leaky')
        self.dc_images_1 = PConvBNActiv(64 + out_channels, out_channels, bn=False, sample='none-3', activ=None, bias=True)
        self.tanh = nn.Tanh()
        if init_weights:
            self.apply(weights_init())

    def forward(self, input_images, input_masks):
        ec_images = {}
        ec_images['ec_images_0'], ec_images['ec_images_masks_0'] = input_images, input_masks
        ec_images['ec_images_1'], ec_images['ec_images_masks_1'] = self.ec_images_1(input_images, input_masks)
        ec_images['ec_images_2'], ec_images['ec_images_masks_2'] = self.ec_images_2(ec_images['ec_images_1'], ec_images['ec_images_masks_1'])
        ec_images['ec_images_3'], ec_images['ec_images_masks_3'] = self.ec_images_3(ec_images['ec_images_2'], ec_images['ec_images_masks_2'])
        ec_images['ec_images_4'], ec_images['ec_images_masks_4'] = self.ec_images_4(ec_images['ec_images_3'], ec_images['ec_images_masks_3'])
        ec_images['ec_images_5'], ec_images['ec_images_masks_5'] = self.ec_images_5(ec_images['ec_images_4'], ec_images['ec_images_masks_4'])
        ec_images['ec_images_6'], ec_images['ec_images_masks_6'] = self.ec_images_6(ec_images['ec_images_5'], ec_images['ec_images_masks_5'])
        ec_images['ec_images_7'], ec_images['ec_images_masks_7'] = self.ec_images_7(ec_images['ec_images_6'], ec_images['ec_images_masks_6'])
        # --------------
        # images decoder
        # --------------
        dc_images, dc_images_masks = ec_images['ec_images_7'], ec_images['ec_images_masks_7']
        for _ in range(7, 0, -1):
            ec_images_skip = 'ec_images_{:d}'.format(_ - 1)
            ec_images_masks = 'ec_images_masks_{:d}'.format(_ - 1)
            dc_conv = 'dc_images_{:d}'.format(_)
            dc_images = F.interpolate(dc_images, scale_factor=2, mode=self.up_sampling_node)
            dc_images_masks = F.interpolate(dc_images_masks, scale_factor=2, mode=self.up_sampling_node)
            dc_images = torch.cat((dc_images, ec_images[ec_images_skip]), dim=1)
            dc_images_masks = torch.cat((dc_images_masks, ec_images[ec_images_masks]), dim=1)
            dc_images, dc_images_masks = getattr(self, dc_conv)(dc_images, dc_images_masks)
        outputs = self.tanh(dc_images)

        return outputs
```

***

### 训练细节

#### 损失函数

Partial Convolution的作者采用了自监督学习的方法，而没有采用GAN中的对抗损失。采用的损失函数有以下几种：

- 首先计算其L1 loss：

$$L_{hole} = \|(1 - M) \odot (I_{out} - I_{gt})\|_1$$

$$L_{valid} = \|M \odot (I_{out} - I_{gt})\|_1$$

其中，$M$ 为初始的mask，其中元素1表示未损坏区域，0表示损坏区域；$I_{out}$ 表示网络输出；$I_{gt}$ 表示标签。

其次，是生成模型中最常用的perceptual loss:

$$L_{perceptual} = \sum_{n=0}^{N-1} \|\Psi_n(I_{out}) - \Psi_n(I_{gt})\|_1 + \sum_{n=0}^{N-1} \|\Psi_n(I_{comp}) - \Psi_n(I_{gt})\|_1$$

其中 $I_{comp}$ 是指compose之后的结果，也就是说保留了 $I_{gt}$ 中的未损失区域，而损失区域用输出 $I_{out}$ 来填充。即：$I_{comp} = M \odot I_{gt} + (1 - M) \odot I_{out}$。$\Psi_n(\cdot)$ 表示预训练好的VGG-16模型中的中间特征层，这里作者使用了pool1, pool2 and pool3三个层。这样perceptual loss就度量了特征层的L1 loss。

- 再次，是和perceptual loss类似的style loss:

$$L_{styleout} = \sum_{n=0}^{N-1} \|K_n((\Psi_n(I_{out}))^T(\Psi_n(I_{out})) - (\Psi_n(I_{gt}))^T(\Psi_n(I_{gt})))\|_1$$

$$L_{stylecomp} = \sum_{n=0}^{N-1} \|K_n((\Psi_n(I_{comp}))^T(\Psi_n(I_{comp})) - (\Psi_n(I_{gt}))^T(\Psi_n(I_{gt})))\|_1$$

其中 $\Psi_n(\cdot)$ 表示 $(H_n W_n) \times C_n$ 的矩阵，那么 $\Psi_n(\cdot)^T \Psi_n(\cdot)$ 则得到一个 $C_n \times C_n$ 的矩阵，数学上成为Gram matrix。$K_n$ 为归一化系数 $1/C_n H_n K_n$（原文如此）。

- 最后是一项total variation (TV) loss：

$$L_{tv} = \sum_{(i,j) \in P, (i,j+1) \in P} \|I_{comp}^{i,j+1} - I_{comp}^{i,j}\| + \|I_{comp}^{i+1,j} - I_{comp}^{i,j}\|$$

这一项可以理解为第一项将 $I_{comp}$ 向上移一位，第二项向右移一位，然后将移位后的输出与原 $I_{comp}$ 计算L1 loss。这一项可以理解为平滑惩罚项，保证修复的图片水平、竖直方向上的像素差不会太大。

- 总损失为上述损失的综合：

$$L_{total} = L_{valid} + 6L_{hole} + 0.05L_{perceptual} + 120(L_{styleout} + L_{stylecomp}) + 0.1L_{tv}$$

作者在论文中说这些系数设置是通过在100张验证集图片上搜索得到的。

***

#### 其它细节

作者采用Adam优化器训练，在一张 NVIDIA V100 GPU (16GB) 上以 batch size 为 6 进行训练。训练过程分为 Initial Training 和 Fine-Tuning 两个阶段：在 Initial Training 阶段，学习率设置为0.0002，启用 batch normalization; 在 Fine-Tuning 阶段，学习率设置为 0.00005，并且固定住网络 encoder 部分的 batch normalization。

在 Imagenet 和 Places2 上，Initial Training 持续10天；在 CelebA-HQ，Initial Training 持续3天。所有的 Fine-Tuning 都在1天内完成。

***

### 实验效果

在本文中，除了提出将partial convolution应用到图像修复领域，作者还提出了：图像修复应该是修复不规则的损坏图片的。因此作者还提供了他们的不规则mask数据集Irregular Mask Dataset，并且hole-to-image area ratios有6种不同的大小: (0.01, 0.1], (0.1, 0.2], (0.2, 0.3], (0.3, 0.4], (0.4, 0.5], (0.5, 0.6]。在之后的图像修复工作中，绝大多数都采用了本文提供的Irregular Mask Dataset进行对比实验。

{% asset_img 7.webp %}
<div align='center'>Irregular Mask Dataset中一些测试mask图片</div>

***

#### Qualitative Comparison

下面是论文中所展示的一些实验效果：

{% asset_img 8.webp %}
<div align='center'>ImagNet数据集上实验效果对比</div>

{% asset_img 9.webp %}
<div align='center'>Places2数据集上实验效果对比</div>

另外作者还给出了普通卷积与PConv的对比：

{% asset_img 10.webp %}
<div align='center'>普通卷积与PConv的效果对比</div>

***

#### Quantitative Comparison

作者采用了L1 loss，PSNR, SSIM和IScore作为对比指标，并在不用的mask ratios上给出了结果：

{% asset_img 11.webp %}

***

### 参考资料

> <https://zhuanlan.zhihu.com/p/519446359>
> [1] [卡卡猡特：详解Partial Convolution （一） | 图像修复领域经典之作 | 运算机制及模型结构](https://zhuanlan.zhihu.com/p/519446359)
> [2] [李文鑫：Partial Convolutions for Image Inpainting](https://zhuanlan.zhihu.com/p/139405565)