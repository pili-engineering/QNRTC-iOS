//
//  QNRemoteUser.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/9/8.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNRTCUser.h"
#import "QNRemoteVideoTrack.h"
#import "QNRemoteAudioTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNRemoteUser : QNRTCUser
/*!
 * @abstract 远端用户发布的视频 track 列表。
 *
 * @since v4.0.0
 */
@property (nonatomic,strong, readonly) NSArray <QNRemoteVideoTrack *> *videoTrack;

/*!
 * @abstract 远端用户发布的音频 track 列表。
 *
 * @since v4.0.0
 */
@property (nonatomic,strong, readonly) NSArray <QNRemoteAudioTrack *> *audioTrack;

@end

NS_ASSUME_NONNULL_END
