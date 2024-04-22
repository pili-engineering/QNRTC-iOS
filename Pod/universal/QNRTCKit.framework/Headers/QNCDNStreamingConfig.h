//
//  QNCDNStreamingConfig.h
//  QNRTCKit
//
//  Created by ShengQiang'Liu on 2023/11/6.
//  Copyright © 2023 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNCDNStreamingConfig : NSObject
/*!
 * @abstract 推流地址。
 *
 * @since v6.0.0
 */
@property (nonatomic, copy) NSString *publishUrl;
/*!
 * @abstract 推流需要的音频轨道。
 *
 * @since v6.0.0
 */
@property (nonatomic, strong) QNLocalAudioTrack *audioTrack;
/*!
 * @abstract 推流需要的视频轨道。
 *
 * @since v6.0.0
 */
@property (nonatomic, strong) QNLocalVideoTrack *videoTrack;
/*!
 * @abstract 是否打开 quic，默认关闭。
 *
 * @since v6.0.0
 */
@property (nonatomic, assign) BOOL enableQuic;
/*!
 * @abstract 重连次数，默认 3 次。
 *
 * @since v6.0.0
 */
@property (nonatomic, assign) uint32_t reconnectCount;
/*!
 * @abstract 推流缓存最大时长，单位ms，默认 5000 ms。
 *
 * @since v6.0.0
 */
@property (nonatomic, assign) uint32_t bufferingTime;
@end

NS_ASSUME_NONNULL_END
