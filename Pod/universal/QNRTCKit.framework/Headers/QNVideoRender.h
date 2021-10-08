//
//  QNRTCVideoRender.h
//  QNRTCKit
//
//  Created by lawder on 2017/9/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNVideoView.h"

@interface QNVideoRender : NSObject

/**
 @brief 对应的 userId，由 SDK 内部设置
 */
@property (nonatomic, strong, readonly) NSString *userId;


@property (nonatomic, strong) QNVideoView *renderView;


@end
