//
//  QNCustomAudioTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/7/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNLocalAudioTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNCustomAudioTrack : QNLocalAudioTrack

/*!
 * @abstract 导入音频数据
 *
 * @discussion 仅在调用 - (void)setExternalAudioSourceEnabled:(BOOL)enabled; 并传入 YES 后才有效。
 * 支持的音频数据格式为：PCM 格式，48000 采样率，16 位宽，单声道
 *
 * @since v4.0.0
 */
- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer;

/*!
 * @abstract 导入音频数据
 *
 * @discussion 仅在调用 - (void)setExternalAudioSourceEnabled:(BOOL)enabled; 并传入 YES 后才有效。
 * 支持的音频数据格式为：PCM 格式
 *
 * @since v4.0.0
 */
- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer asbd:(AudioStreamBasicDescription *)asbd;

@end

NS_ASSUME_NONNULL_END
