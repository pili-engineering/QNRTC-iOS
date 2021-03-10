# QNRTCKit Release Notes for 3.0.2

## 内容

- [简介](#简介)
- [问题反馈](#问题反馈)
- [记录](#记录)

## 简介

QNRTCKit 是七牛推出的一款适用于 iOS 平台的音视频通话 SDK，提供了包括美颜、滤镜、水印、音视频通话等多种功能，提供灵活的接口，支持高度定制以及二次开发。

## 记录
- 功能
    - 支持合流设置 SEI
    
- 缺陷
    - 修复部分机型取消订阅视频 track，偶现内存泄漏
    - 修复第一次初始化 engine，直接调用 leaveroom ，会触发麦克风权限开启通知的问题
    - 修复音频重采样导致音画不同步的问题
    - 修复偶现预览渲染冲突 crash


## 问题反馈

当你遇到任何问题时，可以通过在 GitHub 的 repo 提交 ```issues``` 来反馈问题，请尽可能的描述清楚遇到的问题，如果有错误信息也一同附带，并且在 ```Labels``` 中指明类型为 bug 或者其他。

[通过这里查看已有的 issues 和提交 bug](https://github.com/pili-engineering/QNRTC-iOS/issues)
