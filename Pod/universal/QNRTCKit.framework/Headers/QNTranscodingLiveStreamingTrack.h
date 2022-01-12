//
//  QNTranscodingLiveStreamingTrack.h
//  QNRTCKit
//
//  Created by tony.jing on 2021/8/17.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "QNTypeDefines.h"



@interface QNTranscodingLiveStreamingTrack : NSObject

/*!
 * @abstract 当前要操作的 Track 的 id。
 */
@property (nonatomic, strong) NSString *trackId;

/*!
 * @abstract 该 Track 在合流画面中的大小和位置，该属性仅对视频 Track 有效。
 */
@property (nonatomic, assign) CGRect frame;

/*!
 * @abstract 该 Track 在合流画面中的层次，0 为最底层。该属性仅对视频 Track 有效。
 */
@property (nonatomic, assign) NSUInteger zIndex;

/*!
 * @abstract 图像的填充模式, 默认设置填充模式将继承 QNMergeStreamConfiguration 中数值
 */
@property (nonatomic, assign) QNVideoFillModeType fillMode;

/*!
 * @abstract 是否在合流中添加视频 Track 的 SEI 内容，针对所有合流视频 Track，默认只能设置一路 SEI
 */
@property (nonatomic, assign) BOOL supportSEI;

@end

