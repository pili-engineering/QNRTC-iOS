//
//  QNLocalAudioTrackStats.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/8/24.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNLocalAudioTrackStats : NSObject

/*!
 * @abstract 上行音频码率。
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
