//
//  QNCameraVideoTrackConfig.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/6/21.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNCameraVideoTrackConfig : NSObject

/*!
 * @abstract Track 的 tag，SDK 会将其透传到远端，当发布多路 Track 时可用 tag 来作区分。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) NSString * tag;

/*!
 * @abstract Track 的 bitrate (单位 kbps)，默认码率为 600kbps
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) NSUInteger bitrate;

/*!
 * @abstract Track 编码画面大小
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) CGSize videoEncodeSize;

/*!
 * @abstract Track 是否开启大小流
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) BOOL multiStreamEnable;

/*!
 * @abstract 初始化默认 Track。
 *
 * @discussion 默认码率为 600kbps。
 *
 * @since v4.0.0
 */
- (instancetype)defaultCameraVideoTrackConfig;

/*!
 * @abstract 初始化指定 tag 参数的 Track。
 *
 * @discussion 默认码率为 600kbps。
 *
 * @since v4.0.0
 */
- (instancetype)initWithSourceTag:(nullable NSString *)tag;

/*!
 * @abstract 初始化指定 tag、bitrate (单位 kbps) 参数的 Track。
 *
 * @since v4.0.0
 */
- (instancetype)initWithSourceTag:(nullable NSString *)tag
                          bitrate:(NSUInteger)bitrate;

/*!
 * @abstract 初始化指定 tag、videoEncodeSize 参数的 Track。
 *
 * @since v4.0.0
 */
- (instancetype)initWithSourceTag:(nullable NSString *)tag
                  videoEncodeSize:(CGSize)videoEncodeSize;

/*!
 * @abstract 初始化指定 tag、bitrate (单位 kbps)、videoEncodeSize 参数的 Track。
 *
 * @since v4.0.0
 */
- (instancetype)initWithSourceTag:(nullable NSString *)tag
                          bitrate:(NSUInteger)bitrate
                  videoEncodeSize:(CGSize)videoEncodeSize;

/*!
 * @abstract 初始化指定 tag、bitrate (单位 kbps)、videoEncodeSize、 multiStreamEnable 参数的 Track。
 *
 * @since v4.0.0
 */
- (instancetype)initWithSourceTag:(nullable NSString *)tag
                          bitrate:(NSUInteger)bitrate
                  videoEncodeSize:(CGSize)videoEncodeSize
                multiStreamEnable:(BOOL)multiStreamEnable;

@end

NS_ASSUME_NONNULL_END
