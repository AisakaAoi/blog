---
title: Android-ADB常用命令
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些技术
abbrlink: da31a3cc
date: 2021-08-30 19:36:03
tags:
---

把文件推到Android系统中：**adb pull 内部文件地址 外部目录**

把文件从系统中拖到电脑：**adb push 目标文件 内部目录**

抓取Log：**adb logcat > log文件名称：logcat > crash.log**

获取包名：**adb shell → logcat | grep START**

<!--more-->

应用安装：**adb install apk全路径名称**

应用卸载：**adb uninstall 包名**

启动应用：**adb shell am start -n 包名**

发送广播：**adb shell broadcast -a action** 参数见文档

ADB截图：**adb shell screencap -p /sdcard/screen.png** → **adb pull /sdcard/screen.png ./**

模拟按键：**adb shell input keyevent 键码（keyCode）**
