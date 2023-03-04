---
title: Android-confluence-Android常用命令
categories:
  - 🌙基础学习
  - ⭐Android
abbrlink: cee21a4b
date: 2022-11-18 20:32:37
tags:
---

⭐此confluence系列纪念大三大四TCL实习时在confluence中学习到的一些额外的知识⭐

### linux常用命令

#### top

选项说明：
-b：以批处理模式操作；  
-c：显示完整的治命令；  
-d：屏幕刷新间隔时间；  
-I：忽略失效过程；  
-s：保密模式；  
-S：累积模式；  
-i<时间>：设置间隔时间；  
-u<用户名>：指定用户名；  
-p<进程号>：指定进程；  
-n<次数>：循环显示的次数。

<!--more-->

***

#### ps

解释
USER：该进程属于那个使用者账号。  
PID ：该进程的进程ID号。  
%CPU：该进程使用掉的 CPU 资源百分比；  
%MEM：该进程所占用的物理内存百分比；  
VSZ ：该进程使用掉的虚拟内存量 (Kbytes)  
RSS ：该进程占用的固定的内存量 (Kbytes)  
TTY ：该进程是在那个终端机上面运作，若与终端机无关，则显示 ?。另外， tty1-tty6 是本机上面的登入者程序，若为 pts/0 等等的，则表示为由网络连接进主机的程序。  
STAT：该程序目前的状态，主要的状态有：
    R ：该程序目前正在运作，或者是可被运作；  
    S ：该程序目前正在睡眠当中，但可被某些讯号(signal) 唤醒。  
    T ：该程序目前正在侦测或者是停止了；  
    Z ：该程序应该已经终止，但是其父程序却无法正常的终止他，造成 zombie (疆尸) 程序的状态
START：该进程被触发启动的时间；  
TIME ：该进程实际使用 CPU 运作的时间。  
COMMAND：该程序的实际指令。

***

### Android常用命令

#### am命令

##### am start

选项说明
[-a <ACTION>] [-d <DATA_URI>] [-t <MIME_TYPE>]  
[-c <CATEGORY> [-c <CATEGORY>] ...]  
[-e|--es <EXTRA_KEY> <EXTRA_STRING_VALUE> ...]  
[--ez <EXTRA_KEY> <EXTRA_BOOLEAN_VALUE> ...]  
[-e|--ei <EXTRA_KEY> <EXTRA_INT_VALUE> ...]  
[-n <COMPONENT>] [-f <FLAGS>] [<URI>]

举例
am start -n com.android.music/com.android.music.MusicBrowserActivity  
am start -a android.intent.action.VIEW -d http://www.google.cn/  
am start -n com.xxx.tmotion/.activitys.MainActivity --es webUrl "https://xxxxxxx.api.my7v.com/728page/index.html?debug=true"

***

#### pm命令

##### 安装

用法
pm install [-lrtsfd] [-i PACKAGE] [PATH]

参数说明
-l    锁定应用程序  
-r    重新安装应用，且保留应用数据  
-t    允许测试apk被安装  
-i <INSTALLER_PACKAGE_NAME>    指定安装包的包名  
-s    安装到sd卡  
-f    安装到系统内置存储中（默认安装位置）  
-d    允许降级安装（同一应用低级换高级）  
-g    授予应用程序清单中列出的所有权限（只有6.0系统可用）

举例
adb shell pm install -r /data/local/tmp/test.apk

***

##### 卸载

用法
pm uninstall [options] <PACKAGE>

举例
pm uninstall com.xxx.tshop

***

##### 清除应用数据

用法
pm clear [options] <PACKAGE>

举例
pm clear com.xxx.tshop

***

##### 禁用&恢复应用

被禁用应用在应用管理中变得不可见，桌面图标也会消失禁用应用
pm disenable com.xxxx.tshop

***

#### dumpsys命令

##### 包信息查询

dumpsys package [-h] [-f] [—checkin] [cmd]...

| 参数 | 说明 |
| :--- | :--- |
| -h | 打印帮助信息 |
| -f | 打印intent filter的信息 |
| --checkin | 打印出已经登记的库、系统功能、安装包 |
| cmd | 子命令（可以在-h帮助文档中查看有哪些子命令） |

| cmd子命令 | 说明 |
| :------- | :--- |
| prov[iders] | 	获取content providers |
| p[ackages] | 	获取安装包基本信息 |
| s[hared-user] | 获取共享用户ID的应用 |
| m[essages] | 打印运行时收集的信息 |
| v[erifiers] | 打印包校验信息 |
| version | 打印数据库版本信息 |
| write | 写当前位置 |
| <package.name> | 输出给定包的信息 |
| installs | 安装会话的详细信息 |
| l[ibraries] | 列出已知的共享库 |
| f[ibraries] | 列出手机的功能 |
| k[eysets] | 	列出各个包的Signing KeySets |
| r[esolvers] | 获取intent filter |
| perm[issions] | 获取权限 |
| pref[erred] | 打印包首选项 |
| preferred-xml [—full] | 打印包首选项，xml格式打印 |

***

##### activity信息查询

adb shell dumpsys activity [-a] [-c]...

| 参数 | 说明 |
| :--- | :--- |
| -a | 包括所有可用的服务器状态 |
| -c | 包括客户端状态 |
| -p | 限制输出为给定的包，例如： adb shell dumpsys activity -p com.android.browser |
| -h | 打印帮助信息 |
| cmd | 子命令 |

| cmd子命令 | 说明 |
| :------- | :--- |
| a[ctivities] | activity堆栈状态 |
| r[recents] | 最近activity的状态 |
| b[rodacasts] [package_name] [histpry [-s]] | 广播状态 |
| i[ntents] [package_name] | 挂起的intent状态 |
| p[rocesses] [package_name] | 进程状态 |
| o[om] | oom管理 |
| perm[issions] | url权限授权状态 |
| prov[iders] [comp_spec...] | content provider状态 |
| provider [comp_spec] | provider客户端状态 |
| s[ervices] [comp_spec...] | 服务状态 |
| as[sociations] | 跟踪应用程序的关联 |
| service [comp_spec] | 服务客户端状态 |
| package [package_name] | 给的包的所有状态 |
| all | 转储所有的activityes |
| top | 转储栈顶的activity |
| write | 写入所有挂起状态存储 |
| track-associations | 允许会话跟踪 |
| untrack-associations | 禁用和明确会话跟踪，命令参数可能也是一个comp_spec 转储的activity |

***

##### 网络信息查询

| cmd子命令 | 说明 | 命令格式 |
| :------- | :--- | :------- |
| connectivity | 网络连接 | dumpsys connectivity |
| netpolicy | 网络策略 | dumpsys netpolicy |
| netstats | 网络状态 | dumpsys netstats |
| network_management | 网络管理 | dumpsys network_management |

***

##### 其他常用服务信息查询

| cmd子命令 | 说明 | 命令格式 |
| :------- | :--- | :------- |
| meminfo | 内存 | dumpsys meminfo |
| cpuinfo | CPU | dumpsys cpuinfo |
| gfxinfo | 帧率 | dumpsys gfxinfo |
| display | 显示 | dumpsys display |
| power | 电源 | dumpsys power |
| batterystats | 电池状态 | dumpsys batterystats |
| battery | 电池 | dumpsys battery |
| alarm | 闹钟 | dumpsys alarm |
| location | 位置 | dumpsys location |

***

#### 允许应用安装

setprop persist.xxx.installapk.enable 1  
setprop persist.xxx.debug.installapk 1

***

#### 关闭系统日志

echo 0 > /proc/sys/kernel/printk

***

#### 挂载获取system目录写权限

mount -o rw,remount /system

***

#### 开发者选项

setprop debug.hwui.overdraw show            //显示过渡绘制  
setprop debug.hwui.profile visual_bars      //显示帧率

***

### 原文信息

<font style="color:white">
Android常用命令
由 王世昌 创建, 最后修改于2020-03-30
</font>
