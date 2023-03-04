---
title: Android-Retrofit（OkHttp）踩坑：为何response.body().string()只能调用一次
categories:
  - 🌙基础学习
  - ⭐Android
abbrlink: 83555fbc
date: 2021-08-06 19:24:57
tags:
---

### 问题描述

api接口返回的body读值为空导致空指针崩溃，但Log却有显示内容

{% asset_img 1.png %}

<!--more-->

{% asset_img 2.png %}

***

### 问题定位

通过断点调试发现Log能正常输出内容，可下一行的result却为空值

{% asset_img 3.png %}

而当将Log注释后便能正常显示

{% asset_img 4.png %}

***

### 原因排查

由是否有log导致问题，进而推断出是注释的response.body().string()有问题，进而分析该函数源码

response是public final class Response&lt;T&gt;类，其中的body()得到ResponseBody对象：

``` java
public @Nullable T body() {
    return body;
}

private final @Nullable T body;
```

body()没什么问题，所以接着看string()：

``` java
public final String string() throws IOException {
    try (BufferedSource source = source()) {
        Charset charset = Util.bomAwareCharset(source, charset());
        return source.readString(charset);
    }
}
```

点进去看readString()，是个接口，Ctrl+H查看实现类，找到是RealBufferedSource：

``` java
@Override public String readString(Charset charset) thrIOException {
    if (charset == null) throw new IllegalArgumentException("charset == null");
    buffer.writeAll(source);
    return buffer.readString(charset);
}
```

可以看到将数据用public final Buffer buffer = new Buffer()的writeAll和readString送走了，点进readString，跳进几个Override后：

``` java
Segment s = head;
if (s.pos + byteCount > s.limit) {
    // If the string spans multiple segments, delegate readBytes().
    return new String(readByteArray(byteCount), charset);
}
String result = new String(s.data, s.pos, (int) byteCouncharset);
s.pos += byteCount;
size -= byteCount;
if (s.pos == s.limit) {
    head = s.pop();
    SegmentPool.recycle(s);
}
```

即通过类似于指针的方式，将response的消息读进缓存再把把消息读出，所以response.body().string()只能读一次，就不再含有消息了。

***

### 解决办法

读出string后若需多次使用则需要用变量进行保存

***

### 总结

在实际开发中，响应主体ResponseBody持有的资源可能会很大，所以OkHttp并不会将其直接保存到内存中，只是持有数据流连接。只有当我们需要时，才会从服务器获取数据并返回。同时，考虑到应用重复读取数据的可能性很小，所以将其设计为一次性流（one-shot），读取后即“关闭并释放资源”。

1. 响应体只能被使用一次

2. 响应体必须关闭：值得注意的是，在下载文件等场景下response.body().byteStream()形式获取输入流时，务必通过Respoclose()来手动关闭响应体

3. 获取响应体数据的方法：使用bytes()或string()将整个响应读或者使用source()，byteStream()，charStream()方法以流的形据

4. 以下方法会触发关闭响应体：
    Response.close()
    Response.body().close()
    Response.body().source().close()
    Response.body().charStream().close()
    Response.body().byteString().close()
    Response.body().bytes()
    Response.body().string()
