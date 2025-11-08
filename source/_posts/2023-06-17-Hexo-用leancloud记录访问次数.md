---
title: Hexo-用leancloud记录访问次数
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些技术
abbrlink: 52f4fc4f
date: 2023-06-17 03:21:38
tags:
---

NexT也集成了leancloud，在[leancloud官网](https://leancloud.cn/)中注册账号，获得app_key和app_id，然后在主题配置文件中进行如下配置。

``` config
# Show number of visitors to each article.
# You can visit https://leancloud.cn get AppID and AppKey.
leancloud_visitors:
  enable: true
  app_id: leanapp_id
  app_key: leanapp_key
```

<!--more-->

然后在leancloud的控制台中的存储内添加一个Counter的class，这样就可以记录我们每页的浏览量了。

{% asset_img 1.webp %}

网站评论系统需要维护用户的留言，因此需要用到数据库。轻博客不具备这些功能，除了leancloud之外，还可以借助其它第三方提供的服务。

在NexT5.1.2版本中，集成了如下第三方的评论系统，只需要在主题配置中就可以打开相应功能。

- disqus
- 畅言
- 多说
- 有言
- hypercomments
- 来必力

其中disqus、hypercomments和来必力是国外的，访问效果可能受影响，多说和有言好像也关闭了，畅言目前可用。

评论系统一个足够，在主题配置中进行相应配置，如果打开多个，会根据themes\next\layout\_third-party\comments\index.swig中的顺序，前面配置成功，后面的就无效了。

以畅言为例，只需要在主题配置中打开下列配置。

``` config
changyan:
  enable: true  #打开开关
  appid:        #畅言系统网站上申请的appid
  appkey:       #畅言系统网站上申请的appkey
```

填入从畅言网站获得的appid和appkey即可开启评论。
