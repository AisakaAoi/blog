---
title: >-
  SFFAI 142 | 动态联邦学习专题《王礼旭：Federated Class Incremental Learning, a case study
  of...》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
  - 💫其它讲座
abbrlink: c52c523a
date: 2022-04-03 02:41:16
tags:
---

<iframe src="//player.bilibili.com/player.html?isOutside=true&aid=895559391&bvid=BV1VA4y197JQ&cid=570610162&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>

<!--more-->

SFFAI论坛网站已开放注册，详情点击查看：https://bbs.sffai.com/d/312

关注公众号：【人工智能前沿讲习】，回复【SFFAI142】获取讲者PPT资料，入交流群，推荐论文下载。

分享亮点：

1. 我们是第一个提出并定义联邦类别增量学习的工作，该问题的主要挑战是不损害联邦学习隐私保护功能的前提下，有效地缓解联邦学习在旧类别数据上的灾难性遗忘。尽管我们注意到同期有类似的工作，但他们均对隐私保护有着不同程度的削弱和破坏。
2. 针对联邦类别增量学习问题，我们提出了GLFC方法，从全局和局部两个角度同时减弱灾难性遗忘的影响，据我们所知，这也是第一个该问题的解决方案。
3. 为了保护隐私和进一步减轻用户的存储负担，我们设计了一个代理服务器来为用户的本地训练选择并存储最优的全局模型，我们还设计了一种基于梯度加密的通讯机制来保护该代理服务器与用户之间的通讯。

分享摘要：

联邦学习 (FL) 的训练是基于去中心化用户的隐私数据，近年来引起了越来越多的关注。实际情况中，联邦学习的训练和部署都处于动态变化的环境中，在这种动态变化的环境中，会有源源不断的新数据和新用户参与进联邦学习。然而，大多数现有方法假设整个联邦学习框架的数据类别随着时间的推移是固定不变的，尽管这些方法称对于每个用户而言，数据分布是可随时间缓慢变化的。但在绝大多数联邦学习的应用场景中，整个框架的数据有可能会在短时间内发生巨大变化，比如新冠疫情的爆发会使得联邦学习训练而来的传染病预测模型瞬间瘫痪，手机智能应用新功能的上线会使得联邦学习训练而来的推荐系统没法及时适应新功能的数据等等。所以在联邦学习未来研究中加入动态环境持续学习的考量是十分重要且有意义的，此次报告我们以持续学习中最经典的类别增量学习为例，希望能激发大家对于动态联邦学习研究的兴趣。

在联邦类别增量学习问题中，我们认为已经参与联邦学习的用户经常可能收集到新的类别，但考虑到每个用户自己设备的存储空间非常有限，很难对其收集到的所有类别都保存下足够数量的数据，这种情况下，现如今的联邦学习模型在旧类数据上的性能很可能出现严重的灾难性遗忘(catastrophic forgetting)现象。此外，联邦学习框架往往还会有持续不断的新用户的参与，这些新用户往往有着大量的新数据类别，这样会进一步加剧全局模型的灾难性遗忘。为了应对这些挑战，我们提出了一种全新的全局-局部遗忘补偿 (GLFC) 模型，即同时从global和local两个角度出发，尽可能地减弱灾难性遗忘，使得联邦学习最终可训练一个全局增量模型。具体来说，为了解决由于local client自身新旧类别的不平衡导致的local forgetting，我们设计了一个class-aware gradient compensation loss和一个class-semantic relation distillation loss来平衡旧类的遗忘并保证跨任务的类间关系一致性。为了解决各用户之间非独立同分布类别不平衡带来的global forgetting，我们提出了一个代理服务器，它会选择最好的旧全局模型来辅助各个用户的本地训练。为了保护代理服务器和用户间通信的隐私安全性，我们提出了一种基于梯度的prototype sample通信机制。我们的模型在多个数据集上的平均准确率SOTA方法高出4.4%∼15.1%不等。

***

### 论文推荐

1. Federated Continual Learning with Weighted Inter-client Transfer (ICML 2021)
    该工作提出了一种联邦持续学习，作者假设联邦学习框架中所有用户都按照一定的任务顺序来学习。在特定的时间点，对每个用户而言，其需要学习的任务可能已经被其他用户所学习过，所以可以有效地从其他用户所学到的知识中迁移过来，当然对于不相关的知识，需要消除其不利影响。
    为解决该问题，该工作作者提出了一种模型参数解耦算法，可以对于每个用户在每个任务中学到的知识，或者说模型参数解耦成task-general和task-specific两部分，然后在中央服务器建立一个task-specific参数的数据库。这样在后续的训练中，不同用户就可以以自己特定的attention mask去这个数据库中挑对自己本地训练有利的参数。
    根据该工作实验的设定，每个用户的task sequence是随机确定的，这一点不符合我们所报告工作中的联邦类别增量学习问题，在他们的问题中，旧任务的数据有可能会在不远的未来某个时间重新出现，这样旧任务的灾难性遗忘现象就得到了缓解，而在联邦类别增量学习问题中，旧任务的数据在未来的时间最多只会零星出现，无法缓解灾难性遗忘现象。

2. Addressing Class Imbalance in Federated Learning (AAAI 2021)
    该工作解决了经典联邦学习中的类别不平衡问题，因为类别增量学习其实可以看成一种极端情况下的类别不平衡问题，所以该工作与所报告内容非常相关。
    所报告工作的class-aware gradient compensation loss是由该论文的Ratio-Loss启发而来。

3. iCaRL: Incremental Classifier and Representation Learning (CVPR 2017)
    最经典的类别增量学习paper，提出了exemplar-replay的增量学习方法，启发了一系列replay-based methods，研究增量学习必读文章。
    所报告工作的class-semantic relation distillation loss由该工作以及另一些相关论文启发而来。

4. Robbing the Fed: Directly Obtaining Private Data in Federated Learning with Modified Models (ICLR 2022)
    联邦学习reconstruction攻击的state-of-art
    为了防止这种重构攻击，所报告工作中设计了一个基于梯度的perturbed sample的通讯机制，用于保证用户和代理服务器间的安全通信。

5. iDLG: Improved Deep Leakage from Gradients
    所报告工作中的基于梯度的通讯机制由该论文启发而来。
    该论文有效地加入label information来帮助原先deep leakage from gradient(NeurIPS 2019)工作的数据重构优化过程，速度更快，精度更高。

6. Looking Back on Learned Experiences For Class/task Incremental Learning (ICLR 2022)
    提出了一种cost-free的增量学习方法，与经典的replay-based和regularization-based的方法不同，该论文从已学到的知识中生成旧任务的数据来帮助增量学习过程中的灾难性遗忘减弱。
    该论文所提出方法的性能甚至超过部分replay-based的增量学习方法，以此可见，未来增量学习的研究重点可能会是在non-replay方法上。

***

### 参考资料

> <https://www.bilibili.com/video/BV1VA4y197JQ/>
