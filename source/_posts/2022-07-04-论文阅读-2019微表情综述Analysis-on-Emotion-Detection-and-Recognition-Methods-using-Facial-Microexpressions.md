---
title: >-
  2019年微表情综述《Analysis on Emotion Detection and Recognition Methods using Facial
  Microexpressions》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些论文
abbrlink: '13582714'
date: 2022-07-04 14:50:40
---

### 原文

{% pdf ./file/paper/2019_Analysis_on_Emotion_Detection_and_Recognition_Methods_using_Facial_Microexpressions._A_Review.pdf %}

论文链接：<https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8969925>

<!--more-->

***

### 自动分析的步骤

面部表情的自动分析包括三个步骤：**获取面部图像**，**提取并表示感兴趣的数据**，**识别表情**

***

### 面部表情计算分析的局限性

表情包含有关人脸身份和表情变化的信息，因此提取的特征通常是表情变化和身份特征的混合体。

1. **光照影响。**从不同方向和不同强度照亮面部的方式对特征提取有重大影响。如果关键区域（例如眼睛或嘴巴）的光线昏暗，这会影响特征提取并干扰面部表情识别。

2. **只关注于姿势。**心理学家将这些表情按姿势或自发性进行分类，在外观和时间特征方面彼此不同。而自动化检测的面部表情识别系统专注于姿势表情，而我们的日常交互具有自发的面部表情，这大大降低了这些自动化系统的识别准确性。

3. **持续时间短，强度低，数据集小。**大多数研究人员面临着基于微表情识别情绪的一个很大限制是缺乏标准的微表情数据库，这使得训练精确的微表情识别系统非常困难。

***

### 数据表示的方法

数据表示有两种方法：**基于特征的几何方法**和**基于外观的方法**

1. 基于特征的几何方法
在基于特征的几何方法中，使用图像处理技术提取脸部点（唇角，眼中心，眉毛边缘和鼻尖），获得的坐标将创建代表脸部几何形状的特征向量。

2. 基于外观的方法
基于外观的方法逐帧分析视频，并使用图像过滤器提取特征向量。这可以应用在整个脸部或特定区域。

***

### 面部表情识别方法

1. 基于图像
2. 基于视频
3. 基于3D表面

识别过程包括一些特定步骤，如下图：

{% asset_img 1.webp %}

其中最重要的几步有：**面部检测**，**预处理**，**面部特征提取**，**识别**。

***

### 细节

面部表情与面部动作不同，将中立状态与任何其他情感表情进行比较时，识别它们要容易得多。此外，面部具有永久性特征和暂时性特征。**眼睛和嘴唇充当永久性特征，而面部线条和表情皱纹充当暂时性特征。**

微表情具有三个重要特征：**持续时间短，强度低，它们是原型面部表情的片段。**

面部动作编码系统（FACS）是人类面部运动的分类系统，其基础是最初由Carl-Herman开发并由Ekman，Friesen和Joseph进行更新的系统，具有44个动作单元（AU）来描述面部表情。

与情绪有关的七个基本面部动作可以由脸部以下区域表示：**双眉的左右边缘**，**眼睛的左右边缘**，**嘴巴**和**脸颊的左右边缘**

***

### 最近研究

1. Yao S , He N , Zhang H , et al. Micro-expression recognition by feature points tracking[C]// International Conference on Communications. IEEE, 2014.

    因为跟踪每个重要特征点以进行微表达检测需要大量数据，Yao等[11]决定选择特定的工作点和相关的动作单位（AU）（如唇缘），因为它们更易于检测和追踪。提出了一种微表情识别跟踪和特征点量化的方法。面部区域通过训练霍夫森林（HF）以提取特征点。在测试过程中，第一个图像帧被分为几个区域，面部区域将通过HF进行嘴唇轮廓描绘测试。跟踪学习检测算法接收嘴唇边缘的位置，并且可以自己学习和跟踪特征点。该方法适用于嘴部位置非常重要的情绪。所提出的方法解决了选择对准基本点的位置限制问题，并提供了对微表达的可靠描述。

    **主要选择检测的部位有：**
    **a. 嘴唇边缘作为特征点。与鼻子边缘和眉毛边缘点相比，嘴唇边缘的变化更加明显，这意味着嘴唇边缘的特征点更易于检测和跟踪。**
    **b. 选择动作单元12和16。动作单元12和16两者均与唇缘特征点有关系。 这些动作单元可以代表两种基本情绪，即快乐和厌恶。**

2. Zhang Z , Cui L , Liu X , et al. Emotion Detection Using Kinect 3D Facial Points[C]// IEEE/WIC/ACM International Conference on Web Intelligence. ACM, 2016.

    也基于面部点，但是3D，Zhang[5]等建议识别三种不同类型的人类情感：悲伤，快乐和中立。 本文运用 Kinect V2.0记录人的面部表情在一段时间内的变化（他们邀请参与者自己做的数据集）。对于每个帧，将捕获1347个面部3D点，从中选择100个关键面部点。 然后，使用移动中间滤波器消除噪声，并将数据流划分为具有均匀尺寸的几个切片（考虑样本），从中提取有效属性。对这三类表情的分类效果较好，但是没有考虑光照等环境干扰，并且是从整个面部提取点，根据FACS编码，应该从眉毛眼睛嘴唇等提取特征点会更有说服力。

    **主要运用3D面部检测部位：**
    **每个帧检捕获出1347个面部点并提取出更具代表性的100个点进行时域、频域、时频域的特征提取。**（计算点之间的偏差、峰度、标准差，对每个轴进行傅立叶变换，分别计算功率谱密度（PSD）的均值和标准差等）

3. Wang, Su-Jing, Yan, Wen-Jing, Li, Xiaobai,等. Micro-Expression Recognition Using Color Spaces[J]. 2015.

    Wang等 [2]提出了一种不同的方法，颜色空间模型，张量独立颜色空间（TICS）。 具有微表达的彩色视频被视为四阶张量，即四维数组。前两个维是空间信息，第三个维是时间信息，第四个维是颜色信息。他们将第四维从RGB转换为TICS，其中颜色分量尽可能独立。同时还基于FACS编码系统定义了一组关注区域（ROI），并为每个ROI计算动态纹理直方图。

    **主要检测部位：**
    **将面部动作单元AU划分为大的16块ROI，每个ROI对应一个或多个AU。**

4. Davison A K , Lansley C , Ng C C , et al. Objective Micro-Facial Movement Detection Using FACS-Based Regions and, Baseline Evaluation[J]. 2016.

    Davison等[12]基于FACS定义了一个由26个区域组成的人脸模板，然后使用3D HOG（定向梯度）直方图提取每个区域的时间特征。他们在卡方距离中搜索局部区域的细微面部运动。 最后，使用自动峰值检测器来检测超出自适应基线阈值的微动。该方法通过忽略不助于面部肌肉运动的面部区域来改善局部特征表示。

    **主要检测部位：**
    **与（3）类似，根据FACS将面部区域分成26个区域。**

5. Li X , Yu J , Zhan S . Spontaneous facial micro-expression detection based on deep learning[C]// 2016 IEEE 13th International Conference on Signal Processing (ICSP). IEEE, 2016.

    [17]的作者使用深度多任务学习方法来训练用于面部界标定位的深度卷积神经网络（CNN），这在微表情分析中至关重要。面部区域分为12个ROIS。 然后，他们将鲁棒的光流方法与HOOF功能相结合，以评估面部肌肉的运动方向。作为检测微表达的分类器，他们使用了SVM。

    **主要检测部位：**
    **检测出68个标志点，并根据此与FACS编码将面部分为12个ROIS。**

***

### 总结

有多种面部检测方法：
- 特定的操作点[11]
- 3D点[5]
- 色彩空间模型[2]
- 基于FACS的面部模板[12]
- 动态图[14]
- Gabor小波滤波器[8]
- 向量量化和码本选择[16]
- CNN [17，18，19]

同样，对于情感检测，可以使用：
- 跟踪学习检测算法[11]
- 不同种类的分类器[5，8，14，15，17]
- 直方图[2，12，13，17]
- 神经网络[18，19]

尽管人脸检测和情感识别使用了不同的方式，但是识别的准确性在70％至85％的范围内，仅在特定情况下更高[13]，对于某些类型的情感则更易于检测[8，15]。这些自动的面部表情识别系统将注意力集中在姿势上的表情上，而不是自发地出现在我们的日常互动中。这是可以解释的，因为要检测后者要困难得多。

***

### 引用

[1] V. Bettadapura, “Face expression recognition and analysis: the state of the art”, ArXiv 2012. 
[2] S.-J. Wang, W.-J. Yan, X. Li, G. Zhao, C.-G. Zhou et al., “Micro-expression recognition using color spaces”, IEEE Transactions on Image Processing, 24(12), 2015, pp. 6034–6047. 
[3] D. Matsumoto, J. LeRoux, C. Wilson-Cohn et al., “A new test to measure emotion recognition ability: Matsumoto and Ekman’s Japanese and Caucasian Brief Affect Recognition Test (JACBART)”, Journal of Nonverbal Behavior, 24(3), 2000, pp. 179-207. 
[4] T. Wu, S. Fu, G. Yang, “Survey of the facial expression recognition research”, International Conference on Brain Inspired Cognitive Systems, 2012, pp. 392–402. 
[5] Z. Zhang, L. Cui, X. Liu, T. Zhu, “Emotion detection using Kinect 3D facial points”. IEEE/WIC/ACM International Conference on Web Intelligence (WI), 2016. 
[6] R. Sharma, B. Kaushik, “Facial expression recognition: a survey”, International Journal of Computer Applications, 153, 2016, pp. 32-36. 
[7] B. Bhushan, “Study of facial micro-expressions in psychology”, Understanding Facial Expressions in Communication, pp. 265–286, 2014.
[8] P. Zhang, X. Ben, R. Yan, C. Wu, C. Guo, “Micro-expression recognition system”, Optik - International Journal for Light and Electron Optics, 127(3), 2016, pp. 1395–1400. 
[9] W.-J. Yan, S.-J. Wang, Y.-J. Liu, Q. Wu, X. Fu, (2014). “For micro-expression recognition: database and suggestions”, Neurocomputing, 136, 2014, pp. 82–87. 
[10] M. Takalkar, M. Xu, Q. Wu, Z. Chaczko, “A survey: facial micro-expression recognition”. Multimedia Tools and Applications, 77(15), 2017, pp. 19301–19325. 
[11] S. Yao, N. He, H. Zhang, O. Yoshie, “Micro-expression recognition by feature points tracking”, 10th International Conference on Communications (COMM), 2014. 
[12] A. Davison, W. Merghani, C. Lansley, C.-C. Ng, M.H. Yap, “Objective micro-facial movement detection using FACS-based regions and baseline evaluation”. 13th IEEE International Conference on Automatic Face & Gesture Recognition, 2018, pp.642-649. 
[13] A. Davison, W. Merghani, M.H. Yap, “Objective classes for micro-facial expression recognition”, Journal of imaging, 4, 2018. 
[14] F. Xu, J. Zhang, J. Z. Wang, “Microexpression identification and categorization using a facial dynamics map”, IEEE Transactions on Affective Computing, 8(2), 2017, pp. 254–267. 
[15] L. Stanciu, F. Blidariu, “Emotional states recognition by interpreting facial features”, E-Health and Bioengineering Conference (EHB), 2017, pp. 273-276. 
[16] X. Huang, G. Zhao, X. Hong, W. Zheng, M. Pietikäinen, “Spontaneous facial micro-expression analysis using Spatiotemporal Completed Local Quantized Patterns”. Neurocomputing, 175, 2016, pp. 564–578. 
[17] X. Li, J. Yu, S. Zhan, “Spontaneous facial micro-expression detection based on deep learning”. IEEE 13th International Conference on Signal Processing (ICSP), 2016, pp. 1130-1134. 
[18] R. Breuer, R. Kimmel, “A deep learning perspective on the origin of facial expressions”, Computer Vision and Pattern Recognition, ArXiv 2017.
[19] M. Takalkar, M. Xu, “Image based facial micro-expression recognition using deep learning on small datasets”, International Conference on Digital Image Computing: Techniques and Applications (DICTA), 2017 
[20] H. Costin, C. Rotariu, I. Alexa, et al., “TELEMON - A complex system for real time medical telemonitoring”, 11th Int. Congress of the IUPESM/World Congress on Medical Physics and Biomedical Engineering, Munich, Germany, Sept. 07-12, 2009.

***

### 原文链接

> <https://blog.csdn.net/weixin_45440065/article/details/106231607>
