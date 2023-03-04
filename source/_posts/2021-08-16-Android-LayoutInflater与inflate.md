---
title: Android-LayoutInflater与inflate()
categories:
  - 🌙基础学习
  - ⭐Android
abbrlink: bc5422d5
date: 2021-08-16 17:03:12
tags:
---

在开发中，我们经常需要使用到LayoutInflater，通过该对象的inflate()方法，将一个layout布局文件实例化为View对象。

### LayoutInflater

对于LayoutInflater的定义，我们来看一下官方文档：

Instantiates a layout XML file into its corresponding android.view.View objects.

意思是，将一个XML文件实例化为对应的View对象。

<!--more-->

在实际开发中，我们避免不了需要使用到LayoutInflater类中的inflate()方法。对于LayoutInflater对象的获取，有三种方式。

``` java
// 第一种方式
LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

// 第二种方式
LayoutInflater inflater = LayoutInflater.from(context);

// 第三种方式
LayoutInflater inflater = activity.getLayoutInflater();
```

#### context.getSystemService()

getSystemService()是Android很重要的一个API，它是Context类的一个方法，根据传入的name来取得对应的Object，然后转换成相应的服务对象。Context.LAYOUT_INFLATER_SERVICE表示我们取得的是实例化layout的服务对象。

#### LayoutInflater.from()

它的内部实现如下：

``` java
/**
 * Obtains the LayoutInflater from the given context.
 */
public static LayoutInflater from(Context context) {
    LayoutInflater LayoutInflater =
    (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    if (LayoutInflater == null) {
        throw new AssertionError("LayoutInflater not found.");
    }
    return LayoutInflater;
}
```

from()是LayoutInflater中的一个静态方法，返回LayoutInflater对象。我们可以看到，方法内部其实使用的是context.getSystemService()，也就是上述第一种方式。

#### activity.getLayoutInflater()

getLayoutInflater()是Activity类的一个方法，也就是说只有通过Activity类的引用才能调用，相比于第一种和第二种方式，此种方式存在一定的使用局限。我们来看一下它的内部实现。

``` java
// Window类的关键代码

package android.app;

public class Activity extends ContextThemeWrapper implements ... {
    // ......
    private Window mWindow;
    // ......

    @NonNull
    public LayoutInflater getLayoutInflater() {
        return getWindow().getLayoutInflater();
    }

    public Window getWindow() {
        return mWindow;
    }

    final void attach(...) {
        // ......
        mWindow = new PhoneWindow(this);
        // ......
    }

    // ......
}
```

从源码可以看到，当我们调用getLayoutInflater()方法时，方法内部先调用了getWindow()方法，而getWindow()返回的是Activity类的mWindow成员变量，mWindow是Window类的引用。当Activity被创建时，会调用attach()方法，在attach()方法里面完成mWindow成员变量赋值，mWindow实际上是PhoneWindow类的对象。Window是一个抽象类，其内部的getLayoutInflater()方法是abstract的，PhoneWindow类继承自Window类，实现了getLayoutInflater()方法，即我们最终调用的是PhoneWindow类的getLayoutInflater()方法。

``` java
// Window类的关键代码

package android.view;

public abstract class Window {

    // ......

    @NonNull
    public abstract LayoutInflater getLayoutInflater();

    // ......

}
```

``` java
// PhoneWindow类的关键代码

package com.android.internal.policy;

public class PhoneWindow extends Window implements MenuBuilder.Callback {

    // ......

    private LayoutInflater mLayoutInflater;

    // ......

    public PhoneWindow(Context context) {
        super(context);
        mLayoutInflater = LayoutInflater.from(context);
    }

    @Override
    public LayoutInflater getLayoutInflater() {
        return mLayoutInflater;
    }

    // ......
}
```

PhoneWindow类的getLayoutInflater()方法，内部使用的其实是LayoutInflater.from(context)，即上述第二种方式。

#### 总结

获取LayoutInflater对象，最终都是通过调用Context类的getSystemService()方法来实现的。

### inflate()

inflate方法的主要作用就是将xml转换成一个View对象，用于动态的创建布局。

它有四种重载形式，但最终都只会调用下面的第四种。

``` java
public View inflate(int resource, ViewGroup root)
public View inflate(int resource, ViewGroup root, boolean attachToRoot)
public View inflate(XmlPullParser parser, ViewGroup root)
public View inflate(XmlPullParser parser, ViewGroup root, boolean attachToRoot)

// 常见方式
inflater.inflate(R.layout.test, null);
inflater.inflate(R.layout.test, root, false);
inflater.inflate(R.layout.test, root);  // 不指定则默认为true
inflater.inflate(R.layout.test, root, true);
```

第四种方法的内部实现原理就是利用Pull解析器，对Xml文件进行解析，然后返回View对象。

#### 参数解析

1. resource 布局的资源id

2. root 填充的根视图

3. attachToRoot 是否将载入的视图绑定到根视图中

#### 应用详解

1. 如果root == null，attachToRoot将失去作用，设置任何值都没有意义。ResourceId的根节点没有依赖的父布局（容器），所以width和height属性失效。

2. 如果root != null，attachToRoot == true，则会给加载的布局文件的指定一个父布局，即root。并将root返回，resourceId中的width和height属性有效。

3. 如果root != null，attachToRoot == false，不添加到root中。会将布局文件最外层的所有layout属性进行设置，当该view被添加到父view当中时，这些layout属性会自动生效。

#### 总结

1. 如果root != null，布局文件最外层的layout关于LayoutParams设置的属性和其他属性都会被保留下来。

2. attachToRoot == true，则会给加载的布局文件的指定一个父布局，我们不需要自己在addView，否则会报错。

3. attachToRoot == false，需要我们自己addView，root为null时，被加载的布局LayoutParams的属性会被改变，但是其它属性例如背景颜色什么的会被保留。

### 参考与鸣谢

> <https://blog.csdn.net/ruancoder/article/details/51760942>
> <https://www.cnblogs.com/quanziheng/p/13527871.html>
> <https://www.cnblogs.com/x-bing/p/6744471.html>
> <https://www.jianshu.com/p/83438249ae91>
