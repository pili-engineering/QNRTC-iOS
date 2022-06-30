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

@interface QRDScreenMainViewController ()<QNScreenVideoTrackDelegate>

@end

@implementation QRDScreenMainViewController

- (void)publish {
    self.audioTrack = [QNRTC createMicrophoneAudioTrack];

    self.screenTrack = nil;
    if (![QNScreenVideoTrack isScreenRecorderAvailable]) {
        [self addLogString:@"该系统版本不支持录屏"];
    } else {
        QNVideoEncoderConfig *config = [[QNVideoEncoderConfig alloc] initWithBitrate:self.bitrate videoEncodeSize:self.videoEncodeSize videoFrameRate:self.frameRate];
        QNScreenVideoTrackConfig * screenConfig = [[QNScreenVideoTrackConfig alloc] initWithSourceTag:screenTag config:config];
        self.screenTrack = [QNRTC createScreenVideoTrackWithConfig:screenConfig];
        self.screenTrack.screenDelegate = self;
    }

    if (self.screenTrack) {
        // cameraTrack 摄像头采集的 track
        // screenTrack 屏幕录制的 track
        [self.client publish:@[self.audioTrack, self.cameraTrack, self.screenTrack] completeCallback:^(BOOL onPublished, NSError *error) {
            if (onPublished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.microphoneButton.enabled = YES;
                    self.isAudioPublished = YES;
                    
                    self.videoButton.enabled = YES;
                    self.isVideoPublished = YES;
                    
                    self.isScreenPublished = YES;
                });
            }
        }];
    } else {
        [self.client publish:@[self.audioTrack, self.cameraTrack] completeCallback:^(BOOL onPublished, NSError *error) {
            if (onPublished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.microphoneButton.enabled = YES;
                    self.isAudioPublished = YES;
                    
                    self.videoButton.enabled = YES;
                    self.isVideoPublished = YES;
                });
            }
        } ];
    }
}

/// QNScreenVideoTrackDelegate
- (void)screenVideoTrack:(QNScreenVideoTrack *)screenVideoTrack didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view showFailTip:error.description];
    });
}

@end
