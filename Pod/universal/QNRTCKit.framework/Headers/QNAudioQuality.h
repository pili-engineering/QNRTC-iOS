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
 * @abstract 音频编码码率，默认 64kbps，单位 kbps
 *
 * @since v5.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger bitrate;

/*!
 * @abstract 初始化默认音频编码配置。
 *
 * @discussion 默认码率为 64kbps。
 *
 * @since v5.0.0
 */
+ (instancetype)defaultAudioQuality;

/*!
 * @abstract 初始化指定码率音频编码配置。
 *
 * @param bitrate 编码码率，单位 kbps
 *
 * @since v5.0.0
 */
- (instancetype)initWithBitrate:(NSUInteger)bitrate;
@end

NS_ASSUME_NONNULL_END
