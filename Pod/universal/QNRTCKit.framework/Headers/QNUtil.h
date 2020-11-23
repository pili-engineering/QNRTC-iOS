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

@interface QNUtil : NSObject

/*!
 * @abstract    将 CVPixelBufferRef 转换为 UIImage. 支持的 PixelFormat 类型: kCVPixelFormatType_32BGRA, kCVPixelFormatType_420YpCbCr8Planar, kCVPixelFormatType_420YpCbCr8PlanarFullRange, kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 *
 * @since v2.1.0
 */
+ (UIImage *)convertFrame:(CVPixelBufferRef)pixelBuffer;

+ (void)scaleWithSat:(AudioBuffer *)audioBuffer scale:(double)scale max:(float)max min:(float) min;

@end
