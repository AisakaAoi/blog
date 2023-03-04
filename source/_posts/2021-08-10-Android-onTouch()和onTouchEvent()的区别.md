---
title: Android-onTouch()和onTouchEvent()的区别
categories:
  - 🌙基础学习
  - ⭐Android
abbrlink: 6f0911e6
date: 2021-08-10 20:14:17
tags:
---

### onTouch()方法

当把手放到View上后，onTouch方法被一遍一遍的调用

onTouch方式是View的onTouchListener接口中定义的方法。当一个View绑定了onTouchListener后，当有Touch事件触发时，就会调用onTouch方法。

***

### onTouchEvent()方法

当把手放到Activity上时，onTouchEvent方法会一遍一遍的被调用

onTouchEvent方法时重载的Activity的方法。重写了Acitivity的onTouchEvent方法后，当屏幕有Touch事件时，此方法就会被调用。

<!--more-->

***

### Touch事件的传递

在一个Activity里面放一个TextView的实例tv，并且这个tv的属性设定为march_parent，在这种情况下，当手放到屏幕上的时候，首先会是tv响应Touch事件，执行onTouch方法。

如果onTouch返回值为true，表示这个Touch事件被onTouch方法处理完毕，不会把Touch事件再传递给Activity，也就是说onTouchEvent方法不会被调用。（手放到屏幕上后，onTouch方法会被一遍一遍的调用）

如果onTouch返回值为false,表示这个Touch事件没有被tv完全处理，onTouch返回以后，Touch事件被传递给Activity，onTouchEvent方法调用（当把手放到屏幕上后，onTouch方法调用一次后，onTouchEvent方法被一遍一遍的调用）

{% asset_img 1.png %}

{% asset_img 2.png %}

### 总结

dispatchTouchEvent返回值的意义跟onTouch返回值的区别：两者返回true的时候ACTION都会传递到ACTION_DOWN，其中onTouch返回true的时候由于不会执行到onTouchEvent所以不会执行到onClick，dispatchTouchEvent返回值为true对会不会执行onClick没有影响；onTouch返回false的时候执行onTouchEvent，如果此时该控件是可点击的就发执行onClick，而dispatchTouchEvent返回false就停止ACTION传递。

1. Android事件分发是先传递到ViewGroup，再由ViewGroup传递到的。

2. 在ViewGroup中可以通过onInterceptTouchEvent方法对事件拦截，onInterceptTouchEvent方法返回true代表不允许事件继续向子传递，返回false代表不对事件进行拦截，默认返回false。

3. 子View中如果将传递的事件消费掉，ViewGroup中将无法接收到任何事件。
