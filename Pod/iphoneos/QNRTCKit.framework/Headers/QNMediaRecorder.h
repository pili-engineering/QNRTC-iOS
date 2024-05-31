//
//  QNMediaRecorder.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2024/4/3.
//  Copyright © 2024 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNMediaRecordInfo.h"
#import "QNMediaRecorderConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class QNMediaRecorder;

@protocol QNMediaRecorderDelegate <NSObject>
 
/*!
 * @abstract 录制信息更新回调
 *
 * @param recorder 音视频录制实例
 *
 * @param info 音视频录制完成的信息
 *
 * @since v6.2.0
 */
- (void)mediaRecorder:(QNMediaRecorder* _Nonnull)recorder infoDidUpdated:(QNMediaRecordInfo* _Nonnull)info;
  
/*!
 * @abstract 录制状态发生变化回调
 *
 * @warning 出现错误状态时，会自动停止录制并回调错误信息
 *
 * @param recorder 音视频录制实例
 *
 * @param state 录制状态
 *
 * @param reason 录制错误信息
 *
 * @since v6.2.0
 */
- (void)mediaRecorder:(QNMediaRecorder* _Nonnull)recorder stateDidChanged:(QNMediaRecorderState)state reason:(QNMediaRecorderReasonCode)reason;

@end

@interface QNMediaRecorder : NSObject

- (instancetype)init NS_UNAVAILABLE;
 
/*!
 * @abstract 录制信息回调代理
 *
 * @since v6.2.0
 */
@property (nonatomic, weak) id<QNMediaRecorderDelegate> delegate;
 
/*!
 * @abstract 开始音视频录制
 *
 * @return 返回 0 成功，其他失败
 *
 * @since v6.2.0
 */
- (int)startRecording:(QNMediaRecorderConfig *)configuration;
 
/*!
 * @abstract 停止音视频录制
 *
 * @return 返回 0 成功，其他失败
 *
 * @since v6.2.0
 */
- (int)stopRecording;
@end

NS_ASSUME_NONNULL_END
