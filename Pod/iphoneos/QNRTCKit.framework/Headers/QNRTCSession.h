//
//  QNRTCSession.h
//  QNRTCKit
//
//  Created by lawder on 2017/12/3.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QNTypeDefines.h"
#import "QNVideoRender.h"
#import "QNMergeStreamConfiguration.h"

@class QNRTCSession;

/*** DEPRECATED: QNRTCSession 已废弃, 请使用 QNRTCEngine ***/

NS_ASSUME_NONNULL_BEGIN

@protocol QNRTCSessionDelegate <NSObject>

@optional

/**
 * SDK 运行过程中发生错误会通过该方法回调，具体错误码的含义可以见 QNTypeDefines.h 文件
 */
- (void)RTCSession:(QNRTCSession *)session didFailWithError:(NSError *)error;

/**
 * 房间状态变更的回调。当状态变为 QNRoomStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leaveRoom 即可
 */
- (void)RTCSession:(QNRTCSession *)session roomStateDidChange:(QNRoomState)roomState;

/**
 * 本地音视频发布到服务器的回调
 */
- (void)sessionDidPublishLocalMedia:(QNRTCSession *)session;

/**
 * 创建合流转推成功的回调
 */
- (void)RTCSession:(QNRTCSession *)session didCreateMergeStreamWithJobId:(NSString *)jobId;

/**
 * 远端用户加入房间的回调
 */
- (void)RTCSession:(QNRTCSession *)session didJoinOfRemoteUserId:(NSString *)userId;

/**
 * 远端用户离开房间的回调
 */
- (void)RTCSession:(QNRTCSession *)session didLeaveOfRemoteUserId:(NSString *)userId;

/**
 * 订阅远端用户成功的回调
 */
- (void)RTCSession:(QNRTCSession *)session didSubscribeUserId:(NSString *)userId;

/**
 * 远端用户发布音/视频的回调
 */
- (void)RTCSession:(QNRTCSession *)session didPublishOfRemoteUserId:(NSString *)userId;

/**
 * 远端用户取消发布音/视频的回调
 */
- (void)RTCSession:(QNRTCSession *)session didUnpublishOfRemoteUserId:(NSString *)userId;

/**
 * 被 userId 踢出的回调
 */
- (void)RTCSession:(QNRTCSession *)session didKickoutByUserId:(NSString *)userId;

/**
 * 远端用户音频状态变更为 muted 的回调
 */
- (void)RTCSession:(QNRTCSession *)session didAudioMuted:(BOOL)muted byRemoteUserId:(NSString *)userId;

/**
 * 远端用户视频状态变更为 muted 的回调
 */
- (void)RTCSession:(QNRTCSession *)session didVideoMuted:(BOOL)muted byRemoteUserId:(NSString *)userId;

/**
 * 远端用户视频首帧解码后的回调，如果需要渲染，则需要返回一个带 renderView 的 QNVideoRender 对象
 */
- (QNVideoRender *)RTCSession:(QNRTCSession *)session firstVideoDidDecodeOfRemoteUserId:(NSString *)userId;

/**
 * 远端用户视频取消渲染到 renderView 上的回调
 */
- (void)RTCSession:(QNRTCSession *)session didDetachRenderView:(UIView *)renderView ofRemoteUserId:(NSString *)userId;

/**
 * 远端用户视频数据的回调
 *
 * 注意：回调远端用户视频数据会带来一定的性能消耗，如果没有相关需求，请不要实现该回调
 */
- (void)RTCSession:(QNRTCSession *)session didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer ofRemoteUserId:(NSString *)userId;

/**
 * 远端用户音频数据的回调
 *
 * 注意：回调远端用户音频数据会带来一定的性能消耗，如果没有相关需求，请不要实现该回调
 */
- (void)RTCSession:(QNRTCSession *)session
 didGetAudioBuffer:(AudioBuffer *)audioBuffer
     bitsPerSample:(NSUInteger)bitsPerSample
        sampleRate:(NSUInteger)sampleRate
    ofRemoteUserId:(NSString *)userId;

/**
 * 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致编码帧率下降
 */
- (void)RTCSession:(QNRTCSession *)session cameraSourceDidGetSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 * 获取到麦克风原数据时的回调，需要注意的是这个回调在 AU Remote IO 线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题
 */
- (void)RTCSession:(QNRTCSession *)session microphoneSourceDidGetAudioBuffer:(AudioBuffer *)audioBuffer;

/**
 *统计信息回调，回调的时间间隔由 statisticInterval 参数决定，statisticInterval 默认为 0，即不回调统计信息
 */
- (void)RTCSession:(QNRTCSession *)session didGetStatistic:(NSDictionary *)statistic ofUserId:(NSString *)userId;

@end

__attribute__((deprecated("QNRTCSession 已废弃, 请使用 QNRTCEngine")))
@interface QNRTCSession : NSObject

/**
 *  房间状态
 */
@property (nonatomic, assign, readonly) QNRoomState roomState;

/**
 *  状态回调的 delegate
 */
@property (nonatomic, weak) id<QNRTCSessionDelegate> delegate;

/**
 *  是否使自己发布到服务器上的声音静音，注意：在离开房间后 SDK 并不会重置该值，即会保持您上次设置的值
 */
@property (nonatomic, assign, getter=isMuteAudio) BOOL muteAudio;

/**
 *  是否使自己发布到服务器上的视频黑屏，注意：在离开房间后 SDK 并不会重置该值，即会保持您上次设置的值
 */
@property (nonatomic, assign, getter=isMuteVideo) BOOL muteVideo;

/**
 *  是否静音本地扬声器，注意：在离开房间后 SDK 并不会重置该值，即会保持您上次设置的值
 */
@property (nonatomic, assign, getter=isMuteSpeaker) BOOL muteSpeaker;

/**
 *  统计信息回调的时间间隔；默认为 0 秒，即默认不会回调统计信息
 */
@property (nonatomic, assign) NSUInteger statisticInterval;

/**
 *  设置连麦编码时的尺寸，该尺寸需要小于等于预览的尺寸。
 *  默认值为 CGSizeZero，即使用预览的尺寸。
 */
@property (nonatomic, assign) CGSize videoEncodeSize;

/**
 *  连麦房间中的用户的列表（不包含自己）。
 *  连麦状态为 QNRoomStateConnected 才可获取。
 */
@property (nonatomic, strong, readonly) NSArray<NSString *> *userList;

/**
 *  连麦房间中已发布音/视频的用户的列表（不包含自己）。
 *  连麦状态为 QNRoomStateConnected 才可获取。
 */
@property (nonatomic, strong, readonly) NSArray<NSString *> *publishingUserList;

/**
 *  是否使用 SDK 内部的音视频采集模块，默认为 YES
 */
@property (nonatomic, assign, readonly) BOOL captureEnabled;

/**
 *  初始化 QNRTCSession 实例
 *  @param captureEnabled 是否使用 SDK 内部的音视频采集模块
 */
- (instancetype)initWithCaptureEnabled:(BOOL)captureEnabled;

/**
 *  加入房间，token 中已经包含 appId、roomToken、userId 等信息
 */
- (void)joinRoomWithToken:(NSString *)token;

/**
 *  退出房间
 */
- (void)leaveRoom;

/**
 *  发布自己的音/视频到服务器中
 */
- (void)publishWithAudioEnabled:(BOOL)audioEnabled
                   videoEnabled:(BOOL)videoEnabled;

/**
 *  取消发布自己的音/视频
 */
- (void)unpublish;

/**
 *  导入视频数据，仅在 captureEnabled 为 NO 时才支持导入视频数据
 */
- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 *  导入视频数据，仅在 captureEnabled 为 NO 时才支持导入视频数据
 */
- (void)pushPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/**
 *  导入音频数据，仅在 captureEnabled 为 NO 时才支持导入音频数据
 *  支持的音频数据格式为：PCM 格式，48000 采样率，16 位宽，单声道
 */
- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer;

/**
 *  订阅 userId 的音/视频
 */
- (void)subscribe:(NSString *)userId;

/*!
 @abstract
 订阅某一用户的流。

 @param userId
 被订阅的用户的 userId。

 @param continuous
 是否持续订阅该用户的流。

 @discussion
 调用该接口时，要求 userId 对应的用户已经加入到房间中，否则会回调错误。
 如果 continuous 为 YES，那么当 userId 发布流时，SDK 会自动订阅流。一直持续到取消订阅或者 userId 取消发布流为止。
 另外，本地用户退出房间亦会清空持续订阅的用户列表。

 @since v1.2.0
 */
- (void)subscribe:(NSString *)userId continuous:(BOOL)continuous;

/**
 *  取消订阅 userId 的音/视频
 */
- (void)unsubscribe:(NSString *)userId;

/**
 *  将 userId 的踢出房间
 */
- (void)kickoutUser:(NSString *)userId;

/**
 *  设置连麦的码率
 *  minBitrateBps: 连麦最低的码率值
 *  maxBitrateBps: 连麦最高的码率值
 *  设置最高及最低码率值后，在网络带宽变小导致发送缓冲区数据持续增长时，SDK 内部将适当降低连麦码率直至设置的最低值；反之，当一段时间内网络带宽充裕，SDK 内部将适当增加码率，达到最高值。
 *  注意：网络较差的情况下，若设置最低码率值过高，将严重影响连麦的质量，故建议适当设置最低码率值
 */
- (void)setMinBitrateBps:(NSUInteger)minBitrateBps
           maxBitrateBps:(NSUInteger)maxBitrateBps;

/**
 *  创建 merge stream job
 *  configuration: 合流的配置信息；
 */
- (void)createMergeStreamWithConfiguration:(QNMergeStreamConfiguration *)configuration;

/**
 *  设置服务端合流参数
 *  userId: 本次设置所对应的 userId
 *  frame: 在合流画面中的大小和位置，需为整数；如果合流后想取消视频的合成，重新调用该接口将 frame.size.width 或 frame.size.height 置为 0 即可。
 *  zIndex: 在合流画面中的层次，0 在最底层
 *  注意：取消视频的合成后，音频仍然会保留，如果希望同时取消音频的合成，可以使用 - (void)setMergeStreamLayoutWithUserId:(NSString *)userId frame:(CGRect)frame zIndex:(NSUInteger)zIndex muted:(BOOL)muted; 接口

 */
- (void)setMergeStreamLayoutWithUserId:(NSString *)userId
                                 frame:(CGRect)frame
                                zIndex:(NSUInteger)zIndex;

/**
 *  设置服务端合流参数
 *  userId: 本次设置所对应的 userId；
 *  frame: 在合流画面中的大小和位置，需为整数，若 frame.size.width 或 frame.size.height 为 0，则该用户的视频不会合成到合流画面中；
 *  zIndex: 在合流画面中的层次，0 在最底层；
 *  muted: 音频是否静音，若 muted 为 YES，则不会合成该用户的音频；
 *  说明：设置合流参数后，如果需要更改参数，重新调用该接口并传入修改后的参数即可。
 */
- (void)setMergeStreamLayoutWithUserId:(NSString *)userId
                                 frame:(CGRect)frame
                                zIndex:(NSUInteger)zIndex
                                 muted:(BOOL)muted;

/**
 *  设置服务端合流参数
 *  userId: 本次设置所对应的 userId；
 *  frame: 在合流画面中的大小和位置，需为整数，若 frame.size.width 或 frame.size.height 为 0，则该用户的视频不会合成到合流画面中；
 *  zIndex: 在合流画面中的层次，0 在最底层；
 *  muted: 音频是否静音，若 muted 为 YES，则不会合成该用户的音频；
 *  jobId: 合流的 Id；
 *  说明：设置合流参数后，如果需要更改参数，重新调用该接口并传入修改后的参数即可。
 */
- (void)setMergeStreamLayoutWithUserId:(NSString *)userId
                                 frame:(CGRect)frame
                                zIndex:(NSUInteger)zIndex
                                 muted:(BOOL)muted
                                 jobId:(NSString *)jobId;

/**
 *  停止整个房间的合流。如果停止合流后需要重新开启合流，重新调用 - (void)setMergeStreamLayoutWithUserId:(NSString *)userId frame:(CGRect)frame zIndex:(NSUInteger)zIndex muted:(BOOL)muted 接口设置合流参数即可。
 */
- (void)stopMergeStream;

/**
 *  停止整个房间的合流。如果停止合流后需要重新开启合流，重新调用 - (void)setMergeStreamLayoutWithUserId:(NSString *)userId frame:(CGRect)frame zIndex:(NSUInteger)zIndex muted:(BOOL)muted jobId:(NSString *)jobId 接口设置合流参数即可。
 *  jobId: 合流的 id
 */
- (void)stopMergeStreamWithJobId:(NSString *)jobId;

@end


#pragma mark - Category (CameraSource)

/*!
 * @category PLCameraStreamingSession(CameraSource)
 *
 * @discussion 与摄像头相关的接口
 */
@interface QNRTCSession (CameraSource)

/*!
 @property   captureSession
 @abstract   视频采集 session，只读变量，给有特殊需求的开发者使用，最好不要修改
 */
@property (nonatomic, readonly) AVCaptureSession * _Nullable captureSession;

/*!
 @property   videoCaptureDeviceInput
 @abstract   视频采集输入源，只读变量，给有特殊需求的开发者使用，最好不要修改
 */
@property (nonatomic, readonly) AVCaptureDeviceInput * _Nullable videoCaptureDeviceInput;

/*!
 * @abstract 摄像头的预览视图，调用 startCapture 后才会有画面
 *
 */
@property (nonatomic, strong, readonly) UIView *previewView;

/**
 @brief previewView 中视频的填充方式，默认使用 QNVideoFillModePreserveAspectRatioAndFill
 */
@property(readwrite, nonatomic) QNVideoFillModeType fillMode;

/// default as AVCaptureDevicePositionFront.
@property (nonatomic, assign) AVCaptureDevicePosition   captureDevicePosition;

/**
 @brief 开启 camera 时的采集摄像头的旋转方向，默认为 AVCaptureVideoOrientationPortrait
 */
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

/// default as NO.
@property (nonatomic, assign, getter=isTorchOn) BOOL    torchOn;

/*!
 @property  continuousAutofocusEnable
 @abstract  连续自动对焦。该属性默认开启。
 */
@property (nonatomic, assign, getter=isContinuousAutofocusEnable) BOOL  continuousAutofocusEnable;

/*!
 @property  touchToFocusEnable
 @abstract  手动点击屏幕进行对焦。该属性默认开启。
 */
@property (nonatomic, assign, getter=isTouchToFocusEnable) BOOL touchToFocusEnable;

/*!
 @property  smoothAutoFocusEnabled
 @abstract  该属性适用于视频拍摄过程中用来减缓因自动对焦产生的镜头伸缩，使画面不因快速的对焦而产生抖动感。该属性默认开启。
 */
@property (nonatomic, assign, getter=isSmoothAutoFocusEnabled) BOOL  smoothAutoFocusEnabled;

/// default as (0.5, 0.5), (0,0) is top-left, (1,1) is bottom-right.
@property (nonatomic, assign) CGPoint   focusPointOfInterest;

/// 默认为 1.0，设置的数值需要小于等于 videoActiveForat.videoMaxZoomFactor，如果大于会设置失败。
@property (nonatomic, assign) CGFloat videoZoomFactor;

@property (nonatomic, strong, readonly) NSArray<AVCaptureDeviceFormat *> *videoFormats;

@property (nonatomic, strong) AVCaptureDeviceFormat *videoActiveFormat;

/**
 @brief 采集的视频的 sessionPreset，默认为 AVCaptureSessionPreset640x480
 */
@property (nonatomic, copy) NSString *sessionPreset;

/**
 @brief 采集的视频数据的帧率，默认为 24
 */
@property (nonatomic, assign) NSUInteger videoFrameRate;

/**
 @brief 前置预览是否开启镜像，默认为 YES
 */
@property (nonatomic, assign) BOOL previewMirrorFrontFacing;

/**
 @brief 后置预览是否开启镜像，默认为 NO
 */
@property (nonatomic, assign) BOOL previewMirrorRearFacing;

/**
 *  前置摄像头，对方观看时是否开启镜像，默认 NO
 */
@property (nonatomic, assign) BOOL encodeMirrorFrontFacing;

/**
 *  后置摄像头，对方观看时是否开启镜像，默认 NO
 */
@property (nonatomic, assign) BOOL encodeMirrorRearFacing;



/**
 *  切换前后摄像头
 */
- (void)toggleCamera;

/**
 *  是否开启美颜
 */
-(void)setBeautifyModeOn:(BOOL)beautifyModeOn;

/**
 @brief 设置对应 Beauty 的程度参数.

 @param beautify 范围从 0 ~ 1，0 为不美颜
 */
-(void)setBeautify:(CGFloat)beautify;

/**
 *  设置美白程度（注意：如果美颜不开启，设置美白程度参数无效）
 *
 *  @param whiten 范围是从 0 ~ 1，0 为不美白
 */
-(void)setWhiten:(CGFloat)whiten;

/**
 *  设置红润的程度参数.（注意：如果美颜不开启，设置美白程度参数无效）
 *
 *  @param redden 范围是从 0 ~ 1，0 为不红润
 */

-(void)setRedden:(CGFloat)redden;

/**
 *  开启水印
 *
 *  @param waterMarkImage 水印的图片
 *  @param position       水印的位置
 */
-(void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position;

/**
 *  移除水印
 */
-(void)clearWaterMark;

/**
 *  开启摄像头采集
 *
 *  @discussion 开启摄像头采集
 */
- (void)startCapture;

/**
 *  关闭摄像头采集
 *
 *  @discussion 关闭摄像头采集
 */
- (void)stopCapture;

@end

#pragma mark - Category (Authorization)

/*!
 * @category PLMediaStreamingSession(Authorization)
 *
 * @discussion 与设备授权相关的接口
 */
@interface QNRTCSession (Authorization)

// 摄像头的授权状态
+ (QNAuthorizationStatus)cameraAuthorizationStatus;

/**
 * 获取摄像头权限
 * @param handler 该 block 将会在主线程中回调。
 */
+ (void)requestCameraAccessWithCompletionHandler:(void (^)(BOOL granted))handler;

// 麦克风的授权状态
+ (QNAuthorizationStatus)microphoneAuthorizationStatus;

/**
 * 获取麦克风权限
 * @param handler 该 block 将会在主线程中回调。
 */
+ (void)requestMicrophoneAccessWithCompletionHandler:(void (^)(BOOL granted))handler;

@end

#pragma mark - Category (Logging)

@interface QNRTCSession (Logging)

/**
 * 开启文件日志。为了不错过日志，建议在 App 启动时即开启，日志文件位于 App Container/Library/Caches/Pili/Logs 目录下以 QNRTC+当前时间命名的目录内
 * 注意：文件日志功能主要用于排查问题，打开文件日志功能会对性能有一定影响，上线前请记得关闭文件日志功能！
 */
+ (void)enableFileLogging;

@end

#pragma mark - Category (Info)

@interface QNRTCSession (Info)

/**
 * 获取 SDK 的版本信息
 */
+ (NSString *)versionInfo;

@end

NS_ASSUME_NONNULL_END



