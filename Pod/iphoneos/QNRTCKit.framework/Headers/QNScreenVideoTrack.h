//
//  QNScreenVideoTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/7/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNLocalVideoTrack.h"

NS_ASSUME_NONNULL_BEGIN

@class QNScreenVideoTrack;
@protocol QNScreenVideoTrackDelegate <NSObject>

@optional

/*!
 * @abstract 录屏运行过程中发生错误会通过该方法回调。
 *
 * @since v4.0.0
 */
- (void)screenVideoTrack:(QNScreenVideoTrack *)screenVideoTrack didFailWithError:(NSError *)error;

@end

@interface QNScreenVideoTrack : QNLocalVideoTrack

/*!
 * @abstract 判断屏幕录制功能是否可用
 *
 * @discussion 屏幕录制功能仅在 iOS 11 及以上版本可用
 *
 * @since v4.0.0
 */
+ (BOOL)isScreenRecorderAvailable;

/*!
 * @abstract 录屏 Track 回调代理。
 *
 * @since v4.0.0
 */
@property (nonatomic, weak) id<QNScreenVideoTrackDelegate> screenDelegate;

/*!
 * @abstract 屏幕录制的帧率，默认值为 20，可设置 [10, 60] 之间的值，超出范围则不变更
 *
 * @discussion 该值仅为期望值，受 ReplayKit 的限制，在特定情况（比如画面保持不动）下，ReplayKit 可能隔几秒才会回调一帧数据。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) NSUInteger screenRecorderFrameRate;

@end

NS_ASSUME_NONNULL_END
