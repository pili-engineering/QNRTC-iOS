//
//  QNTrack.h
//  QNRTCKit
//
//  Created by lawder on 2018/9/3.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"


NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract 用来描述一路 Track 的相关信息
 *
 * @discussion 主要用于发布/订阅时传入 Track 相关的信息，或者远端 Track 状态变更时 SDK 回调给 App Track 相关的信息。
 *
 * @since v4.0.0
 */
@interface QNTrack : NSObject

/*!
 * @abstract 一路 Track 在 Server 端的唯一标识。
 *
 * @discussion 发布成功时由 SDK 自动生成，订阅/Mute 等操作依据此 trackId 来确定相应的 Track。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) NSString *trackID;

/*!
 * @abstract 标识该路 Track 是音频还是视频。
 *
 * @discussion 发布时由 SDK 根据 sourceType 确定。
 *
 * @see QNTrackKind，QNRTCSourceType
 *
 * @since v4.0.0
 */
@property (nonatomic, readonly) QNTrackKind kind;

/*!
 * @abstract Track 的 tag，SDK 会将其透传到远端，当发布多路视频 Track 时可用 tag 来作区分。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) NSString *tag;

/*!
 * @abstract 标识 Track 是否为 mute 状态
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) BOOL muted;

@end


NS_ASSUME_NONNULL_END
