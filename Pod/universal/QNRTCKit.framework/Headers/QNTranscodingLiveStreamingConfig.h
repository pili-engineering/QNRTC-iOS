//
//  QNTranscodingLiveStreamingConfig.h
//  QNRTCKit
//
//  Created by tony.jing on 2021/8/17.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNTranscodingLiveStreamingImage.h"
#import "QNTranscodingLiveStreamingTrack.h"

@interface QNTranscodingLiveStreamingConfig : NSObject
<
NSCopying
>

/**
 @brief 合流的 id
 @since v4.0.0
 */
@property (nonatomic, strong) NSString *streamID;

/**
 @brief 合流的转推地址
 @since v4.0.0
 */
@property (nonatomic, strong) NSString *publishUrl;

/**
 @brief 图像的宽度，默认值为 480
 @since v4.0.0
 */
@property (nonatomic, assign) int width;

/**
 @brief 图像的高度，默认值为 848
 @since v4.0.0
 */
@property (nonatomic, assign) int height;

/**
 @brief 帧率，默认值为 25
 @since v4.0.0
 */
@property (nonatomic, assign) int fps;

/**
 @brief  码率，单位为 bps，默认值为 1000*1000
 @since v4.0.0
 */
@property (nonatomic, assign) NSUInteger bitrateBps;

/**
 @brief 图像的填充模式，默认值为 QNVideoFillModePreserveAspectRatioAndFill
 @since v4.0.0
 */
@property (nonatomic, assign) QNVideoFillModeType fillMode;

/**
 @brief 水印，为可选项
 @since v4.0.0
 */
@property (nonatomic, strong) NSArray<QNTranscodingLiveStreamingImage *> *watermarks;

/**
 @brief 背景图片，为可选项
 @since v4.0.0
 */
@property (nonatomic, strong) QNTranscodingLiveStreamingImage *background;

/**
 @brief 最小码率，为可选项
 @since v4.0.0
 */
@property (nonatomic, assign) NSUInteger minBitrateBps;

/**
 @brief 最大码率，为可选项
 @since v4.0.0
 */
@property (nonatomic, assign) NSUInteger maxBitrateBps;

/**
 @brief 是否在 Track 没有数据的情况下在合流画布中保持最后一帧,默认为 NO
 @since v4.0.0
 */
@property (nonatomic, assign) BOOL holdLastFrame;

/**
 @brief 创建默认配置的实例
 @since v4.0.0
 */
+ (instancetype)defaultConfiguration;

@end
