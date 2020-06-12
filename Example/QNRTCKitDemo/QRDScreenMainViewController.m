//
//  QRDScreenMainViewController.m
//  QNRTCTestDemo
//
//  Created by hxiongan on 2018/8/21.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import "QRDScreenMainViewController.h"
#import "QRDMicrophoneSource.h"
#import <ReplayKit/ReplayKit.h>
#import "UIView+Alert.h"

@interface QRDScreenMainViewController ()

@end

@implementation QRDScreenMainViewController

- (void)publish {
    
    QNTrackInfo *audioTrack = [[QNTrackInfo alloc] initWithSourceType:QNRTCSourceTypeAudio master:YES];
    QNTrackInfo *cameraTrack =  [[QNTrackInfo alloc] initWithSourceType:(QNRTCSourceTypeCamera)
                                                                    tag:cameraTag
                                                                 master:YES
                                                             bitrateBps:self.bitrate
                                                        videoEncodeSize:self.videoEncodeSize];
    QNTrackInfo *screenTrack = nil;
    if (![QNRTCEngine isScreenRecorderAvailable]) {
        [self addLogString:@"该系统版本不支持录屏"];
    } else {
        screenTrack = [[QNTrackInfo alloc] initWithSourceType:QNRTCSourceTypeScreenRecorder
                                                          tag:screenTag
                                                       master:NO
                                                   bitrateBps:self.bitrate
                                              videoEncodeSize:self.videoEncodeSize];
    }

    if (screenTrack) {
        // cameraTrack 摄像头采集的 track
        // screenTrack 屏幕录制的 track
        [self.engine publishTracks:@[audioTrack, cameraTrack, screenTrack]];
    } else {
        [self.engine publishTracks:@[audioTrack, cameraTrack]];
    }
}

@end
