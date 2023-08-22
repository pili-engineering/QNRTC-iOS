# QNRTCKit Release Notes for 5.2.4

## 内容

- [简介](#简介)
- [问题反馈](#问题反馈)
- [记录](#记录)

## 简介

QNRTCKit 是七牛推出的一款适用于 iOS 平台的音视频通话 SDK，提供了包括美颜、滤镜、水印、音视频通话等多种功能，提供灵活的接口，支持高度定制以及二次开发。


## 记录

- 功能
   - 支持设置房间重连超时时间
   - 支持视频编码参数的预设配置接口
   - 支持软件编码
   - 支持视频降级默认值自动区分场景
   - 支持本地及远端视频 stats 回调宽高信息
 
- 优化
   - 优化在弱网传输时的重传和接收 buffer 策略，降低卡顿率
   - 优化平台层断线重连的反应时间
   - 转推异常断开时回调新增错误码 QNRTCErrorLiveStreamingClosedError
   
- 问题
   - 修复订阅相同 Track 多次导致订阅失败的问题
   - 修复销毁 Track 后再发布会 crash 的问题
   - 修复取消发布后仍回调 stats 的问题
   - 修复偶现远端离开房间本地 crash 的问题
   - 修复日志文件 Tag 非法及 Size 过小的 crash 问题
   - 修复连麦时订阅还未成功便立即取消订阅发生 crash 的问题

## 问题反馈

当你遇到任何问题时，可以通过在 GitHub 的 repo 提交 ```issues``` 来反馈问题，请尽可能的描述清楚遇到的问题，如果有错误信息也一同附带，并且在 ```Labels``` 中指明类型为 bug 或者其他。

[通过这里查看已有的 issues 和提交 bug](https://github.com/pili-engineering/QNRTC-iOS/issues)
