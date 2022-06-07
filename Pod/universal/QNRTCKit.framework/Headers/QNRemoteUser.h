//
//  QNRemoteUser.h
//  QNRTCKit
//
//  Created by 何云旗 on 2022/1/6.
//  Copyright © 2022 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNRemoteUser : NSObject

/*!
 * @abstract 用户的唯一标识。
 *
 * @since v5.0.0
 */
@property (nonatomic, readonly) NSString *userID;

/*!
 * @abstract SDK 可将 userData 传给房间中的其它用户，如无需求可置为 nil。
 *
 * @since v5.0.0
 */
@property (nonatomic, readonly) NSString *userData;

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
