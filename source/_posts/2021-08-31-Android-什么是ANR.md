---
title: Android-什么是ANR
categories:
  - 🌙基础学习
  - ⭐Android
abbrlink: 7496070b
date: 2021-08-31 19:32:33
tags:
---

### 简介

ANR的全称是Application Not Respond，意思就是程序未响应，类似于我们在windows上见到的程序未响应。

### 原因

Android系统中，ActivityManagerService（简称AMS）和WindowManagerService（简称WMS）会检测App的响应时间，如果App在特定时间无法相应屏幕触摸或键盘输入时间，或者特定事件没有处理完毕，就会出现ANR。

无论是四大组件或者进程等只要发生ANR，最终都会调用AMS.appNotResponding()方法。

以下四个条件都可以造成ANR发生：

**InputDispatching Timeout**：5秒内无法响应屏幕触摸事件或键盘输入事件。

**BroadcastQueue Timeout**：在执行前台广播（BroadcastReceiver）的onReceive()函数时10秒没有处理完成，后台为60秒。

**Service Timeout**：前台服务20秒内，后台服务在200秒内没有执行完毕。

**ContentProvider Timeout**：ContentProvider的publish在10s内没进行完。

<!--more-->

1. 只有主线程（UI线程）才会产生ANR

2. 必须发生某些输入事件或特定操作，比如按键或触屏等输入事件，在BroadcastReceiver或Service的各个生命周期调用函数

3. 上述事件响应超时，不同的context规定的上限时间不同

### ANR的根本原因

1. 耗时的网络访问

2. 大量的数据读写

3. 数据库操作

4. 硬件操作（比如camera)

5. 调用thread的join()方法、sleep()方法、wait()方法或者等待线程锁的时候

6. service binder的数量达到上限无法和和System Server通信

7. system server中发生WatchDog ANR

8. service忙导致超时无响应

9. 其他线程持有锁，导致主线程等待超时

10. 其它线程终止或崩溃导致主线程一直等待

### 避免ANR及ANR的解决办法

1. 主线程阻塞或主线程数据读取

    避免死锁的出现；

    避免在主线程执行耗时操作，所有耗时操作应新开一个子线程完成，然后再在主线程更新UI；

    尽量避免在主线程query provider、不要滥用SharePreferences。

2. CPU满负荷，I/O阻塞

    文件读写或数据库操作放在子线程异步操作。

3. 内存不足

    AndroidManifest.xml文件&lt;applicatiion&gt;中可以设置 android:largeHeap="true"，以此增大App使用内存（不过**不建议使用此法**，从根本上防止内存泄漏，优化内存使用才是正道）

4. 各大组件ANR

    各大组件生命周期中也应避免耗时操作，注意BroadcastReciever的onRecieve()、后台Service和ContentProvider也不要执行太长时间的任务；

    BroadcastReceiver要执行耗时操作时应启动一个service，将耗时操作交给service来完成；

    避免在Intent Receiver里启动一个Activity，因为它会创建一个新的画面，并从当前用户正在运行的程序上抢夺焦点。如果应用程序在响应Intent广播时需要向用户展示什么，应该使用Notification Manager来实现。

### 参考与鸣谢

> <https://www.jianshu.com/p/388166988cef>
