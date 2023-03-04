---
title: Android-四大组件-Activity启动模式
categories:
  - 🌙基础学习
  - ⭐Android
abbrlink: ee465568
date: 2021-07-20 17:21:15
tags:
---

### Activity启动模式

1. &lt;activity android:name=".FirstActivity" android:launchMode="standard"&gt;

    standard模式会创建新的任务，并把新Activity置于当前栈顶，点击返回键相当于移除栈顶Activity，栈空时销毁Task。

    使用场景：默认的启动模式，大多数场景都是用该模式。

2. &lt;activity android:name=".FirstActivity" android:launchMode="singleTop"&gt;

    singleTop模式在standard模式的基础上，表示如果当前栈顶为该Activity，则不会创建新的Activity（防止栈顶Activity重复创建）。

    使用场景：一般来说，为保证只有一个任务，而不被创建多个时需要此模式。例如，浏览器的书签被动调用的界面）、应用的推送通知、配置及配置里的内容等。

    <!--more-->

3. &lt;activity android:name=".FirstActivity" android:launchMode="singleTask"&gt;

    singleTask模式在singleTop的基础上，表示如果Task中已存在该Activity但不在栈顶，则会移除栈顶Activity直至该Activity成为栈顶（保证仅有一个该Activity）。跨app时则会在此基础上把原有的Task压到当前Task顶。

    使用场景：Task或Activity占的资源相对比较大时，使用该模式。（唯一性）

    （只有一个Task里有这个Activity，同时这个Activity里最多只有一个这个Activity。）

    【补充知识：当不同Task在前台堆叠时，进入后台就会分开，例如按home⚪键以及最近任务■键的瞬间。】

4. &lt;activity android:name=".FirstActivity" android:launchMode="singleInstance"&gt;

    singleInstance模式在singleTask的基础上，但该Activity会单独一个Task并压到当前栈顶。若此时打开有singleInstance模式的app的其它Activity，则会在原有Task里创建并压到当前Task顶（三个Task压成一个，但⚪/■后分离）。（唯一性与独占性）

    使用场景：在整个系统中只有唯一一个实例，例如，Launcher，有道词典的取词。
