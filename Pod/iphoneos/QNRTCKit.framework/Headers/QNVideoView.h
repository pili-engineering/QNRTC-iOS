//
//  QNRTCVideoView.h
//  QNRTCKit
//
//  Created by lawder on 2017/10/24.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNTypeDefines.h"

@interface QNVideoView : UIView

/*!
 * @abstract 远端画面的填充方式
 *
 * @discussion 当远端画面与 QNVideoView 的比例不一致时，使用的填充方式。默认使用 QNVideoFillModePreserveAspectRatioAndFill。
 *
 * @since v2.1.1
 */
@property(nonatomic, assign) QNVideoFillModeType fillMode;

@end
