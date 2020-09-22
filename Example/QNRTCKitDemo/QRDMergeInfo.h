//
//  QRDMergeInfo.h
//  QNRTCKitDemo
//
//  Created by hxiongan on 2018/8/16.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QNRTCKit/QNRTCKit.h>

@interface QRDMergeInfo : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *trackId;
@property (nonatomic, getter = isMerged) BOOL merged;   // 是否加入合流
@property (nonatomic, assign) QNTrackKind kind;
@property (nonatomic, assign) NSString *trackTag;

// 以下两个属性仅针对视频 track
@property (nonatomic, assign) CGRect mergeFrame;
@property (nonatomic, assign) NSInteger zIndex;

@end
