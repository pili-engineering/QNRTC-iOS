//
//  QNAudioEffectMixer.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2022/4/8.
//  Copyright © 2022 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNAudioFilterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNAudioEffect : NSObject

/*!
 * @abstract 获取指定音效文件时长
 *
 * @warning 该接口为同步方法，对于在线音频文件，获取时长会存在一定的耗时，需注意调用接口所在的线程
 *
 * @param filePath 文件路径，支持本地路径以及在线文件，音频格式支持 aac、mp3、mp4、wav、m4r、caf、ogg、opus、m4a、flac
 *
 * @return int64_t 时长，单位 ms
 *
 * @since v5.1.0
 */
+ (int64_t)getDuration:(NSString *)filePath;

/*!
 * @abstract 获取音效唯一标识符
 *
 * @return int
 *
 * @since v5.1.0
 */
- (int)getID;

/*!
 * @abstract 获取音效文件路径
 *
 * @return NSString 文件地址
 *
 * @since v5.1.0
 */
- (NSString *)getFilePath;

/*!
 * @abstract 设置音效参与混音的起始位置
 *
 * @param position 位置，单位 ms
 *
 * @since v5.1.0
 */
- (void)setStartPosition:(int64_t)position;

/*!
 * @abstract 获取音效参与混音的起始位置
 *
 * @return int64_t 单位 ms
 *
 * @since v5.1.0
 */
- (int64_t)getStartPosition;

/*!
 * @abstract 设置音效混音循环次数
 *
 * @param loopCount 循环次数，-1 为无限循环，0 为不混音，大于 0 为实际循环次数
 *
 * @since v5.1.0
 */
- (void)setLoopCount:(int)loopCount;

/*!
 * @abstract 获取音效混音循环次数
 *
 * @return int 循环次数，-1 为无限循环，0 为不混音，大于 0 为实际循环次数
 *
 * @since v5.1.0
 */
- (int)getLoopCount;
@end

@class QNAudioEffectMixer;

@protocol QNAudioEffectMixerDelegate <NSObject>

/*!
 * @abstract 音效混音发生错误的回调
 *
 * @param audioEffectMixer 音效混音实例
 *
 * @param error 错误
 *
 * @since v5.1.0
 */
- (void)audioEffectMixer:(QNAudioEffectMixer *)audioEffectMixer didFailWithError:(NSError *)error __deprecated_msg("Method deprecated in v5.2.4. Use `- (void)audioEffect:(QNAudioEffect *)audioEffect didFailed:(int)effectID error:(NSError *)error`");

/*!
 * @abstract 某音效混音发生错误的回调
 *
 * @param audioEffect 音效实例
 *
 * @param effectID 音效唯一标识符
 *
 * @param error 错误
 *
 * @since v5.2.4
 */
- (void)audioEffect:(QNAudioEffect *)audioEffect didFailed:(int)effectID error:(NSError *)error;

/*!
 * @abstract 音效混音某音效播放完成的回调
 *
 * @param audioEffect 音效实例
 *
 * @param effectID 音效唯一标识符
 *
 * @since v5.2.4
 */
- (void)audioEffect:(QNAudioEffect *)audioEffect didFinished:(int)effectID;
@end

@interface QNAudioEffectMixer : NSObject <QNAudioFilterProtocol>

/*!
 * @abstract 创建音效类
 *
 * @warning 创建已存在的音效唯一标识符，需要先调用 destroyAudioEffectWithEffectID，否则将会返回 nil
 *
 * @param effectID 音效唯一标识符，务必保证唯一
 *
 * @param filePath 文件路径，支持本地路径以及在线文件，音频格式支持 aac、mp3、mp4、wav、m4r、caf、ogg、opus、m4a、flac
 *
 * @return QNAudioEffect 实例
 *
 * @since v5.1.0
 */
- (QNAudioEffect *)createAudioEffectWithEffectID:(int)effectID filePath:(NSString *)filePath;

/*!
 * @abstract 销毁音效类
 *
 * @param effectID 音效唯一标识符，务必保证唯一
 *
 * @since v5.2.0
 */
- (void)destroyAudioEffectWithEffectID:(int)effectID;

/*!
 * @abstract 设置某音效是否推送到远端
 *
 * @param publishEnabled 是否推送到远端
 *
 * @param effectID 音效唯一标识符
 *
 * @since v5.2.0
 */
- (void)setPublishEnabled:(BOOL)publishEnabled effectID:(int)effectID;

/*!
 * @abstract 获取某音效是否推送到远端
 *
 * @param effectID 音效唯一标识符
 *
 * @return BOOL 是否推送到远端
 *
 * @since v5.2.0
 */
- (BOOL)isPublishEnabled:(int)effectID;

/*!
 * @abstract 开始混音某音效
 *
 * @param effectID 音效唯一标识符
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)start:(int)effectID;

/*!
 * @abstract 停止混音某音效
 *
 * @param effectID 音效唯一标识符
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)stop:(int)effectID;

/*!
 * @abstract 暂停混音某音效
 *
 * @param effectID 音效唯一标识符
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)pause:(int)effectID;

/*!
 * @abstract 恢复混音某音效
 *
 * @param effectID 音效唯一标识符
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)resume:(int)effectID;

/*!
 * @abstract 获取某音效当前位置
 *
 * @param effectID 音效唯一标识符
 *
 * @return int64_t 单位 ms
 *
 * @since v5.1.0
 */
- (int64_t)getCurrentPosition:(int)effectID;

/*!
 * @abstract 设置某音效音量
 *
 * @warning setEffectID 已废弃，应调用 setVolume
 *
 * @param effectID 音效唯一标识符
 *
 * @param volume 音量
 *
 * @since v5.1.0
 */
- (void)setEffectID:(int)effectID volume:(float)volume __deprecated_msg("Method deprecated in v5.2.0. Use `setVolume:`");

/*!
 * @abstract 设置某音效音量
 *
 * @param volume 音量
 *
 * @param effectID 音效唯一标识符
 *
 * @since v5.2.0
 */
- (void)setVolume:(float)volume effectID:(int)effectID;

/*!
 * @abstract 获取某音效音量
 *
 * @param effectID 音效唯一标识符
 *
 * @return float 范围 0～1.0
 *
 * @since v5.1.0
 */
- (float)getVolume:(int)effectID;

/*!
 * @abstract 设置所有音效的音量
 *
 * @param volume 音量，范围 0～1.0
 *
 * @since v5.1.0
 */
- (void)setAllEffectsVolume:(float)volume;

/*!
 * @abstract 停止混音所有音效
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)stopAll;

/*!
 * @abstract 暂停混音所有音效
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)pauseAll;

/*!
 * @abstract 恢复混音所有音效
 *
 * @return BOOL 是否成功
 *
 * @since v5.1.0
 */
- (BOOL)resumeAll;
@end

NS_ASSUME_NONNULL_END
