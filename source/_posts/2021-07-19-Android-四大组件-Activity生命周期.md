---
title: Android-四大组件-Activity生命周期
categories:
  - 🌙基础学习
  - ⭐Android
abbrlink: 13b8c915
date: 2021-07-19 16:42:46
tags:
---

### Activity生命周期

小程序的生命周期（左图）与Android Activity生命周期（右图）类似

{% asset_img 1.png %}

{% asset_img 2.png %}

<!--more-->

生命周期：onCreate() -> onStart() - > onResume() -> onPause() -> onStop() -> onDestroy()

1. onCreate()（必须实现）

    系统首次创建Activity时触发，Activity会在创建后进入“已创建”状态。该逻辑在Activity的整个生命周期中只发生一次，所以只需执行基本的应用启动逻辑，例如将数据绑定到列表、将Activity与ViewModel关联的initView()方法、实例化某些类作用域变量、实现点击事件的initListener()方法等。

    若有生命周期感知型组件与Activity生命周期相关联，则组件会收到ON_CREATE事件，系统将调用带有@OnLifecycleEvent注释的方法。（这个还未实操过）

    官方示例中，在onCreate()里声明界面（通过资源ID R.layout.*传递给setContentView()来指定XML布局文件）、定义成员变量、配置某些界面。

    调用onCreate()后，Activity进入”已开始“状态，系统会相继调用onStart()和onResume()方法。

2. onStart()

    Activity进入”已开始“状态后，系统会调用此回调方法。onStart()调用使Activity对用户可见，应用会为Activity进入前台并支持互动做准备，比如通过此方法来初始化维护界面的代码。

    同理，相关联的生命周期感知型组件会受到ON_START事件。

    此方法会非常快速完成，并与”已开始“状态一样不会长时间处于该状态。一旦回调结束，Activity便进入”已恢复“状态，调用onResume()方法。

3. onResume()

    处于该”已恢复“状态时，Activity来到前台，调用onResume()回调。此时是应用与用户互动的状态，会一直保持该状态直至某些事件发生让应用失焦，比如手机来电、跳转至另一个Activity、设备屏幕关闭等。

    同理，相关联的生命周期感知型组件会受到ON_RESUME事件。此时，生命周期组件可以启用组件可见并位于前台时需要运行的任何功能，例如启动相机预览。

    当发生中断事件时，Activity进入”已暂停“状态，调用onPause()回调。

    从”已暂停“状态返回”已恢复“状态时，会重新调用onResume()方法。所以应在onResume()中初始化onPause()释放的组件，以及其它必须完成的初始化操作。

    此部分不够熟悉，加一份代码巩固一下，以下是生命周期感知型组件收到ON_RESUME事件时访问相机：

    ``` java
    public class CameraComponent implements LifecycleObserver {
        // ...
        @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
        public void initializeCamera() {
            if (camera == null) {
                getCamera();
            }
        }
        // ...
    }
    ```

    无论在哪个方法中执行初始化操作，都务必使用相对应的生命周期事件来释放资源。例如ON_START事件后初始化某些内容，则需要在ON_STOP事件后释放或终止相应内容；ON_RESUME事件后初始化某些内容，则需要在ON_PAUSE事件后释放或终止相应内容。

4. onPause()

    此方法视为用户将要离开此Activity的第一个标志，但不意味着Activity会被销毁，而是表示Activity不再位于前台（虽然多窗口下依然可见）。文档中，使用onPause()方法暂停或调整Activity处于“已暂停”时不应继续或受限的操作以及希望很快恢复的操作。

    进入此状态的原因：某些事件中断应用执行；应用失焦；可见但未处于焦点之中。

    同理，相关联的生命周期感知型组件会受到ON_PAUSE事件。此时，生命周期组件可以停止组件未位于前台时无需运行的任何功能，例如停止相机预览。

    还可使用该方法释放系统资源、传感器（例如GPS）手柄，或Activity暂停且用户不需要时影响电池续航时间的任何资源。在多窗口模式中，因“已暂停”的Activity可能仍完全可见，因此需要用onStop()来完全释放、调整与界面相关的资源与操作，提高多窗口模式的用户体验。

    ``` java
    public class JavaCameraComponent implements LifecycleObserver {
        // ...
        @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
            public void releaseCamera() {
                if (camera != null) {
                    camera.release();
                    camera = null;
                }
            }
        // ...
    }
    ```

    onPause()调用完毕后Activity会保持此状态，直至恢复为“已恢复”触发onResume()或对用户完全不可见触发onStop()。

5. onStop()

    若Activity不再对用户可见，说明其进入“已停止”状态，系统调用onStop()回调。例如，新启动的Activity覆盖整个屏幕时，以及Activity已结束运行并即将终止。

    同理，相关联的生命周期感知型组件会受到ON_STOP事件。此时，生命周期组件可以停止组件未显示在屏幕上时无需运行的任何功能。

    在onStop()中，应用应释放或调整在应用对用户不可见时的无用资源。例如，应用暂停动画效果、从精确的位置更新切换为粗略位置更新。在多窗口模式下，使用onStop()而非onPause()可确保与界面相关的工作继续进行。

    应使用onStop()执行CPU相对密集的关闭操作。例如信息保存到数据库（未找到更好时机时）。

    当Activity进入“已停止“状态时，Activity要么返回与用户互动，要么结束运行并消失。若Activity返回，系统将调用onRestart()；如果Activity结束运行，系统将调用onDestroy()。

6. onDestroy()

    销毁Activity之前，系统会调用onDestroy()。例如，Activity即将结束（用户彻底关闭Activity或系统为Activity调用finish()），由于配置变更使得系统暂时销毁Activity（例如设备旋转或多窗口模式）。

    应使用ViewModel对象来包含Activity的相关视图数据，而不是在Activity中加入逻辑来确定Activity被销毁的原因。如果因配置变更而重新创建Activity，ViewModel不必执行任何操作，因为系统将保留ViewModel并将其提供给下一个Activity实例。若不重新创建Activity，ViewModel将调用onCleared()方法，在Activity被销毁前清除所需的任何数据。

    如果Activity即将结束，onDestroy()是Activity收到的最后一个生命周期回调。如果由于配置变更而调用onDestroy()，系统会立即新建Activity实例，然后在新配置中为新实例调用onCreate()。

    onDestroy()回调应释放先前的回调（例如onStop()）尚未释放的所有资源。
