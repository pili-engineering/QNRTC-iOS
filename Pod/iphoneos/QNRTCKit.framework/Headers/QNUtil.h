//
//  QNUtil.h
//  QNRTCKit
//
//  Created by hxiongan on 2019/1/4.
//  Copyright © 2019年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import <UIKit/UIKit.h>
#import <CoreAudioTypes/CoreAudioTypes.h>
#import <CoreMedia/CoreMedia.h>

@interface QNUtil : NSObject

/*!
 * @abstract 将 CVPixelBufferRef 转换为 UIImage. 支持的 PixelFormat 类型: kCVPixelFormatType_32BGRA, kCVPixelFormatType_420YpCbCr8Planar, kCVPixelFormatType_420YpCbCr8PlanarFullRange, kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 *
 * @since v4.0.0
 */
+ (UIImage *)convertFrame:(CVPixelBufferRef)pixelBuffer;

/*!
 * @abstract 开始 dump 音频数据到本地
 *
 * @since v5.2.1
 */
+ (BOOL)startAecDump:(NSString *)path durationMs:(int)durationMs;

/*!
 * @abstract 停止 dump 音频数据
 *
 * @since v5.2.1
 */
+ (void)stopAecDump;
@end
