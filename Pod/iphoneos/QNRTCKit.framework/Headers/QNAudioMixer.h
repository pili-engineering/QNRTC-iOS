//
//  QNAudioMixer.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2019/3/6.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class QNAudioMixer;
@protocol QNAudioMixerDelegate <NSObject>

@required
/*!
 * @abstract QNAudioMixer 在运行过程中，发生错误的回调
 *
 * @param audioMixer QNAudioMixer
 * @param error 错误
 *
 * @since v4.0.0
 */
- (void)audioMixer:(QNAudioMixer *)audioMixer didFailWithError:(NSError *)error;

/*!
 * @abstract QNAudioMixer 在运行过程中，音频状态发生变化的回调
 *
 * @param audioMixer QNAudioMixer
 * @param playState 播放状态
 *
 * @since v4.0.0
 */
- (void)audioMixer:(QNAudioMixer *)audioMixer playStateDidChange:(QNAudioPlayState)playState;

/*!
 * @abstract QNAudioMixer 在运行过程中，混音进度的回调
 *
 * @discussion 混音进度不被 loopTimes 影响，跟当前时间 currentTime 节奏一致。
 *
 * @param audioMixer QNAudioMixer
 * @param currentTime 当前时间
 *
 * @since v4.0.0
 */
- (void)audioMixer:(QNAudioMixer *)audioMixer didMixing:(NSTimeInterval)currentTime;

@optional
/*!
 * @abstract QNAudioMixer 在运行过程中，麦克风音频数据的回调
 *
 * @warning 当 playState 为 QNAudioPlayStatePlaying 时，该回调有数据；否则，无数据。
 *
 * @param audioMixer QNAudioMixer
 * @param audioBuffer 音频数据
 * @param asbd 音频数据的格式参数
 *
 * @since v4.0.0
 */
- (void)audioMixer:(QNAudioMixer *)audioMixer microphoneSourceDidGetAudioBuffer:(AudioBuffer *)audioBuffer asbd:(const AudioStreamBasicDescription *)asbd;

/*!
 * @abstract QNAudioMixer 在运行过程中，音乐音频数据的回调
 *
 * @warning 当 playState 为 QNAudioPlayStatePlaying 时，该回调有数据；否则，无数据。
 *
 * @param audioMixer QNAudioMixer
 * @param audioBuffer 音频数据
 * @param asbd 音频数据的格式参数
 *
 * @since v4.0.0
 */
- (void)audioMixer:(QNAudioMixer *)audioMixer musicSourceDidGetAudioBuffer:(AudioBuffer *)audioBuffer asbd:(const AudioStreamBasicDescription *)asbd;

/*!
 * @abstract QNAudioMixer 在运行过程中，混音数据的回调
 *
 * @warning 当 playState 为 QNAudioPlayStatePlaying 时，该回调有数据；否则，无数据。
 *
 * @param audioMixer QNAudioMixer
 * @param audioBuffer 音频数据
 * @param asbd 音频数据的格式参数
 *
 * @since v4.0.0
 */
- (void)audioMixer:(QNAudioMixer *)audioMixer mixedSourceDidGetAudioBuffer:(AudioBuffer *)audioBuffer asbd:(const AudioStreamBasicDescription *)asbd;

@end

@interface QNAudioMixer : NSObject

/*!
 * @abstract 音频播放的状态
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) QNAudioPlayState playState;

/*!
 * @abstract 回调的 delegate。
 *
 * @since v4.0.0
 */
@property (nonatomic, weak) id<QNAudioMixerDelegate> delegate;

/*!
 * @abstract 音频地址。
 *
 * @discussion 音频地址支持本地音频或 mp3 格式的在线音频
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) NSURL *audioURL;

/*!
 * @abstract 音频是否正在播放。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) BOOL isPlaying;

/*!
 * @abstract 是否开启返听，默认为 NO。
 *
 * @warning 耳返功能建议在用户戴耳机的状态下开启，当用户未戴耳机时，耳返将从设备听筒播放；
 *          混音过程中，当返听从关闭切换到开启时，音乐声音相对会变小，这是由于系统对于人声+音乐声同时输出播放的优化，避免两个输出源音频波形叠加过高，可能带来的刺耳声。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) BOOL playBack;

/*!
 * @abstract 麦克风混音音量的大小。
 *
 * @discussion 取值范围 0 ～ 1.0。注意：当设置麦克风输入音量为 0 时， 则麦克风静音。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) float microphoneInputVolume;

/*!
 * @abstract 音乐音频混音音量的大小。
 *
 * @discussion 取值范围 0 ～ 1.0。注意：当设置音乐音频输入音量为 0 时，则音乐静音。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) float musicInputVolume;

/*!
 * @abstract 音乐音频播放音量大小。
 *
 * @discussion 取值范围 0 ～ 1.0。注意：当设置音乐音频输入音量为 0 时，则音乐播放静音。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) float musicOutputVolume;

/*!
 * @abstract 播放的当前时间。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

/*!
 * @abstract 音频总时长。
 *
 * @discussion 音频未开始播放前，当 playState 为 QNAudioPlayStateReady 时，totalTime 有值。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSTimeInterval duration;

/*!
 * @abstract 混合进度回调的时间间隔。
 *
 * @discussion 单位为秒。默认为 0，即默认不回调混合进度。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) float rateInterval;

/*!
 * @abstract 定位到指定播放的时间点。
 *
 * @param time seek 的时间位置。
 *
 * @return 是否 seek 成功
 *
 * @since v4.0.0
 */
- (BOOL)seekTo:(CMTime)time;

/*!
 * @abstract 开始混音
 *
 * @return 是否 start 成功
 *
 * @since v4.0.0
 */
- (BOOL)start;

/*!
 * @abstract 开始混音
 *
 * @discussion 循环播放音频，>= 0 播放次数。例如，0 表示不播放；1 表示播放 1 次。 -1 则代表无限循环。
 *
 * @return 是否 start 成功
 *
 * @since v4.0.0
 */
- (BOOL)start:(NSInteger)loopTimes;

/*!
 * @abstract 停止混音
 *
 * @return 是否 stop 成功
 *
 * @since v4.0.0
 */
- (BOOL)stop;

/*!
 * @abstract 暂停混音
 *
 * @since v4.0.0
 */
- (void)pause;

/*!
 * @abstract 恢复混音
 *
 * @since v4.0.0
 */
- (void)resume;

@end

NS_ASSUME_NONNULL_END
