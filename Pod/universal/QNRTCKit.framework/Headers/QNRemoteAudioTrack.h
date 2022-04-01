//
//  QNRemoteAudioTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/7/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNRemoteTrack.h"

NS_ASSUME_NONNULL_BEGIN
@class QNRemoteAudioTrack;
@protocol QNRemoteTrackAudioDataDelegate <NSObject>

@optional
/*!
 * @abstract 音频 Track 数据回调。
 *
 * @since v4.0.0
 */
- (void)remoteAudioTrack:(QNRemoteAudioTrack *)remoteAudioTrack didGetAudioBuffer:(AudioBuffer *)audioBuffer bitsPerSample:(NSUInteger)bitsPerSample sampleRate:(NSUInteger)sampleRate;

@end

@interface QNRemoteAudioTrack : QNRemoteTrack

/*!
 * @abstract 音频 Track 回调代理。
 *
 * @since v4.0.0
 */
@property (nonatomic, weak) id<QNRemoteTrackAudioDataDelegate> audioDelegate;

/*!
 * @abstract 设置远端音频 Track 播放音量。范围从 0 ~ 10，10 为最大
 *
 * @discussion 需要发布成功后才可以执行 setRemote 操作。本次操作仅对远端音频播放音量做调整，远端音量回调为远端音频数据的原始音量，不会基于本设置做相应调整。
 *
 * @warning 部分机型调整音量放大会出现低频噪音
 *
 * @since  v4.0.0
 */
- (void)setVolume:(float)volume;

/*!
 * @abstract 获取远端音频 Track 播放音量。范围从 0 ~ 1，1 为最大
 *
 * @since  v4.0.2
 */
- (float)getVolumeLevel;

@end

NS_ASSUME_NONNULL_END
