//
//  QRDPureAudioViewController.m
//  QNRTCKitDemo
//
//  Created by hxiongan on 2018/12/18.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDPureAudioViewController.h"

@interface QRDPureAudioViewController ()

@end

@implementation QRDPureAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoButton.enabled = NO;
    self.beautyButton.enabled = NO;
    self.togCameraButton.enabled = NO;
    // Do any additional setup after loading the view.
}

- (void)setupClient {
    [QNRTC initRTC:[QNRTCConfiguration defaultConfiguration]];
    // 1.创建初始化 RTC 核心类 QNRTCClient
    self.client = [QNRTC createRTCClient];
    self.client.delegate = self;
    
    [self.renderBackgroundView addSubview:self.colorView];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.renderBackgroundView);
    }];
}

- (void)publish {
    self.audioTrack = [QNRTC createMicrophoneAudioTrack];
    // 纯音频则只发布音频 track
    [self.client publish:@[self.audioTrack] completeCallback:^(BOOL onPublished, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.microphoneButton.enabled = YES;
            self.isAudioPublished = YES;
        });
    }];
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

@end
