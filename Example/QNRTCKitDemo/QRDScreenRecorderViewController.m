//
//  QRDScreenRecorderViewController.m
//  QNRTCKitDemo
//
//  Created by lawder on 2018/6/15.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDScreenRecorderViewController.h"
#import "UIView+Alert.h"

@interface QRDScreenRecorderViewController ()<QNScreenVideoTrackDelegate>

@property (nonatomic, strong) UIView *colorView;

@end

@implementation QRDScreenRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoButton.enabled = NO;
    self.beautyButton.enabled = NO;
    self.togCameraButton.enabled = NO;
}

- (void)setupClient {
    // 1. 初始配置 QNRTC
    [QNRTC initRTC:[QNRTCConfiguration defaultConfiguration]];
    // 2.创建初始化 RTC 核心类 QNRTCClient
    self.client = [QNRTC createRTCClient];
    // 3.设置 QNRTCClientDelegate 状态回调的代理
    self.client.delegate = self;
    
    [self.renderBackgroundView addSubview:self.colorView];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.renderBackgroundView);
    }];
}

- (void)publish {
    // 3.配置音频 track
    self.audioTrack = [QNRTC createMicrophoneAudioTrack];
    self.screenTrack = nil;
    
    // 判断本机系统是否支持录屏
    if (![QNScreenVideoTrack isScreenRecorderAvailable]) {
        [self addLogString:@"该系统版本不支持录屏"];
    } else {
        // 支持，则配置录屏 track（视频 track）
        QNVideoEncoderConfig *config = [[QNVideoEncoderConfig alloc] initWithBitrate:self.bitrate videoEncodeSize:self.videoEncodeSize videoFrameRate:self.frameRate];
        QNScreenVideoTrackConfig * screenConfig = [[QNScreenVideoTrackConfig alloc] initWithSourceTag:screenTag config:config];
        self.screenTrack = [QNRTC createScreenVideoTrackWithConfig:screenConfig];
        self.screenTrack.screenDelegate = self;
    }
    
    // 4.发布音视频 track
    if (self.screenTrack) {
        [self.client publish:@[self.audioTrack, self.screenTrack] completeCallback:^(BOOL onPublished, NSError *error) {
            if (onPublished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.microphoneButton.enabled = YES;
                    self.isAudioPublished = YES;
                    
                    self.isScreenPublished = YES;
                });
            }
            
        }];
    } else {
        [self.client publish:@[self.audioTrack] completeCallback:^(BOOL onPublished, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (onPublished) {
                    self.microphoneButton.enabled = YES;
                    self.isAudioPublished = YES;
                }
            });
        }];
    }
}

/**
 * 房间状态变更的回调。当状态变为 QNConnectionStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leave 即可
 */
- (void)RTCClient:(QNRTCClient *)client didConnectionStateChanged:(QNConnectionState)state disconnectedInfo:(QNConnectionDisconnectedInfo *)info {
    [super RTCClient:client didConnectionStateChanged:state disconnectedInfo:info];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoButton.enabled = NO;
        self.beautyButton.enabled = NO;
        self.togCameraButton.enabled = NO;
    });
}

/// QNScreenVideoTrackDelegate
- (void)screenVideoTrack:(QNScreenVideoTrack *)screenVideoTrack didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view showFailTip:error.description];
    });
}

@end
