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
 * @abstract 远端视频 Track 的 profile。
 *
 * @discussion 表示当前应用正在接收的视频轨道的 profile
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) QNTrackProfile profile;

/*!
 * @abstract 远端视频下行帧率。
 *
 * @discussion 当前应用正在下载的轨道的帧率
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger downlinkFrameRate;

/*!
 * @abstract 远端视频下行码率，单位 kbps。
 *
 * @discussion 当前应用下载对应轨道时的码率，和远端用户上行无关
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double downlinkBitrate;

/*!
 * @abstract 远端视频下行网络丢包率，百分比 [0, 100]。
 *
 * @discussion 当前应用下载对应轨道时的网络丢包率，和远端用户上行无关
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double downlinkLostRate;

/*!
 * @abstract 远端视频上行网络延时，单位 ms。
 *
 * @discussion 表示远端用户上传自身视频数据时的网络延时
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger uplinkRTT;

/*!
 * @abstract 远端视频上行网络丢包率，百分比 [0, 100]。
 *
 * @discussion 表示远端用户上传自身音频数据时的丢包率
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double uplinkLostRate;

/*!
 * @abstract 远端视频上行视频帧宽度
 *
 * @discussion 远端用户编码输出的视频宽度
 *
 * @since v5.2.4
 */
@property (nonatomic, assign, readonly) NSUInteger uplinkFrameWidth;

/*!
 * @abstract 远端视频上行视频帧高度
 *
 * @discussion 远端用户编码输出的视频高度
 *
 * @since v5.2.4
 */
@property (nonatomic, assign, readonly) NSUInteger uplinkFrameHeight;

@end

NS_ASSUME_NONNULL_END
