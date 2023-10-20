//
//  QNAudioSourceMixer.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2022/8/23.
//  Copyright © 2022 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNAudioFilterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNAudioSource : NSObject

/*!
 * @abstract 获取音源唯一标识符
 *
 * @return int
 *
 * @since v5.2.0
 */
- (int)getID;

@end

@class QNAudioSourceMixer;

@protocol QNAudioSourceMixerDelegate <NSObject>

/*!
 * @abstract 音源混音发生错误的回调
 *
 * @param audioSourceMixer 音源混音实例
 *
 * @param error 错误
 *
 * @since v5.2.0
 */
- (void)audioSourceMixer:(QNAudioSourceMixer *)audioSourceMixer didFailWithError:(NSError *)error;

@end

@interface QNAudioSourceMixer : NSObject <QNAudioFilterProtocol>

/*!
 * @abstract 创建音源类，默认关闭阻塞模式
 *
 * @warning 创建已存在的音源唯一标识符，需要先调用 destroyAudioSourceWithSourceID，否则将会返回 nil
 *          默认小端、非阻塞模式
 *
 * @param sourceID 音源唯一标识符，务必保证唯一
 *
 * @return QNAudioSource 实例
 *
 * @since v5.2.0
 */
- (QNAudioSource *)createAudioSourceWithSourceID:(int)sourceID;

/*!
 * @abstract 创建音源类
 *
 * @warning 创建已存在的音源唯一标识符，需要先调用 destroyAudioSourceWithSourceID，否则将会返回 nil
 *          默认小端
 *
 * @param sourceID 音源唯一标识符，务必保证唯一
 *
 * @param blockingMode 是否使用阻塞模式进行音源混音，设置为 YES 则外部数据可以持续送入 SDK，当 SDK 缓存的待混音数据过多时，会阻塞 push 接口，直到缓存数据被 SDK 混音消费使用；设置为 NO 则外部数据需要按每次送入音频数据的时长间隔依此送入，也可以使用播放器解码后的回调数据来送入 SDK，此时需要注意的是如果送入过快，SDK 将会丢弃多余的数据
 *
 * @return QNAudioSource 实例
 *
 * @since v5.2.0
 */
- (QNAudioSource *)createAudioSourceWithSourceID:(int)sourceID blockingMode:(BOOL)blockingMode;

/*!
 * @abstract 创建音源类
 *
 * @warning 创建已存在的音源唯一标识符，需要先调用 destroyAudioSourceWithSourceID，否则将会返回 nil
 *
 * @param sourceID 音源唯一标识符，务必保证唯一
 *
 * @param bigEndian 是否是大端，默认为 NO，务必与导入音频数据的 asbd 大小端配置一致
 *
 * @param blockingMode 是否使用阻塞模式进行音源混音，设置为 YES 则外部数据可以持续送入 SDK，当 SDK 缓存的待混音数据过多时，会阻塞 push 接口，直到缓存数据被 SDK 混音消费使用；设置为 NO 则外部数据需要按每次送入音频数据的时长间隔依此送入，也可以使用播放器解码后的回调数据来送入 SDK，此时需要注意的是如果送入过快，SDK 将会丢弃多余的数据
 *
 * @return QNAudioSource 实例
 *
 * @since v5.2.1
 */
- (QNAudioSource *)createAudioSourceWithSourceID:(int)sourceID bigEndian:(BOOL)bigEndian blockingMode:(BOOL)blockingMode;

/*!
 * @abstract 销毁音源类
 *
 * @param sourceID 音源唯一标识符，务必保证唯一
 *
 * @since v5.2.0
 */
- (void)destroyAudioSourceWithSourceID:(int)sourceID;

/*!
 * @abstract 设置某音源是否推送到远端
 *
 * @param publishEnabled 是否推送到远端
 *
 * @param sourceID 音源唯一标识符
 *
 * @since v5.2.0
 */
- (void)setPublishEnabled:(BOOL)publishEnabled sourceID:(int)sourceID;

/*!
 * @abstract 获取某音源是否推送到远端
 *
 * @param sourceID 音源唯一标识符
 *
 * @return BOOL
 *
 * @since v5.2.0
 */
- (BOOL)isPublishEnabled:(int)sourceID;

/*!
 * @abstract 设置某音源音量
 *
 * @param volume 音量
 *
 * @param sourceID 音源唯一标识符
 *
 * @since v5.2.0
 */
- (void)setVolume:(float)volume sourceID:(int)sourceID;

/*!
 * @abstract 获取某音源音量
 *
 * @param sourceID 音源唯一标识符
 *
 * @return float 范围 0～1.0
 *
 * @since v5.2.0
 */
- (float)getVolume:(int)sourceID;

/*!
 * @abstract 设置所有音源的音量
 *
 * @param volume 音量，范围 0～1.0
 *
 * @since v5.2.0
 */
- (void)setAllSourcesVolume:(float)volume;

/*!
 * @abstract 导入音频数据
 *
 * @discussion 支持的音频数据格式为：PCM 格式
 *
 * @warning 音频数据的格式信息，请务必对应实际数据信息传入
 *
 * @param audioBuffer 实际音频数据
 *
 * @param asbd PCM 音频数据的具体音频信息，包括采样率、声道数、位宽等
 *
 * @param sourceID 音源唯一标识符
 *
 * @since v5.2.0
 */
- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer asbd:(AudioStreamBasicDescription *)asbd sourceID:(int)sourceID;
@end

NS_ASSUME_NONNULL_END
