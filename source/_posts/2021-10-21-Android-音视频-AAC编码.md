---
title: Android-音视频-AAC编码
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些技术
abbrlink: 18fff05b
date: 2021-10-21 15:58:44
tags:
---

### 什么是AAC

#### 简介

AAC是高级音频编码（Advanced Audio Coding）的缩写，出现于1997年，最初是基于MPEG-2的音频编码技术。由Fraunhofer IIS、Dolby Laboratories、AT&T、Sony等公司共同开发，目的是取代MP3格式。2000年，MPEG-4标准出台，AAC重新集成了其它技术（PS,SBR），为区别于传统的MPEG-2 AAC，故含有SBR或PS特性的AAC又称为MPEG-4 AAC。

AAC通常压缩比为18：1，也有资料说为20：1，远胜mp3。

<!--more-->

#### 特点

1. AAC是一种高压缩比的音频压缩算法，但它的压缩比要远超过较老的音频压缩算法，如AC-3、MP3等。并且其质量可以同未压缩的CD音质相媲美。

2. 同其他类似的音频编码算法一样，AAC也是采用了变换编码算法，但AAC使用了分辨率更高的滤波器组，因此它可以达到更高的压缩比。

3. AAC使用了临时噪声重整、后向自适应线性预测、联合立体声技术和量化哈夫曼编码等最新技术，这些新技术的使用都使压缩比得到进一步的提高。

4. AAC支持更多种采样率和比特率、支持1个到48个音轨、支持多达15个低频音轨、具有多种语言的兼容能力、还有多达15个内嵌数据流。

5. AAC支持更宽的声音频率范围，最高可达到96kHz，最低可达8KHz，远宽于MP3的16KHz-48kHz的范围。

6. 不同于MP3及WMA，AAC几乎不损失声音频率中的甚高、甚低频率成分，并且比WMA在频谱结构上更接近于原始音频，因而声音的保真度更好。专业评测中表明，AAC比WMA声音更清晰，而且更接近原音。

7. AAC采用优化的算法达到了更高的解码效率，解码时只需较少的处理能力。

#### 编码方式

AAC音频格式有ADIF和ADTS：

**ADIF：**Audio Data Interchange Format 音频数据交换格式。这种格式的特征是可以确定的找到这个音频数据的开始，不需进行在音频数据流中间开始的解码，即它的解码必须在明确定义的开始处进行。故这种格式常用在磁盘文件中。

**ADTS：**Audio Data Transport Stream 音频数据传输流。这种格式的特征是它是一个有同步字的比特流，解码可以在这个流中任何位置开始。它的特征类似于mp3数据流格式。

简单说，ADTS可以在任意帧解码，也就是说它每一帧都有头信息。ADIF只有一个统一的头，所以必须得到所有的数据后解码。且这两种的header的格式也是不同的，目前一般编码后的和抽取出的都是ADTS格式的音频流。

ADTS是帧序列，本身具备流特征，在音频流的传输与处理方面更加合适。

***

### ADIF编码

**ADIF：**Audio Data Interchange Format 音频数据交换格式。这种格式的特征是可以确定的找到这个音频数据的开始，不需进行在音频数据流中间开始的解码，即它的解码必须在明确定义的开始处进行。故这种格式常用在磁盘文件中。

{% asset_img 3.webp %}

ADIF只有一个文件头。

#### ADIF头信息

{% asset_img 4.webp %}

***

### ADTS编码

**ADTS：**Audio Data Transport Stream 音频数据传输流。这种格式的特征是它是一个有同步字的比特流，解码可以在这个流中任何位置开始。它的特征类似于mp3数据流格式。这种格式可以用于广播电视。

{% asset_img 1.webp %}

可以看到ADTS的每一帧都有头信息，即ADTS_header，ADTS头中相对有用的信息是采样率、声道数、帧长度。一般ADTS头信息都是7字节，如果有CRC则为9字节。

ADTS每个包前面有一个文件头。

#### ADTS头信息

{% asset_img 5.webp %}

#### ADTS帧首部结构

| 序号 | 域 | 长度（bits） | 说明 |
| ---- | -- | ----------- | ---- |
| 1 | Syncword | 12 | all bits must be 1 |
| 2 | MPEG version | 1 | 0 for MPEG-4, 1 for MPEG-2 |
| 3 | Layer | 2 | always 0 |
| 4 | Protection Absent | 1 | et to 1 if there is no CRC and 0 if there is CRC |
| 5 | Profile | 2 | the MPEG-4 Audio Object Type minus 1 |
| 6 | MPEG-4 Sampling Frequency Index | 4 | MPEG-4 Sampling Frequency Index (15 is forbidden) |
| 7 | Private Stream | 1 | set to 0 when encoding, ignore when decoding |
| 8 | MPEG-4 Channel Configuration | 3 | MPEG-4 Channel Configuration (in the case of 0, the channel configuration is sent via an inband PCE) |
| 9 | Originality | 1 | set to 0 when encoding, ignore when decoding |
| 10 | Home | 1 | set to 0 when encoding, ignore when decoding |
| 11 | Copyrighted Stream | 1 | set to 0 when encoding, ignore when decoding |
| 12 | Copyrighted Start | 1 | set to 0 when encoding, ignore when decoding |
| 13 | Frame Length | 13 | this value must include 7 or 9 bytes of header length: FrameLength = (ProtectionAbsent == 1 ? 7 : 9) + size(AACFrame) |
| 14 | Buffer Fullness | 11 | buffer fullness |
| 15 | Number of AAC Frames | 2 | number of AAC frames (RDBs) in ADTS frame minus 1, for maximum compatibility always use 1 AAC frame per ADTS frame |
| 16 | CRC | 16 | CRC if protection absent is 0 |

#### ADTS头部的生成

``` java
/**
 * 添加ADTS头部
 *
 * @param packet    ADTS header 的 byte[]，长度为7
 * @param packetLen 该帧的长度，包括header的长度
 */
private void addADTStoPacket(byte[] packet, int packetLen) {
    int profile = 2; // AAC LC
    int freqIdx = 3; // 48000Hz
    int chanCfg = 2; // 2 Channel

    packet[0] = (byte) 0xFF;
    packet[1] = (byte) 0xF9;
    packet[2] = (byte) (((profile - 1) << 6) + (freqIdx << 2) + (chanCfg >> 2));
    packet[3] = (byte) (((chanCfg & 3) << 6) + (packetLen >> 11));
    packet[4] = (byte) ((packetLen & 0x7FF) >> 3);
    packet[5] = (byte) (((packetLen & 7) << 5) + 0x1F);
    packet[6] = (byte) 0xFC;
}
```

其中profile表示使用哪个级别的AAC，在MPEG-2 AAC中定义了3种：

{% asset_img 2.webp %}

freqIdx表示使用的采样率下标，通过这个下标在 Sampling Frequencies[ ]数组中查找得知采样率的值：

| freqIdx | 采样率（Hz） | freqIdx | 采样率（Hz） |
| ------- | ----------- | ------- | ----------- |
| 0 | 96000Hz | 1 | 88200Hz |
| 2 | 64000Hz | 3 | 48000Hz |
| 4 | 44100Hz | 5 | 32000Hz |
| 6 | 24000Hz | 7 | 22050Hz |
| 8 | 16000Hz | 9 | 12000Hz |
| 10 | 11025Hz | 11 | 8000Hz |
| 12 | 7350Hz | 13 | Reserved |
| 14 | Reserved | 15 | frequency is written explictly |

chanCfg表示声道数：

| chanCfg | 声道数 | chanCfg | 声道数 |
| ------- | ------ | ------- | ----- |
| 0 | Defined in AOT Specifc Config | 1 | 1 channel: front-center |
| 2 | 2 channels: front-left, front-right | 3 | 3 channels: front-center, front-left, front-right |
| 4 | 4 channels: front-center, front-left, front-right, back-center | 5 | 5 channels: front-center, front-left, front-right, back-left, back-right |
| 6 | 6 channels: front-center, front-left, front-right, back-left, back-right, LFE-channel | 7 | 8 channels: front-center, front-left, front-right, side-left, side-right, back-left, back-right, LFE-channel |
| 8-15 | Reserved |

***

#### AAC的解析

``` java
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;

public class AACHelper {
    // 采样频率对照表
    private static Map<Integer, Integer> samplingFrequencyIndexMap = new HashMap<>();

    static {
        samplingFrequencyIndexMap.put(96000, 0);
        samplingFrequencyIndexMap.put(88200, 1);
        samplingFrequencyIndexMap.put(64000, 2);
        samplingFrequencyIndexMap.put(48000, 3);
        samplingFrequencyIndexMap.put(44100, 4);
        samplingFrequencyIndexMap.put(32000, 5);
        samplingFrequencyIndexMap.put(24000, 6);
        samplingFrequencyIndexMap.put(22050, 7);
        samplingFrequencyIndexMap.put(16000, 8);
        samplingFrequencyIndexMap.put(12000, 9);
        samplingFrequencyIndexMap.put(11025, 10);
        samplingFrequencyIndexMap.put(8000, 11);
        samplingFrequencyIndexMap.put(0x0, 96000);
        samplingFrequencyIndexMap.put(0x1, 88200);
        samplingFrequencyIndexMap.put(0x2, 64000);
        samplingFrequencyIndexMap.put(0x3, 48000);
        samplingFrequencyIndexMap.put(0x4, 44100);
        samplingFrequencyIndexMap.put(0x5, 32000);
        samplingFrequencyIndexMap.put(0x6, 24000);
        samplingFrequencyIndexMap.put(0x7, 22050);
        samplingFrequencyIndexMap.put(0x8, 16000);
        samplingFrequencyIndexMap.put(0x9, 12000);
        samplingFrequencyIndexMap.put(0xa, 11025);
        samplingFrequencyIndexMap.put(0xb, 8000);
    }

    private AdtsHeader mAdtsHeader = new AdtsHeader();
    private BitReader mHeaderBitReader = new BitReader(new byte[7]);
    private byte[] mSkipTwoBytes = new byte[2];
    private FileInputStream mFileInputStream;
    private byte[] mBytes = new byte[1024];

    /**
     * 构造函数，通过传递进来的文件路径创建输入流
     *
     * @param aacFilePath AAC文件路径
     * @throws FileNotFoundException
     */
    public AACHelper(String aacFilePath) throws FileNotFoundException {
        mFileInputStream = new FileInputStream(aacFilePath);
    }

    /**
     * 获取下一Sample数据
     *
     * @param byteBuffer 存放Sample数据的ByteBuffer
     * @return 当前Sample的byte[]大小，如果为空返回-1
     * @throws IOException
     */
    public int getSample(ByteBuffer byteBuffer) throws IOException {
        if (readADTSHeader(mAdtsHeader, mFileInputStream)) {
            int length = mFileInputStream.read(mBytes, 0, mAdtsHeader.frameLength - mAdtsHeader.getSize());
            byteBuffer.clear();
            byteBuffer.put(mBytes, 0, length);
            byteBuffer.position(0);
            byteBuffer.limit(length);
            return length;
        }
        return -1;
    }

    /**
     * 从AAC文件流中读取ADTS头部
     *
     * @param adtsHeader      ADTS头部
     * @param fileInputStream AAC文件流
     * @return 是否读取成功
     * @throws IOException
     */
    private boolean readADTSHeader(AdtsHeader adtsHeader, FileInputStream fileInputStream) throws IOException {
        if (fileInputStream.read(mHeaderBitReader.buffer) < 7) {
            return false;
        }

        mHeaderBitReader.position = 0;

        int syncWord = mHeaderBitReader.readBits(12); // A
        if (syncWord != 0xfff) {
            throw new IOException("Expected Start Word 0xfff");
        }
        adtsHeader.mpegVersion = mHeaderBitReader.readBits(1); // B
        adtsHeader.layer = mHeaderBitReader.readBits(2); // C
        adtsHeader.protectionAbsent = mHeaderBitReader.readBits(1); // D
        adtsHeader.profile = mHeaderBitReader.readBits(2) + 1;  // E
        adtsHeader.sampleFrequencyIndex = mHeaderBitReader.readBits(4);
        adtsHeader.sampleRate = samplingFrequencyIndexMap.get(adtsHeader.sampleFrequencyIndex); // F
        mHeaderBitReader.readBits(1); // G
        adtsHeader.channelconfig = mHeaderBitReader.readBits(3); // H
        adtsHeader.original = mHeaderBitReader.readBits(1); // I
        adtsHeader.home = mHeaderBitReader.readBits(1); // J
        adtsHeader.copyrightedStream = mHeaderBitReader.readBits(1); // K
        adtsHeader.copyrightStart = mHeaderBitReader.readBits(1); // L
        adtsHeader.frameLength = mHeaderBitReader.readBits(13); // M
        adtsHeader.bufferFullness = mHeaderBitReader.readBits(11); // 54
        adtsHeader.numAacFramesPerAdtsFrame = mHeaderBitReader.readBits(2) + 1; // 56
        if (adtsHeader.numAacFramesPerAdtsFrame != 1) {
            throw new IOException("This muxer can only work with 1 AAC frame per ADTS frame");
        }
        if (adtsHeader.protectionAbsent == 0) {
            fileInputStream.read(mSkipTwoBytes);
        }
        return true;
    }

    /**
     * 释放资源
     *
     * @throws IOException
     */
    public void release() throws IOException {
        mFileInputStream.close();
    }

    /**
     * ADTS头部
     */
    private class AdtsHeader {
        int getSize() {
            return 7 + (protectionAbsent == 0 ? 2 : 0);
        }

        int sampleFrequencyIndex;

        int mpegVersion;
        int layer;
        int protectionAbsent;
        int profile;
        int sampleRate;

        int channelconfig;
        int original;
        int home;
        int copyrightedStream;
        int copyrightStart;
        int frameLength;
        int bufferFullness;
        int numAacFramesPerAdtsFrame;
    }
}
```

***

### 参考与鸣谢

> <https://www.jianshu.com/p/839b11e0638b>
> <https://www.jianshu.com/p/b5ca697535bd>
> <https://blog.csdn.net/leixiaohua1020/article/details/11822537>
