//
//  QNLocalVideoTrackStats.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/8/24.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNLocalVideoTrackStats : NSObject

/*!
 * @abstract 该路 track 的 profile。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) QNTrackProfile profile;

/*!
 * @abstract 上行视频帧率。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger uplinkFrameRate;

/*!
 * @abstract 上行视频码率。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double uplinkBitrate;

/*!
 * @abstract 上行网络 rtt。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger uplinkRTT;

/*!
 * @abstract 上行网络丢包率。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double uplinkLostRate;

@end

NS_ASSUME_NONNULL_END
