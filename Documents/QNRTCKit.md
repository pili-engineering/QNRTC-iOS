<a id="1"></a>
# 1 概述
QNRTCKit 是七牛推出的一款适用于 iOS 平台的音视频通话 SDK，提供了包括美颜、滤镜、水印、音视频通话等多种功能，提供灵活的接口，支持高度定制以及二次开发。

<a id="1.1"></a>
## 1.1 下载地址
- [iOS Demo 以及 SDK 下载地址](https://github.com/pili-engineering/QNRTC-iOS)

<a id="2"></a>
# 2 功能列表

| 功能 				       | 版本 		|
| --------------------- | ------------ |
| 支持后台连麦 		       | v0.1.0(+) |
| 支持纯音频连麦 		    | v0.1.0(+) |
| 支持硬件编码 		       | v0.1.0(+) |
| 支持码率上下限配置 	    | v0.1.0(+) |
| 支持多分辨率编码 	       | v0.1.0(+) |
| 支持回调视频数据 	       | v0.1.0(+) |
| 支持实时美颜滤镜 		    | v0.1.0(+) |
| 支持第三方美颜滤镜 	    | v0.1.0(+) |
| 支持水印功能 		       | v0.1.0(+) |
| 支持踢人功能 		        | v0.1.0(+) |
| 支持静音功能 		        | v0.1.0(+) |
| 支持自动/手动对焦 	    | v0.1.0(+) |
| 支持实时状态回调		    | v0.1.0(+) |
| 支持回调连麦房间统计信息  | v0.1.0(+) |
| 支持丰富的连麦消息回调    | v0.1.0(+) |

<a id="3"></a>
# 3 总体设计

<a id="3.1"></a>
## 3.1 基本规则

为了方便理解和使用，对于 SDK 的接口设计，我们遵循了如下的规则：

- 每一个 `连麦` 接口类，均以 `QN` 开头

<a id="3.2"></a>
## 3.2 核心接口类

核心接口类说明如下：

|   接口类名    		|        功能         	|   备注  |
|   ------     		|        ---          	|   ---  |
| QNRTCSession 		|      连麦核心类        | 包含连麦相关的接口              |
| QNVideoView 		| 远端视频渲染 View  		| 用于渲染远端用户的画面           |
| QNVideoRender 	| 远端视频渲染的类  		|  包含视频渲染 View 和 userId 等|

<a id="3.3"></a>
## 3.3 回调相关类

回调相关类说明如下：

|       类名       |        功能            |   备注  |
|       ------        |        ---            |   ---   |
| QNRTCSessionDelegate |  连麦相关的所有回调   | 包括远端连麦者加入/离开房间、发布/取消发布音视频以及连麦状态等回调|
| QNRoomState         |  定义了房间的状态信息     | 包括但不限于重连以及断开连接等状态 |
| QNRTCErrorDomain         |  定义了连麦过程中的错误码| 包括但不限于 token 错误、房间不存在等错误信息 |

另外，统计信息回调中的 `statistic`，提供了连麦过程中的统计信息，包括连麦过程中实时的音视频码率、帧率等回调信息。


<a id="4"></a>
# 4 阅读对象

本文档为技术文档，需要阅读者：

- 具有基本的 iOS 开发能力
- 准备接入七牛云

<a id="5"></a>
# 5 开发准备

<a id="5.1"></a>
## 5.1 设备以及系统要求

- 设备要求：iPhone 5 及以上
- 系统要求：iOS 8 及以上

<a id="5.2"></a>
## 5.2 开发环境配置

- Xcode 开发工具。App Store [下载地址](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12)
- 安装 CocoaPods。[了解 CocoaPods 使用方法](https://cocoapods.org/)

<a id="5.3"></a>
## 5.3 导入 SDK

<a id="5.3.1"></a>
### 5.3.1 CocoaPods 导入

[CocoaPods](https://cocoapods.org/) 是针对 Objective-C 的依赖管理工具，它能够将使用类似 QNRTCKit 的第三方库的安装过程变得非常简单和自动化，你能够用下面的命令来安装它：

```bash
$ sudo gem install cocoapods
```

#### Podfile

为了使用 CoacoaPods 集成 QNRTCKit 到你的 Xcode 工程当中，你需要编写你的 `Podfile`

```ruby
target 'TargetName' do
pod 'QNRTCKit'
end
```

- 默认为真机版
- 若需要使用模拟器 + 真机版，则改用如下配置

```
pod "QNRTCKit", :podspec => 'https://raw.githubusercontent.com/pili-engineering/QNRTC-iOS/master/QNRTCKit-universal.podspec'
```

**注意：鉴于目前上架 App Store 时只支持动态库真机版本，请在 App 上架前更换至真机版本**

然后，运行如下的命令：

```bash
$ pod install
```


<a id="5.3.2"></a>
### 5.3.2 手动导入

将下载好的文件 QNRTCKit.framework 导入到你的 Xcode 工程当中，引入后使用

```Objective-C
#import <QNRTCKit/QNRTCKit.h>
```

<a id="5.4"></a>
## 5.4 添加权限说明
我们需要在 Info.plist 文件中添加相应权限的说明，否则程序在 iOS 10 及以上系统会出现崩溃。需要添加如下权限：

- 麦克风权限：Privacy - Microphone Usage Description 是否允许 App 使用麦克风
- 相机权限：Privacy - Camera Usage Description 是否允许 App 使用相机

<a id="6"></a>
# 6 快速开始

<a id="6.1"></a>
## 6.1 创建连麦 Session 对象

在 `ViewController.m` 中添加 session 属性

```Objective-C
@property (nonatomic, strong) QNRTCSession *session;
```

创建连麦 `session` 对象

``` Objective-C
self.session = [[QNRTCSession alloc] init];
self.session.delegate = self;
```

其中 delegate （`QNRTCSessionDelegate`）的回调相关说明，详见 [代理回调](#7.4代理回调)

<a id="6.2"></a>
## 6.2 添加摄像头预览视图

将预览视图添加为当前视图的子视图

```Objective-C
[self.view insertSubview:self.session.previewView atIndex:0];
```

<a id="6.3"></a>
## 6.3 开始采集

开启采集后才能看到摄像头预览

```Objective-C
[self.session startCapture];
```

<a id="6.4"></a>
## 6.4 加入房间

```Objective-C
- (void)joinRoomWithToken:(NSString *)token;
```

此处 `token` 需要 App 从 App Server 中获取，App Server 如何生成 token 可[查阅文档]()。

<a id="6.5"></a>
## 6.5 发布音/视频

当 `audioEnable` 为 YES 时可发布音频，而 `videoEnabled` 为 YES 时则可发布视频。

```Objective-C
[self.session publishWithAudioEnabled:YES videoEnabled:YES];
```

<a id="6.6"></a>
## 6.6 订阅远端用户

在远端用户发布成功后的回调中订阅该用户

```Objective-C
- (void)RTCSession:(QNRTCSession *)session didPublishOfRemoteUserId:(NSString *)userId {
    [self.session subscribe:userId];
}
```

也可以在发布成功后，根据产品需求在合适的时机通过调用如下的方法来订阅：

```Objective-C
- (void)subscribe:(NSString *)userId；
```

<a id="6.7"></a>
## 6.7 渲染远端用户的视频画面

在远端用户视频首帧解码后的回调中，渲染画面并返回相应类

```Objective-C
- (QNVideoRender *)RTCSession:(QNRTCSession *)session firstVideoDidDecodeOfRemoteUserId:(NSString *)userId {
    QNVideoRender *render = [[QNVideoRender alloc] init];
    QNVideoView *videoView = [[QNVideoView alloc]initWithFrame: CGRectMake(100, 20, 180, 320)];
    [self.view addSubview:videoView];
    render.renderView = videoView;
    return render;
}
```

<a id="7"></a>
# 7 功能使用

<a id="7.1"></a>
## 7.1 采集配置

<a id="7.1.1"></a>
### 7.1.1 摄像头相关配置

采集摄像头的位置 `captureDevicePosition `，默认使用 `AVCaptureDevicePositionFront` 前置摄像头 

```Objective-C
@property (nonatomic, assign) AVCaptureDevicePosition   captureDevicePosition;
```

采集摄像头的旋转方向 `videoOrientation `，默认使用 `AVCaptureVideoOrientationPortrait` 竖屏采集 

```Objective-C
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;
```

切换摄像头采集

```Objective-C
- (void)toggleCamera;
```

<a id="7.1.2"></a>
### 7.1.2 分辨率及帧率

采集的视频的 `sessionPreset` 分辨率，默认为 AVCaptureSessionPreset640x480

```Objective-C
@property (nonatomic, copy) NSString *sessionPreset;
```

采集视频数据的帧率，默认为 24

```Objective-C
@property (nonatomic, assign) NSUInteger videoFrameRate;
```

<a id="7.1.3"></a>
### 7.1.3 预览镜像

前置摄像头预览是否开启镜像，默认为 YES

```Objective-C
@property (nonatomic, assign) BOOL previewMirrorFrontFacing;
```

后置摄像头预览是否开启镜像，默认为 NO

```Objective-C
@property (nonatomic, assign) BOOL previewMirrorRearFacing;
```

<a id="7.1.4"></a>
### 7.1.4 开启/关闭采集

开启摄像头采集

```Objective-C
- (void)startCapture;
```

关闭摄像头采集

```Objective-C
- (void)stopCapture;
```

<a id="7.2"></a>
## 7.2 编码配置

<a id="7.2.1"></a>
### 7.2.1 连麦码率

设置连麦的码率

```Objective-C
- (void)setMinBitrateBps:(nullable NSNumber *)minBitrateBps
           maxBitrateBps:(nullable NSNumber *)maxBitrateBps;
```

<a id="7.2.2"></a>
### 7.2.2 连麦编码尺寸

设置连麦编码时的尺寸，即使用预览的尺寸

```Objective-C
@property (nonatomic, assign) CGSize videoEncodeSize;
```

<a id="7.3"></a>
## 7.3 连麦相关操作

<a id="7.3.1"></a>
### 7.3.1 加入/离开房间

加入房间

```Objective-C
- (void)joinRoomWithToken:(NSString *)token;
```

离开房间 

```Objective-C
- (void)leaveRoom;
```

<a id="7.3.2"></a>
### 7.3.2 发布/取消发布 

发布自己的音/视频到服务器中

```Objective-C
- (void)publishWithAudioEnabled:(BOOL)audioEnabled videoEnabled:(BOOL)videoEnabled;
```

取消发布自己的音/视频

```Objective-C
- (void)unpublish;
```

<a id="7.3.3"></a>
### 7.3.3 订阅/取消订阅 

订阅远端用户的音/视频

```Objective-C
- (void)subscribe:(NSString *)userId;
```

取消订阅远端用户的音/视频

```Objective-C
- (void)unsubscribe:(NSString *)userId;
```

<a id="7.3.4"></a>
### 7.3.4 踢人

将用户 userId 踢出房间

```Objective-C
- (void)kickoutUser:(NSString *)userId;
```

<a id="7.3.5"></a>
### 7.3.5 Mute 音/视频
是否 Mute 视频，置为 YES 后，远端用户用户将无法看到你的画面

```Objective-C
@property (nonatomic, assign, getter=isMuteVideo) BOOL muteVideo;
```

是否 Mute 音频，置为 YES 后，远端用户用户将无法听你到你的声音

```Objective-C
@property (nonatomic, assign, getter=isMuteAudio) BOOL muteAudio;
```

<a id="7.3.6"></a>
### 7.3.6 获取用户列表
获取房间中的用户的列表（不包括自己）

```Objective-C
@property (nonatomic, strong, readonly) NSArray<NSString *> *userList;
```

获取连麦房间中已发布音/视频的用户的列表

```Objective-C
@property (nonatomic, strong, readonly) NSArray<NSString *> *publishingUserList;
```



<a id="7.4"></a>
## 7.4 代理回调

<a id="7.4.1"></a>
### 7.4.1 房间状态变化的回调

```Objective-C
- (void)RTCSession:(QNRTCSession *)session roomStateDidChange:(QNRoomState)roomState;
```

房间状态参考`roomState`属性

```Objective-C
@property (nonatomic, assign, readonly) QNRoomState roomState;
```

`QNRoomState` 状态说明如下：

|            状态           |         说明          |
|           ------         |        ---            | 
| QNRoomStateIdle          |  空闲状态、初始状态或者退出房间后  | 
| QNRoomStateConnecting    |  正在加入房间的状态  |
| QNRoomStateConnected     |  已加入房间的状态  |
| QNRoomStateReconnecting  |  正在重连的状态  |

<a id="7.4.2"></a>
### 7.4.2 发布本地音视频回调

```Objective-C
- (void)sessionDidPublishLocalMedia:(QNRTCSession *)session;
```

<a id="7.4.3"></a>
### 7.4.3 远端用户加入／离开房间的回调

远端用户加入房间的回调

```Objective-C
- (void)RTCSession:(QNRTCSession *)session didJoinOfRemoteUserId:(NSString *)userId;
```

远端用户离开房间的回调

```Objective-C
- (void)RTCSession:(QNRTCSession *)session didLeaveOfRemoteUserId:(NSString *)userId;
```

<a id="7.4.4"></a>
### 7.4.4 远端用户发布／取消发布音视频的回调

远端用户发布音视频的回调

```Objective-C
- (void)RTCSession:(QNRTCSession *)session didPublishOfRemoteUserId:(NSString *)userId;
```

远端用户取消发布音视频的回调

```Objective-C
- (void)RTCSession:(QNRTCSession *)session didUnpublishOfRemoteUserId:(NSString *)userId;
```

<a id="7.4.5"></a>
### 7.4.5 订阅远端用户的回调

订阅远端用户的回调

```Objective-C
- (void)RTCSession:(QNRTCSession *)session didSubscribeUserId:(NSString *)userId;
```

<a id="7.4.6"></a>
### 7.4.6 远端用户音/视频 Mute 状态的回调

在音视频的 muted 状态回调中，可实时更新远端用户的音视频状态
 
远端用户音频状态变更为 muted 的回调

```Objective-C
- (void)RTCSession:(QNRTCSession *)session didAudioMuted:(BOOL)muted byRemoteUserId:(NSString *)userId;
```

远端用户视频状态变更为 muted 的回调

```Objective-C
- (void)RTCSession:(QNRTCSession *)session didVideoMuted:(BOOL)muted byRemoteUserId:(NSString *)userId;
```

<a id="7.4.7"></a>
### 7.4.7 本人被踢出房间的回调

当远端调用踢人的功能，将你踢出房间时，本人会收到被踢出房间的回调

```Objective-C
- (void)kickoutUser:(NSString *)userId;
```

本人被 userId 踢出房间的回调
 
```Objective-C
- (void)RTCSession:(QNRTCSession *)session didKickoutByUserId:(NSString *)userId;
```

### 7.4.8 SDK 运行中的错误回调

SDK 运行过程中发生错误会通过该方法回调，具体错误码的含义可以见 QNTypeDefines.h 文件

```Objective-C
- (void)RTCSession:(QNRTCSession *)session didFailWithError:(NSError *)error;
```

`QNRTCErrorDomain` 错误说明如下：

|  QNRTCErrorDomain  |  错误码  |        功能         |
|       ------        |     ---     |        ---        |
| QNRTCErrorTokenError          | 10001 | token 错误  | 
| QNRTCErrorTokenExpired        | 10002 | token 过期 |
| QNRTCErrorRoomInstanceClosed  | 10003 | 房间实例关闭 | 
| QNRTCErrorReconnectTokenError | 10004 | 重连 token 错误 |
| QNRTCErrorRoomClosed          | 10005 | 房间已关闭 |
| QNRTCErrorRoomIsFull          | 10011 | 房间已满 |
| QNRTCErrorRoomNotExist        | 10012 | 房间不存在 |
| QNRTCErrorUserNotExist        | 10021 | 用户不存在 |
| QNRTCErrorUserAlreadyExist    | 10022 | 用户已存在 |
| QNRTCErrorPublishStreamNotExist | 10031 | 流不存在 |
| QNRTCErrorPublishStreamInfoNotMatch | 10032 | 流信息不匹配 |
| QNRTCErrorPublishStreamAlreadyExist | 10033 | 流已存在 |
| QNRTCErrorPublishStreamNotReady | 10034 | 流未完成 |
| QNRTCErrorSubscribeStreamNotExist | 10041 | 订阅不存在流 |
| QNRTCErrorSubscribeStreamInfoNotMatch | 10042 | 订阅不匹配信息流 |
| QNRTCErrorSubscribeStreamAlreadyExist | 10043 | 订阅已存在流 |
| QNRTCErrorSubscribeSelf       | 10044 | 无法订阅自己 |
| QNRTCErrorNoPermission        | 10051 | 未许可 |
| QNRTCErrorServerUnavailable   | 10052 | 服务不可用 |
| QNRTCErrorInvalidParameter    | 11001 | 参数错误 |
| QNRTCErrorAuthFailed          | 11002 | 授权失败 |
| QNRTCErrorPublishFailed       | 11011 | 发布失败 |
| QNRTCErrorSubscribeFailed     | 11012 | 订阅失败 |

<a id="7.4.9"></a>
### 7.4.9 远端用户画面渲染的相关回调

远端用户视频首帧解码后的回调

```Objective-C
- (QNVideoRender *)RTCSession:(QNRTCSession *)session firstVideoDidDecodeOfRemoteUserId:(NSString *)userId;
```

**注意：如果需要渲染，则需要返回一个带 renderView 的 QNVideoRender 对象**

远端用户取消渲染到 renderView 上的回调

```Objective-C
- (void)RTCSession:(QNRTCSession *)session didDetachRenderView:(UIView *)renderView ofRemoteUserId:(NSString *)userId;
```

<a id="7.4.10"></a>
### 7.4.10 获取摄像头原数据的回调

获取到摄像头原数据时的回调，便于开发者做滤镜等处理

```Objective-C
- (CVPixelBufferRef)RTCSession:(QNRTCSession *)session cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer;
```

**注意：这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致推流帧率下降**

<a id="7.4.11"></a>
### 7.4.11 统计信息的回调

```Objective-C
- (void)RTCSession:(QNRTCSession *)session didGetStatistic:(NSDictionary *)statistic ofUserId:(NSString *)userId;
```

统计信息回调的时间间隔

```Objective-C
@property (nonatomic, assign) NSUInteger statisticInterval;
```

**注意：统计信息的回调，由 `statisticInterval` 参数决定， `statisticInterval` 默认为 0，即不回调统计信息**

<a id="7.5"></a>
## 7.5 美颜水印

<a id="7.5.1"></a>
### 7.5.1 美颜 

是否开启美颜

```Objective-C
-(void)setBeautifyModeOn:(BOOL)beautifyModeOn;
```

设置美颜 `Beauty` 的程度值，范围从 0 ~ 1，0 为不美颜

```Objective-C
-(void)setBeautify:(CGFloat)beautify;
```

**注意：若美颜未开启，则设置以下两个参数无效**

设置美白 `whiten` 的程度值，范围从 0 ~ 1，0 为不美白

```Objective-C
-(void)setWhiten:(CGFloat)whiten;
```

设置红润 `redden` 的程度值，范围从 0 ~ 1，0 为不红润

```Objective-C
-(void)setWhiten:(CGFloat)whiten;
```

<a id="7.5.2"></a>
### 7.5.2 水印

开启水印，其中 `waterMarkImage` 设置水印图片，`position` 设置水印位置

```Objective-C
-(void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position;
```

若需移除水印，调用如下代码：

```Objective-C
-(void)clearWaterMark;
```

<a id="7.6"></a>
## 7.6 其他功能

<a id="7.6.1"></a>
### 7.6.1 推流图片

用图片代替摄像头采集的数据推流

```Objective-C
- (void)setPushImage:(UIImage *)image;
```

<a id="7.6.2"></a>
### 7.6.2 previewView 的填充方式

```Objective-C
@property(readwrite, nonatomic) QNVideoFillModeType fillMode;
```

<a id="7.6.3"></a>
### 7.6.3 画面缩放

`videoZoomFactor` 默认为 1.0，设置的数值需要小于等于 videoActiveForat.videoMaxZoomFactor，如果大于会设置失败。

```Objective-C
@property (nonatomic, assign) CGFloat videoZoomFactor;
```

<a id="7.6.4"></a>
### 7.6.4 对焦

连续自动对焦，默认为 YES

```Objective-C
@property (nonatomic, assign, getter=isContinuousAutofocusEnable) BOOL  continuousAutofocusEnable;
```

手动点击屏幕进行对焦，默认为 YES

```Objective-C
@property (nonatomic, assign, getter=isTouchToFocusEnable) BOOL touchToFocusEnable;
```

自动对焦，适用于视频拍摄过程中用来减缓因自动对焦产生的镜头伸缩，使画面不因快速的对焦而产生抖动感，默认为 YES

```Objective-C
@property (nonatomic, assign, getter=isSmoothAutoFocusEnabled) BOOL  smoothAutoFocusEnabled;
```

手动对焦的位置，默认为 (0.5, 0.5), (0,0) 代表左上方, (1,1) 代表右下方

```Objective-C
@property (nonatomic, assign) CGPoint focusPointOfInterest;
```

<a id="7.6.5"></a>
### 7.6.5 扬声器

是否使扬声器静音

```Objective-C
@property (nonatomic, assign, getter=isMuteSpeaker) BOOL muteSpeaker;
```

<a id="7.6.6"></a>
### 7.6.6 手电筒

设备手电筒，默认为 NO

```Objective-C
@property (nonatomic, assign, getter=isTorchOn) BOOL torchOn;
```

<a id="7.6.7"></a>
### 7.6.7 设备授权

获取摄像头的授权状态

```Objective-C
+ (QNAuthorizationStatus)cameraAuthorizationStatus;
```

获取摄像头权限，`handler` 将会在主线程中回调。

```Objective-C
+ (void)requestCameraAccessWithCompletionHandler:(void (^)(BOOL granted))handler;
```

获取麦克风的授权状态

```Objective-C
+ (QNAuthorizationStatus)microphoneAuthorizationStatus;
```

获取麦克风权限，`handler` 将会在主线程中回调。

```Objective-C
+ (void)requestMicrophoneAccessWithCompletionHandler:(void (^)(BOOL granted))handler;
```

<a id="7.6.8"></a>
### 7.6.8 获取 SDK 的版本信息

获取 SDK 的版本信息

```Objective-C
+ (NSString *)versionInfo;
```

<a id="7.6.9"></a>
### 7.6.9 关于 SDK 的日志文件

开启文件日志，建议在 App 启动时即开启，日志文件位于 App Container/Library/Caches/Pili/Logs 目录下以 QNRTC+当前时间命名的目录内。

```Objective-C
+ (void)enableFileLogging;
```

**注意：文件日志功能主要用于排查问题，打开文件日志功能会对性能有一定影响，上线前请记得关闭文件日志功能！**

<a id="8"></a>
# 8 历史记录
- 0.1.0
    - 支持后台连麦 
    - 支持纯音频连麦
    - 支持硬件编码 	
    - 支持码率上下限配置 
    - 支持多分辨率编码 	      
    - 支持回调视频数据 	    
    - 支持实时美颜滤镜 		 
    - 支持第三方美颜滤镜 	
    - 支持水印功能 		    
    - 支持踢人功能 		      
    - 支持静音功能 		     
    - 支持自动/手动对焦 
    - 支持实时状态回调		
    - 支持回调连麦房间统计信息 
    - 支持丰富的连麦消息回调
	

<a id="9"></a>
# 9 FAQ

<a id="9.1"></a>
## 9.1 我可以体验下 demo 吗 ？

- 可以，请到 App Store 搜索：牛会议


















