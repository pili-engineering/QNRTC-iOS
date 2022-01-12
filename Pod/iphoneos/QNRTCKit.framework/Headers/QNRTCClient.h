//
//  QNRTCClient.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/6/18.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNTrack.h"
#import "QNLocalTrack.h"
#import "QNRTCUser.h"
#import "QNMessageInfo.h"
#import "QNTypeDefines.h"

@class QNRTCClient;
@class QNRemoteTrack;
@class QNRemoteVideoTrack;
@class QNRemoteAudioTrack;
@class QNDirectLiveStreamingConfig;
@class QNTranscodingLiveStreamingConfig;
@class QNLiveStreamingErrorInfo;
@class QNTranscodingLiveStreamingTrack;
@class QNNetworkQuality;
@class QNConnectionDisconnectedInfo;
@class QNRemoteUser;
@class QNAudioMixer;
@class QNClientRoleOptions;
@class QNRoomMediaRelayInfo;
@class QNRoomMediaRelayConfiguration;
NS_ASSUME_NONNULL_BEGIN

@protocol QNRTCClientDelegate <NSObject>

@optional

/*!
 * @abstract 房间状态变更的回调。
 *
 * @discussion 当状态变为 QNConnectionStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leave 即可。
 * 重连成功后的状态为 QNConnectionStateReconnected。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didConnectionStateChanged:(QNConnectionState)state disconnectedInfo:(QNConnectionDisconnectedInfo *)info;

/*!
 * @abstract 远端用户加入房间的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didJoinOfUserID:(NSString *)userID userData:(NSString *)userData;

/*!
 * @abstract 远端用户离开房间的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didLeaveOfUserID:(NSString *)userID;

/*!
 * @abstract 订阅远端用户成功的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didSubscribedRemoteVideoTracks:(NSArray<QNRemoteVideoTrack *> *)videoTracks audioTracks:(NSArray<QNRemoteAudioTrack *> *)audioTracks ofUserID:(NSString *)userID;

/*!
 * @abstract 远端用户发布音/视频的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didUserPublishTracks:(NSArray<QNRemoteTrack *> *)tracks ofUserID:(NSString *)userID;

/*!
 * @abstract 远端用户取消发布音/视频的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didUserUnpublishTracks:(NSArray<QNRemoteTrack *> *)tracks ofUserID:(NSString *)userID;

/*!
 * @abstract 远端用户发生重连的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didReconnectingOfUserID:(NSString *)userID;

/*!
 * @abstract 远端用户重连成功的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didReconnectedOfUserID:(NSString *)userID;

/*!
 * @abstract 成功创建转推/合流转推任务的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didStartLiveStreamingWith:(NSString *)streamID;

/*!
 * @abstract 停止转推/合流转推任务的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didStopLiveStreamingWith:(NSString *)streamID;

/*!
 * @abstract 更新合流布局的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didTranscodingTracksUpdated:(BOOL)success withStreamID:(NSString *)streamID;

/*!
 * @abstract 合流转推出错的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didErrorLiveStreamingWith:(NSString *)streamID errorInfo:(QNLiveStreamingErrorInfo *)errorInfo;

/*!
 * @abstract 收到远端用户发送给自己的消息时回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didReceiveMessage:(QNMessageInfo *)message;

/*!
 * @abstract 远端用户视频首帧解码后的回调。
 *
 * @discussion 如果需要渲染，则需要返回一个带 renderView 的 QNVideoRender 对象。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client firstVideoDidDecodeOfTrack:(QNRemoteVideoTrack *)videoTrack remoteUserID:(NSString *)userID;

/*!
 * @abstract 远端用户视频取消渲染到 renderView 上的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didDetachRenderTrack:(QNRemoteVideoTrack *)videoTrack remoteUserID:(NSString *)userID;

/*!
 * @abstract 跨房媒体转发状态变更的回调。
 *
 * @warning 非主动调用触发，由目标房间状态变化引起此通知。目前仅当目标房间关闭（QNMediaRelayStateRoomClosed）时，会触发此通知。
 *
 * @param relayRoom 目标房间名称
 *
 * @param state 目标房间媒体转发状态
 *
 * @since v4.0.1
*/
- (void)RTCClient:(QNRTCClient *)client didMediaRelayStateChanged:(NSString *)relayRoom state:(QNMediaRelayState)state;

@end



@interface QNRTCClient : NSObject

/*!
 * @abstract 状态回调的 delegate。
 *
 * @since v4.0.0
 */
@property (nonatomic, weak) id<QNRTCClientDelegate> delegate;

/*!
 * @abstract 房间状态。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) QNConnectionState roomState;

/*!
 * @abstract 是否自动订阅远端的流，默认为 YES。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) BOOL autoSubscribe;

/*!
 * @abstract 远端用户列表
 *
 * @since v4.0.0
 */
@property (nonatomic, strong, readonly) NSArray<QNRemoteUser *> *remoteUserList;

/*!
 * @abstract 已发布 track 列表
 *
 * @since v4.0.0
 */
@property (nonatomic, strong, readonly) NSArray<QNTrack *> *publishedTracks;


/*!
 * @abstract 设置直播场景下的用户角色。
 *
 * @param role 直播场景里的用户角色。
 * @see QNClientRole.
 *
 * @discussion 该方法在加入频道前后均可调用。
 *
 * @warning 该方法仅适用于直播场景。
 *
 * @since v4.0.1
 */
- (void)setClientRole:(QNClientRole)role completeCallback:(nullable QNClientRoleResultCallback)callback;

/*!
 * @abstract 加入房间。
 *
 * @since v4.0.0
 */
- (void)join:(NSString *)token;

/*!
 * @abstract 加入房间。
 *
 * @since v4.0.0
 */
- (void)join:(NSString *)token userData:(NSString *)userData;

/*!
 * @abstract 退出房间。
 *
 * @since v4.0.0
 */
- (void)leave;

/*!
 * @abstract 发布 tracks。
 *
 * @since v4.0.0
 */
- (void)publish:(NSArray<QNLocalTrack *> *)tracks;

/*!
 * @abstract 发布 tracks。
 *
 * @since v4.0.0
 */
- (void)publish:(NSArray<QNLocalTrack *> *)tracks completeCallback:(QNPublishResultCallback)callback;

/*!
 * @abstract 取消发布 tracks。
 *
 * @since v4.0.0
 */
- (void)unpublish:(NSArray<QNTrack *> *)tracks;

/*!
 * @abstract 订阅 tracks。
 *
 * @since v4.0.0
 */
- (void)subscribe:(NSArray<QNTrack *> *)tracks;

/*!
 * @abstract 取消订阅。
 *
 * @since v4.0.0
 */
- (void)unsubscribe:(NSArray<QNTrack *> *)tracks;

/*!
 * @abstract 获取指定用户已被自己订阅的 tracks。
 *
 * @since v4.0.0
 */
- (NSArray <QNTrack *> *)getSubscribedTracks:(NSString *)userID;

/*!
 * @abstract 开启单路转推。
 *
 * @since v4.0.0
 */
- (void)startLiveStreamingWithDirect:(QNDirectLiveStreamingConfig *)config;

/*!
 * @abstract 开启合流转推。
 *
 * @since v4.0.0
 */
- (void)startLiveStreamingWithTranscoding:(QNTranscodingLiveStreamingConfig *)config;

/*!
 * @abstract 停止单路转推。
 *
 * @since v4.0.0
 */
- (void)stopLiveStreamingWithDirect:(QNDirectLiveStreamingConfig *)config;

/*!
 * @abstract 停止合流转推。
 *
 * @since v4.0.0
 */
- (void)stopLiveStreamingWithTranscoding:(QNTranscodingLiveStreamingConfig *)config;

/*!
 * @abstract 将对应的音视频 Track 加入合流。
 *
 * @discussion 需要更新合流布局时，重新调用该接口即可。若使用默认的合流任务，则 streamID 传入 nil 即可。
 *
 * @since v4.0.0
 */
- (void)setTranscodingLiveStreamingID:(nullable NSString *)streamID withTracks:(NSArray <QNTranscodingLiveStreamingTrack *> *)tracks;

/*!
 * @abstract 将对应的音视频 Track 从合流中移除。
 *
 * @discussion 此处 QNMergeStreamLayout 中只需要设置 trackId 即可，其它参数可忽略。若使用默认的合流任务，则 streamID 传入 nil 即可。
 *
 * @since v4.0.0
 */
- (void)removeTranscodingLiveStreamingID:(nullable NSString *)streamID withTracks:(NSArray <QNTranscodingLiveStreamingTrack *> *)tracks;

/*!
 * @abstract 发送消息给 users 数组中的所有 userID。若需要给房间中的所有人发消息，数组传入 nil 即可。
 *
 * @since v4.0.0
 */
- (void)sendMessage:(NSString *)messsage toUsers:(nullable NSArray<NSString *> *)users messageId:(nullable NSString *)messageId;

/*!
 * @abstract 开启跨房媒体转发
 *
 * @discussion 如果已经开启，则调用失败
 *             当所有目标房间跨房媒体转发都失败，则本次跨房媒体转发请求视为失败，使用跨房媒体转发功能需要再次调用此 API
 *             当有任意一个目标或多个目标房间媒体转发成功，则本次跨房媒体转发请求视为成功，具体每个房间的状态参考回调结果。
 *
 * @param config 跨房间媒体转发参数配置。
 *
 * @see QNRoomMediaRelayConfiguration
 *
 * @warning 该方法仅适用直播类型房间中角色类型为主播的用户。
 *
 * @since v4.0.1
 */
- (void)startRoomMediaRelay:(QNRoomMediaRelayConfiguration *_Nonnull)config completeCallback:(nullable QNMediaRelayResultCallback)callback;

/*!
 * @abstract 更新媒体流转发的房间。
 *
 * @discussion 成功开启跨房媒体转发后，如果你希望将流转发到多个目标房间，或退出当前正在转发的房间，可以调用该方法。
 *             此 API 为全量更新，正在跨房媒体转发中却未被包含在参数 configuration 中的房间，将停止媒体转发。
 *
 * @param config 跨房间媒体流转发参数配置。
 *
 * @see QNRoomMediaRelayConfiguration
 *
 * @warning 调用此 API 前必须确保已经成功开启跨房媒体转发，否则将调用失败；该方法仅适用直播类型房间中角色类型为主播的用户。
 *
 * @since v4.0.1
 */
- (void)updateRoomMediaRelay:(QNRoomMediaRelayConfiguration *_Nonnull)config completeCallback:(nullable QNMediaRelayResultCallback)callback;

/*!
 * @abstract 停止跨房间媒体流转发。
 *
 * @discussion 如果未开启，则调用失败。
 *
 * @warning 一旦停止，会停止在所有目标房间中的媒体转发；该方法仅适用直播类型房间中角色类型为主播的用户。
 *
 * @since v4.0.1
 */
- (void)stopRoomMediaRelay:(nullable QNMediaRelayResultCallback)callback;

/*!
 * @abstract 获取远端用户。
 *
 * @since v4.0.0
 */
- (QNRemoteUser *)getRemoteUser:(NSString *)userID;

/*!
 * @abstract 获取某个用户的网路质量等级。
 *
 * @since v4.0.0
 */
- (QNNetworkQuality *)getUserNetworkQuality:(NSString *)userID;

/*!
 * @abstract 获取远端用户视频传输统计信息。
 *
 * @since v4.0.0
 */
- (NSDictionary *)getRemoteVideoTrackStats;

/*!
 * @abstract 获取远端用户音频传输统计信息。
 *
 * @since v4.0.0
 */
- (NSDictionary *)getRemoteAudioTrackStats;

/*!
 * @abstract 获取本地视频传输统计信息。
 *
 * @since v4.0.0
 */
- (NSDictionary *)getLocalVideoTrackStats;

/*!
 * @abstract 获取本地音频传输统计信息。
 *
 * @since v4.0.0
 */
- (NSDictionary *)getLocalAudioTrackStats;

@end

NS_ASSUME_NONNULL_END
