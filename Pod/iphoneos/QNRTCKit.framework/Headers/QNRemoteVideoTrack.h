//
//  QNRemoteVideoTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/7/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNRemoteTrack.h"
#import "QNVideoView.h"
#import "QNTypeDefines.h"

@class QNRemoteVideoTrack;
NS_ASSUME_NONNULL_BEGIN
@protocol QNRemoteTrackVideoDataDelegate <NSObject>

@optional
/*!
 * @abstract 视频 Track 数据回调。
 *
 * @since v4.0.0
 */
- (void)remoteVideoTrack:(QNRemoteVideoTrack *)remoteVideoTrack didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/*!
 * @abstract 订阅的远端视频 Track 分辨率发生变化时的回调。
 *
 * @since v4.0.0
 */
- (void)remoteVideoTrack:(QNRemoteVideoTrack *)remoteVideoTrack didSubscribeProfileChanged:(QNTrackProfile)profile;

@end

@interface QNRemoteVideoTrack : QNRemoteTrack

/*!
 * @abstract 视频 Track 回调代理。
 *
 * @since v4.0.0
 */
@property (nonatomic, weak) id<QNRemoteTrackVideoDataDelegate> videoDelegate;

/*!
 * @abstract 是否开启大小流。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) BOOL isMultiProfileEnabled;

/*!
 * @abstract 当前大小流等级。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) QNTrackProfile profile;

/*!
 * @abstract 视频 Track 渲染。
 *
 * @since v4.0.0
 */
- (void)play:(nullable QNVideoView *)renderView;

/*!
 * @abstract 变更订阅大小流等级。
 *
 * @since v4.0.0
 */
- (void)setProfile:(QNTrackProfile)profile;

@end

NS_ASSUME_NONNULL_END
