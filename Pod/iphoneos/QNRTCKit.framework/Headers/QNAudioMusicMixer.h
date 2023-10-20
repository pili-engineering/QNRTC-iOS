//
//  QNAudioMusicMixer.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2022/4/8.
//  Copyright © 2022 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNAudioFilterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class QNAudioMusicMixer;

@protocol QNAudioMusicMixerDelegate <NSObject>

/*!
 * @abstract 背景音乐混音发生错误的回调
 *
 * @param audioMusicMixer 背景音乐混音实例
 *
 * @param error 错误
 *
 * @since v5.1.0
 */
- (void)audioMusicMixer:(QNAudioMusicMixer *)audioMusicMixer didFailWithError:(NSError *)error;

/*!
 * @abstract 背景音乐混音状态变化的回调
 *
 * @param audioMusicMixer 背景音乐混音实例
 *
 * @param musicMixerState 背景音乐混音回调代理
 *
 * @since v5.1.0
 */
- (void)audioMusicMixer:(QNAudioMusicMixer *)audioMusicMixer didStateChanged:(QNAudioMusicMixerState)musicMixerState;

/*!
 * @abstract 背景音乐混音当前进度的回调
 *
 * @param audioMusicMixer 背景音乐混音实例
 *
 * @param currentPosition 当前进度
 *
 * @discussion 需要注意的是这个回调在解码线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题。
 *
 * @since v5.1.0
 */
- (void)audioMusicMixer:(QNAudioMusicMixer *)audioMusicMixer didMixing:(int64_t)currentPosition;

@end


@interface QNAudioMusicMixer : NSObject <QNAudioFilterProtocol>

/*!
 * @abstract 设置是否推送到远端
 *
 * @param publishEnabled 是否推送到远端
 *
 * @since v5.2.0
 */
- (void)setPublishEnabled:(BOOL)publishEnabled;

/*!
 * @abstract 获取背景音乐音乐是否推送到远端
 *
 * @return BOOL 是否推送到远端
 *
 * @since v5.2.0
 */
- (BOOL)isPublishEnabled;

/*!
 * @abstract 获取指定音频文件的总时长
 *
 * @warning 该接口为同步方法，对于在线音频文件，获取时长会存在一定的耗时，需注意调用接口所在的线程
 *
 * @param filePath 文件路径，支持本地路径以及在线文件，音频格式支持 aac、mp3、mp4、wav、m4r、caf、ogg、opus、m4a、flac
 *
 * @return int64_t 总时长，单位 ms
 *
 * @since v5.1.0
 */
+ (int64_t)getDuration:(NSString *)filePath;

/*!
 * @abstract 设置参与混音的音量
 *
 * @param volume 音量，范围 0～1.0
 *
 * @since v5.1.0
 */
- (void)setMixingVolume:(float)volume __deprecated_msg("Method deprecated in v5.2.0. Use `setMusicVolume:`");

/*!
 * @abstract 获取参与混音的音量
 *
 * @return float 音量，范围 0～1.0
 *
 * @since v5.1.0
 */
- (float)getMixingVolume __deprecated_msg("Method deprecated in v5.2.0. Use `getMusicVolume`");

/*!
 * @abstract 设置背景音乐参与混音的音量
 *
 * @param volume 音量，范围 0～1.0
 *
 * @since v5.2.0
 */
- (void)setMusicVolume:(float)volume;

/*!
 * @abstract 获取背景音乐参与混音的音量
 *
 * @return float 音量，范围 0～1.0
 *
 * @since v5.2.0
 */
- (float)getMusicVolume;

/*!
 * @abstract 设置参与混音的起始位置
 *
 * @param position 位置，单位 ms
 *
 * @since v5.1.0
 */
- (void)setStartPosition:(int64_t)position;

/*!
 * @abstract 获取参与混音的起始位置
 *
 * @return int64_t 单位 ms
 *
 * @since v5.1.0
 */
- (int64_t)getStartPosition;

/*!
 * @abstract 获取当前时长
 *
 * @return int64_t 单位 ms
 *
 * @since v5.1.0
 */
- (int64_t)getCurrentPosition;

/*!
 * @abstract 开始混音，默认混一次
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)start;

/*!
 * @abstract 开始混音，可设置循环次数
 *
 * @param loopCount 循环次数，-1 为无限循环，0 为不混音，大于 0 为实际循环次数
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)start:(int)loopCount;

/*!
 * @abstract 停止混音
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)stop;

/*!
 * @abstract 暂停混音
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)pause;

/*!
 * @abstract 恢复混音
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)resume;

/*!
 * @abstract 跳转到指定的位置混音
 *
 * @param position 跳转的位置，单位 ms
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)seekTo:(int64_t)position;

@end

NS_ASSUME_NONNULL_END
