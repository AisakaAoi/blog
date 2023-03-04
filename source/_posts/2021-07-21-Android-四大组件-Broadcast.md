---
title: Android-四大组件-Broadcast
categories:
  - 🌙基础学习
  - ⭐Android
abbrlink: 8b83a4cc
date: 2021-07-21 17:50:45
tags:
---

### Broadcast动态注册与静态注册

1. 动态注册

    ``` java
    // 在onCreate()中注册registerBatteryReceiver();

    private void registerBatteryReceiver() {
        // 收听的频道是 电量变化
        IntentFilter intentFilter = new IntentFilter();
        // 设置频道
        intentFilter.addAction(Intent.ACTION_BATTERY_CHANGED);
        // 创建一个广播接收者
        mBatteryLevelReceiver = new BatteryLevelReceiver();
        // 注册
        this.registerReceiver(mBatteryLevelReceiver, intentFilter);
    }

    /**
     * 创建一个广播接收者
     */
    private class BatteryLevelReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (Intent.ACTION_BATTERY_CHANGED.equals(action)) {
                Log.d(TAG, "Battery change action is == " + action);
                int currentLevel = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, 0);
                Log.d(TAG, "当前电量：" + currentLevel);
                if (mBatteryLevelText != null) {
                    mBatteryLevelText.setText("当前电量：" + currentLevel);
                }
                int maxLevel = intent.getIntExtra(BatteryManager.EXTRA_SCALE, 0);
                float percent = currentLevel * 1.0f / maxLevel * 100;
                Log.d(TAG, "当前电量百分比为：" + percent + "%");
            }
        }
    }

    // 在onDestroy()中取消广播注册

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // 取消广播注册
        if (mBatteryLevelReceiver != null) {
            this.unregisterReceiver(mBatteryLevelReceiver);
        }
    }
    ```

    <!--more-->

2. 静态注册

    ``` java
    // 在AndroidManifest.xml对静态广播进行注册

    <receiver android:name=".AppStateChangeReceiver">
        <intent-filter>
            <action android:name="android.intent.action.PACKAGE_ADDED" />
            <action android:name="android.intent.action.PACKAGE_REMOVED" />
            <data android:scheme="package" />
            </intent-filter>
    </receiver>

    // 其余与动态类似，但无需在onCreate()与onDestroy()注册与销毁，仅需设置广播接收者即可
    ```

    ***

### 自定义Broadcast广播与接收

``` java
// 例如本次在按钮中设置发送广播，仅在上述部分多添加一个发送intent并设置发送频道与内容即可

public void sendBroadcastMsg(View view) {
    String content = mInputBox.getText().toString().trim();
    Intent intent = new Intent();
    intent.setAction(Constants.ACTION_SEND_MSG);
    intent.putExtra(Constants.KEY_CONTENT, content);
    // 注意：Android8.0后对静态广播的使用上做了一些限制 具体点击详情
    // 解决办法 1.使用动态广播代替静态广播 2.保留原来的静态广播但加入Component参数如下：参数一是包名，参数二是接收器的路径
    intent.setComponent(new ComponentName(getPackageName(), "com.example.a11_broadcastdemoforcourse.MessageReceiver"));
    sendBroadcast(intent);
    }
```

***

### 有序广播

上述部分为无序广播，即任何应用只要有对应的action就可以接收。（Android8.0后静态注册无法有序，需用动态注册）

有序广播的特点：有序、可以终止向下传达、可以修改广播的内容。
