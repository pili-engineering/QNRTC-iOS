//
//  QNDirectLiveStreamingConfig.h
//  QNRTCKit
//
//  Created by tony.jing on 2021/8/17.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNDirectLiveStreamingConfig : NSObject
<
NSCopying
>

/**
 @brief 单路转推的 id
 */
@property (nonatomic, strong) NSString *streamID;

/**
 @brief 单路转推的地址
 */
@property (nonatomic, strong) NSString *publishUrl;

/**
 @brief 音频 track
 */
@property (nonatomic, strong) QNTrack *audioTrack;

/**
 @brief 视频 track
 */
@property (nonatomic, strong) QNTrack *videoTrack;

@end

NS_ASSUME_NONNULL_END
