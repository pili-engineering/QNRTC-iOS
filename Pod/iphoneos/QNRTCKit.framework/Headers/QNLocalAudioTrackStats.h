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
 * @abstract 本地音频上行码率，单位 bps。
 *
 * @discussion 表示本地用户上传自身音频数据时的码率
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double uplinkBitrate;

/*!
 * @abstract 本地音频上行网络延迟，单位 ms。
 *
 * @discussion 表示本地用户上传自身音频数据时的网络延迟
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger uplinkRTT;

/*!
 * @abstract 本地音频上行网络丢包率，百分比 [0, 100]。
 *
 * @discussion 表示本地用户上传自身音频数据时的网络丢包率
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) double uplinkLostRate;

@end

NS_ASSUME_NONNULL_END
