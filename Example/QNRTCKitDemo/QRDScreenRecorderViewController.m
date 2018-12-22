//
//  QRDScreenRecorderViewController.m
//  QNRTCKitDemo
//
//  Created by lawder on 2018/6/15.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDScreenRecorderViewController.h"

@interface QRDScreenRecorderViewController ()

@property (nonatomic, strong) UIView *colorView;

@end

@implementation QRDScreenRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoButton.enabled = NO;
    self.beautyButton.enabled = NO;
    self.togCameraButton.enabled = NO;
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
    QNTrackInfo *screenTrack = nil;
    if (![QNRTCEngine isScreenRecorderAvailable]) {
        [self addLogString:@"该系统版本不支持录屏"];
    } else {
        screenTrack = [[QNTrackInfo alloc] initWithSourceType:QNRTCSourceTypeScreenRecorder
                                                          tag:screenTag
                                                       master:YES
                                                   bitrateBps:self.bitrate
                                              videoEncodeSize:self.videoEncodeSize];
    }
    
    if (screenTrack) {
        [self.engine publishTracks:@[audioTrack, screenTrack]];
    } else {
        [self.engine publishTracks:@[audioTrack]];
    }
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
