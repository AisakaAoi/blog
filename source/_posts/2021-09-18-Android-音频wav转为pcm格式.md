---
title: Android-音频wav转为pcm格式
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些技术
abbrlink: 7f2474a
date: 2021-09-18 20:10:54
tags:
---

正经方法硬解与软解应该在第三部分mediaCodec中提及，目前测试音频使用第二部分录制的pcm音频以及外部音频，以下是外部音频转pcm的方法：

1. 将音频导入格式工厂转为wav格式（格式工厂底层利用ffmpeg软解，选择wav是因为wav=44字节wav文件头+pcm）

2. 将wav文件前44个字节去掉并改后缀名为pcm，代码如下（个人用c++实现）

<!--more-->

``` C++
#include<iostream>
#include<stdlib.h>
 
using namespace std;
 
int main() {
    size_t result;
    char *buf;
    FILE *fp1 = fopen("C:\\Users\\ZONGNAN.CHEN\\Music\\test.wav", "rb");//wav文件打开，打开读权限
    FILE *fp2 = fopen("C:\\Users\\ZONGNAN.CHEN\\Music\\test.pcm", "wb");//pcm文件创建，给予写权限
    fseek(fp1, 0, SEEK_END);    // 文件指针从0挪到尾部
    long filesize;
    filesize = ftell(fp1);              // ftell求文件指针相对于0的便宜字节数，就求出了文件字节数
 
    if (fp1 == NULL || fp2 == NULL) {   // 判断两个文件是否打开
        cout << "file open filed!!" << endl;
        return 0;
    }
 
    rewind(fp1);//还原指针位置
    fseek(fp1, 44, SEEK_SET);   // wav文件的指针从头向后移动44字节
    buf = (char *) malloc(sizeof(char) * filesize);//开辟空间给缓存数组
 
    if (buf == NULL) {
        printf("memory  error");
        return 0;
    }
 
    result = fread(buf, 1, (filesize - 44), fp1);//每次读一个字节到buf，同时求读的次数
    if (result != filesize - 44) {      // 判断读的次数和文件大小是否一致
        cout << "reing error!!" << endl;
        return 0;
    }
    fwrite(buf, 1, (filesize - 44), fp2);   // 写到pcm文件中
    fclose(fp1);    // 关闭文件指针
    fclose(fp2);
    free(buf);      // 释放buf
    return 0;
 
}
```
