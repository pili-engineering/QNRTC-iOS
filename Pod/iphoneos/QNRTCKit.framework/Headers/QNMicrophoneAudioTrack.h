//
//  QNMicrophoneAudioTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/7/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNLocalAudioTrack.h"
#import "QNAudioMixer.h"

NS_ASSUME_NONNULL_BEGIN

@class QNMicrophoneAudioTrack;
@protocol QNMicrophoneAudioTrackDataDelegate <NSObject>

@optional
/*!
 * @abstract 音频 Track 数据回调。
 *
 * @since v4.0.0
 */
- (void)microphoneAudioTrack:(QNMicrophoneAudioTrack *)microphoneAudioTrack didGetAudioBuffer:(AudioBuffer *)audioBuffer bitsPerSample:(NSUInteger)bitsPerSample sampleRate:(NSUInteger)sampleRate;

@end

@interface QNMicrophoneAudioTrack : QNLocalAudioTrack
/*!
 * @abstract 音频 Track 回调代理。
 *
 * @since v4.0.0
 */
@property (nonatomic, weak) id<QNMicrophoneAudioTrackDataDelegate> audioDelegate;

/*!
 * @abstract 连麦房间中的音频管理类实例。
 *
 * @warning 务必保证已创建 QNMicrophoneAudioTrack，再使用 QNAudioMixer
 *          该值为 QNAudioMixer 的属性，使用方式如下：
 *          self.audioTrack.audioMixer.audioURL = [NSURL URLWithString:@"http://www.xxx.com/test.mp3"];
 *          self.audioTrack.audioMixer.delegate = self;
 *
 * @discussion 需要配置 audioURL 传入音频地址，调用 start 开始混音，调用 stop 停止混音。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong, readonly) QNAudioMixer *audioMixer;

/*!
 * @abstract 麦克风输入音量
 *
 * @discussion 设置范围为 0~10，默认为 1
 *
 * @warning 当麦克风输入音量增益调大之后，部分机型会出现噪音
 *
 * @since v4.0.0
 */
- (void)setVolume:(float)volume;

@end

NS_ASSUME_NONNULL_END
