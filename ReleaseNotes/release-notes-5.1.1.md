# QNRTCKit Release Notes for 5.1.1

## 内容

- [简介](#简介)
- [问题反馈](#问题反馈)
- [记录](#记录)

## 简介

QNRTCKit 是七牛推出的一款适用于 iOS 平台的音视频通话 SDK，提供了包括美颜、滤镜、水印、音视频通话等多种功能，提供灵活的接口，支持高度定制以及二次开发。


## 记录

- 功能
  - 支持创建纯音频合流转推任务

- 优化
  - 缩小 FFmpeg 的包体大小，改为静态库由 QNRTCKit.framework 内部链路

- 缺陷
  - 修复远端音视频传输统计数据中 uplinkRTT 以及 uplinkLostRate 值错误的问题
  - 修复本地质量等级变更回调 didNetworkQualityNotified 未触发的问题
  - 修复跨房信息配置初始化方法 initWithToken 设置 token 无效的问题
  

## 问题反馈

当你遇到任何问题时，可以通过在 GitHub 的 repo 提交 ```issues``` 来反馈问题，请尽可能的描述清楚遇到的问题，如果有错误信息也一同附带，并且在 ```Labels``` 中指明类型为 bug 或者其他。

[通过这里查看已有的 issues 和提交 bug](https://github.com/pili-engineering/QNRTC-iOS/issues)
