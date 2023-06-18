---
title: Git-commit代码提交说明规范
categories:
  - 🌙基础学习
  - ⭐Git&Hexo
abbrlink: b1b30ed3
date: 2022-10-11 21:24:04
tags:
---

git 是现在市面上最流行的版本控制工具，书写良好的 commit message 能大大提高代码维护的效率。但是在日常开发中由于缺少对于 commit message 的约束，导致填写内容随意、质量参差不齐，可读性低亦难以维护。在项目中引入 commit message 规范已是迫在眉睫。

### 用什么规范？

现在市面上比较流行的方案是约定式提交规范（Conventional Commits），它受到了 Angular 提交准则的启发，并在很大程度上以其为依据。约定式提交规范是一种基于提交消息的轻量级约定。它提供了一组用于创建清晰的提交历史的简单规则；这使得编写基于规范的自动化工具变得更容易。这个约定与 SemVer 相吻合，在提交信息中描述新特性、bug 修复和破坏性变更。它的 message 格式如下：

```
// 头header
<类型>[可选的作用域]: <描述>
// 空一行
[可选的正文]
// 空一行
[可选的脚注]
```

即👇

```
<type>([scope]): <subject> 

[body]

[footer]
```

<!--more-->

***

### Commit message 规范

#### header（关键）

记录主要的修改类型和内容

由三个部分组合：type（必填）、scope（可选）、subject（必填）

##### type

```
# 主要type
feat:     增加新功能
fix:      修复bug

# 特殊type
docs:     只改动了文档相关的内容
style:    不影响代码含义的改动，例如去掉空格、改变缩进、增删分号
build:    构造工具的或者外部依赖的改动，例如webpack，npm
refactor: 代码重构时使用
revert:   执行git revert打印的message

# 暂不使用type
test:     添加测试或者修改现有测试
perf:     提高性能的改动
ci:       与CI（持续集成服务）有关的改动
chore:    不修改src或者test的其余修改，例如构建过程或辅助工具的变动
```

当一次改动包括主要type与特殊type时，统一采用主要type。

当然最好是分两次commit，便于了解每次的具体更新内容，方便回滚。

##### scope

scope非必填，用于说明此次提交影响的范围，比如数据层、控制层、视图层等。

也可用于描述改动的范围，格式为项目名/模块名，例如：node-pc/common rrd-h5/activity。如果一次commit修改多个模块，建议拆分成多次commit，以便更好追踪和维护。

简单易懂，成规则就好。

##### subject

必填，此次提交的简短描述。动词开头，用英文的话用第一人称现在时，比如add，而不用added、adds，第一个字母小写，句尾不加句号（.）

***

#### body（可省略）

body填写详细描述，可多行，与header之间空一行，主要描述改动之前的情况及修改动机，对于小的修改不作要求，但是重大需求、更新等必须添加body来作说明。

***

#### footer（可省略）

footer只用于以下两种情况：

##### break changes

break changes（不兼容变动）

break changes指明是否产生了破坏性修改，涉及break changes的改动必须指明该项，类似版本升级、接口参数减少、接口删除、迁移等。要写清楚变动的描述、变动的理由以及迁移的方法，比如用户密码的加密方式发生改变，如果进行了类似的修改，务必也在body中说明！

##### affect issues

affect issues（关闭issue）

当前提交修改了某个issue，整体的git message如下：

```
feat(数据层): [简短描述]

[详细描述]

BREAKING CHANGE: 不兼容变动

Closes 关闭issue
```

affect issues 指明是否影响了某个问题。例如我们使用 jira 时，我们在 commit message 中可以填写其影响的 JIRA_ID，若要开启该功能需要先打通 jira 与 gitlab。

（上班时一般会用到，便于统计你的bug情况，影响你的okr和kpi）

***

### idea插件

知道了提交的规范，但是经常记不住格式怎么办？

这时强大的 idea 插件 Git Commit Message Helper，真香

#### 安装

在 settings->plugins，搜索 Git Commit Message Helper，点击 install 并重启即可

{% asset_img 1.webp %}

#### 使用

在 git 提交页面，点击 create commit message 按钮，弹出如下窗口，编辑之后，点击 ok

{% asset_img 2.webp %}

在以下弹窗输入信息

{% asset_img 3.webp %}

提交的message如下

{% asset_img 4.webp %}

***

### 参考资料

> <https://www.jianshu.com/p/6a6b9698cf06>
> <https://baijiahao.baidu.com/s?id=1711325963965181539>
