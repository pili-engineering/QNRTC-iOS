# QNRTCKit Release Notes for 2.0.0

## 内容

- [简介](#简介)
- [问题反馈](#问题反馈)
- [记录](#记录)

## 简介

QNRTCKit 是七牛推出的一款适用于 iOS 平台的音视频通话 SDK，提供了包括美颜、滤镜、水印、音视频通话等多种功能，提供灵活的接口，支持高度定制以及二次开发。

## 记录
- 功能
   	- 新增核心类 QNRTCEngine，支持本地发布多路视频
   	- 支持音频和视频分开发布

## 升级必读
建议选择合适的时机升级到新核心类 QNRTCEngine，相比 QNRTCSession，QNRTCEngine 有更灵活的连麦控制、更低的功耗以及更低的内存占用。请查看我们的[新版文档站](https://doc.qnsdk.com/rtn/ios/)。

自 2.0.0 后，我们为了提高用户阅读文档的体验，使用了新的文档站（老文档地址继续保留），新文档站地址 https://doc.qnsdk.com/rtn

## 问题反馈

当你遇到任何问题时，可以通过在 GitHub 的 repo 提交 ```issues``` 来反馈问题，请尽可能的描述清楚遇到的问题，如果有错误信息也一同附带，并且在 ```Labels``` 中指明类型为 bug 或者其他。

[通过这里查看已有的 issues 和提交 bug](https://github.com/pili-engineering/QNRTC-iOS/issues)