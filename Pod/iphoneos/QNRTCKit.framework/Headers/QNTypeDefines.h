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

extern NSString *QNAudioFileErrorDomain;

#pragma mark - RTC Error Code

NS_ERROR_ENUM(QNRTCErrorDomain)
{
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
     * @abstract room instance closed
     *
     * @discussion 房间实例关闭，用户无需处理。
     */
    QNRTCErrorRoomInstanceClosed                = 10003,
    
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
     * @abstract publish stream not exist
     *
     * @discussion 流不存在。
     */
    QNRTCErrorPublishStreamNotExist             = 10031,
    
    /*!
     * @abstract publish stream info not match
     *
     * @discussion 流信息不匹配。
     */
    QNRTCErrorPublishStreamInfoNotMatch         = 10032,
    
    /*!
     * @abstract publish stream already exist
     *
     * @discussion 流已存在。
     */
    QNRTCErrorPublishStreamAlreadyExist         = 10033,
    
    /*!
     * @abstract publish stream not ready
     *
     * @discussion 流未完成。
     */
    QNRTCErrorPublishStreamNotReady             = 10034,
    
    /*!
     * @abstract subscribe stream not exist
     *
     * @discussion 订阅不存在的流。
     */
    QNRTCErrorSubscribeStreamNotExist           = 10041,
    
    /*!
     * @abstract subscribe stream info not match
     *
     * @discussion 订阅不匹配信息流。
     */
    QNRTCErrorSubscribeStreamInfoNotMatch       = 10042,
    
    /*!
     * @abstract subscribe stream already exist
     *
     * @discussion 订阅已存在流。
     */
    QNRTCErrorSubscribeStreamAlreadyExist       = 10043,
    
    /*!
     * @abstract can't subscribe self
     *
     * @discussion 不能订阅自己。
     */
    QNRTCErrorSubscribeSelf                     = 10044,
    
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
     * @abstract invalid parameter
     *
     * @discussion 参数错误，当用户在进行踢人、合流等操作传入错误的参数时会返回此错误代码。
     */
    QNRTCErrorInvalidParameter                  = 11001,
    
    /*!
     * @abstract auth failed
     *
     * @discussion 鉴权失败，建议用户收到此错误代码时检查网络并尝试重新获取 RoomToken 后再次加入房间。
     */
    QNRTCErrorAuthFailed                        = 11002,
    
    /*!
     * @abstract publish failed
     *
     * @discussion 发布失败。
     */
    QNRTCErrorPublishFailed                     = 11011,
    
    /*!
     * @abstract subscribe failed
     *
     * @discussion 订阅失败。
     */
    QNRTCErrorSubscribeFailed                   = 11012,
    
    /*!
     * @abstract merge failed
     *
     * @discussion 更新合流失败。
     */
    QNRTCErrorUpdateMergeFailed                 = 11013,
    
    /*!
     * @abstract push audioBuffer with asbd convert failed
     *
     * @discussion 音频转码失败。
     */
    QNRTCErrorPushAudioBufferFailed             = 11014,

};

NS_ERROR_ENUM(QNAudioMixErrorDomain)
{
    // new grap failed
    QNAudioMixErrorGraphNewFailed = 20001,
    // add node error
    QNAudioMixErrorAddNodeError = 20002,
    // open graph failed
    QNAudioMixErrorGraphOpenFailed = 20003,
    // get node info error
    QNAudioMixErrorNodeInfoError = 20004,
    // add render callback failed
    QNAudioMixErrorAddRenderFailed = 20005,
    // connect node failed
    QNAudioMixErrorConnectNodeFailed = 20006,
    // set volume failed
    QNAudioMixErrorVolumeFailed = 20011,
    // set/get property error
    QNAudioMixErrorPropertyError = 20012,
    // set node input callback error
    QNAudioMixErrorMixCallbackError = 20013,
    // init graph failed
    QNAudioMixErrorGraphInitFailed = 20021,
    // start graph failed
    QNAudioMixErrorGraphStartFailed = 20022,
    // stop graph failed
    QNAudioMixErrorGraphStopFailed = 20023,
    // read audio data failed
    QNAudioMixErrorReadDataError = 20031,
};

NS_ERROR_ENUM(QNAudioFileErrorDomain)
{
    // open audio file failed
    QNAudioFileErrorOpenFailed = 30001,
    // dispose audio file failed
    QNAudioFileErrorDisposeFailed = 30002,
    // set/get property error
    QNAudioFileErrorPropertyError = 30011,
    // read audio file failed
    QNAudioFileErrorReadFailed = 30021,
    // audio file seek failed
    QNAudioFileErrorSeekFailed = 30022,
    // audio file not exist
    QNAudioFileErrorFileNotExist = 30031,
};

#pragma mark - RTC Video Size

/*!
 @typedef    QNRTCVideoSizePreset
 @abstract   定义连麦时的视频大小。
 */
typedef NS_ENUM(NSUInteger, QNRTCVideoSizePreset) {
    QNRTCVideoSizePresetDefault = 0,    //与采集端保持一致，不作改变
    QNRTCVideoSizePreset144x192,        //4:3
    QNRTCVideoSizePreset176x320,        //16:9
    QNRTCVideoSizePreset240x320,        //4:3
    QNRTCVideoSizePreset240x432,        //16:9
    QNRTCVideoSizePreset368x640,        //16:9
    QNRTCVideoSizePreset480x640,        //4:3
    QNRTCVideoSizePreset544x720,        //4:3
    QNRTCVideoSizePreset544x960,        //16:9
    QNRTCVideoSizePreset720x960,        //4:3
    QNRTCVideoSizePreset720x1280,       //16:9
};

/*!
 @typedef    QNTrackKind
 @abstract   定义 Track 的类型。
 */
typedef NS_ENUM(NSUInteger, QNTrackKind) {
    QNTrackKindAudio = 0,
    QNTrackKindVideo = 1,
};

/*!
 * @abstract Track 的数据源
 *
 * @since v2.0.0
 */
typedef NS_ENUM(NSUInteger, QNRTCSourceType) {
    QNRTCSourceTypeCamera = 0,
    QNRTCSourceTypeScreenRecorder = 1,
    QNRTCSourceTypeExternalVideo = 2,

    QNRTCSourceTypeAudio = 100,
};

///房间状态
typedef NS_ENUM(NSUInteger, QNRoomState) {
    /*!
     * @abstract 空闲状态，初始状态或者退出房间后都会进入该状态
     *
     * @since v1.0.0
     */
    QNRoomStateIdle = 0,
    /*!
     * @abstract 正在加入房间的状态
     *
     * @since v1.0.0
     */
    QNRoomStateConnecting,
    /*!
     * @abstract 已加入房间的状态
     *
     * @since v1.0.0
     */
    QNRoomStateConnected,
    /*!
     * @abstract 正在重连的状态
     *
     * @since v1.0.0
     */
    QNRoomStateReconnecting,
    /*!
     * @abstract 重连成功的状态
     *
     * @discussion 重连成功后，QNRTCEngine 会回调该状态。QNRTCSession 则保持原有的逻辑，继续使用 QNRoomStateConnected 状态
     *
     * @since v2.0.0
     */
    QNRoomStateReconnected
};

/*!
 * @abstract 音频设备的类型
 *
 * @since v2.1.0
 */
typedef NS_ENUM(NSUInteger, QNAudioDeviceType) {
    QNAudioDeviceTypeSpeaker = 0,
    QNAudioDeviceTypeReceiver = 1,
    QNAudioDeviceTypeWiredHeadphone = 2,
    QNAudioDeviceTypeBluetooth = 3
};

/// 设备授权状态
typedef NS_ENUM(NSUInteger, QNAuthorizationStatus) {
    /// 还没有确定是否授权
    QNAuthorizationStatusNotDetermined = 0,
    /// 设备受限，一般在家长模式下设备会受限
    QNAuthorizationStatusRestricted,
    /// 拒绝授权
    QNAuthorizationStatusDenied,
    /// 已授权
    QNAuthorizationStatusAuthorized
};

/*!
 * @abstract 媒体流的连接方式
 *
 * @since v2.2.0
 */
typedef NS_ENUM(NSUInteger, QNRTCPolicy) {
    /// 使用 UDP
    QNRTCPolicyForceUDP = 0,
    /// 使用 TCP
    QNRTCPolicyForceTCP,
    /// 优先 UDP，不通的话自动改为 TCP
    QNRTCPolicyPreferUDP,
};

/*!
 * @abstract 带宽估计的策略
 *
 * @since v2.3.0
 */
typedef NS_ENUM(NSUInteger, QNRTCBWEPolicy) {
    /// 使用 TCC
    QNRTCBWEPolicyTCC = 0,
    /// 使用 GCC
    QNRTCBWEPolicyGCC = 1,
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

///音频播放状态
typedef NS_ENUM(NSUInteger, QNAudioPlayState) {
    /*!
     * @abstract 初始状态
     *
     * @since v2.2.0
     */
    QNAudioPlayStateInit = 0,
    /*!
     * @abstract 准备播放的状态
     *
     * @since v2.2.0
     */
    QNAudioPlayStateReady,
    /*!
     * @abstract 正在播放的状态
     *
     * @since v2.2.0
     */
    QNAudioPlayStatePlaying,
    /*!
     * @abstract 数据缓冲的状态
     *
     * @since v2.2.0
     */
    QNAudioPlayStateBuffering,
    /*!
     * @abstract 播放暂停的状态
     *
     * @since v2.2.0
     */
    QNAudioPlayStatePaused,
    /*!
     * @abstract 停止播放的状态
     *
     * @since v2.2.0
     */
    QNAudioPlayStateStoped,
    /*!
     * @abstract 播放完成的状态
     *
     * @since v2.2.0
     */
    QNAudioPlayStateCompleted,
    /*!
     * @abstract 播放发生错误的状态
     *
     * @since v2.2.0
     */
    QNAudioPlayStateError,
    /*!
     * @abstract 播放发生未知错误的状态
     *
     * @since v2.2.0
     */
    QNAudioPlayStateUnknow,
};

///网络质量等级
typedef NS_ENUM(NSUInteger, QNNetworkGrade) {
    /*!
     * @abstract 初始状态
     *
     * @since v3.0.0
     */
    QNNetworkGradeInvalid = 0,
    /*!
     * @abstract 网络优
     *
     * @since v3.0.0
     */
    QNNetworkGradeExcellent,
    /*!
     * @abstract 网络良
     *
     * @since v3.0.0
     */
    QNNetworkGradeGood,
    /*!
     * @abstract 网络一般
     *
     * @since v3.0.0
     */
    QNNetworkGradeGeneral,
    /*!
     * @abstract 网络差
     *
     * @since v3.0.0
     */
    QNNetworkGradePoor,
};

extern NSString *QNStatisticAudioBitrateKey;
extern NSString *QNStatisticVideoBitrateKey;
extern NSString *QNStatisticVideoFrameRateKey;
extern NSString *QNStatisticAudioPacketLossRateKey;
extern NSString *QNStatisticVideoPacketLossRateKey;
extern NSString *QNStatisticRttKey;
extern NSString *QNStatisticNetworkGrade;
extern NSString *QNStatisticAudioRemotePacketLossRateKey;
extern NSString *QNStatisticVideoRemotePacketLossRateKey;
extern NSString *QNStatisticProfileKey;




#endif


