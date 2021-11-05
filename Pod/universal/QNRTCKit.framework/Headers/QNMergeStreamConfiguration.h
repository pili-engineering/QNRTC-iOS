//
//  QNMergeStreamConfiguration.h
//  QNRTCKit
//
//  Created by suntongmian on 2018/9/13.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNWatermarkInfo.h"

@interface QNMergeStreamConfiguration : NSObject
<
NSCopying
>

/**
 @brief 合流的 id
 */
@property (nonatomic, strong) NSString *jobId;

/**
 @brief 合流的转推地址
 */
@property (nonatomic, strong) NSString *publishUrl;

/**
 @brief 是否只有音频
 */
@property (nonatomic, assign) BOOL audioOnly;

/**
 @brief 图像的宽度，默认值为 480
 */
@property (nonatomic, assign) int width;

/**
 @brief 图像的高度，默认值为 848
 */
@property (nonatomic, assign) int height;

/**
 @brief 帧率，默认值为 25
 */
@property (nonatomic, assign) int fps;

/**
 @brief  码率，单位为 bps，默认值为 1000*1000
 */
@property (nonatomic, assign) NSUInteger bitrateBps;

/**
 @brief 图像的填充模式，默认值为 QNVideoFillModePreserveAspectRatioAndFill
 */
@property (nonatomic, assign) QNVideoFillModeType fillMode;

/**
 @brief 水印，为可选项
 */
@property (nonatomic, strong) NSArray<QNWatermarkInfo *> *watermarks;

/**
 @brief 背景图片，为可选项
 */
@property (nonatomic, strong) QNBackgroundInfo *background;

/**
 @brief 最小码率，为可选项
 */
@property (nonatomic, assign) NSUInteger minBitrateBps;

/**
 @brief 最大码率，为可选项
 */
@property (nonatomic, assign) NSUInteger maxBitrateBps;

/**
 @brief 是否在 Track 没有数据的情况下在合流画布中保持最后一帧,默认为 NO
 */
@property (nonatomic, assign) BOOL holdLastFrame;


/**
 @brief 创建默认配置的实例
 */
+ (instancetype)defaultConfiguration;

@end
