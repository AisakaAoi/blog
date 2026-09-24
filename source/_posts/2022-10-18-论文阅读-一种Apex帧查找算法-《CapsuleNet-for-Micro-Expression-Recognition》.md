---
title: 一种Apex帧查找算法-《CapsuleNet for Micro Expression Recognition》
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫学习报告
abbrlink: 92536c52
date: 2022-10-18 11:19:54
---

### 原文

{% pdf ./file/paper/2019-CapsuleNet-for-Micro-Expression-Recognition.pdf %}

<!--more-->

***

### 微表情序列中Apex帧介绍

一个微表情视频序列以Onset帧开始，以Offset帧结束，通常保持中性的表情；其中Apex帧是在序列中变化强度最大的那一帧。

一个微表情序列的Apex帧，在微表情分类中能提供丰富的特征，可以帮助接下来的光流特征提取、迁移学习等。

***

### 一种查找Apex帧算法

下面是一种在微表情序列中提取Apex帧的算法，算法流程如下：
1. 根据面部68个特征点，定位10个微表情肌肉移动发生频繁的区域
2. 定义变化强度M，用于衡量序列中每一帧变化大小
3. 遍历序列帧，计算每一帧变化强度Mi，取值最大的那帧作为Apex帧

#### Step 1 定义10个面部区域块

首先通过一个开源面部工具(ageitgey/face_recognition)[https://github.com/ageitgey/face_recognition]定位每一帧68个面部特征点，接着基于这些特征点定义10个面部区域块。其效果如图1：

{% asset_img 1.webp %}

这10个区域分别选取left_lip、right_lip、chin、left_nose、right_nose、left_eye、right_eye、left_eyebrow、right_eyebrow处的特征点作为基准点，形成正方形块。其中，正方形的边长是上嘴唇距离的一半，作者称边长的确定是启发式地（heuristically）。

下面以左嘴唇正方形块区域举例：

``` python
import face_recognition
import numpy as np

# 获取当前frame的人脸特征点，lmks是一个字典，记录了68个特征点坐标
lmks = face_recognition.face_landmarks(frame)[0]

# 正方形宽度的确定
cell_width = int((lmks['top_lip'][6][0] - lmks['top_lip'][0][0]) / 2)
# 最左嘴唇点的坐标
leftmost_lip_point=lmks['top_lip'][0]
# 确定正方形块左上角和右下角坐标，据此确定一个块
left_lip_rect=
tuple(np.array(leftmost_lip_point) - int(cell_width / 2)),
tuple(np.array(leftmost_lip_point) + int(cell_width / 2))
```

#### Step 2 定义变化强度

首先分别计算当前帧与Onset帧、Offset帧在这10个区域块的绝对像素差，为了减少环境噪音影响，将差值的除以当前帧与偏差为З的连续帧的绝对像素差。将规化后的像素差求和，表示当前帧的变化强度值，即Mi。（З 表示epsilon,一个变量，并非数字3）

{% asset_img 2.webp %}

下面根据计算脸部某个区域的变化强度函数，理解上述公式。实际上还需要对10个面部区域块分别计算，取其均值作为当前帧的变化强度值Mi。

``` python
def compute_cell_difference(cell_t: np.ndarray, cell_onset: np.ndarray, cell_offset: np.ndarray, cell_epsilon: int): 
    """ 
    计算某块区域的变化强度 
    :param cell_t:当前面部区域块 
    :param cell_onset:起始帧 
    :param cell_offset:末尾帧 
    :param cell_epsilon:偏差为epsilon的帧 
    :return: 一个float 
    """ 
    numerator = (np.abs(cell_t - cell_onset) + 1.0) 
    # 分子分母同时加1的一个原因是防止出现'inf'数据 
    denominator = (np.abs(cell_t - cell_epsilon) + 1.0) 
    difference = numerator / denominator 

    numerator = (np.abs(cell_t - cell_offset) + 1.0) 
    difference1 = numerator / denominator 
 
    difference = difference + difference1 
    return difference.mean() 
```

#### Step 3 遍历查找

遍历计算对应帧的的变化强度M,取值最大的那帧作为Apex帧。

浅蓝色曲线描述了序列中每帧的变化强度M值的变化。

{% asset_img 3.webp %}

***

### 实验

CASMEⅡ 微表情数据集已经对其中的微表情序列Apex帧进行了人工标注，在此数据集上使用上述算法进行自动查找，观察实验结果。

1. 准备CASMEⅡ 数据集
2. 运行代码得到预测的Apex 帧序号数组pred_apex_id_list，图3 显示了某个微表情序列的Apex帧标注过程
3. 通过人工标注的Apex帧序号数组groundtruth_apex_id_list 和自动预测的Apex帧序号数组 pred_apex_id_list，得到绝对差值数组absolute_difference_list, 观察其平均值（也即两组数据的**平均绝对误差，MAE**）、无偏标准差(两组数组的**均方根误差, RMSE**)、中位数。

{% asset_img 4.webp %}

其平均值7.91, 中位数4.0，无偏标准差10.0, 反应了其集中趋势和波动大小。

{% asset_img 5.webp %}

***

### 参考文献

[1] N. V. Quang, J. Chun and T. Tokuyama, "CapsuleNet for Micro-Expression Recognition," 2019 14th IEEE International Conference on Automatic Face & Gesture Recognition (FG 2019), 2019, pp. 1-7, doi: 10.1109/FG.2019.8756544.

***

### 原文链接

> <https://zhuanlan.zhihu.com/p/425412701>
