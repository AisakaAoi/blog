---
title: Linux-部署Node.js和Express框架
categories:
  - 🌙基础学习
  - ⭐Linux
abbrlink: e3e12799
date: 2020-12-22 00:29:14
---

### 前期准备

- [putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/)

- [腾讯云服务器或轻量应用服务器](https://cloud.tencent.com/)

***

### 云服务器配置

- 镜像：系统镜像：CentOS 7.6

***

### 云服务器准备

- 重置密码

{% asset_img 1.webp %}

***

<!--more-->

### 登录云服务器

- 使用 putty 输入公网ip地址登录云服务器

{% asset_img 2.png %}

- 输入账号密码，登录 root

***

### 配置Node.js

- 查看当前目录：输入pwd会发现此时默认在 /root

```shell
[root@VM-8-3-centos ~]# pwd
```

- 若不在 /root，我习惯是切换到 root (方便我之后代码统一)

```shell
[root@VM-8-3-centos ~]# cd /root
```

- 下载node的镜像，此次使用 taobao 镜像的 node v14.15.2 版本（如果太慢了就在电脑上复制链接下载好，用WinSCP传过去）

```shell
[root@VM-8-3-centos ~]# wget https://npm.taobao.org/mirrors/node/v14.15.2/node-v14.15.2-linux-x64.tar.xz
```

- 解压下载好的压缩包

```shell
[root@VM-8-3-centos ~]# tar -xvf ./node-v14.15.2-linux-x64.tar.xz
```

- 为了环境卫生，删除已解压的压缩包

```shell
[root@VM-8-3-centos ~]# rm -rf ./node-v14.15.2-linux-x64.tar.xz
```

- 配置node的环境变量

```shell
[root@VM-8-3-centos ~]# ln -s /root/node-v14.15.2-linux-x64/bin/node /usr/local/bin/
[root@VM-8-3-centos ~]# ln -s /root/node-v14.15.2-linux-x64/bin/npm /usr/local/bin/
```

- 查看环境配置是否完成

```shell
[root@VM-8-3-centos ~]# node -v
[root@VM-8-3-centos ~]# npm -v
```

- 注：低版本的npm下载依赖比较慢，若下载速度慢，可以使用以下命令可以将npm升级至最新版本

```shell
[root@VM-8-3-centos ~]# npm install -g npm
```

***

### 配置Express框架

- 下载 taobao 的 cnpm，比普通的 npm 翻墙下载快多了，并配置环境变量

```shell
[root@VM-8-3-centos ~]# npm install cnpm -g --registry=https://registry.npm.taobao.org
[root@VM-8-3-centos ~]# ln -s /root/node-v14.15.2-linux-x64/bin/cnpm /usr/local/bin/
```

- 全局安装Express，并配置环境变量

```shell
[root@VM-8-3-centos ~]# cnpm install -g express 
[root@VM-8-3-centos ~]# cnpm install -g express-generator
[root@VM-8-3-centos ~]# ln -s /root/node-v14.15.2-linux-x64/bin/express /usr/local/bin/
```

- 创建一个 express 站点 cloud

```shell
[root@VM-8-3-centos ~]# cd /home/
[root@VM-8-3-centos ~]# express cloud
```

- 初始化完成后，进入到目录中，安装对应的依赖

```shell
[root@VM-8-3-centos ~]# cd cloud/
[root@VM-8-3-centos ~]# cnpm install
```

- 测试Express（记得在云服务器安全组开放3000端口）

```shell
[root@VM-8-3-centos ~]# DEBUG=cloud:* npm start
```

#### 参考资料

> <https://www.cnblogs.com/liuqi/p/6483317.html>
> <https://blog.csdn.net/weixin_42883636/article/details/87720104>
> <https://blog.csdn.net/qq_38306688/article/details/80454896>
