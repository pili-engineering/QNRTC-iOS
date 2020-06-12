# QNRTCKit Release Notes for 2.4.0

## 内容

- [简介](#简介)
- [问题反馈](#问题反馈)
- [记录](#记录)

## 简介

QNRTCKit 是七牛推出的一款适用于 iOS 平台的音视频通话 SDK，提供了包括美颜、滤镜、水印、音视频通话等多种功能，提供灵活的接口，支持高度定制以及二次开发。

## 记录
- 功能
    - 增加本地离开房间的回调
    - 添加对端网络信令回调字段：网络等级 networkGrade, 远端用户 track 丢包率，远端用户 rtt
    - 添加本地统计回调字段：本地 rtt， 网络等级 networkGrade

- 缺陷
    - 修复频繁进入退出房间 crash（未成功进入便立即退出）
    - 修复 audioEngine 在 engine 重新加入房间时 startMixing 无效
    - 修复双路视频流发布，设置各码率配置与实际码率不符

## 问题反馈

当你遇到任何问题时，可以通过在 GitHub 的 repo 提交 ```issues``` 来反馈问题，请尽可能的描述清楚遇到的问题，如果有错误信息也一同附带，并且在 ```Labels``` 中指明类型为 bug 或者其他。

[通过这里查看已有的 issues 和提交 bug](https://github.com/pili-engineering/QNRTC-iOS/issues)
