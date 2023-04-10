---
title: 'Hexo-Hexo异常：fatal:in unpopulated submodule ''.deploy_git'' 怎么解决？'
categories:
  - 🌙基础学习
  - ⭐Git&Hexo
abbrlink: cff31d29
date: 2023-03-05 04:09:07
tags:
---

之前把hexo博客源文件git到github上后，想可以在多台电脑更新我的blog，以及以防万一电脑坏了丢失了源文件，然后在另一台电脑git push的时候它居然报了错。

这种情况可以先安装下相关的依赖：

```cmd
npm install hexo-deployer-git –save
```

实在不行，就把它删掉，然后重新生成和部署。

``` cmd
rm -rf .deploy_git
hexo clean && hexo g && hexo d
```

<!--more-->

如果还不行，可能是不知道为什么命令行没删掉。那就手动把根目录下的 .deploy_git 目录删除即可，重新hexo g hexo d的时候重新生成。.deploy_git目录删除重新创建不影响原本的东西，反正sourse文件夹里面别动就行。
