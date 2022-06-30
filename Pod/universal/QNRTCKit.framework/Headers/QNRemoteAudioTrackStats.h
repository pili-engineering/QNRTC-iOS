//
//  QNRemoteAudioTrackStats.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/8/24.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNRemoteAudioTrackStats : NSObject

/*!
 * @abstract 远端音频下行码率，单位 bps。
 *
 * @discussion 当前应用下载对应轨道时的码率，和远端用户上行无关
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double downlinkBitrate;

/*!
 * @abstract 远端音频下行网络丢包率，百分比 [0, 100]。
 *
 * @discussion 当前应用下载对应轨道时的网络丢包率，和远端用户上行无关
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double downlinkLostRate;

/*!
 * @abstract 远端音频上行网络延迟，单位 ms。
 *
 * @discussion 表示远端用户上传自身音频数据时的网络延时
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger uplinkRTT;

/*!
 * @abstract 远端音频上行网络丢包率，百分比 [0, 100]。
 *
 * @discussion 表示远端用户上传自身音频数据时的网络丢包率
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double uplinkLostRate;

@end

NS_ASSUME_NONNULL_END
