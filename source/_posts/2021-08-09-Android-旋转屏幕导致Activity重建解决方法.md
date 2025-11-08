---
title: Android-旋转屏幕导致Activity重建解决方法
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些技术
abbrlink: 23d10eaa
date: 2021-08-09 20:23:52
tags:
---

### 禁止旋转屏幕

``` java
<activity
    android:name=".MyActivity"
    android:screenOrientation="portrait"
    android:label="@string/app_name"/>
```

### 旋转后恢复现场

“持久化/恢复现场”来解决。即在onPause()里将用户当前已经输入的内容保存到数据库或Preference，在onCreate()方法里读取并填充到表单中，这也是官方推荐的方法。

<!--more-->

如果Activity重建需要耗费大量资源或需要访问网络导致时间很长，可以实现onRetainNonConfigurationInstance()方法将所需数据先保存到一个对象里，像下面这样：

``` java
@Override
public Object onRetainNonConfigurationInstance() {
    final MyDataObject data = collectMyLoadedData();
    return data;
}
```

重建时，在onCreate()方法里通过getLastNonConfigurationInstance()方法获得之前保存的数据，如下所示：

``` java
@Override
public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main);
    final MyDataObject data = (MyDataObject) getLastNonConfigurationInstance();
    if (data == null) {    //表示不是由于Configuration改变触发的onCreate()
        data = loadMyData();
    }
    //...
}
```

### 手工处理旋转

一般情况下Configuration的改变会导致Activity被销毁重建，但也有办法让指定的Configuration改变时不重建Activity，方法是在AndroidManifest.xml里通过android:configChanges属性指定需要忽略的Configuration名字，例如下面这样：

``` java
<activity
    android:name=".MyActivity"
    android:configChanges="orientation|keyboardHidden"
    android:label="@string/app_name"/>
```

当屏幕旋转时Activity对象不会被销毁——作为替代，Activity的onConfigurationChanged()方法被触发，在这里开发者可以获取到当前的屏幕方向以便做必要的更新。既然这种情况下的Activity不会被销毁，旋转后Activity里正显示的信息（例如文本框中的文字）也就不会丢失了。假如你的应用里，横屏和竖屏使用同一个layout资源文件，onConfigurationChanged()里甚至可以什么都不做。但如果横屏与竖屏使用不同的layout资源文件，例如横屏用res/layout-land/main.xml，竖屏用res/layout-port/main.xml，则必须在onConfigurationChanged()里重新调用setContentView()方法以便新的layout能够生效，这时虽然Activity对象没有销毁，但界面上的各种控件都被销毁重建了，你需要写额外的代码来恢复界面信息。

``` java
@Override
public void onConfigurationChanged(Configuration newConfig) {
    super.onConfigurationChanged(newConfig);
    // Checks the orientation of the screen
    if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
        Toast.makeText(this, "横屏模式", Toast.LENGTH_SHORT).show();
    } else if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT){
        Toast.makeText(this, "竖屏模式", Toast.LENGTH_SHORT).show();
    }
}
```

### 总结

考虑到旋转屏幕并不是使Activity被销毁重建的唯一因素，仍然推荐前文介绍过的方法：在onPause()里持久化Activity状态，在onCreate()里恢复现场，可以做到一举多得；虽然Google不推荐设置android:configChanges属性的方式，但如果你的Activity横向纵向共用同一个layout文件，方法3无疑是最省事的。
