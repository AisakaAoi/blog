---
title: 人脸识别-DeepID3 face recognition
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
abbrlink: ebc4aeea
date: 2022-10-12 02:31:36
---

### Network Architecture

DeepID3[1]有两种不同的结构，分别为DeepID3 net1，DeepID3 net2。相对DeepID2+[2]，它的层数更多，网络更深。同时还借鉴了VGG net[3]和GoogLeNet[4]，引入了inception layer，这个主要是用在了DeepID3 net2里面。网络中还出现了连续两个conv layer直接相连的情况，这样使得网络具有更大的receptive fields和更复杂的nonlinearity，同时还能限制参数的数量。直接上图，从图中就能看出网络的结构，这里就不多说了。

{% asset_img 1.webp %}

<!--more-->

***

### Perfomance

在训练样本上，DeepID3仍采用原来DeepID2+中使用的样本，在25个image patches产生的网络上作对比时，DeepID3 net1优势最为明显，而DeepID3 net2提升不大显著。

{% asset_img 2.webp %}

DeepID3在LFW上的face verification准确率为99.53％，性能上并没有比DeepID2+的99.47％提升多少。而且LFW数据集里面有三对人脸被错误地标记了，在更正这些错误的label后，两者准确率均为99.52％。

因此，作者对于具有更深的架构网络是否具有更强的优势没有下定论，这可以作为之后的研究方向。

在检查误判人脸时，作者在DeepID[5]，DeepID2[6]，DeepID2+，和DeepID3中找出了12对相同的误判人脸。这些人脸确实不好分辨，我也分辨不出，毕竟DeepID系列从DeepID2+开始已经超越了人类。。。作者试图说明判错的原因是有的人脸确实相似，有的还有遮挡等因素，还有一些是年龄变化导致的。

{% asset_img 3.webp %}
{% asset_img 4.webp %}

***

### Conclusion

DeepID3原文篇幅较短，与之前的模型相比网络更深了，同时还引入了inception layer。但是在更正了LFW上的错误后，它的准确率却和DeepID2+一样，所以这里层数的增加，inception layer的引入等结构上的改变并没有起到提高准确率的效果。那么是否网络更深优势更大？从这里我们真的看不出，但是我们不能说它真的没有。作者最后提出一个方向，在这样深的架构上采用更多的数据集，或许这可以提升性能。

***

### 参考资料

> [1] Sun Y, Liang D, Wang X, et al. Deepid3: Face recognition with very deep neural networks[J]. arXiv preprint arXiv:1502.00873, 2015.
> [2] Sun Y, Liang D, Wang X, et al. Deepid3: Face recognition with very deep neural networks[J]. arXiv preprint arXiv:1502.00873, 2015.
> [3] Simonyan K, Zisserman A. Very deep convolutional networks for large-scale image recognition[J]. arXiv preprint arXiv:1409.1556, 2014.
> [4] Szegedy C, Liu W, Jia Y, et al. Going Deeper with Convolutions[J]. arXiv preprint arXiv:1409.4842, 2014.
> [5] Yi Sun, Xiaogang Wang, and XiaoouTang.DeepLearningFace Representation from Predicting 10,000 Classes. Computer Vision and Pattern Recognition(CVPR), 2014.
> [6] Sun Y, Chen Y, Wang X, et al. Deep learning face representation by joint identification-verification[C]//Advances in Neural Information Processing Systems. 2014: 1988-1996.

> 版权声明：本文为CSDN博主「yiyouxian」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
> 原文链接：https://blog.csdn.net/yiyouxian/article/details/52145727
