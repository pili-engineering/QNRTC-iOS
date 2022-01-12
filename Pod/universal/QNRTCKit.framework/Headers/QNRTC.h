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
#import "QNRTCClient.h"
#import "QNMicrophoneAudioTrackConfig.h"
#import "QNCustomAudioTrackConfig.h"
#import "QNCameraVideoTrackConfig.h"
#import "QNScreenVideoTrackConfig.h"
#import "QNCustomVideoTrackConfig.h"

@class QNRTC;
@class QNRTCConfiguration;
@class QNClientConfig;
@class QNMicrophoneAudioTrack;
@class QNCameraVideoTrack;
@class QNCustomAudioTrack;
@class QNScreenVideoTrack;
@class QNCustomVideoTrack;

NS_ASSUME_NONNULL_BEGIN

@protocol QNRTCDelegate <NSObject>

@optional

/*!
 * @abstract 音频输出设备变更的回调。主动调用的 `+ (void)setAudioRouteToSpeakerphone:(BOOL)audioRouteToSpeakerphone;` 不会有该回调。
 *
 * @since v4.0.0
 */
- (void)QNRTCDidChangeRTCAudioOutputToDevice:(QNAudioDeviceType)deviceType;

@end

@interface QNRTC : NSObject

/*!
 * @abstract 用 configuration 配置 QNRTC。
 *
 * @param configuration QNRTC 的配置。
 *
 * @since v4.0.0
 */
+ (void)configRTC:(QNRTCConfiguration *)configuration;

/*!
 * @abstract 取消初始化 QNRTC。
 *
 * @since v4.0.0
 */
+ (void)deinit;

/*!
 * @abstract 创建 QNRTCClient。
 *
 * @since v4.0.0
 */
+ (QNRTCClient *)createRTCClient;

/*!
 * @abstract 用 config 创建 QNRTCClient。
 *
 * @since v4.0.1
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
 * @abstract 创建一路以屏幕录制采集为数据源的视频 track，默认码率为 600 kbps
 *
 * @since v4.0.0
 */
+ (QNScreenVideoTrack *)createScreenVideoTrack;

/*!
 * @abstract 创建一路以屏幕录制采集为数据源的视频 track。
 *
 * @param configuration 用于初始化屏幕录制采集的视频 track 的配置。
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
 * @since v4.0.0
 */
+ (void)setAudioRouteDelegate:(id <QNRTCDelegate>)delegate;

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
 * @discussion 为了不错过日志，建议在 App 启动时即开启，日志文件位于 App Container/Library/Caches/Pili/Logs 目录下以 QNRTC+当前时间命名的目录内
 * 注意：文件日志功能主要用于排查问题，打开文件日志功能会对性能有一定影响，上线前请记得关闭文件日志功能！
 *
 * @since v4.0.0
*/
+ (void)enableFileLogging;

/*!
 * @abstract 设置日志等级
 *
 * @discussion 设置日志级别 默认：QNRTCLogLevelInfo
 *
 * @since v4.0.0
*/
+ (void)setLogLevel:(QNRTCLogLevel)level;

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
