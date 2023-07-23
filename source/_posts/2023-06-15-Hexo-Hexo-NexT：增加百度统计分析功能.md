---
title: Hexo-Hexo+NexT：增加百度统计分析功能
categories:
  - 🌙基础学习
  - ⭐Git&Hexo
abbrlink: 424ebcb2
date: 2023-06-15 17:15:54
tags:
---

### 增加百度统计分析功能

1. 访问百度统计<http://tongji.baidu.com>网站，注册。进入管理菜单，在网站列表下面注册网站并获得访问代码如下。

``` js
<script>
var _hmt = _hmt || [];
(function() {
  var hm = document.createElement("script");
  hm.src = "https://hm.baidu.com/hm.js?ce33112f521e07dfe453757625e4XXXX";
  var s = document.getElementsByTagName("script")[0]; 
  s.parentNode.insertBefore(hm, s);
})();
</script>
```

<!--more-->

2. 这是一段JavaScript脚本代码。把它放入所有页面的<head>标签最前方，就可以实现访问统计，其中ce33112f521e07dfe453757625e4XXXX是你网站的标识码。

3. 在NexT中，这段代码已经放入themes\next\layout\_third-party\analytics\baidu-analytics.swig，通过include，当满足条件是就会植入页面头部。

4. 在主题配置中，设置baidu_analytics的值，也就是上面说的标识码，然后植入页面头部代码就会生效。

``` md
baidu_analytics: ce33112f521e07dfe453757625e4XXXX
```
