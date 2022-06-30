//
//  QNCustomVideoTrackConfig.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/6/21.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QNVideoEncoderConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNCustomVideoTrackConfig : NSObject

/*!
 * @abstract Track 的 tag，SDK 会将其透传到远端，当发布多路 Track 时可用 tag 来作区分。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) NSString * tag;

/*!
 * @abstract 视频编码配置。
 *
 * @since v5.0.0
 */
@property (nonatomic, strong, readonly) QNVideoEncoderConfig *config;

/*!
 * @abstract Track 是否开启大小流
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) BOOL multiStreamEnable;

/*!
 * @abstract 初始化默认 Track 配置。
 *
 * @discussion 默认码率为 600kbps。
 *
 * @since v5.0.0
 */
+ (instancetype)defaultCustomVideoTrackConfig;

/*!
 * @abstract 初始化指定 tag 参数的 Track 配置。
 *
 * @discussion 默认码率为 600kbps。
 *
 * @since v4.0.0
 */
- (instancetype)initWithSourceTag:(nullable NSString *)tag;

/*!
 * @abstract 初始化指定 tag、config 参数的 Track 配置。
 *
 * @param tag Track 的标识
 *
 * @param config 视频编码配置 QNVideoEncoderConfig 实例
 * 
 * @since v5.0.0
 */
- (instancetype)initWithSourceTag:(nullable NSString *)tag
                           config:(QNVideoEncoderConfig *)config;

/*!
 * @abstract 初始化指定 tag、config、multiStreamEnable 参数的 Track 配置。
 *
 * @param tag Track 的标识
 *
 * @param config 视频编码配置 QNVideoEncoderConfig 实例
 *
 * @param multiStreamEnable 是否开启大小流
 *
 * @since v5.0.0
 */
- (instancetype)initWithSourceTag:(nullable NSString *)tag
                           config:(QNVideoEncoderConfig *)config
                multiStreamEnable:(BOOL)multiStreamEnable;

@end

NS_ASSUME_NONNULL_END
