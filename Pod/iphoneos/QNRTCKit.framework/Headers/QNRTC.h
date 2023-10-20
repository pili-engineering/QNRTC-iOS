//
//  QNRTC.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/6/18.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QNTypeDefines.h"
#import "QNTrack.h"
#import "QNRTCLogConfiguration.h"

@class QNRTC;
@class QNRTCConfiguration;
@class QNClientConfig;
@class QNRTCClient;
@class QNMicrophoneAudioTrack;
@class QNMicrophoneAudioTrackConfig;
@class QNCameraVideoTrack;
@class QNCameraVideoTrackConfig;
@class QNCustomAudioTrack;
@class QNCustomAudioTrackConfig;
@class QNScreenVideoTrack;
@class QNScreenVideoTrackConfig;
@class QNCustomVideoTrack;
@class QNCustomVideoTrackConfig;

NS_ASSUME_NONNULL_BEGIN

@protocol QNRTCDelegate <NSObject>

@optional

/*!
 * @abstract 音频输出设备变更的回调。主动调用的 `+ (void)setAudioRouteToSpeakerphone:(BOOL)audioRouteToSpeakerphone;` 不会有该回调。
 *
 * @since v5.0.0
 */
- (void)RTCDidAudioRouteChanged:(QNAudioDeviceType)deviceType;

@end

@interface QNRTC : NSObject

/*!
 * @abstract 用 configuration 初始化 QNRTC，务必使用。
 *
 * @param configuration QNRTC 的配置。
 *
 * @since v5.0.0
 */
+ (void)initRTC:(QNRTCConfiguration *)configuration;

/*!
 * @abstract 取消初始化 QNRTC。
 *
 * @since v5.0.0
 */
+ (void)deinit;

/*!
 * @abstract 创建 QNRTCClient。
 *
 * @since v4.0.0
 */
+ (QNRTCClient *)createRTCClient;

/*!
 * @abstract 创建 QNRTCClient。
 *
 *@param clientConfig QNRTCClient 的配置。
 *
 * @since v4.0.0
 */
+ (QNRTCClient *)createRTCClient:(QNClientConfig *)clientConfig;

/*!
 * @abstract 创建一路以麦克风采集为数据源的音频 track，默认码率为 64kbps
 *
 * @since v4.0.0
 */
+ (QNMicrophoneAudioTrack *)createMicrophoneAudioTrack;

/*!
 * @abstract 创建一路以麦克风采集为数据源的音频 track
 *
 * @param configuration 用于初始化麦克风采集的音频 track 的配置。
 *
 * @since v4.0.0
 */
+ (QNMicrophoneAudioTrack *)createMicrophoneAudioTrackWithConfig:(QNMicrophoneAudioTrackConfig *)configuration;

/*!
 * @abstract 创建一路以外部数据导入为数据源的音频 track，默认码率为 64kbps
 *
 * @since v4.0.0
 */
+ (QNCustomAudioTrack *)createCustomAudioTrack;

/*!
 * @abstract 创建一路以外部数据导入为数据源的音频 track
 *
 * @param configuration 用于初始化外部数据导入的音频 track 的配置。
 *
 * @since v4.0.0
 */
+ (QNCustomAudioTrack *)createCustomAudioTrackWithConfig:(QNCustomAudioTrackConfig *)configuration;

/*!
 * @abstract 创建一路以摄像头采集为数据源的视频 track，默认码率为 600 kbps
 *
 * @since v4.0.0
 */
+ (QNCameraVideoTrack *)createCameraVideoTrack;

/*!
 * @abstract 创建一路以摄像头采集为数据源的视频 track
 *
 * @param configuration 用于初始化摄像头采集的视频 track 的配置。
 *
 * @since v4.0.0
 */
+ (QNCameraVideoTrack *)createCameraVideoTrackWithConfig:(QNCameraVideoTrackConfig *)configuration;

/*!
 * @abstract 创建一路以屏幕共享采集为数据源的视频 track，默认码率为 600 kbps
 *
 * @since v4.0.0
 */
+ (QNScreenVideoTrack *)createScreenVideoTrack;

/*!
 * @abstract 创建一路以屏幕共享采集为数据源的视频 track。
 *
 * @param configuration 用于初始化屏幕共享采集的视频 track 的配置。
 *
 * @since v4.0.0
 */
+ (QNScreenVideoTrack *)createScreenVideoTrackWithConfig:(QNScreenVideoTrackConfig *)configuration;

/*!
 * @abstract 创建一路以外部视频数据导入为数据源的视频 track，默认码率为 600 kbps
 *
 * @since v4.0.0
 */
+ (QNCustomVideoTrack *)createCustomVideoTrack;

/*!
 * @abstract 创建一路以外部视频数据导入为数据源的视频 track
 *
 * @param configuration 用于初始化外部视频数据导入的视频 track 的配置。
 *
 * @since v4.0.0
 */
+ (QNCustomVideoTrack *)createCustomVideoTrackWithConfig:(QNCustomVideoTrackConfig *)configuration;

/*!
 * @abstract 创建背景音乐混音对象实例
 *
 * @param musicPath 背景音乐路径，支持本地路径及在线文件
 *
 * @param musicMixerDelegate 背景音乐混音回调代理
 *
 * @return QNAudioMusicMixer 对象实例
 *
 * @since v5.2.6
 */
+ (QNAudioMusicMixer *)createAudioMusicMixer:(NSString *)musicPath musicMixerDelegate:(id<QNAudioMusicMixerDelegate>)musicMixerDelegate;

/*!
 * @abstract 销毁背景音乐混音对象实例
 *
 * @since v5.2.6
 */
+ (void)destroyAudioMusicMixer:(QNAudioMusicMixer*)mixer;

/*!
 * @abstract 创建音效混音对象实例
 *
 * @param effectMixerDelegate 音效混音回调代理
 *
 * @since v5.2.6
 */
+ (QNAudioEffectMixer *)createAudioEffectMixer:(id<QNAudioEffectMixerDelegate>)effectMixerDelegate;

/*!
 * @abstract 销毁音效混音对象实例
 *
 * @since v5.2.6
 */
+ (void)destroyAudioEffectMixer:(QNAudioEffectMixer*)mixer;

/*!
 * @abstract 创建音源混音对象实例
 *
 * @param sourceMixerDelegate 音源混音回调代理
 *
 * @since v5.2.6
 */
+ (QNAudioSourceMixer *)createAudioSourceMixer:(id<QNAudioSourceMixerDelegate>)sourceMixerDelegate;

/*!
 * @abstract 销毁音源混音对象实例
 *
 * @since v5.2.6
 */
+ (void)destroyAudioSourceMixer:(QNAudioSourceMixer*)mixer;

@end

#pragma mark - Category (Audio)

/*!
 * @category QNRTC(Audio)
 *
 * @discussion 与音频设备相关的接口。
 *
 * @since v4.0.0
 */
@interface QNRTC (Audio)

/*!
 * @abstract 设置 QNRTCDelegate 代理回调。
 *
 * @since v5.0.0
 */
+ (void)setRTCDelegate:(id <QNRTCDelegate>)delegate;

/*!
 * @abstract 是否将声音从扬声器输出。
 *
 * @discussion 传入 YES 时，强制声音从扬声器输出。
 *
 * @warning 由于系统原因，在某些设备（如 iPhone XS Max、iPhone 8 Plus）上，连接 AirPods 后无法通过
 * 该接口将声音强制设为扬声器输出。如有需求，可以通过使用 AVRoutePickerView 来切换。
 *
 * @since v4.0.0
 */
+ (void)setAudioRouteToSpeakerphone:(BOOL)audioRouteToSpeakerphone;

/*!
 * @abstract 是否静音远端的声音，设置为 YES 后，本地不会输出远端用户的声音。
 *
 * @discussion 默认为 NO。该值跟房间状态无关，在离开房间后 SDK 并不会重置该值，即会保持您上次设置的值。
 *
 * @since v4.0.0
 */
+ (void)setSpeakerphoneMuted:(BOOL)mute;

/*!
 * @abstract 获取静音远端的声音的状态。
 *
 * @since v4.0.0
 */
+ (BOOL)speakerphoneMuted;

/*!
 * @abstract 动态切换音频场景。
 *
 * @since v5.2.3
 */
+ (void)setAudioScene:(QNAudioScene)audioScene;

@end

#pragma mark - Category (Logging)

/*!
 * @category QNRTC(Logging)
 *
 * @discussion 与日志相关的接口。
 *
 * @since v4.0.0
 */
@interface QNRTC (Logging)

/*!
 * @abstract 开启文件日志
 *
 * @discussion 为了不错过日志，建议在 App 启动时开启，日志文件位于 App Container/Library/Caches/Pili/Logs 目录内
 * 注意：文件日志功能主要用于排查问题，打开文件日志功能会对性能有一定影响，上线前请记得关闭文件日志功能！
 *
 * @since v4.0.0
 */
+ (void)enableFileLogging __deprecated_msg("Method deprecated in v5.2.3. Use `setLogConfig:`");

/*!
 * @abstract 设置日志等级
 *
 * @discussion 设置日志级别 默认：QNRTCLogLevelInfo
 *
 * @since v4.0.0
 */
+ (void)setLogLevel:(QNRTCLogLevel)level __deprecated_msg("Method deprecated in v5.2.3. Use `setLogConfig:`");

/*!
 * @abstract 设置日志文件配置
 *
 * @discussion 设置日志文件配置，包括文件存储路径、日志等级、日志文件的大小等
 *
 * @since v5.2.3
 */
+ (void)setLogConfig:(QNRTCLogConfiguration *)configuration;

/*!
 * @abstract 上传本地文件至七牛服务器
 *
 * @discussion 上传回调结果通过实现 QNUploadLogResultCallback 获取
 *
 * @since v5.2.3
 */
+ (void)uploadLog:(nullable QNUploadLogResultCallback)callback;

/*!
 * @abstract 上传本地文件至指定的七牛云存储空间
 *
 * @discussion token 需要您的业务服务器自行签算
 *
 * @since v5.2.3
 */
+ (void)uploadLog:(NSString *)token callback:(nullable QNUploadLogResultCallback)callback;
@end

#pragma mark - Category (Info)

/*!
 * @category QNRTC(Info)
 *
 * @discussion SDK 相关信息的接口。
 *
 * @since v4.0.0
 */
@interface QNRTC (Info)

/*!
 * @abstract 获取 SDK 的版本信息。
 *
 * @since v4.0.0
 */
+ (NSString *)versionInfo;

@end


NS_ASSUME_NONNULL_END
