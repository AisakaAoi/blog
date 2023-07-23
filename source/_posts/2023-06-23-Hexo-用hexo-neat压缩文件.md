---
title: Hexo-用hexo-neat压缩文件
categories:
  - 🌙基础学习
  - ⭐Git&Hexo
abbrlink: 47f39781
date: 2023-06-23 03:35:53
tags:
---

hexo-neat作为一个hexo插件出现，他支持压缩html、css和js文件，可以消除hexo生成网页过程中留下大大片空白，压缩输出文件的体积。使用方法如下：

1. 使用npm安装hexo-neat插件

``` cmd
npm install hexo-neat --save
```

<!--more-->

2. 在**站点配置文件**中打开开关。

``` config
neat_enable: true  #打开总开关
neat_html:      
  enable: true      #打开压缩html文件开关
  exclude:          #html的排除列表

neat_css:          
  enable: true      #配置CSS文件开关
  exclude:
    - '**.min.css'   #配置排除文件  

neat_js:
  enable: true       #js压缩开关
  mangle: true       #是否破坏文件名
  output:            #是否输出log日志，默认为true
  compress:
  exclude:
    - '*.min.js'     #js文件压缩排除列表
```

对于插件，除了日志输出外，用户基本无感。
