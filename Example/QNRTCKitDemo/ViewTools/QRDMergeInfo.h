//
//  QRDMergeInfo.h
//  QNRTCKitDemo
//
//  Created by hxiongan on 2018/8/16.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface QRDMergeInfo : NSObject

@property (nonatomic, assign) CGRect mergeFrame;
@property (nonatomic, assign) NSInteger zIndex;
@property (nonatomic, getter = isMute) BOOL mute;
@property (nonatomic, getter = isHidden) BOOL hidden;

@property (nonatomic, copy) NSString *userId;

@end
