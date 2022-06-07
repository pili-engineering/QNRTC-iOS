//
//  QNVideoEncoderConfig.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2022/5/16.
//  Copyright © 2022 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNVideoEncoderConfig : NSObject

/*!
 * @abstract Track 的 bitrate (单位 kbps)，默认码率为 600kbps
 *
 * @since v5.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger bitrate;

/*!
 * @abstract Track 编码画面大小，默认 480x640
 *
 * @since v5.0.0
 */
@property (nonatomic, assign, readonly) CGSize videoEncodeSize;

/*!
 * @abstract Track 编码帧数，默认 24 帧，若视频输入帧数无法达到设置值，则根据实际输入帧数为准
 *
 * @since v5.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger videoFrameRate;

/*!
 * @abstract 初始化默认编码配置。
 *
 * @discussion 默认码率为 600kbps。
 *
 * @since v5.0.0
 */
+ (instancetype)defaultVideoEncoderConfig;

/*!
 * @abstract 初始化指定 bitrate (单位 kbps) 参数的 Track。
 *
 * @since v5.0.0
 */
- (instancetype)initWithBitrate:(NSUInteger)bitrate;

/*!
 * @abstract 初始化指定 bitrate (单位 kbps) 、videoEncodeSize 参数的 Track。
 *
 * @since v5.0.0
 */
- (instancetype)initWithBitrate:(NSUInteger)bitrate
                videoEncodeSize:(CGSize)videoEncodeSize;

/*!
 * @abstract 初始化指定 bitrate (单位 kbps) 、videoEncodeSize、videoFrameRate 参数的 Track。
 *
 * @since v5.0.0
 */
- (instancetype)initWithBitrate:(NSUInteger)bitrate
                videoEncodeSize:(CGSize)videoEncodeSize
                 videoFrameRate:(NSUInteger)videoFrameRate;

@end

NS_ASSUME_NONNULL_END
