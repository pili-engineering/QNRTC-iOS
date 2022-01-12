//
//  QNTypeDefines.h
//  QNRTCKit
//
//  Created on 15/3/26.
//  Copyright (c) 2015年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#ifndef QNRTCKit_QNTypeDefines_h
#define QNRTCKit_QNTypeDefines_h

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

extern NSString *QNCameraAuthorizationStatusDidGetNotificaiton;

extern NSString *QNRTCErrorDomain;

extern NSString *QNAudioMixErrorDomain;

extern NSString *QNMediaRelayErrorDomain;

extern NSString *QNAudioFileErrorDomain;

#pragma mark - RTC Log Level

/*!
 * @typedef    QNRTCLogLevel
 *
 * @abstract   日志输出等级。
 *
 * @since      v4.0.0
 */
typedef NS_ENUM(NSUInteger, QNRTCLogLevel) {
    /*!
     * @abstract Verbose 日志输出
     */
    QNRTCLogLevelVerbose,
    
    /*!
     * @abstract Info 日志输出
     */
    QNRTCLogLevelInfo,
    
    /*!
     * @abstract Warning 日志输出
     */
    QNRTCLogLevelWarning,
    
    /*!
     * @abstract Error 日志输出
     */
    QNRTCLogLevelError,
    
    /*!
     * @abstract None 不输出日志
     */
    QNRTCLogLevelNone,
};

#pragma mark - RTC Error Code

NS_ERROR_ENUM(QNRTCErrorDomain) {
    /*!
     * @abstract token error
     *
     * @discussion 鉴权失败，建议用户收到此错误代码时尝试重新获取 RoomToken 后再次加入房间。
     */
    QNRTCErrorTokenError                        = 10001,
    
    /*!
     * @abstract token expired
     *
     * @discussion RoomToken 过期，建议用户收到此错误代码时尝试重新获取 RoomToken 后再次加入房间。
     */
    QNRTCErrorTokenExpired                      = 10002,
        
    /*!
     * @abstract reconnect token error
     *
     * @discussion 重连时 RoomToken 错误，建议用户收到此错误代码时尝试重新获取 RoomToken 后再次加入房间。
     */
    QNRTCErrorReconnectTokenError               = 10004,
    
    /*!
     * @abstract room closed
     *
     * @discussion 房间被管理员关闭。
     */
    QNRTCErrorRoomClosed                        = 10005,
    
    /*!
     * @abstract kick out of room
     *
     * @discussion 被管理员踢出房间。
     */
    QNRTCErrorKickOutOfRoom                     = 10006,
    
    /*!
     * @abstract room is full
     *
     * @discussion 房间人数已超过限制。
     */
    QNRTCErrorRoomIsFull                        = 10011,
    
    /*!
     * @abstract room not exist
     *
     * @discussion 房间不存在。
     */
    QNRTCErrorRoomNotExist                      = 10012,
    
    /*!
     * @abstract user not exist
     *
     * @discussion 用户不存在。
     */
    QNRTCErrorUserNotExist                      = 10021,
    
    /*!
     * @abstract user already exist
     *
     * @discussion 用户已存在，该用户可能已使用其他设备进入房间。
     */
    QNRTCErrorUserAlreadyExist                  = 10022,
        
    /*!
     * @abstract no permission
     *
     * @discussion 当用户在进行踢人等操作没有权限时会返回此错误代码。
     */
    QNRTCErrorNoPermission                      = 10051,
    
    /*!
     * @abstract server unavailable
     *
     * @discussion 服务不可用，SDK 内部错误。用户无需处理。
     */
    QNRTCErrorServerUnavailable                 = 10052,
    
    /*!
     * @abstract invalid parameter
     *
     * @discussion 服务端信令参数错误以及配置参数非法等。
     */
    QNRTCErrorInvalidParameter                  = 10053,
    
    /*!
     * @abstract server unavailable
     *
     * @discussion 服务不可用，SDK 内部错误。用户无需处理。
     */
    QNRTCErrorMediaCapNotSupport                 = 10054,

    /*!
     * @abstract Publisher Disconnected, or not exist
     *
     * @discussion 发布失败，或不存在，用户无需处理。
     */
    QNRTCErrorPublishDisconnected               = 10061,
    
    /*!
     * @abstract Subscriber Disconnected, or not exist
     *
     * @discussion 订阅失败，或订阅不存在，用户无需处理。
     */
    QNRTCErrorSubscribeDisconnected             = 10062,
    
    /*!
     * @abstract Multi master video or audio
     *
     * @discussion 音频或视频 track 最多只有一路为 master。
     */
    QNRTCErrorMultiMasterVideoOrAudio           = 10063,

    /*!
     * @abstract auth failed
     *
     * @discussion 鉴权失败，建议用户收到此错误代码时检查网络并尝试重新获取 RoomToken 后再次加入房间。
     *
     * @since v4.0.0
     */
    QNRTCErrorAuthFailed                        = 21001,
    
    /*!
     * @abstract room state error
     *
     * @discussion 当前房间状态不允许此操作。
     *
     * @since v4.0.0
     */
    QNRTCErrorRoomStateError                    = 21002,
    
    /*!
     * @abstract reconnect failed
     *
     * @discussion 房间重连失败。
     *
     * @since v4.0.1
     */
    QNRTCErrorReconnectFailed                   = 21003,
    
    /*!
     * @abstract fatal error
     *
     * @discussion 非预期错误。
     *
     * @since v4.0.0
     */
    QNRTCErrorFatalError                        = 21005,
    
    /*!
     * @abstract update timeout
     *
     * @discussion 信令超时。
     */
    QNRTCErrorSignalTimeOut                     = 11013,
    
    /*!
     * @abstract push audioBuffer with asbd convert failed
     *
     * @discussion 音频重采样失败。
     */
    QNRTCErrorPushAudioBufferFailed             = 11014,
};

#pragma mark - Audio Mix Error Code

NS_ERROR_ENUM(QNAudioMixErrorDomain) {
    /*!
     * @abstract graph error
     *
     * @discussion 系统 AUGraph 操作相关错误。
     *
     * @since v4.0.0
     */
    QNAudioMixErrorGraphError = 22006,
    
    /*!
     * @abstract node error
     *
     * @discussion 系统 AUNode 操作相关错误。
     *
     * @since v4.0.0
     */
    QNAudioMixErrorNodeError  = 22007,
    
    /*!
     * @abstract read data error
     *
     * @discussion 读取混音数据发生错误。
     *
     * @since v4.0.0
     */
    QNAudioMixErrorReadDataError = 22008,
    
    /*!
     * @abstract set property error
     *
     * @discussion 混音参数设置错误。
     *
     * @since v4.0.0
     */
    QNAudioMixErrorPropertyError = 22009,
    
    /*!
     * @abstract callback error
     *
     * @discussion 配置混音相关回调发生错误。
     *
     * @since v4.0.0
     */
    QNAudioMixErrorCallbackError = 22010,
};

NS_ERROR_ENUM(QNAudioFileErrorDomain) {
    /*!
     * @abstract open audio file failed
     *
     * @since v4.0.0
     */
    QNAudioFileErrorOpenFailed = 30001,
    
    /*!
     * @abstract dispose audio file failed
     *
     * @since v4.0.0
     */
    QNAudioFileErrorDisposeFailed = 30002,
    
    /*!
     * @abstract set/get property error
     *
     * @since v4.0.0
     */
    QNAudioFileErrorPropertyError = 30011,
    
    /*!
     * @abstract read audio file failed
     *
     * @since v4.0.0
     */
    QNAudioFileErrorReadFailed = 30021,
    
    /*!
     * @abstract audio file seek failed
     *
     * @since v4.0.0
     */
    QNAudioFileErrorSeekFailed = 30022,
    
    /*!
     * @abstract audio file not exist
     *
     * @since v4.0.0
     */
    QNAudioFileErrorFileNotExist = 30031,
};

#pragma mark - Media Relay Error Code

NS_ERROR_ENUM(QNMediaRelayErrorDomain) {
    /*!
     * @abstract media relay token error
     *
     * @discussion 跨房转推 Token 错误。
     *
     * @since v4.0.1
     */
    QNMediaRelayErrorTokenError = 24000,
    
    /*!
     * @abstract client mode error
     *
     * @discussion 使用场景不符。
     *
     * @since v4.0.1
     */
    QNRTCErrorInvalidMode  = 24001,
    
    /*!
     * @abstract client role error
     *
     * @discussion 用户角色不符。
     *
     * @since v4.0.1
     */
    QNRTCErrorInvalidRole = 24002,
};

#pragma mark - state define

/*!
 * @abstract 房间连接状态
 */
typedef NS_ENUM(NSUInteger, QNConnectionState) {
    /*!
     * @abstract 空闲状态，初始状态或者退出后都会进入该状态
     *
     * @since v4.0.0
     */
    QNConnectionStateIdle = 0,
    
    /*!
     * @abstract 正在加入的状态
     *
     * @since v4.0.0
     */
    QNConnectionStateConnecting,
    
    /*!
     * @abstract 已加入的状态
     *
     * @since v4.0.0
     */
    QNConnectionStateConnected,
    
    /*!
     * @abstract 正在重连的状态
     *
     * @since v4.0.0
     */
    QNConnectionStateReconnecting,
    
    /*!
     * @abstract 重连成功的状态
     *
     * @discussion 重连成功后，会回调该状态。
     *
     * @since v4.0.0
     */
    QNConnectionStateReconnected
};

/*!
 * @abstract  设备授权状态
 */
typedef NS_ENUM(NSUInteger, QNAuthorizationStatus) {
    /*!
     * @abstract 还没有确定是否授权
     */
    QNAuthorizationStatusNotDetermined = 0,
    
    /*!
     * @abstract 设备受限，一般在家长模式下设备会受限
     */
    QNAuthorizationStatusRestricted,
    
    /*!
     * @abstract 拒绝授权
     */
    QNAuthorizationStatusDenied,
    
    /*!
     * @abstract 已授权
     */
    QNAuthorizationStatusAuthorized
};

/*!
 * @abstract 音频播放状态
 */
typedef NS_ENUM(NSUInteger, QNAudioPlayState) {
    /*!
     * @abstract 初始状态
     *
     * @since v4.0.0
     */
    QNAudioPlayStateInit = 0,
    
    /*!
     * @abstract 准备播放的状态
     *
     * @since v4.0.0
     */
    QNAudioPlayStateReady,
    
    /*!
     * @abstract 正在播放的状态
     *
     * @since v4.0.0
     */
    QNAudioPlayStatePlaying,
    
    /*!
     * @abstract 数据缓冲的状态
     *
     * @since v4.0.0
     */
    QNAudioPlayStateBuffering,
    
    /*!
     * @abstract 播放暂停的状态
     *
     * @since v4.0.0
     */
    QNAudioPlayStatePaused,
    
    /*!
     * @abstract 停止播放的状态
     *
     * @since v4.0.0
     */
    QNAudioPlayStateStoped,
    
    /*!
     * @abstract 播放完成的状态
     *
     * @since v4.0.0
     */
    QNAudioPlayStateCompleted,
    
    /*!
     * @abstract 播放发生错误的状态
     *
     * @since v4.0.0
     */
    QNAudioPlayStateError,
    
    /*!
     * @abstract 播放发生未知错误的状态
     *
     * @since v4.0.0
     */
    QNAudioPlayStateUnknow,
};

#pragma mark - type define

/*!
 * @typedef QNTrackKind
 *
 * @abstract 定义 Track 的类型。
 */
typedef NS_ENUM(NSUInteger, QNTrackKind) {
    /*!
     * @abstract 音频 Track
     */
    QNTrackKindAudio = 0,
    
    /*!
     * @abstract 视频 Track
     */
    QNTrackKindVideo = 1,
};

/*!
 * @abstract 音频设备的类型
 *
 * @since v4.0.0
 */
typedef NS_ENUM(NSUInteger, QNAudioDeviceType) {
    /*!
     * @abstract 扬声器
     */
    QNAudioDeviceTypeSpeaker = 0,
    
    /*!
     * @abstract 听筒
     */
    QNAudioDeviceTypeReceiver = 1,
    
    /*!
     * @abstract 有线耳机
     */
    QNAudioDeviceTypeWiredHeadphone = 2,
    
    /*!
     * @abstract 蓝牙
     */
    QNAudioDeviceTypeBluetooth = 3
};

/*!
 * @abstract Track 的数据源
 *
 * @since v4.0.0
 */
typedef NS_ENUM(NSUInteger, QNRTCSourceType) {
    /*!
     * @abstract 摄像头采集
     */
    QNRTCSourceTypeCamera = 0,
    
    /*!
     * @abstract 录屏采集
     */
    QNRTCSourceTypeScreenRecorder = 1,
    
    /*!
     * @abstract 外部导入
     */
    QNRTCSourceTypeExternalVideo = 2,

    /*!
     * @abstract 音频
     */
    QNRTCSourceTypeAudio = 100,
};

/*!
 * @abstract 媒体流的连接方式
 *
 * @since v4.0.0
 */
typedef NS_ENUM(NSUInteger, QNRTCPolicy) {
    /*!
     * @abstract 使用 UDP
     */
    QNRTCPolicyForceUDP = 0,
    
    /*!
     * @abstract 使用 TCP
     */
    QNRTCPolicyForceTCP,
    
    /*!
     * @abstract 优先 UDP，不通的话自动改为 TCP
     */
    QNRTCPolicyPreferUDP,
};

/*!
 * @abstract 带宽估计的策略
 *
 * @since v4.0.0
 */
typedef NS_ENUM(NSUInteger, QNRTCBWEPolicy) {
    /*!
     * @abstract 使用 TCC
     */
    QNRTCBWEPolicyTCC = 0,
    
    /*!
     * @abstract 使用 GCC
     */
    QNRTCBWEPolicyGCC = 1,
};

/*!
 * @abstract 视频填充模式
 */
typedef enum {
    /*!
     @abstract default
     */
    QNVideoFillModeNone,
    
    /*!
     @abstract Stretch to fill the full view, which may distort the image outside of its normal aspect ratio
     */
    QNVideoFillModeStretch,
    
    /*!
     @abstract Maintains the aspect ratio of the source image, adding bars of the specified background color
     */
    QNVideoFillModePreserveAspectRatio,
    
    /*!
     @abstract Maintains the aspect ratio of the source image, zooming in on its center to fill the view
     */
    QNVideoFillModePreserveAspectRatioAndFill
} QNVideoFillModeType;

/*!
 * @abstract 网络质量等级
 */
typedef NS_ENUM(NSUInteger, QNNetworkGrade) {
    /*!
     * @abstract 初始状态
     *
     * @since v4.0.0
     */
    QNNetworkGradeInvalid = 0,
    
    /*!
     * @abstract 网络优
     *
     * @since v4.0.0
     */
    QNNetworkGradeExcellent,
    
    /*!
     * @abstract 网络良
     *
     * @since v4.0.0
     */
    QNNetworkGradeGood,
    
    /*!
     * @abstract 网络一般
     *
     * @since v4.0.0
     */
    QNNetworkGradeGeneral,
    
    /*!
     * @abstract 网络差
     *
     * @since v4.0.0
     */
    QNNetworkGradePoor,
};

///客户端场景
typedef NS_ENUM(NSUInteger, QNClientMode) {
    /*!
     * @abstract 通信场景，用于常见的一对一通话或群聊，该场景中的用户均可以发布和订阅音视频轨道。
     *
     * @since v4.0.1
     */
    QNClientModeRTC = 0,
    /*!
     * @abstract 直播场景，有主播和观众两种用户角色，可以通过 setClientRole 方法设置用户角色为主播或观众。主播可以发布和订阅音视频轨道，而观众只能订阅音视频轨道，无法发布。
     *
     * @warning 直播场景中的用户角色默认为观众。如需发布音视频，必须将角色修改为主播。
     *
     * @since v4.0.1
     */
    QNClientModeLive = 1,
};

///用户角色
typedef NS_ENUM(NSUInteger, QNClientRole) {
    /*!
     * @abstract 主播角色，拥有发布和订阅媒体流的权限，仅适用于直播场景。
     *
     * @since v4.0.1
     */
    QNClientRoleBroadcaster = 0,
    /*!
     * @abstract 观众角色，仅有订阅媒体流的权限，仅适用于直播场景。
     *
     * @since v4.0.1
     */
    QNClientRoleAudience = 1,
};

///直播房间中观众端（用户角色为观众的客户端）的延时级别。仅在用户角色设为 QNClientRoleAudience 时才生效。
typedef NS_ENUM(NSUInteger, QNAudienceLatencyLevelType) {
    /*!
     * @abstract 低延时。
     *
     * @since v4.0.1
     */
    QNAudienceLatencyLevelLowLatency = 0,
    /*!
     * @abstract（默认）超低延时。
     *
     * @since v4.0.1
     */
    QNAudienceLatencyLevelUltraLowLatency = 1,
};

///跨房媒体转发状态
typedef NS_ENUM(NSUInteger, QNMediaRelayState) {
    /*!
     * @abstract 成功
     *
     * @since v4.0.1
     */
    QNMediaRelayStateSuccess = 0,
    /*!
     * @abstract 主动停止
     *
     * @since v4.0.1
     */
    QNMediaRelayStateStopped  = 1,
    /*!
     * @abstract 无效token
     *
     * @since v4.0.1
     */
    QNMediaRelayStateInvalidToken = 2,
    /*!
     * @abstract 目标房间不存在
     *
     * @since v4.0.1
     */
    QNMediaRelayStateNoRoom = 3,
    /*!
     * @abstract 目标房间已关闭
     *
     * @since v4.0.1
     */
    QNMediaRelayStateRoomClosed = 4,
    /*!
     * @abstract 目标房间存在相同用户名
     *
     * @since v4.0.1
     */
    QNMediaRelayStatePlayerExisted = 5,
};


/*!
 * @abstract 大小流等级
 */
typedef NS_ENUM(NSUInteger, QNTrackProfile) {
    /*!
     * @abstract 低分辨率
     *
     * @since v4.0.0
     */
    QNTrackProfileLow = 0,
    
    /*!
     * @abstract 中分辨率
     *
     * @since v4.0.0
     */
    QNTrackProfileMedium,
    
    /*!
     * @abstract 高分辨率
     *
     * @since v4.0.0
     */
    QNTrackProfileHigh,
};

/*!
 * @abstract 断联原因
 */
typedef NS_ENUM(NSUInteger, QNConnectionDisconnectedReason) {
    /*!
     * @abstract 主动退出
     *
     * @since v4.0.0
     */
    QNConnectionDisconnectedReasonLeave = 0,
    
    /*!
     * @abstract 被踢出房间
     *
     * @since v4.0.0
     */
    QNConnectionDisconnectedReasonKickedOut,
    
    /*!
     * @abstract 房间被关
     *
     * @since v4.0.0
     */
    QNConnectionDisconnectedReasonRoomClosed,
    
    /*!
     * @abstract 房间人数已满
     *
     * @since v4.0.0
     */
    QNConnectionDisconnectedReasonRoomFull,
    
    /*!
     * @abstract 发生错误异常断开
     *
     * @since v4.0.0
     */
    QNConnectionDisconnectedReasonError,
};

#pragma mark - statistic key define

/*!
 * @abstract 音频码率
 */
extern NSString *QNStatisticAudioBitrateKey;

/*!
 * @abstract 视频码率
 */
extern NSString *QNStatisticVideoBitrateKey;

/*!
 * @abstract 本地音频丢包率
 */
extern NSString *QNStatisticAudioPacketLossRateKey;

/*!
 * @abstract 本地视频丢包率
 */
extern NSString *QNStatisticVideoPacketLossRateKey;

/*!
 * @abstract 远端音频丢包率
 */
extern NSString *QNStatisticAudioRemotePacketLossRateKey;

/*!
 * @abstract 远端视频丢包率
 */
extern NSString *QNStatisticVideoRemotePacketLossRateKey;

/*!
 * @abstract 视频帧率
 */
extern NSString *QNStatisticVideoFrameRateKey;

/*!
 * @abstract 视频分辨率
 */
extern NSString *QNStatisticProfileKey;

/*!
 * @abstract 往返延迟
 */
extern NSString *QNStatisticRttKey;

/*!
 * @abstract 网络等级
 */
extern NSString *QNStatisticNetworkGrade;

#pragma mark - callback define

/*!
 * @typedef QNPublishResultCallback
 *
 * @abstract 用户发布 track 的回调
 */
typedef void (^QNPublishResultCallback)(BOOL onPublished, NSError *error);

/*!
 * @typedef QNClientRoleResultCallback
 *
 * @abstract 设置用户角色的回调
 *
 * @param newRole 设置成功后的新角色
 *
 * @param error 操作失败的错误信息
 */
typedef void (^QNClientRoleResultCallback)(QNClientRole newRole, NSError *error);


/*!
 * @typedef QNMediaRelayResultCallback
 *
 * @abstract 跨房间媒体转发操作的回调
 *
 * @warning 此接口回调的是所有跨房目标房间的状态。具体每个目标房间转发状态，需要参考回调参数中目标房间对应的 QNMediaRelayState
 *
 * @param state 目标房间状态， key 为房间名， value 为状态
 *
 * @param error 操作失败的错误信息
 */
typedef void (^QNMediaRelayResultCallback)(NSDictionary *state, NSError *error);
#endif


