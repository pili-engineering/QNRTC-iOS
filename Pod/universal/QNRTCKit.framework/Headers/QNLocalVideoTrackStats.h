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
 * @abstract 本地视频 Track 的 profile。
 *
 * @discussion 表示当前应用正在上传的视频轨道的 profile
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) QNTrackProfile profile;

/*!
 * @abstract 本地视频上行帧率。
 *
 * @discussion 表示本地用户上传自身视频数据时的帧率
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger uplinkFrameRate;

/*!
 * @abstract 本地视频上行码率，单位 bps。
 *
 * @discussion 表示本地用户上传自身视频数据时的码率
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double uplinkBitrate;

/*!
 * @abstract 本地视频上行网络延迟，单位 ms。
 *
 * @discussion 表示本地用户上传自身视频数据时的网络延时
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger uplinkRTT;

/*!
 * @abstract 本地视频上行网络丢包率，百分比 [0, 100]。
 *
 * @discussion 表示本地用户上传自身音频数据时的丢包率
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double uplinkLostRate;

@end

NS_ASSUME_NONNULL_END
