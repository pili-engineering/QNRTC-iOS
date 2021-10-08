//
//  MuseGLKView.h
//  Musemage
//
//  Created by YangBin on 14/11/10.
//  Copyright (c) 2014年 Paraken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreVideo/CoreVideo.h>
#import "QNTypeDefines.h"

@interface QNGLKView : UIView

/*!
 * @abstract 渲染模式。默认 QNVideoFillModePreserveAspectRatioAndFill
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) QNVideoFillModeType fillMode;

@end
