---
title: Hexo-NexT主题添加pdf预览
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些技术
abbrlink: 182775a5
date: 2020-12-24 14:57:12
tags:
---

### Install hexo dependency

``` cmd
$ npm install --save hexo-pdf
```

***

### Usage

**/_config.yml** 中调整为 **post_asset_folder: true**

**/themes/next/_config.yml** 中的 **pdf** 调整为 **enable: true**

***

<!--more-->

#### 第一种方法

源文件在 **/themes/next/source**，在要预览pdf的博客中写入：

```
{% pdf ./xxx.pdf %}
```

所以例如pdf文件的路径是 **\themes\next\source\file\Deep_Residual_Learning_for_Image_Recognition.pdf**，那么在博客中应为：

``` 
{% pdf ./file/Deep_Residual_Learning_for_Image_Recognition.pdf %}
```
或者
```
[Deep_Residual_Learning_for_Image_Recognition.pdf](/file/Deep_Residual_Learning_for_Image_Recognition.pdf)
```

{% asset_img 1.webp %}

{% asset_img 2.png %}

***

#### 第二种方法

这种是比较自定义的方法，用html解决

``` html
<object data="./xxx.pdf" type="application/pdf" width="100%" height="1000px">
```

object可换成embed, iframe

***
