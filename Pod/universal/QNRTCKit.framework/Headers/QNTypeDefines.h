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
    //token error
    QNRTCErrorTokenError                        = 10001,
    //token expired
    QNRTCErrorTokenExpired                      = 10002,
    //room instance closed
    QNRTCErrorRoomInstanceClosed                = 10003,
    //reconnect token error
    QNRTCErrorReconnectTokenError               = 10004,
    //room closed
    QNRTCErrorRoomClosed                        = 10005,
    //room is full
    QNRTCErrorRoomIsFull                        = 10011,
    //room not exist
    QNRTCErrorRoomNotExist                      = 10012,
    //user not exist
    QNRTCErrorUserNotExist                      = 10021,
    //user already exist
    QNRTCErrorUserAlreadyExist                  = 10022,
    //publish stream not exist
    QNRTCErrorPublishStreamNotExist             = 10031,
    //publish stream info not match
    QNRTCErrorPublishStreamInfoNotMatch         = 10032,
    //publish stream already exist
    QNRTCErrorPublishStreamAlreadyExist         = 10033,
    //publish stream not ready
    QNRTCErrorPublishStreamNotReady             = 10034,
    //subscribe stream not exist
    QNRTCErrorSubscribeStreamNotExist           = 10041,
    //subscribe stream info not match
    QNRTCErrorSubscribeStreamInfoNotMatch       = 10042,
    //subscribe stream already exist
    QNRTCErrorSubscribeStreamAlreadyExist       = 10043,
    //can't subscribe self
    QNRTCErrorSubscribeSelf                     = 10044,
    //no permission
    QNRTCErrorNoPermission                      = 10051,
    //server unavailable
    QNRTCErrorServerUnavailable                 = 10052,
    //invalid parameter
    QNRTCErrorInvalidParameter                  = 11001,
    //auth failed
    QNRTCErrorAuthFailed                        = 11002,
    //publish failed
    QNRTCErrorPublishFailed                     = 11011,
    //subscribe failed
    QNRTCErrorSubscribeFailed                   = 11012,
    //merge failed
    QNRTCErrorUpdateMergeFailed                 = 11013,
    //push audioBuffer with asbd convert failed
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

extern NSString *QNStatisticAudioBitrateKey;
extern NSString *QNStatisticVideoBitrateKey;
extern NSString *QNStatisticVideoFrameRateKey;
extern NSString *QNStatisticAudioPacketLossRateKey;
extern NSString *QNStatisticVideoPacketLossRateKey;




#endif


