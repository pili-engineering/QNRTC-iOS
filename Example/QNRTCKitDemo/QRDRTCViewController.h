//
//  QRDRTCViewController.h
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/18.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDBaseViewController.h"

static NSString *cameraTag = @"camera";
static NSString *screenTag = @"screen";

@interface QRDRTCViewController : QRDBaseViewController

@property (nonatomic, strong) NSDictionary *configDic;

@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSTimer *durationTimer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) UIView *bottomButtonView;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *microphoneButton;
@property (nonatomic, strong) UIButton *speakerButton;
@property (nonatomic, strong) UIButton *beautyButton;
@property (nonatomic, strong) UIButton *togCameraButton;
@property (nonatomic, strong) UIButton *conferenceButton;
@property (nonatomic, strong) UIButton *logButton;
@property (nonatomic, strong) UIButton *mergeButton;

@property (nonatomic, assign) BOOL isAudioPublished;
@property (nonatomic, assign) BOOL isVideoPublished;
@property (nonatomic, assign) BOOL isScreenPublished;
@property (nonatomic, strong) QNTrackInfo *screenTrackInfo;
@property (nonatomic, strong) QNTrackInfo *cameraTrackInfo;
@property (nonatomic, strong) QNTrackInfo *audioTrackInfo;

@property (nonatomic, assign) CGSize videoEncodeSize;
@property (nonatomic, assign) NSInteger bitrate;

- (void)publish;

@end
