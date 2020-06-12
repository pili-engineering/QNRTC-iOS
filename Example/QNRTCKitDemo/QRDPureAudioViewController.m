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

- (void)setupEngine {
    self.engine = [[QNRTCEngine alloc] init];
    self.engine.delegate = self;
    self.engine.statisticInterval = 5;
    
    [self.renderBackgroundView addSubview:self.colorView];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.renderBackgroundView);
    }];
}

- (void)publish {
    QNTrackInfo *audioTrack = [[QNTrackInfo alloc] initWithSourceType:QNRTCSourceTypeAudio master:YES];
    // 纯音频则只发布音频 track
    [self.engine publishTracks:@[audioTrack]];
}

/**
 * 房间状态变更的回调。当状态变为 QNRoomStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leaveRoom 即可
 */
- (void)RTCEngine:(QNRTCEngine *)engine roomStateDidChange:(QNRoomState)roomState {
    [super RTCEngine:engine roomStateDidChange:roomState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoButton.enabled = NO;
        self.beautyButton.enabled = NO;
        self.togCameraButton.enabled = NO;
    });
}

@end
