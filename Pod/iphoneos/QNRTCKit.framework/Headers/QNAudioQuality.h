//
//  QNAudioQuality.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2022/5/16.
//  Copyright © 2022 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNAudioQuality : NSObject

/*!
 * @abstract Track 的 bitrate (单位 kbps)，默认码率为 64kbps
 *
 * @since v5.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger bitrate;

/*!
 * @abstract 初始化默认编码配置。
 *
 * @discussion 默认码率为 64kbps。
 *
 * @since v5.0.0
 */
+ (instancetype)defaultAudioQuality;

/*!
 * @abstract 初始化指定 bitrate (单位 kbps) 参数的 Track。
 *
 * @since v5.0.0
 */
- (instancetype)initWithBitrate:(NSUInteger)bitrate;
@end

NS_ASSUME_NONNULL_END
