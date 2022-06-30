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

/*!
 * @abstract 单路转推的 id
 *
 * @discussion streamID 为 CDN 转推过程中的唯一标识符
 */
@property (nonatomic, strong) NSString *streamID;

/*!
 * @abstract 单路转推的地址
 *
 * @discussion 当有单路转推及合流场景切换的需求时，流地址一样会导致抢流现象的出现，因此需要在流地址中拼接 '?serialnum=xxx' 决定流的优先级，serialnum 的值从 1 开始递增，值越大，优先级越高。
 */
@property (nonatomic, strong) NSString *publishUrl;

/*!
 * @abstract 音频 track
 *
 * @discussion 单路转推任务仅支持一路音频轨的设置，重复设置会被覆盖
 */
@property (nonatomic, strong) QNLocalAudioTrack *audioTrack;

/*!
 * @abstract 视频 track
 *
 * @discussion 单路转推任务仅支持一路视频轨的设置，重复设置会被覆盖
 */
@property (nonatomic, strong) QNLocalVideoTrack *videoTrack;

@end

NS_ASSUME_NONNULL_END
