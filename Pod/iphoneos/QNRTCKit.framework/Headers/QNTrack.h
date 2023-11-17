//
//  QNTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/12/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNVideoGLView.h"
#import "QNAudioMusicMixer.h"
#import "QNAudioEffectMixer.h"
#import "QNAudioSourceMixer.h"
#import "QNVideoEncoderConfig.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -- QNTrack
/*!
 * @abstract 用来描述一路 Track 的相关信息
 *
 * @discussion 主要用于发布/订阅时传入 Track 相关的信息，或者远端 Track 状态变更时 SDK 回调给 App Track 相关的信息。
 *
 * @since v4.0.0
 */
@interface QNTrack : NSObject

/*!
 * @abstract 用户的唯一标识。
 *
 * @since v5.0.0
 */
@property (nonatomic, readonly) NSString *userID;

/*!
 * @abstract 一路 Track 在 Server 端的唯一标识。
 *
 * @discussion 发布成功时由 SDK 自动生成，订阅/Mute 等操作依据此 trackID 来确定相应的 Track。
 *
 * @since v4.0.0
 */
@property (nonatomic, readonly) NSString *trackID;

/*!
 * @abstract 标识该路 Track 是音频还是视频。
 *
 * @discussion 发布时由 SDK 确定。
 *
 * @see QNTrackKind
 *
 * @since v4.0.0
 */
@property (nonatomic, readonly) QNTrackKind kind;

/*!
 * @abstract Track 的 tag，SDK 会将其透传到远端，当发布多路视频 Track 时可用 tag 来作区分。
 *
 * @since v4.0.0
 */
@property (nonatomic, readonly) NSString *tag;

/*!
 * @abstract 标识 Track 是否为 mute 状态
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) BOOL muted;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark -- QNLocalTrack
@interface QNLocalTrack : QNTrack

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 将本地音/视频 Track 置为 muted 状态。
 *
 * @discussion 需要发布成功后才可以执行 mute 操作。
 *
 * @since v4.0.0
 */
- (void)updateMute:(BOOL)muted;

/*!
 * @abstract 销毁本地音/视频 Track。
 *
 * @warning 在不使用该 Track 之后，请务必调用此接口。
 *
 * @since v5.0.0
 */
- (void)destroy;

@end

@class QNLocalAudioTrack;
@protocol QNLocalAudioTrackDelegate <NSObject>

@optional
/*!
 * @abstract 音频 Track 数据回调。
 *
 * @discussion 需要注意的是这个回调在 AU Remote IO 线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题。
 *
 * @since v5.0.0
 */
- (void)localAudioTrack:(QNLocalAudioTrack *)localAudioTrack didGetAudioBuffer:(AudioBuffer *)audioBuffer bitsPerSample:(NSUInteger)bitsPerSample sampleRate:(NSUInteger)sampleRate;

@end


#pragma mark -- QNLocalAudioTrack
@interface QNLocalAudioTrack : QNLocalTrack

/*!
 * @abstract 音频 Track 回调代理。
 *
 * @since v5.0.0
 */
@property (nonatomic, weak) id<QNLocalAudioTrackDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 输入音量
 *
 * @discussion 设置范围为 0 ~ 10，默认为 1
 *
 * @warning 当麦克风输入音量增益调大之后，部分机型会出现噪音
 *
 * @since v5.0.0
 */
- (void)setVolume:(double)volume;

/*!
 * @abstract 获取用户音量，范围 0 ～ 10。
 *
 * @since v5.0.0
 */
- (float)getVolumeLevel;

/*!
 * @abstract 设置耳返开关
 *
 * @param enabled 是否开启
 *
 * @since v5.1.0
 */
- (void)setEarMonitorEnabled:(BOOL)enabled;

/*!
 * @abstract 是否开启了耳返
 *
 * @return BOOL 是否开启
 *
 * @since v5.1.0
 */
- (BOOL)getEarMonitorEnabled;

/*!
 * @abstract 设置混音、返听场景下，本地播放的音量大小
 *
 * @param volume 播放音量，范围 0～1.0
 *
 * @since v5.1.0
 */
- (void)setPlayingVolume:(float)volume;

/*!
 * @abstract 获取混音、返听场景下，本地播放音量的大小
 *
 * @return float 播放音量，范围 0～1.0
 *
 * @since v5.1.0
 */
- (float)getPlayingVolume;

/*!
 * @abstract 增加 filter 模块
 *
 * @discussion 支持设置 QNAudioMusicMixer、QNAudioEffectMixer、QNAudioSourceMixer  等内置 Filter
 *
 * @since v5.2.6
 */
- (BOOL)addAudioFilter:(id<QNAudioFilterProtocol>)filter;

/*!
 * @abstract 移除 filter 模块
 *
 * @discussion 移除已经添加的 filter 模块
 *
 * @since v5.2.6
 */
- (BOOL)removeAudioFilter:(id<QNAudioFilterProtocol>)filter;

@end

@class QNMicrophoneAudioTrack;
@protocol QNMicrophoneAudioTrackDelegate <NSObject>

@optional

/*!
 * @abstract 麦克风采集运行过程中发生错误会通过该方法回调。
 *
 * @since v5.2.7
 */
- (void)microphoneAudioTrack:(QNMicrophoneAudioTrack *)microphoneAudioTrack didFailWithError:(NSError *)error;

@end

#pragma mark -- QNMicrophoneAudioTrack
@interface QNMicrophoneAudioTrack : QNLocalAudioTrack

/*!
 * @abstract 麦克风 Track 回调代理。
 *
 * @since v5.2.7
 */
@property (nonatomic, weak) id<QNMicrophoneAudioTrackDelegate> microphoneDelegate;

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 开始麦克风采集
 *
 * @return 是否调用成功
 *
 * @since v5.2.7
 */
- (BOOL)startRecording;

/*!
 * @abstract 停止麦克风采集
 *
 * @return 是否调用成功
 *
 * @since v5.2.7
 */
- (BOOL)stopRecording;

@end

#pragma mark -- QNCustomAudioTrack

@class QNCustomAudioTrack;
@protocol QNCustomAudioTrackDelegate <NSObject>

@optional

/*!
 * @abstract 导入音频数据过程中发生错误会通过该方法回调。
 *
 * @since v5.0.0
 */
- (void)customAudioTrack:(QNCustomAudioTrack *)customAudioTrack didFailWithError:(NSError *)error;

@end

@interface QNCustomAudioTrack : QNLocalAudioTrack

/*!
 * @abstract 自定义音频 Track 回调代理。
 *
 * @since v5.0.0
 */
@property (nonatomic, weak) id<QNCustomAudioTrackDelegate> customAudioDelegate;

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 导入音频数据
 *
 * @discussion 支持的音频数据格式为：PCM 格式，48000 采样率，16 位宽，单声道
 *
 * @since v4.0.0
 */
- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer;

/*!
 * @abstract 导入音频数据
 *
 * @discussion 支持的音频数据格式为：PCM 格式
 *
 * @warning 音频数据的格式信息，请务必对应实际数据信息传入
 *
 * @param asbd PCM 音频数据的具体音频信息，包括采样率、声道数、位宽等
 *
 * @since v4.0.0
 */
- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer asbd:(AudioStreamBasicDescription *)asbd;

/*!
 * @abstract 导入音频数据
 *
 * @discussion 支持的音频数据格式为：PCM 格式
 *
 * @warning 音频数据的格式信息，请务必对应实际数据信息传入
 *
 * @param data PCM 裸数据
 *
 * @param bitsPerSample 位宽
 *
 * @param sampleRate 采样率
 *
 * @param channels 声道数
 *
 * @param bigEndian 是否是大端，默认是小端
 *
 * @param planar 是否是平面结构，双声道模式下，默认是 packed
 *
 * @since v5.2.7
 */
- (void)pushAudioFrame:(const uint8_t*)data dataSize:(uint32_t)dataSize bitsPerSample:(uint32_t)bitsPerSample sampleRate:(uint32_t)sampleRate channels:(uint32_t)channels bigEndian:(bool)bigEndian planar:(bool)planar;
@end

#pragma mark -- QNLocalVideoTrackDelegate
@class QNLocalVideoTrack;
@protocol QNLocalVideoTrackDelegate <NSObject>

@optional
/*!
 * @abstract 视频 Track 数据回调。
 *
 * @discussion 需要注意的是这个回调在视频数据的输出线程，请不要做过于耗时的操作，否则可能会导致编码帧率下降。
 *
 * @since v5.0.0
 */
- (void)localVideoTrack:(QNLocalVideoTrack *)localVideoTrack didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

#pragma mark -- QNLocalVideoTrack
@interface QNLocalVideoTrack : QNLocalTrack

/*!
 * @abstract 视频 Track 回调代理。
 *
 * @since v5.0.0
 */
@property (nonatomic, weak) id<QNLocalVideoTrackDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 本地视频 Track 添加 SEI
 *
 * @param videoSEI SEI 内容
 *
 * @param uuid  自定义设置 uuid
 *
 * @param repeatNumber SEI 重复发送次数，-1 为永久发送
 *
 * @discussion 需要停止发送 SEI，可以设置 videoSEI 为 nil，repeatNumber 为 0 即可
 *
 * @since v5.0.0
 */
- (void)sendSEI:(NSString *)videoSEI
           uuid:(NSString *)uuid
   repeatNmuber:(NSNumber *)repeatNumber __deprecated_msg("Method deprecated in v5.2.3. Use `sendSEI:`");

/*!
 * @abstract 本地视频 Track 添加 SEI
 *
 * @param SEIData SEI 内容，不超过 4096 个字节
 *
 * @param uuid  自定义设置 uuid
 *
 * @param repeatCount SEI 重复发送次数，-1 为永久发送
 *
 * @discussion 需要停止发送 SEI，可以设置 videoSEI 为 nil，repeatNumber 为 0 即可
 *
 * @since v5.2.3
 */
- (void)sendSEIWithData:(NSData *)SEIData
                   uuid:(NSData *)uuid
            repeatCount:(NSNumber *)repeatCount;

/*!
 * @abstract 视频 Track 渲染。
 *
 * @discussion videoView 会被内部引用，外部销毁时需主动传 nil
 *
 * @since v5.0.0
 */
- (void)play:(QNVideoGLView *)videoView;

/*!
 * @abstract 动态修改编码配置
 *
 * @param config 编码参数配置
 *
 * @since v5.2.1
 */
- (void)setVideoEncoderConfig:(QNVideoEncoderConfig *)config;

@end


#pragma mark -- QNCameraVideoTrack

@class QNCameraVideoTrack;
@protocol QNCameraVideoTrackDelegate <NSObject>

@optional

/*!
 * @abstract 摄像头采集运行过程中发生错误会通过该方法回调。
 *
 * @since v5.2.3
 */
- (void)cameraVideoTrack:(QNCameraVideoTrack *)cameraVideoTrack didFailWithError:(NSError *)error;

/*！
 * @abstract 图片推流运行过程中发生错误会通过该方法回调。
 *
 * @since v5.2.5
 */
- (void)cameraVideoTrack:(QNCameraVideoTrack *)cameraVideoTrack didPushImageWithError:(NSError *)error;

@end

@interface QNCameraVideoTrack : QNLocalVideoTrack

/*!
 * @abstract 摄像头 Track 回调代理。
 *
 * @since v5.2.3
 */
@property (nonatomic, weak) id<QNCameraVideoTrackDelegate> cameraDelegate;

/*!
 * @abstract 摄像头的位置，默认为 AVCaptureDevicePositionFront。需在 config 中设置
 *
 * @since v5.0.0
 */
@property (nonatomic, assign, readonly) AVCaptureDevicePosition captureDevicePosition;

/*!
 * @abstract 开启 camera 时的采集摄像头的旋转方向，默认为 AVCaptureVideoOrientationPortrait。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

/*!
 * @abstract 是否开启手电筒，默认为 NO。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, getter=isTorchOn) BOOL torchOn;

/*!
 * @abstract 是否连续自动对焦，默认为 YES。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, getter=isContinuousAutofocusEnable) BOOL continuousAutofocusEnable;

/*!
 * @abstract 该属性适用于视频拍摄过程中用来减缓因自动对焦产生的镜头伸缩，使画面不因快速的对焦而产生抖动感。默认为 YES。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, getter=isSmoothAutoFocusEnabled) BOOL smoothAutoFocusEnabled;

/*!
 * @abstract 聚焦的位置，(0,0) 代表左上, (1,1) 代表右下。默认为 (0.5, 0.5)，即中间位置。
 *
 * @since v5.0.0
 */
@property (nonatomic, assign) CGPoint manualFocus;

/*!
 * @abstract 控制摄像头的缩放，默认为 1.0。
 *
 * @discussion 设置的数值需要小于等于 videoActiveForat.videoMaxZoomFactor，如果大于会设置失败。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) CGFloat videoZoomFactor;

/*!
 * @abstract 设备支持的 formats。
 *
 * @since v5.0.0
 */
@property (nonatomic, strong, readonly) NSArray<AVCaptureDeviceFormat *> *supportedVideoFormats;

/*!
 * @abstract 设备当前的 format。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) AVCaptureDeviceFormat *videoActiveFormat;

/*!
 * @abstract 采集的视频的 videoFormat，默认为 AVCaptureSessionPreset640x480。
 *
 * @since v5.0.0
 */
@property (nonatomic, copy) NSString *videoFormat;

/*!
 * @abstract 采集的视频数据的帧率，默认为 24。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) NSUInteger videoFrameRate;

/*!
 * @abstract 前置摄像头，预览是否开启镜像，默认为 YES。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) BOOL previewMirrorFrontFacing;

/*!
 * @abstract 后置摄像头，预览是否开启镜像，默认为 NO。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) BOOL previewMirrorRearFacing;

/*!
 * @abstract 前置摄像头，对方观看时是否开启镜像，默认 YES。
 *
 * @since v5.2.0
 */
@property (nonatomic, assign) BOOL encodeMirrorFrontFacing;

/*!
 * @abstract 后置摄像头，对方观看时是否开启镜像，默认 NO。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) BOOL encodeMirrorRearFacing;

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 切换前后摄像头。
 *
 * @since v4.0.0
 */
- (void)switchCamera __deprecated_msg("Method deprecated in v5.2.3. Use `switchCamera:`");

/*!
 * @abstract 切换前后摄像头。
 *
 * @since v5.2.3
 */
- (void)switchCamera:(nullable QNCameraSwitchResultCallback)callback;

/*!
 * @abstract 是否开启美颜。
 *
 * @since v4.0.0
 */
- (void)setBeautifyModeOn:(BOOL)beautifyModeOn;

/*!
 * @abstract 设置磨皮的程度，范围从 0 ~ 1，0 为不磨皮。
 *
 * @discussion 如果美颜不开启，设置该参数无效。
 *
 * @since v5.0.0
 */
- (void)setSmoothLevel:(CGFloat)smoothLevel;

/*!
 * @abstract 设置美白的程度，范围从 0 ~ 1，0 为不美白。
 *
 * @discussion 如果美颜不开启，设置该参数无效。
 *
 * @since v4.0.0
 */
- (void)setWhiten:(CGFloat)whiten;

/*!
 * @abstract 设置红润的程度，范围是从 0 ~ 1，0 为不红润。
 *
 * @discussion 如果美颜不开启，设置该参数无效。
 *
 * @since v4.0.0
 */
- (void)setRedden:(CGFloat)redden;

/*!
 * @abstract 设置水印。
 *
 * @since v4.0.0
 */
- (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position;

/*!
 * @abstract 移除水印。
 *
 * @since v4.0.0
 */
- (void)clearWaterMark;

/*!
 * @abstract 设置摄像头 track 发送图片数据
 *
 * @param image 推流的图片
 *
 * @discussion 由于某些特殊原因不想使用摄像头采集的数据作为发送视频数据时，可以使用该接口设置一张图片来替代。传入 nil 则关闭该功能。
 * @warning    请确保传入的 image 的宽和高是 16 的整数倍。请对应错误码确保传入参数源可用
 *
 * @return 返回 0 代表接口调用成功，调用失败将直接返回错误码
 *
 * @since v5.2.5
 */
- (int)pushImage:(nullable UIImage *)image;

/*!
 * @abstract 开启摄像头采集。
 *
 * @since v4.0.0
 */
- (void)startCapture;

/*!
 * @abstract 关闭摄像头采集。
 *
 * @since v4.0.0
 */
- (void)stopCapture;

@end


@class QNScreenVideoTrack;
@protocol QNScreenVideoTrackDelegate <NSObject>

@optional

/*!
 * @abstract 录屏运行过程中发生错误会通过该方法回调。
 *
 * @since v4.0.0
 */
- (void)screenVideoTrack:(QNScreenVideoTrack *)screenVideoTrack didFailWithError:(NSError *)error;

@end

#pragma mark -- QNScreenVideoTrack
@interface QNScreenVideoTrack : QNLocalVideoTrack

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 判断屏幕共享功能是否可用
 *
 * @discussion 屏幕共享功能仅在 iOS 11 及以上版本可用
 *
 * @since v4.0.0
 */
+ (BOOL)isScreenRecorderAvailable;

/*!
 * @abstract 录屏 Track 回调代理。
 *
 * @since v4.0.0
 */
@property (nonatomic, weak) id<QNScreenVideoTrackDelegate> screenDelegate;

@end

#pragma mark -- QNCustomVideoTrack
@interface QNCustomVideoTrack : QNLocalVideoTrack

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 导入视频数据。
 *
 * @discussion 调用此接口将把数据导入给所有 QNCustomVideoTrack 的 Track。
 *
 * @param sampleBuffer 支持导入的视频数据格式为：kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 *                     和 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange。
 *
 * @since v4.0.0
 */
- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/*!
 * @abstract 导入视频数据。
 *
 * @discussion 调用此接口将把数据导入给所有 QNCustomVideoTrack  的 Track。
 *
 * @param pixelBuffer 支持导入的视频数据格式为：kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 *                    和 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange。
 *
 * @since v4.0.0
 */
- (void)pushPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

#pragma mark -- QNRemoteTrack
@interface QNRemoteTrack : QNTrack

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 是否已订阅。
 *
 * @since v4.0.0
 */
@property (nonatomic, readonly) BOOL isSubscribed;

@end

@class QNRemoteAudioTrack;
@protocol QNRemoteAudioTrackDelegate <NSObject>

/*!
 * @abstract 音频 Track 数据回调。
 *
 * @since v4.0.0
 */
- (void)remoteAudioTrack:(QNRemoteAudioTrack *)remoteAudioTrack didGetAudioBuffer:(AudioBuffer *)audioBuffer bitsPerSample:(NSUInteger)bitsPerSample sampleRate:(NSUInteger)sampleRate;

/*!
 * @abstract 订阅的远端音频 Track 开关静默时的回调。
 *
 * @since v5.0.0
 */
- (void)remoteAudioTrack:(QNRemoteAudioTrack *)remoteAudioTrack didMuteStateChanged:(BOOL)isMuted;

@end

#pragma mark -- QNRemoteAudioTrack
@interface QNRemoteAudioTrack : QNRemoteTrack

/*!
 * @abstract 远端音频 Track 回调代理。
 *
 * @since v5.0.0
 */
@property (nonatomic, weak) id<QNRemoteAudioTrackDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 设置远端音频 Track 播放音量。范围从 0 ~ 10，10 为最大
 *
 * @discussion 需要发布成功后才可以执行。本次操作仅对远端音频播放音量做调整，远端音量回调为远端音频数据的原始音量，不会基于本设置做相应调整。
 *
 * @warning 部分机型调整音量放大会出现低频噪音
 *
 * @since  v4.0.0
 */
- (void)setVolume:(double)volume;

/*!
 * @abstract 获取用户音量等级，volume 值在 [0, 1] 之间。
 *
 * @since v5.0.0
 */
- (float)getVolumeLevel;

@end

@class QNRemoteVideoTrack;
@protocol QNRemoteVideoTrackDelegate <NSObject>

@optional
/*!
 * @abstract 视频 Track 数据回调。
 *
 * @since v4.0.0
 */
- (void)remoteVideoTrack:(QNRemoteVideoTrack *)remoteVideoTrack didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/*!
 * @abstract 订阅的远端视频 Track 开关静默时的回调。
 *
 * @since v5.0.0
 */
- (void)remoteVideoTrack:(QNRemoteVideoTrack *)remoteVideoTrack didMuteStateChanged:(BOOL)isMuted;

/*!
 * @abstract 订阅的远端视频 Track 分辨率发生变化时的回调。
 *
 * @since v5.0.0
 */
- (void)remoteVideoTrack:(QNRemoteVideoTrack *)remoteVideoTrack didVideoProfileChanged:(QNTrackProfile)profile;

@end

#pragma mark -- QNRemoteVideoTrack
@interface QNRemoteVideoTrack : QNRemoteTrack

/*!
 * @abstract 视频 Track 回调代理。
 *
 * @since v5.0.0
 */
@property (nonatomic, weak) id<QNRemoteVideoTrackDelegate> delegate;

/*!
 * @abstract 是否开启大小流。
 *
 * @since v4.0.0
 */
@property (nonatomic, readonly) BOOL isMultiProfileEnabled;

/*!
 * @abstract 当前大小流等级。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) QNTrackProfile profile;

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 变更订阅大小流等级。
 *
 * @since v4.0.0
 */
- (void)setProfile:(QNTrackProfile)profile;

/*!
 * @abstract 视频 Track 渲染。
 *
 * @discussion videoView 会被内部引用，外部销毁时需主动传 nil
 *
 * @since v5.0.0
 */
- (void)play:(QNVideoGLView *)videoView;

@end

NS_ASSUME_NONNULL_END
