//
//  QNCDNStreamingStats.h
//  QNRTCKit
//
//  Created by ShengQiang'Liu on 2023/11/20.
//  Copyright © 2023 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNCDNStreamingStats : NSObject
/*!
 * @abstract 发送到 CDN 的视频 fps。
 *
 * @since v6.0.0
 */
@property (nonatomic, assign) uint32_t sendVideoFps;
/*!
 * @abstract 发送的视频码率，单位 kbps。
 *
 * @since v6.0.0
 */
@property (nonatomic, assign) uint32_t videoBitrate;
/*!
 * @abstract 发送的音频码率，单位 kbps。
 *
 * @since v6.0.0
 */
@property (nonatomic, assign) uint32_t audioBitrate;
/*!
 * @abstract 每秒的视频丢帧数。
 *
 * @since v6.0.0
 */
@property (nonatomic, assign) uint32_t droppedVideoFrames;
@end

NS_ASSUME_NONNULL_END
