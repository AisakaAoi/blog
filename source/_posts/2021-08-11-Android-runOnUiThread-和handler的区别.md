---
title: Android-runOnUiThread()和handler的区别
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些技术
abbrlink: 4fab8125
date: 2021-08-11 14:53:32
tags:
---

在Android开发过程中，常需要更新界面的UI，而更新UI是要主线程来更新的，即UI线程更新。Android中的View不是线程安全的，如果在主线程之外的线程中直接更新页面显示会报错。runOnUithread(Runnale)和Handler.post(Runnable)都是将更新UI的操作提交到主线程/UI线程中执行。

非主UI线程更新视图的两种方法：一种是Handler，一种是Activity中的runOnUiThread(Runnable)方法。

<!--more-->

***

### Handler

对于Handler是采用传递消息的方式，调用Handler中方法来处理消息更新视图，这种方式对于不是很频繁的调用是可取的。如果更新的较快，则消息处理会一直排队处理，这样显示会相对滞后。

在主线程中使用：（本身主线程就可以，没必要这样用Handler）【慢慢排队】

``` java
new Handler().post(new Runnable() {
    @Override
    public void run() {
        mTest.setText("post");//更新UI
    }
});
```

在子线程中使用：（使用handler方法切回主线程时，注意handler的实例化要放在主线程中，而不能在新开的子线程中）

``` java
Handler handler = new Handler();
new Thread(new Runnable() {
    @Override
    public void run() {
        /**
           耗时操作
         */
        handler.post(new Runnable() {
            @Override
            public void run() {
                /**
                   更新UI
                 */
            }
        });
    }
}).start();
```

### runOnUiThread()

实时性较高则用runOnUiThread()，将需要执行的代码放到Runnable的run方法中，然后调用runOnUiThread()这个方法将Runnable的对象传入即可。【在主线程就插队，不然还是排队】

``` java
runOnUiThread(new Runnable() {
    @Override
    public void run() {
        // do something
    }
});
```

流程：事件响应→开启线程→runOnUiThread→判断是否当前线程为主UI线程（是就立刻执行，不是就通过handler.post()发送到动作序列中，等到是主UI线程再立刻执行）

### 结论与三种常见更新方式

runOnUiThread()这个方法比较适合在异步线程之前去更新进度条之类的UI操作，在线程执行过程之中动态更新UI的方法最好还是选用Handler.post()这一种方法。

``` java
final Handler handler = new Handler();
new Thread(new Runnable() {
    @Override
    public void run() {
    // 素描算法处理 耗时操作
        final Bitmap bitmap = SketchUtil.testGaussBlur(finalBitmap,1,1);
        // 三种切回主线程更新UI的方法
        imageView.post(new Runnable() {
            @Override
            public void run() {
                imageView.setImageBitmap(bitmap); // 素描图
            }
        });
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                orignView.setImageBitmap(bitmap); // 素描图
            }
        });
        handler.post(new Runnable() {
            @Override
            public void run() {
                threeView.setImageBitmap(bitmap); // 素描图
            }
        });
    }
}).start();
```
