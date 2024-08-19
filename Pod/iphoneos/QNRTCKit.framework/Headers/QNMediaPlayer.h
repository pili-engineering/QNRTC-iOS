//
//  QNMediaPlayer.h
//  QNRTCKit
//
//  Created by ShengQiang'Liu on 2024/6/6.
//  Copyright © 2024 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNVideoGLView.h"
#import "QNTrack.h"
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class QNMediaPlayer;
/**
 事件信息
 */
@interface QNPlayerEventInfo : NSObject
/*!
 * @abstract 说明信息
 *
 * @since v6.4.0
 */
@property (nonatomic, strong) NSString *message;
/*!
 * @abstract 错误码
 *
 * @since v6.4.0
 */
@property (nonatomic, assign) int errorCode;
@end

@protocol QNMediaPlayerDelegate <NSObject>
/**
 * 状态发生变化的回调
 *
 * @param state 播放状态
 * @see QNPlayerState
 *
 * @since v6.4.0
 */
- (void)mediaPlayer:(QNMediaPlayer *)player didPlayerStateChanged:(QNPlayerState)state;
/** 事件变化的回调
 *
 * @param event 播放事件
 * @see QNPlayerEvent
 * @param info 事件携带的信息
 * @see QNPlayerEventInfo
 *
 * @since v6.4.0
 */
- (void)mediaPlayer:(QNMediaPlayer *)player didPlayerEvent:(QNPlayerEvent)event eventInfo:(QNPlayerEventInfo *)info;
/**
 * 播放进度变化的回调
 *
 * @param position 播放进度，回调频率 1s 一次，单位(ms)
 *
 * @since v6.4.0
 */
- (void)mediaPlayer:(QNMediaPlayer *)player didPlayerPositionChanged:(NSUInteger)position;

@end

@interface QNMediaSource : NSObject
/*!
 * @abstract 设置视频播放地址
 *
 * @since v6.4.0
 */
@property (nonatomic, strong) NSString *url;
@end

@interface QNMediaPlayer : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 * 设置监听回调
 */
@property (nonatomic, weak) id<QNMediaPlayerDelegate> delegate;
/**
 * 开始播放
 *
 * @param source QNMediaSource 参数配置
 * @see QNMediaSource
 *
 * @since v6.4.0
 */
- (int)play:(QNMediaSource *)source;
/**
 * 暂停播放
 *
 * @since v6.4.0
 */
- (int)pause;
/**
 * 停止播放
 *
 * @since v6.4.0
 */
- (int)stop;
/**
 * 恢复播放
 *
 * @since v6.4.0
 */
- (int)resume;
/**
 * seek 到某一点播放
 * @param positionMs seek 位置，单位(ms)
 *
 * @since v6.4.0
 */
- (int)seek:(NSUInteger)positionMs;
/**
 * 获取点播文件总时长，直播流获取返回 0。单位(ms)
 *
 * @since v6.4.0
 */
- (int)getDuration;
/**
 * 获取播放进度
 *
 * @since v6.4.0
 */
- (int)getCurrentPosition;
/**
 * 设置循环播放次数
 * @param loopCount 循环次数，默认值为 1，设置 -1，表示一直循环
 *
 * @since v6.4.0
 */
- (int)setLoopCount:(NSInteger)loopCount;
/**
 * 获取播放状态
 *
 * @since v6.4.0
 */
- (QNPlayerState)getCurrentPlayerState;
/*!
 * @abstract 视频渲染
 *
 * @discussion videoView 会被内部引用，外部销毁时需主动传 nil
 *
 * @since v6.4.0
 */
- (void)setView:(QNVideoGLView *)videoView;
/**
 * 获取需要发布到房间内的 VideoTrack，外部拿到 VideoTrack 之后，由调用方通过调用 destroy 进行释放。
 *
 * @since v6.4.0
 */
- (QNCustomVideoTrack *)getMediaPlayerVideoTrack;
/**
 * 获取需要发布到房间内的 AudioTrack，外部拿到 AudioTrack 之后，由调用方通过调用 destroy 进行释放。
 *
 * @since v6.4.0
 */
- (QNCustomAudioTrack *)getMediaPlayerAudioTrack;

@end

NS_ASSUME_NONNULL_END
