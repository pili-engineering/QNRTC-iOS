//
//  QNCustomVideoTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/7/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNLocalVideoTrack.h"
#import "QNVideoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNCustomVideoTrack : QNLocalVideoTrack

/*!
 * @abstract 设置本地屏幕渲染。
 *
 * @discussion track 必须为已发布状态下，方可渲染出画面
 *
 * @since v4.0.0
 */
- (void)play:(QNVideoView *)renderView;

/*!
 * @abstract 导入视频数据。
 *
 * @discussion 调用此接口将把数据导入给所有 sourceType 为 QNRTCSourceTypeExternalVideo 的视频 Track。
 * 支持导入的视频数据格式为：kCVPixelFormatType_32BGRA、kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 * 和 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange。
 *
 * @since v4.0.0
 */
- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/*!
 * @abstract 导入视频数据。
 *
 * @discussion 调用此接口将把数据导入给所有 sourceType 为 QNRTCSourceTypeExternalVideo 的视频 Track。
 * 支持导入的视频数据格式为：kCVPixelFormatType_32BGRA、kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 * 和 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange。
 *
 * @since v4.0.0
 */
- (void)pushPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END
