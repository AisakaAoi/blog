---
title: Hexo-fatal：in unpopulated submodule 'XXX'
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些技术
abbrlink: '58080252'
date: 2023-03-04 04:19:41
tags:
---

踩坑小记，Hexo & Git上传到远程库的时候发现一个文件夹上传不成功，报错如下

``` cmd
fatal: in unpopulated submodule 'themes/next'
```

原因是这个文件夹来自的库是第三方库，通常这种情况就会出现报错

解决办法：删除git下载别人的东西文件夹里的.git，手动进去把这个隐藏的文件夹删了。

然后再删除一下缓存

``` cmd
git rm -rf --cached
```

之后再 git add / git commit / git push 就不会出错了！
