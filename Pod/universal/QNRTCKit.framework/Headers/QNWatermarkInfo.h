//
//  QNWatermarkInfo.h
//  QNRTCKit
//
//  Created by suntongmian on 2018/9/12.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QNWatermarkInfo : NSObject

/**
 @brief 水印在合流中的位置
*/
@property (nonatomic, assign) CGRect frame;

/**
 @brief 水印图片的 url
*/
@property (nonatomic, strong) NSString *watermarkUrl;

@end


@interface QNBackgroundInfo : NSObject

/**
 @brief 背景图片在合流中的位置
*/
@property (nonatomic, assign) CGRect frame;

/**
 @brief 背景图片的 url
*/
@property (nonatomic, strong) NSString *backgroundUrl;

@end
