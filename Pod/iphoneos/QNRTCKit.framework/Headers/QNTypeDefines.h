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


///连麦状态
typedef NS_ENUM(NSUInteger, QNRoomState) {
    /// 空闲状态，初始状态或者退出房间后都会进入该状态
    QNRoomStateIdle = 0,
    /// 正在加入房间的状态
    QNRoomStateConnecting,
    /// 已加入房间的状态
    QNRoomStateConnected,
    /// 正在重连的状态
    QNRoomStateReconnecting,
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


extern NSString *QNStatisticAudioBitrateKey;
extern NSString *QNStatisticVideoBitrateKey;
extern NSString *QNStatisticVideoFrameRateKey;
extern NSString *QNStatisticAudioPacketLossRateKey;
extern NSString *QNStatisticVideoPacketLossRateKey;




#endif


