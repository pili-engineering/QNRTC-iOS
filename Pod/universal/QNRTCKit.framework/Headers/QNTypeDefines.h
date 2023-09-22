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

extern NSString *QNMediaRelayErrorDomain;

extern NSString *QNAudioMixErrorDomain;

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
     * @abstract room closed
     *
     * @discussion 房间被管理员关闭。
     */
    QNRTCErrorRoomClosed                        = 10005,
    
    /*!
     * @abstract room is full
     *
     * @discussion 房间人数已超过限制。
     */
    QNRTCErrorRoomIsFull                        = 10011,
        
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
     * @abstract Subscriber Disconnected, or not exist
     *
     * @discussion 订阅失败，或订阅不存在，用户无需处理。
     */
    QNRTCErrorSubscribeDisconnected             = 10062,

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
     * @abstract network request timeout
     *
     * @discussion 网络超时。
     *
     * @since v4.0.1
     */
    QNRTCErrorNetworkTimeout                   = 21004,
    
    /*!
     * @abstract fatal error
     *
     * @discussion 非预期错误。
     *
     * @since v4.0.0
     */
    QNRTCErrorFatalError                        = 21005,
    
    /*!
     * @abstract CDN stream not exist
     *
     * @discussion 流不存在
     */
    QNRTCErrorStreamNotExistError               = 21006,
    
    /*!
     * @abstract Server unavailable
     *
     * @discussion 服务不可用
     */
    QNRTCErrorServerUnavailable                 = 21007,
    
    /*!
     * @abstract Operation Timeout
     *
     * @discussion 操作超时
     */
    QNRTCErrorOperationTimeoutError             = 21008,
    
    /*!
     * @abstract live streaming closed by server
     *
     * @discussion 流被服务端关闭
     */
    QNRTCErrorLiveStreamingClosedError          = 21009,
    
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
    
    /*!
     * @abstract upload log file with fetch token failed
     *
     * @discussion 上传日志获取 token 失败
     */
    QNRTCErrorFetchToken                        = 25001,
    
    /*!
     * @abstract upload log file failed
     *
     * @discussion 上传日志文件读取失败
     */
    QNRTCErrorReadFile                          = 25002,
    
    /*!
     * @abstract invalid dir
     *
     * @discussion 上传日志路径无效
     */
    QNRTCErrorInvalidDir                        = 25003,
    
    /*!
     * @abstract image parser failed
     *
     * @discussion 推图片图片解析失败
     */
    QNRTCErrorImageParserFailed                 = 25004,
    
};

#pragma mark - Audio Mix Error Code

NS_ERROR_ENUM(QNAudioMixErrorDomain) {
    /*!
     * @abstract audio data resample error
     *
     * @since v5.0.0
     */
    QNAudioMixErrorResampleFailed = 22001,
    
    /*!
     * @abstract audio not found error
     *
     * @since v5.0.0
     */
    QNAudioMixErrorAudioNotFound = 22002,
    
    /*!
     * @abstract IO exception error
     *
     * @since v5.0.0
     */
    QNAudioMixErrorIOException = 22003,


    /*!
     * @abstract decode error
     *
     * @since v5.0.0
     */
    QNAudioMixErrorDecoderException = 22004,
    
    /*!
     * @abstract seek failed
     *
     * @since v5.0.0
     */
    QNAudioMixErrorSeekFailed  = 22005,
    
    /*!
     * @abstract invalid ID
     *
     * @since v5.2.0
     */
    QNAudioMixErrorInvalidID  = 22011
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
     * @abstract relay already started
     *
     * @discussion 当前跨房已开始。
     *
     * @since v5.0.0
     */
    QNMediaRelayErrorAlreadyStart  = 24001,
    
    /*!
     * @abstract relay not started
     *
     * @discussion 当前跨房未开始。
     *
     * @since v5.0.0
     */
    QNMediaRelayErrorNotStart  = 24002,
    
    /*!
     * @abstract destination room not existed
     *
     * @discussion 目标房间不存在。
     *
     * @since v5.0.0
     */
    QNMediaRelayErrorDestinationRoomNotExisted  = 24003,
    
    /*!
     * @abstract player in dest room
     *
     * @discussion 已在房间内。
     *
     * @since v5.0.0
     */
    QNMediaRelayErrorPlayerInDestRoom  = 24004,
    
    /*!
     * @abstract relay start failed
     *
     * @discussion 开始失败。
     *
     * @since v5.0.0
     */
    QNMediaRelayErrorStartFailed  = 24005,
    
    /*!
     * @abstract client mode error
     *
     * @discussion 使用场景不符。
     *
     * @since v4.0.1
     */
    QNRTCErrorInvalidMode  = 24006,
    
    /*!
     * @abstract client role error
     *
     * @discussion 用户角色不符。
     *
     * @since v4.0.1
     */
    QNRTCErrorInvalidRole = 24007,
};

#pragma mark - state define

/*!
 * @abstract 房间连接状态
 */
typedef NS_ENUM(NSUInteger, QNConnectionState) {
    /*!
     * @abstract 初始状态或者退出后都会进入该状态
     *
     * @since v5.0.0
     */
    QNConnectionStateDisconnected = 0,
    
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
 * @abstract 背景音乐混音状态
 */
typedef NS_ENUM(NSUInteger, QNAudioMusicMixerState) {
    /*!
     * @abstract 初始状态
     *
     * @since v5.0.0
     */
    QNAudioMusicMixerStateIdle = 0,
    
    /*!
     * @abstract 正在混音的状态
     *
     * @since v5.0.0
     */
    QNAudioMusicMixerStateMixing,
    
    /*!
     * @abstract 暂停混音的状态
     *
     * @since v5.0.0
     */
    QNAudioMusicMixerStatePaused,
    
    /*!
     * @abstract 停止混音的状态
     *
     * @since v5.0.0
     */
    QNAudioMusicMixerStateStopped,
    
    /*!
     * @abstract 混音完成的状态
     *
     * @since v5.0.0
     */
    QNAudioMusicMixerStateCompleted
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
    /*!
     * @abstract 未知状态
     *
     * @since v5.0.0
     */
    QNMediaRelayStateUnknown = 0XFF
};

//视频填充模式
typedef enum {
    
    /**
     @brief default
     */
    QNVideoFillModeNone,
    
    /**
     @brief Stretch to fill the full view, which may distort the image outside of its normal aspect ratio
     */
    QNVideoFillModeStretch,
    
    /**
     @brief Maintains the aspect ratio of the source image, adding bars of the specified background color
     */
    QNVideoFillModePreserveAspectRatio,
    
    /**
     @brief Maintains the aspect ratio of the source image, zooming in on its center to fill the view
     */
    QNVideoFillModePreserveAspectRatioAndFill
} QNVideoFillModeType;


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

/*!
 * @abstract 视频质量降级模式
 */
typedef NS_ENUM(NSUInteger, QNDegradationPreference) {
    /*!
     * @abstract 保持帧率
     *
     * @discussion 保持帧率, 降低分辨率和适当的码率
     *
     * @since v5.2.3
     */
    QNDegradationMaintainFrameRate = 0,
    
    /*!
     * @abstract 保持分辨率
     *
     * @discussion 保持分辨率, 降低帧率和适当的码率
     *
     * @since v5.2.3
     */
    QNDegradationMaintainResolution,
    
    /*!
     * @abstract 平衡调节分辨率和帧率
     *
     * @discussion 平衡模式, 降低帧率，分辨率和适当的码率
     *
     * @since v5.2.3
     */
    QNDegradationBlanced,
    
    /*!
     * @abstract 保持分辨率和帧率，适当调节码率
     *
     * @discussion 仅控制码率, 保持帧率和分辨率
     *
     * @since v5.2.3
     */
    QNDegradationAdaptBitrateOnly,
    
    /*!
     * @abstract 默认值
     *
     * @discussion RTC 模式下使用 QNDegradationBlanced，Live 模式下使用 QNDegradationMaintainResolution
     *
     * @since v5.2.4
     */
    QNDegradationDefault,
};

/*!
 * @abstract 音频场景
 */
typedef NS_ENUM(NSUInteger, QNAudioScene) {
    /*!
     * @abstract 默认音频场景
     *
     * @warning 仅发布或仅订阅时，SDK 使用媒体模式；同时发布和订阅时，SDK 自动切换到通话模式
     *
     * @since v5.2.3
     */
    QNAudioSceneDefault = 0,
    
    /*!
     * @abstract 清晰语聊场景
     *
     * @warning 使用通话模式；为了人声清晰，环境音和音乐声会有一定抑制
     *
     * @since v5.2.3
     */
    QNAudioSceneVoiceChat,
    
    /*!
     * @abstract 音质均衡场景
     *
     * @warning 使用媒体模式；平衡音质，对环境音和音乐声的还原性更优
     *
     * @since v5.2.3
     */
    QNAudioSceneSoundEqualize,
};

/*!
 * @typedef QNVideoEncoderType
 *
 * @abstract 定义视频编码类型
 */
typedef NS_ENUM(NSUInteger, QNVideoEncoderType) {
    /*!
     * @abstract videoToolbox 编码器
     *
     * @since v5.2.4
     */
    QNVideoEncoderToolboxH264 = 0,
    
    /*!
     * @abstract 七牛自定义 openh264
     *
     * @since v5.2.4
     */
    QNVideoEncoderOpenH264 = 1,
};

/*!
 * @abstract 视频编码预设
 */
typedef NS_ENUM(NSUInteger, QNVideoFormatPreset) {
    /*!
     * @abstract 分辨率 320x180, 15fps, 400kbps(RTC), 500kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset320x180_15 = 0,
    
    /*!
     * @abstract 分辨率 320x240, 15fps, 500kbps(RTC), 600kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset320x240_15,
    
    /*!
     * @abstract 分辨率 640x360, 15fps, 700kbps(RTC), 800kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset640x360_15,
    
    /*!
     * @abstract 分辨率 640x360, 30fps, 850kbps(RTC), 1050kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset640x360_30,
    
    /*!
     * @abstract 分辨率 640x480, 15fps, 800kbps(RTC), 1100kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset640x480_15,
    
    /*!
     * @abstract 分辨率 640x480, 30fps, 1100kbps(RTC), 1400kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset640x480_30,
    
    /*!
     * @abstract 分辨率 960x540, 15fps, 1000kbps(RTC), 1300kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset960x540_15,
    
    /*!
     * @abstract 分辨率 960x540, 30fps, 1400kbps(RTC), 1700kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset960x540_30,
    
    /*!
     * @abstract 分辨率 960x720, 30fps, 1300kbps(RTC), 1700kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset960x720_15,
    
    /*!
     * @abstract 分辨率 960x720, 30fps, 1700kbps(RTC), 2400kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset960x720_30,
    
    /*!
     * @abstract 分辨率 1280x720, 15fps, 1600kbps(RTC), 2000kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset1280x720_15,
    
    /*!
     * @abstract 分辨率 1280x720, 30fps, 2200kbps(RTC), 2900kbps(Live)
     *
     * @since v5.2.4
     */
    QNVideoFormatPreset1280x720_30,
    
    /*!
     * @abstract 无编码预设
     *
     * @since v5.2.4
     */
    QNVideoFormatPresetNone = 0XFF,
};

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

/*!
 * @typedef QNUploadLogResultCallback
 *
 * @abstract 日志文件上传结果的 Callback
 *
 * @warning 此接口的回调在调用 setLogConfig 设置日志文件配置之后才会有效，如有需要可关注返回的 code 值，方便定位失败原因
 *
 * @param fileName 文件名
 *
 * @param code 错误码
 *
 * @param remaining 剩余文件个数
 *
 * @since v5.2.3
 */
typedef void (^QNUploadLogResultCallback)(NSString *fileName, int code, int remaining);

/*!
 * @typedef QNCameraSwitchResultCallback
 *
 * @abstract 切换摄像头返回结果的 Callback
 *
 * @warning 此接口的回调在调用 switchCamera 配置之后返回
 *
 * @param isFrontCamera 是否是前置
 *
 * @param errorMessage 错误信息
 *
 * @since v5.2.3
 */
typedef void (^QNCameraSwitchResultCallback)(BOOL isFrontCamera, NSString *errorMessage);

#endif
