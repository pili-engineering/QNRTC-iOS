//
//  QNForwardStreamConfiguration.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2020/7/17.
//  Copyright © 2020 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNTrackInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNForwardStreamConfiguration : NSObject
<
NSCopying
>

/**
 @brief 单路转推的 id
 */
@property (nonatomic, strong) NSString *jobId;

/**
 @brief 单路转推的地址
 */
@property (nonatomic, strong) NSString *publishUrl;

/**
 @brief 是否只有音频
 */
@property (nonatomic, assign) BOOL audioOnly;

/**
 @brief 音频 trackInfo
 */
@property (nonatomic, strong) QNTrackInfo *audioTrackInfo;

/**
 @brief 视频 trackInfo
 */
@property (nonatomic, strong) QNTrackInfo *videoTrackInfo;

@end

NS_ASSUME_NONNULL_END
