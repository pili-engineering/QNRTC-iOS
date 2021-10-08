//
//  QNRemoteVideoTrackStats.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/8/24.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNRemoteVideoTrackStats : NSObject

/*!
 * @abstract 该路 track 的 profile。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) QNTrackProfile profile;

/*!
 * @abstract 下行视频帧率（即自己拉取的视频的帧率）。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger downlinkFrameRate;

/*!
 * @abstract 下行视频码率。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double downlinkBitrate;

/*!
 * @abstract 下行网络丢包率。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double downlinkLostRate;

/*!
 * @abstract 上行网络 rtt （即远端用户发布视频的网络链路的 rtt）。
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
