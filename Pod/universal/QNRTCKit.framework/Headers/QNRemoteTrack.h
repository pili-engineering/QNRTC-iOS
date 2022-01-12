//
//  QNRemoteTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/7/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNTrack.h"
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class QNRemoteTrack;
@protocol QNRemoteTrackDelegate <NSObject>

@optional

/*!
 * @abstract 订阅的远端 Track 开关静默时的回调。
 *
 * @since v4.0.0
 */
- (void)remoteTrack:(QNRemoteTrack *)remoteTrack didMutedByRemoteUserID:(NSString *)userID;

@end

@interface QNRemoteTrack : QNTrack
/*!
 * @abstract 远端 Track 回调代理。
 *
 * @since v4.0.0
 */
@property (nonatomic, weak) id<QNRemoteTrackDelegate> remoteDelegate;

/*!
 * @abstract 是否已订阅。
 *
 * @since v4.0.0
 */
@property (nonatomic, readonly)BOOL isSubscribed;

@end

NS_ASSUME_NONNULL_END
