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
    // 1.初始化
    self.engine = [[QNRTCEngine alloc] init];
    // 2.设置回调代理
    self.engine.delegate = self;
    
    self.engine.statisticInterval = 5;
    
    [self.renderBackgroundView addSubview:self.colorView];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.renderBackgroundView);
    }];
}

- (void)publish {
    // 3.配置音频 track
    QNTrackInfo *audioTrack = [[QNTrackInfo alloc] initWithSourceType:QNRTCSourceTypeAudio master:YES];
    QNTrackInfo *screenTrack = nil;
    
    // 判断本机系统是否支持录屏
    if (![QNRTCEngine isScreenRecorderAvailable]) {
        [self addLogString:@"该系统版本不支持录屏"];
    } else {
        // 支持，则配置录屏 track（视频 track）
        screenTrack = [[QNTrackInfo alloc] initWithSourceType:QNRTCSourceTypeScreenRecorder
                                                          tag:screenTag
                                                       master:YES
                                                   bitrateBps:self.bitrate
                                              videoEncodeSize:self.videoEncodeSize];
    }
    
    // 4.发布音视频 track
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
