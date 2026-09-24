---
title: >-
  SFFAI 136 | 通信强化学习专题《于会涵：Deep Reinforcement Learning Based Beamforming for
  ...》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些讲座
  - 💫其它讲座
abbrlink: 58df20db
date: 2022-02-11 02:21:11
tags:
---

<iframe src="//player.bilibili.com/player.html?isOutside=true&aid=681877247&bvid=BV1UU4y1Z7bY&cid=541209304&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>

<!--more-->

SFFAI论坛网站已开放注册，详情点击查看：https://bbs.sffai.com/d/312

关注公众号：【人工智能前沿讲习】，回复【SFFAI136】获取讲者PPT资料，入交流群，推荐论文下载。

报告题目：Deep Reinforcement Learning Based Beamforming for Throughput Maximization in Ultra-Dense Networks

报告亮点：
1. We proposed a muti-agent DRL-based algorithm to improve the beamforming computation efficiency drastically. Agents train their deep Q-networks (DQNs) and execute the actions distributedly. Each agent only needs to exchange a part of the global CSI during the entire training phase.
2. To improve the computation efficiency, discrete actions are used instead of continuous actions. In addition, we divided the beamformer into two parts, namely, the transmit power and the beam direction in order to minimize the interference.
3. We designed a specific reward function to make sure the transmission rates of primary users are larger than a given threshold, and avoid to generate too much interference to secondary users.

***

### 讲者介绍

**于会涵：**北京邮电大学智能感知与计算教研中心研究生，主要研究方向为深度强化学习在通信网络中的应用。目前已在WCNC会议上发表论文。

**报告题目：**Deep Reinforcement Learning Based Beamforming for Throughput Maximization in Ultra-Dense Networks

**报告摘要：**Ultra-dense network (UDN) is a promising technology for 5G and beyond communication systems to meet the requirements of explosive data traffic. However, the dense distribution of wireless terminals potentially leads to severe interference and deteriorate network performance. To address this issue, beamforming is widely used to coordinate the interference in UDNs and improve receive gains by controlling the phase of multiple antennas. In this paper, we propose a multi-agent deep reinforcement learning (DRL) based beamforming algorithm to achieve more dynamic and fast beamforming adjustment. In the proposed algorithm, the agents inside beamforming controllers are distributively trained while exchanging partial channel state information (CSI) for better optimizing beamforming vectors to achieve maximized throughputs in UDNs. The evaluation results demonstrate that the proposed algorithm significantly improves the computation efficiency, as well as achieves the highest network throughput compared to several baselines.

**论文题目：**Deep Reinforcement Learning Based Beamforming for Throughput Maximization in Ultra-Dense Networks
 
**分享亮点：**
1. We proposed a muti-agent DRL-based algorithm to improve the beamforming computation efficiency drastically. Agents train their deep Q-networks (DQNs) and execute the actions distributedly. Each agent only needs to exchange a part of the global CSI during the entire training phase.
2. To improve the computation efficiency, discrete actions are used instead of continuous actions. In addition, we divided the beamformer into two parts, namely, the transmit power and the beam direction in order to minimize the interference.
3. We designed a specific reward function to make sure the transmission rates of primary users are larger than a given threshold, and avoid to generate too much interference to secondary users.

***

### 论文推荐

1. A Machine Learning Approach for Beamforming in Ultra Dense Network Considering Selfish and Altruistic Strategy

    **Coefficients of selfish and altruistic strategy.** They proposed to use deep reinforcement learning to determine the balancing coefficients of selfish and altruistic strategy in coordinated beamforming. The method of using balance coefficient to coordinate beamforming is novel.

    **MIMO configuration.** The performance of the proposed scheme was simulated and evaluated by experiments with arguments regarding multiple input and multiple output (MIMO) configuration, shadow fading and state design options. This paper elaborates on the formulation of beamforming in MIMO configuration, which can inspire subsequent researchers.

2. Multi-Agent Double Deep Q-Learning for Beamforming in mmWave MIMO Networks

    **Distributed multi-agent algorithm.** They proposed a distributed multi-agent double deep Q-learning network (DDQN) solution for beamfoming in mmWave MIMO networks. The proposed learning-based algorithm can achieve comparable performance with respect to exhaustive search while operating at much lower complexity.

    **Dynamic environment.** In this system, users (UEs) move to different locations at each time, and may be served by different base stations (BSs) according to the adopted largest received power association criterion. The simulation results illustrate that the proposed distributed multi-agent DDQN solution adapts to UEs’ mobility.

3. Reconfigurable Intelligent Surface Assisted Multiuser MISO Systems Exploiting Deep Reinforcement Learning

    **RIS.** They investigated the joint design of transmit beamforming at the BS and phase shifts at the reflecting reconfigurable intelligent surface (RIS) to maximize the sum rate of multiuser downlink multiple input single output (MISO) systems utilizing DRL, assuming that direct transmissions between the BS and the users are totally blocked.

    **DDPG framework.** They use policy-based deep deterministic policy gradient (DDPG) derived from Markov decision process to address continuous beamforming matrix and phase shifts. Since the transmit beamforming matrix and the phase shifts are continuous, the performance of DDPG is better, in contrast to designs addressing the discrete action space.

    **Low complexity.** The proposed DRL based algorithm has a very standard formulation and low complexity in implementation, without knowledge of explicit model of wireless environment and specific mathematical formulations. Such that it is very easy to be scaled to various system settings.

4. Towards Energy Efficient Resource Allocation: When Green Mobile Edge Computing Meets Multi-Agent Deep Reinforcement Learning

    **System model.** The issue of MEC-empowered energy efficient resource allocation has not been well studied. They presented the system model for green mobile edge computing (MEC) scenarios and formulated the long-term average energy efficiency maximization problem.

    **PPO framework.** They proposed a decentralized MADRL resource allocation algorithm for energy efficiency in green MEC. The algorithm adopted PPO framework which is novel in DRL. Compared to the three baseline methods (i.e., DQN, FP, and Random), their proposed algorithm achieved the best performance under different environment settings.

    **Robustness.** They conducted extensive experiments to evaluate the effectiveness and robustness of their proposed algorithm.

5. A Two-Hops State-Aware Routing Strategy Based on Deep Reinforcement Learning for LEO Satellite Networks

    **DRL for LEO satellite networks.** A two-hops state-aware routing strategy based on deep reinforcement learning (DRL-THSA) was proposed for LEO satellite networks. In DRL-THSA, each node collect link state information within two-hop neighbors and makes routing decisions based on the information. The link state information is interacted between nodes through Hello packets; therefore, the DRL-THSA discover the node failure event in time and change the next hop node.

    **Novel link state.** A setup and update method of link state was proposed. The link state is divided into three levels, and the traffic forwarding strategy for each level is presented, which allows DRL-THSA to cope with link congestion.

6. Leveraging Deep Reinforcement Learning for Traffic Engineering: A Survey

    **DRL-based traffic engineering (TE).** They present a comprehensive overview of DRL-based TE and the TE issues within the scope of the paper from three aspects, namely, routing optimization, congestion control, and resource management. Having distilled the major TE issues, they discuss the general procedure of formulating TE as a RL problem based on their analogy. Finally, they review fundamental DRL algorithms classified into three types, namely, value based, policy-based, and actor-critic. It is helpful for readers quickly to establish their understanding of DRL algorithm and the feasibility of DRL in TE issues.

    **Detailed literature review.** They conduct a detailed literature review on applications of DRL in TE from three categories including routing optimization, congestion control, and resource management. The research works are introduced from basic DRL models to advanced DRL models, along with their comparison and relationship.

***

### 参考资料

> <https://www.bilibili.com/video/BV1UU4y1Z7bY/>
