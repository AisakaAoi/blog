---
title: >-
  2018年微表情识别综述《Micro-expression recognition: an updated review of current
  trends, challenges and solutions》
categories:
  - 🌙进阶学习
  - ⭐SCNU BCI团队
  - 💫学习报告
abbrlink: d965e878
date: 2022-12-14 17:04:23
---

### 原文

{% pdf ./file/paper/2018-Micro-expression-recognition-an-updated-review-of-current-trends-challenges-and-solutions.pdf %}

<!--more-->

微表情（Micro-expression）识别近几年来引起了多个计算机视觉领域的极大兴趣，尤其是定位、运动放大和识别领域。ME识别的挑战来自于ME变化持续时间短和运动强度微弱。

***

### Introduction 简介

微表情是人脸面部的微弱运动，持续时间在1/25s~1/5s之间。微表情的研究提供了在真实情感被故意掩盖和隐藏时揭示短暂而无意发生的真实情绪的能力。当前的研究表明，ME通常发生在高风险的情况下，实时监测具有很高的挑战性。与宏表情相比，微表情很难伪装或隐藏使得它成为测谎的有效证据。Ekman研发了微表情训练工具Micro-Expression Training Tool(METT)来训练微表情识别。据此，Ekman把人类情感分为7中主要类别：生气、高兴、上心、厌恶、惊讶、恐惧和蔑视。另外，Ekman和Friesen引入了面部动作编码系统（Facial Action Coding System ，FACS）来根据动作单元（action units，AU）定义面部表情。AU是面部运动的可观察组件，不同的面部区域用来检测面部细微的的表情变化。一共有44种AU独立或者同时发生来表达人脸表情。然而，由于微表情持续时间只有不到0.5且强度很低，人根据AU的识别精度只有40%左右。因此，亟需微表情的分辨、识别和分析系统。

使用计算机视觉的方式，微表情识别已经有许多相关研究。然而，对于微表情的检测与识别精度影响较大的环境变化、无意识的微弱面部运动以及不平衡的数据集问题至今并没有得到很好的解决。当前存在问题如下：

#### 环境影响

在微表情识别中最大的挑战就是环境变化，包括光照变化和人的头部姿态变化。对于光照变化，大多数识别特征都严重依赖于像素变化的强度，例如局部二值模式(Local Binary Pattern ,LBP)、光流和方向梯度直方图(Histogram of Oriented Gradient,HOG)。光线变化会导致错误的特征评估，头部运动、头部姿态变化都会被误认为是微表情。微弱的头部运动会很大程度上影响面部组件的变化，最终影响检测精度。

#### 无意识的微弱面部运动

面部无意识的低强度微弱运动导致裸眼无法分辨准确的识别情绪，是微表情识别的重要挑战。通常，分类器会把微弱的运动错误的表达为平静面部。因此，数据预处理阶段放大和增强微弱面部运动信号至关重要。

#### 数据集不均衡

针对微表情识别的可用数据集很少，例如SMIC、CASME、CASMEII、CAS(ME)2等，这些数据集是现存的用于微表情识别的推荐数据集，但是其情绪类别间数据分布不均衡会导致检测结果的误差。另外，可用数据集往往在光照变化控制的环境下拍摄，样本对象头部基本不会有运动变化的情况。因此，使用这些数据集测试良好的数据集在通用场景中可能并不能很好的识别，亟需通用场景的微表情识别数据集。

本文贡献：
- 提供了微表情的发现方法的综述。
- 现存的识别特征分为低级特征、中级特征、高级特征。
- 分析了微表情识别的性能评估方法流程。
- 分析了当前微表情识别数据集的优点和不足。

***

### Context 相关内容

#### 数据集

{% asset_img 1.webp %}

#### 通用流程

微表情识别可以分为：图像采集、面部识别、预处理、微表情发现、特征提取、微表情分类。如图所示：

{% asset_img 2.webp %}

**图像采集：**使用高速摄像头来采集至关重要，因为裸眼或者低帧率的视频很难检测到面部组件的快速微弱运动。微表情发现和识别之前要对面部表情做预处理。首先，对采集的图像检测人脸并把面部区域从背景中分割出来，然后把面部映射到原型脸来削弱头部姿态变化产生的影响。

**预处理：**图像预处理来克服光线变化或者噪声的影响，然后使用运动放大技术放大面部局部感兴趣的区域。增强后的图像用于微表情发现、特征提取和分类。然而，当前微表情发现的工作较少，当前主流的研究是关于微表情发现后的特征选择和分类方法。图像或者视频中微表情发现的研究是未来的研究方向。

***

#### 数据预处理

微表情识别的数据预处理流程主要包括面部检测、面部校正、运动放大(Motion magniﬁcation)和时域归一化(Temporal normalization)，面部校正后的人脸经过归一化(Face detection and registration)以后，过滤了噪声并加强了用于更好提升性能的可用特征。相关处理方法包括微弱特征放大、时域归一化以及Wiener滤波或者高斯滤波来过滤噪声。

***

### Features for ME representation 微表情特征

用于微表情表征的特征是用于分类的特征。分为低级特征、中级特征和高级特征。

#### Low-level representation 底层表征

低级特征为从图像中直接提取出来的特征，例如强度、时域强度、梯度等。低级特征通常以描述符的形式表示，描述符包含一组没有明确语义含义/知识的可视化数据线索，主要包括局部二值模式(LBP)，光流，梯度，以及它们各自的变体。

#### Mid-level representation 中层表征

当前存在的主要方法利用面部整体或者不同区域的时间和空间特征进行分类。然而，低级特征对于表达持续时间短、强度低、有噪声和头部姿态变化的微弱运动是不充分的。因此，中级特征来把低级特征整合为有更强描述能力的更丰富的特征。

中级特征转换低级特征为用于分类的图像表征，增加权重来给局部特征以明确的含义与知识。这类提取的描述符将以图像级信息的视觉词内容来表示，而不是简单的没有明确含义的视觉线索。最常见的中层技术是在情感识别中常用的词袋模型bag-of-words (BoW)。

目前存在的两个中级特征的方法：
[1] He, J., Hu, J.-F., Lu, X., Zheng,W.-S.:Multi-taskmid-levelfeature learning for micro-expression recognition. Pattern Recognit. 66, 44–52 (2017)
[2] Zheng, H., Zhu, J., Yang, Z., Jin, Z.: Effective micro-expression  recognition using relaxed K-SVD algorithm. Int. J. Mach. Learn.  Cybern. 8(6), 2043–2049 (2017)

***

#### High-level representation 高层表征

高级表示可以定义为一组人类可解释的语义数据，其中高级特性是几个低级特性的组合。例如在面部认证中，一系列信息作为高级特征，例如年龄、性别、肤色等，这些语义信息可以用低级特征如颜色或者纹理等信息中提取。低级特征又称为手工特征，从像素中提取，送入分类器中用于认证。另外，高级方法倾向于特征学习，也就是从原始输入图像中学习和理解。

当前ME的soat的高级表征识别方法主要由CNN方法提取。CNN从大量标记好的样本数据中提取特征，低层用于提取低级特征，高层用于提取高级特征。

针对现有微表情数据集数据量少容易导致CNN模型过拟合的问题
1. 模型采用在ImageNet数据集预训练的方式
2. 模型在宏表情数据集如CK+上训练后，通过迁移学习的方式迁移到微表情数据集进行训练
3. 针对数据量少的问题，采用数据扩增的方式进行数据扩充。例如样本图片水平翻转、裁剪、校正等。

另外，还可以根据结合时域插帧方法对微表情视频序列进行时间对齐，然后提取特征后进行分类。主要方法有：
1. 结合时域插帧和DCNN的MER
    Mayya, V., Pai, R.M., Pai, M.M.M.: Combining temporal interpolation and DCNN for faster recognition of micro-expressions  in video sequences. In: International Conference on dvances in Computing, Communicati
2. 多时域尺度卷积神经网络识别无意识面部微动作。该方法简化了双流网络，模型中不同流用于处理不同帧率的ME视频。作者的研究结果，比FDM等传统方法精度提升10%
    Peng, M., Wang, C., Chen, T., Liu, G., Fu, X.: Dual temporal scale convolutional neural network for micro-expression recognition. Front. Psychol. 8, 1745 (2017)
3. CNN+LSTM方法处理ME视频中的时空信息。
    Kim, D.H., Baddar, W., Jang, J., Ro, Y.M.: Multi-objective based spatio-temporal feature representation learning robust to expression intensity variations for facial expression recognition. IEEE Trans. Affect Comput. 66(99), 1–1 (2017)
4. 深度级联peak-piloted网络(DPCN)，识别微弱表情。此方法在CK+数据集的准确率达到99.6%

基于CNN方法的微表情识别存在的主要问题是当前用于微表情识别的数据量很少。

***

### 微表情发现

#### 基于外观特征

主要基于像素级别的特征，尤其是特征强度值。例如通过计算LBP的距离来计算特征差作为微表情发现的特征。基于强度的特征，使用3D梯度直方图算子或者方向梯度直方图。

#### 动态方法

在动态方法中，使用提取的运动变化的微弱表情非刚性运动变化，例如光流或者光强。或者使用面部动态图(facial dynamic map,FDM)对面部组件的运动建模，并基于光流进行像素级别的校正。

#### 通用方法

提出 micro-expression spotting benchmark (MESB)，结合多尺度滑动窗口进行微表情发现，并提供微表情发现方法的标准性能评估方法。在该方法中，假设微表情发现问题是二进制分类任务。两个评估方法：1）基于滑动窗口(是否含有微表情)量化二进制分类的性能 2）基于检测窗口的最终输出结果。评估TP、FP和缺失样本。
[1] Hong, X., Tran, T.-K., Zhao, G.: Micro-Expression Spotting: A Benchmark. CoRR bs/1710.02820 (2017)
[2] Tran, T.-K., Hong, X., Zhao, G.: Sliding window based microexpression spotting: a enchmark. In: Cham 2017. Advanced Concepts for Intelligent Vision Systems, pp. 542–553. Springer

***

### Recognition results and discussion 识别结果与讨论

#### Result 结果

LOVO和LOSO交叉验证法是微表情识别中最常用的性能评价方法，除了LOVO和LOSO, k-fold验证法、重复随机采样验证或基础保持验证法，也被用于评估方法准确度。

#### Discussion and future recommendation 讨论与未来研究的建议

克服头部变化影响的方法，就是使用归一化，将面部图像转换成标准的位置和尺寸。光照变化的影响，暂时没有好的方法，都是在受控的光照环境下进行的研究。对于第二个挑战(面部运动幅度较小和无意识的运动)，一般采用欧拉增强的方法，在预处理阶段放大低强度的运动。预处理阶段，与特征提取和分类相比，运动增强相关工作较少。微表情检测相关工作较少。手工特征中，低层特征研究的较多，中层特征的研究有待提升。

***

### Conclusion 结论

Feature representations are evolving from low-level approach to mid-level and high-level approach.
特征提取需要从低层特征向中层特征发展。

***

### 参考资料

> <https://blog.csdn.net/juan190755422/article/details/114006772>
> <https://blog.csdn.net/pzb19841116/article/details/127894880>
