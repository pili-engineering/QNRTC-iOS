# QNRTCKit Release Notes for 4.0.0

## 内容

- [简介](##简介)
- [版本](##版本)
- [注意](##注意)
- [功能](##功能)
- [优化](##优化)
- [问题反馈](##问题反馈)

## 简介

QNRTCKit 是七牛推出的一款适用于 iOS 平台的音视频通话 SDK，提供了包括美颜、滤镜、水印、音视频通话等多种功能，提供灵活的接口，支持高度定制以及二次开发。

## 版本

- 发布 QNRTCKit.framework 4.0 版本

## 注意

1. 本次升级为主版本升级(v3.0.2 -> v4.0.0)，是基于 3.x 版本开发的全量重构版本，简化了接口调用逻辑，提高了接口的易用性，开发文档请参考[新版文档站](https://developer.qiniu.com/rtc/8802/pd-overview)。
2. **本次升级版本对老版本不兼容**，若您已使用老版本并希望升级到新版本，可参考 [QNRTC v4.x 迁移指南](https://developer.qiniu.com/rtc/9538/migration-guide-iOS)。

## 功能

- 新增核心类 QNRTC 和 QNRTCClient，移除 QNRTCCEngine 接口类
- 新增 QNLocalTrack 和 QNRemoteTrack 及其衍生的子类，对不同类型的音视频轨道做了区分，并提供了丰富的控制接口

## 优化

- 优化事件监听逻辑，提供更丰富更具体的事件监听


## 问题反馈

当你遇到任何问题时，可以通过在 GitHub 的 repo 提交 ```issues``` 来反馈问题，请尽可能的描述清楚遇到的问题，如果有错误信息也一同附带，并且在 ```Labels``` 中指明类型为 bug 或者其他。

[通过这里查看已有的 issues 和提交 bug](https://github.com/pili-engineering/QNRTC-iOS/issues)
