//
//  QRDRTCViewController.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/18.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDRTCViewController.h"
#import <QNRTCKit/QNRTCKit.h>
#import "QRDUserView.h"

#define QRD_BUTTON_SPACE (QRD_SCREEN_WIDTH - 54 * 3)/4
#define DOUBLE_VALUE_IS_ZERO(fValue) (fabs((double)(fValue)) < (1e-6))



static CGSize backgroundSize = {480, 848};

@interface QRDRTCViewController ()
<
QNRTCSessionDelegate,
QRDUserViewDelegate
>

@property (nonatomic, strong) QNRTCSession *session;
@property (nonatomic, strong) UIButton *logButton;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *microphoneButton;
@property (nonatomic, strong) UIButton *speakerButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *beautyButton;
@property (nonatomic, strong) UIButton *conferenceButton;
@property (nonatomic, strong) UIButton *toggleButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSTimer *durationTimer;
@property (nonatomic, assign) NSInteger totalDuration;
@property (nonatomic, assign) BOOL hiddenEnable;

@property (nonatomic, strong) UIImageView *ownMicroImageView;
@property (nonatomic, strong) UILabel *userIdLabel;

@property (nonatomic, strong) UIView *logView;
@property (nonatomic, strong) UITextView *statisTextView;
@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, copy) NSString *logString;

@property (nonatomic, strong) NSMutableArray *renderArray;

@property (nonatomic, strong) NSString *roomToken;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, copy) NSString *kickUserString;

@property (nonatomic, assign) BOOL reconnecting;

@property (nonatomic, strong) NSMutableArray *mergePositionArray;
@property (nonatomic, strong) QRDUserView *videoView;
@property (nonatomic, strong) UITapGestureRecognizer *viewSwitchGesture;

@property (nonatomic, strong) NSDate *startTime;

@end

@implementation QRDRTCViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarHidden = !QRD_iPhoneX;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QRD_COLOR_RGBA(20, 20, 20, 1);
    
    _viewSwitchGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewSwitch:)];
    self.renderArray = [NSMutableArray array];
    self.mergePositionArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i++) {
        self.mergePositionArray[i] = @"";
    }
    self.totalDuration = 0;
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    self.logString = [NSString stringWithFormat:@"version: %@\nbundle id:\n%@\n", [QNRTCSession versionInfo], bundleId];
    self.hiddenEnable = YES;
    
    self.ownMicroImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _ownMicroImageView.image = [UIImage imageNamed:@"un_mute_audio"];
    
    self.colorArray = @[QRD_HEAD_BLUE_COLOR,    QRD_HEAD_ORANGE_COLOR,  QRD_HEAD_YELLOW_COLOR,
                        QRD_HEAD_GREEN_COLOR,   QRD_HEAD_RED_COLOR,     QRD_HEAD_CYAN_COLOR,
                        QRD_HEAD_BLUE_COLOR,    QRD_HEAD_ORANGE_COLOR,  QRD_HEAD_YELLOW_COLOR];

    [self setupRTCSession];
    [self setupRTCButtonView];
}

- (void)setupRTCSession {
    self.session = [[QNRTCSession alloc] init];
    self.session.delegate = self;
    self.session.statisticInterval = 3.0;
    [self.view insertSubview:self.session.previewView atIndex:0];
    if (self.videoEnabled) {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        self.session.videoEncodeSize = CGSizeFromString(_configDic[@"VideoSize"]);
        self.session.videoFrameRate = [_configDic[@"FrameRate"] integerValue];
        NSInteger bitrate = [_configDic[@"Bitrate"] integerValue];
        [self.session setMinBitrateBps:bitrate * 0.7  maxBitrateBps:bitrate];
        [self.session startCapture];
    }

    self.userIdLabel = [[UILabel alloc] initWithFrame:self.session.previewView.bounds];
    self.userIdLabel.backgroundColor = self.colorArray[0];
    self.userIdLabel.textColor = [UIColor whiteColor];
    self.userIdLabel.textAlignment = NSTextAlignmentCenter;
    self.userIdLabel.text = self.userId;
    self.userIdLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.session.previewView addSubview:self.userIdLabel];
    self.userIdLabel.hidden = self.videoEnabled;
    
    [QNRTCSession requestCameraAccessWithCompletionHandler:^(BOOL granted) {
        if ([QNRTCSession cameraAuthorizationStatus] != QNAuthorizationStatusAuthorized) {
            [self showAlertWithMessage:@"请授权允许访问相机！" state:0];
        }
    }];

    [QNRTCSession requestMicrophoneAccessWithCompletionHandler:^(BOOL granted) {
        if ([QNRTCSession microphoneAuthorizationStatus] != QNAuthorizationStatusAuthorized) {
            [self showAlertWithMessage:@"请授权允许访问麦克风！" state:0];
        }
    }];
    
    [self requestTokenWithCompletionHandler:^(NSError *error, NSString *token) {
        if (error) {
            [self showAlertWithMessage:error.localizedDescription state:0];
            return ;
        }
        self.roomToken = token;
        self.conferenceButton.enabled = YES;
        self.startTime = [NSDate date];
        [self.session joinRoomWithToken:_roomToken];
    }];
}

- (void)setupRTCButtonView {
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, QRD_SCREEN_HEIGHT - 230, QRD_SCREEN_WIDTH, 180)];
    self.buttonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_buttonView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH/2 - 50, 0, 100, 22)];
    _timeLabel.font = QRD_REGULAR_FONT(16);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor whiteColor];
    [_buttonView addSubview:_timeLabel];
    
    _microphoneButton = [[UIButton alloc] initWithFrame:CGRectMake(QRD_BUTTON_SPACE, 40, 54, 54)];
    [_microphoneButton setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateSelected];
    [_microphoneButton setImage:[UIImage imageNamed:@"microphone-disable"] forState:UIControlStateNormal];
    [_microphoneButton addTarget:self action:@selector(microphoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_microphoneButton];

    _speakerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 27, 40, 54, 54)];
    [_speakerButton setImage:[UIImage imageNamed:@"loudspeaker"] forState:UIControlStateSelected];
    [_speakerButton setImage:[UIImage imageNamed:@"loudspeaker-disable"] forState:UIControlStateNormal];
    [_speakerButton addTarget:self action:@selector(loudspeakerAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_speakerButton];
    
    _videoButton = [[UIButton alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH - QRD_BUTTON_SPACE - 54, 40, 54, 54)];
    [_videoButton setImage:[UIImage imageNamed:@"video-open"] forState:UIControlStateSelected];
    [_videoButton setImage:[UIImage imageNamed:@"video-close"] forState:UIControlStateNormal];
    [_videoButton addTarget:self action:@selector(videoAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_videoButton];
    _videoButton.enabled = NO;
    
    _beautyButton = [[UIButton alloc] initWithFrame:CGRectMake(QRD_BUTTON_SPACE, 136, 54, 54)];
    [_beautyButton setImage:[UIImage imageNamed:@"face-beauty-open"] forState:UIControlStateSelected];
    [_beautyButton setImage:[UIImage imageNamed:@"face-beauty-close"] forState:UIControlStateNormal];
    [_beautyButton addTarget:self action:@selector(beautyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_beautyButton];
    _beautyButton.enabled = self.videoEnabled;
    
    _conferenceButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 32, 136, 64, 64)];
    [_conferenceButton setImage:[UIImage imageNamed:@"close-phone"] forState:UIControlStateNormal];
    [_conferenceButton addTarget:self action:@selector(conferenceAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_conferenceButton];
    
    _toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH - QRD_BUTTON_SPACE - 54, 136, 54, 54)];
    [_toggleButton setImage:[UIImage imageNamed:@"camera-switch-front"] forState:UIControlStateSelected];
    [_toggleButton setImage:[UIImage imageNamed:@"camera-switch-end"] forState:UIControlStateNormal];
    [_toggleButton addTarget:self action:@selector(toggleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_toggleButton];
    _toggleButton.enabled = self.videoEnabled;

    _logButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 28, 28)];
    [_logButton setImage:[UIImage imageNamed:@"log-btn"] forState:UIControlStateNormal];
    [_logButton addTarget:self action:@selector(logAction:) forControlEvents:UIControlEventTouchUpInside];
    if (QRD_iPhoneX) {
        _logButton.frame = CGRectMake(15, 50, 28, 28);
    }
    [self.view insertSubview:_logButton aboveSubview:_session.previewView];
    
    [self setupRTCLogView];
}

- (void)setupRTCLogView {
    CGFloat logViewWidth = QRD_SCREEN_WIDTH/1.7;
    CGFloat statisTextHeight = logViewWidth/2;
    if (QRD_SCREEN_WIDTH == 320) {
        statisTextHeight = logViewWidth/2 * 1.2;
    }
    
    self.logView = [[UIView alloc] initWithFrame:CGRectMake(15, 54, logViewWidth, QRD_SCREEN_WIDTH)];
    self.logView.backgroundColor = QRD_COLOR_RGBA(73, 73, 75, 0.5);
    self.logView.hidden = YES;
    [self.view addSubview:_logView];
    
    self.statisTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, logViewWidth, statisTextHeight)];
    self.statisTextView.backgroundColor = [UIColor clearColor];
    self.statisTextView.textColor =  QRD_COLOR_RGBA(255, 255, 255, 1);
    self.statisTextView.font = QRD_LIGHT_FONT(13);
    self.statisTextView.editable = NO;
    self.statisTextView.text = @" AudioBitrate: 0 kb/s \n AudioPacketLossRate: 0% \n VideoBitrate: 0 kb/s \n VideoFrameRate: 0 fps\n VideoPacketLossRate: 0%";
    [self.logView addSubview:_statisTextView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, statisTextHeight + 2, logViewWidth - 20, 0.5)];
    lineView.backgroundColor = QRD_COLOR_RGBA(220, 20, 60, 1);
    [_logView addSubview:lineView];
    
    self.logTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, statisTextHeight + 4, logViewWidth, QRD_SCREEN_WIDTH - (statisTextHeight + 6))];
    self.logTextView.backgroundColor = [UIColor clearColor];
    self.logTextView.textColor =  QRD_COLOR_RGBA(255, 255, 255, 1);
    self.logTextView.font = QRD_LIGHT_FONT(13);
    self.logTextView.editable = NO;
    [self.logView addSubview:_logTextView];
}

#pragma mark - button action
- (void)logAction:(UIButton *)logButton {
    logButton.selected = !logButton.selected;
    self.logView.hidden = !logButton.selected;
    if (logButton.selected) {
        [_logView removeFromSuperview];
        [self.view insertSubview:_logView aboveSubview:self.view.subviews.lastObject];
    }
}

- (void)microphoneAction:(UIButton *)microphoneButton {
    microphoneButton.selected = !microphoneButton.selected;
    self.session.muteAudio = !microphoneButton.selected;
    if (self.session.muteAudio ) {
        _ownMicroImageView.image = [UIImage imageNamed:@"microphone-disable"];
    } else {
        _ownMicroImageView.image = [UIImage imageNamed:@"un_mute_audio"];
    }
}

- (void)loudspeakerAction:(UIButton *)loudspeakerButton {
    loudspeakerButton.selected = !loudspeakerButton.selected;
    self.session.muteSpeaker = !self.speakerButton.selected;
}

- (void)videoAction:(UIButton *)videoButton {
    videoButton.selected = !videoButton.selected;
    self.session.muteVideo = !videoButton.selected;
    self.userIdLabel.hidden = videoButton.selected;
    _toggleButton.enabled = !self.session.muteVideo;
    _beautyButton.enabled = !self.session.muteVideo;
}

- (void)beautyAction:(UIButton *)beautyButton {
    beautyButton.selected = !beautyButton.selected;
    [self.session setBeautifyModeOn:beautyButton.selected];
}

- (void)conferenceAction:(UIButton *)conferenceButton {
    conferenceButton.selected = !conferenceButton.selected;
    if (conferenceButton.selected) {
        if (_durationTimer) {
            [self.durationTimer invalidate];
            self.durationTimer = nil;
            if ([self isAdmin]) {
                [self.session stopMergeStream];
            }
            [self.session leaveRoom];
            if (self.videoEnabled) {
                [self.session stopCapture];
            }
            self.session.delegate = nil;
            self.session = nil;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)toggleAction:(UIButton *)logButton {
    logButton.selected = !logButton.selected;
    [self.session toggleCamera];
}

- (void)showAlertWithMessage:(NSString *)message state:(NSInteger)state{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 踢人
        if (state == 1) {
            [_session kickoutUser:_kickUserString];
            _kickUserString = nil;
        }
        // 被踢
        if (state == 2) {
            [self.durationTimer invalidate];
            self.durationTimer = nil;
            if (self.videoEnabled) {
                [self.session stopCapture];
            }
            self.session.delegate = nil;
            self.session = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }]];
    if (state == 1) {
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            _kickUserString = nil;
        }]];
    }
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 请求数据

- (void)requestTokenWithCompletionHandler:(void (^)(NSError *error, NSString *token))completionHandler
{
#warning
    /*
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     */
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api-demo.qnsdk.com/v1/rtc/token/admin/app/%@/room/%@/user/%@?bundleId=%@", self.appId, self.roomName, self.userId, [[NSBundle mainBundle] bundleIdentifier]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(error, nil);
            });
            return;
        }
        
        NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, token);
        });
    }];
    [task resume];
}

- (void)onTimer:(NSTimer *)timer {
    if (self.reconnecting) {
        _timeLabel.text = @"正在重连中...";
        return;
    }

    _totalDuration ++;
    float minutes = _totalDuration/ 60.0;
    int seconds = (int)_totalDuration % 60;
    if (minutes < 60) {
        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)minutes, seconds];
    } else{
        float hours = minutes / 60.0;
        int min = (int)minutes % 60;
        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)hours, (int)min, seconds];
    }
}

#pragma mark - QNRTCSessionDelegate

- (void)RTCSession:(QNRTCSession *)session didFailWithError:(NSError *)error {
    NSLog(@"QNRTCKitDemo: didFailWithError: %@", error);
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"didFailWithError: %@ \n", error]];
        _logTextView.text = _logString;
    });
   
    [self showAlertWithMessage:[NSString stringWithFormat:@"didFailWithError: %@", error]  state:0];
}

- (void)RTCSession:(QNRTCSession *)session roomStateDidChange:(QNRoomState)roomState {
    static NSDictionary *roomStateDictionary;
    roomStateDictionary = roomStateDictionary ?: @{@(QNRoomStateIdle):       @"Idle",
                                             @(QNRoomStateConnecting):    @"Connecting",
                                             @(QNRoomStateConnected):        @"Connected",
                                             @(QNRoomStateReconnecting):         @"Reconnecting"
                                             };
    NSLog(@"QNRTCKitDemo: roomStateDidChange: %@", roomStateDictionary[@(roomState)]);
   
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"roomStateDidChange: %@ \n", roomStateDictionary[@(roomState)]]];
        _logTextView.text = _logString;
        
        if (roomState == QNRoomStateConnected) {
            if (self.reconnecting) {
                //重连成功后将时间重置
                _totalDuration = 0;
                self.videoButton.enabled = self.videoEnabled;
                self.microphoneButton.enabled = YES;
                self.reconnecting = NO;
                return ;
            }

            self.videoButton.enabled = self.videoEnabled;
            self.videoButton.selected = self.videoEnabled;
            self.microphoneButton.selected = YES;
            self.speakerButton.selected = YES;
            NSInteger takeTime = [[NSDate date] timeIntervalSinceDate:self.startTime] * 1000.0;
            _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"加会耗时：%ldms", (long)takeTime]];
            _logTextView.text = _logString;
            [self.session publishWithAudioEnabled:YES videoEnabled:self.videoEnabled];
            self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        }
        else if (roomState == QNRoomStateIdle) {
            self.videoButton.enabled = NO;
            self.conferenceButton.selected = NO;
            self.videoButton.selected = NO;
            [self.durationTimer invalidate];
            self.durationTimer = nil;
        }
        else if (roomState == QNRoomStateReconnecting) {
            self.reconnecting = YES;
            self.videoButton.enabled = NO;
            self.microphoneButton.enabled = NO;
        }
    });
}

- (void)sessionDidPublishLocalMedia:(QNRTCSession *)session {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoButton.enabled = self.videoEnabled;

        if ([self isAdmin]) {
            [self.session setMergeStreamLayoutWithUserId:self.userId frame:CGRectMake(0, 0, backgroundSize.width, backgroundSize.height) zIndex:0 muted:NO];
        }
    });
}

- (void)RTCSession:(QNRTCSession *)session didJoinOfRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: userId: %@ join room", userId);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ join room \n", userId]];
        _logTextView.text = _logString;
        
        QRDUserView *userView = [[QRDUserView alloc] initWithFrame:CGRectZero];
        userView.delegate = self;
        userView.userId = userId;
        [self addUserViewInfoToArrayWithUserId:userId userView:userView];
        [self refreshUserView:userId];
    });
}

- (void)RTCSession:(QNRTCSession *)session didLeaveOfRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: userId: %@ leave room", userId);

    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ leave room \n", userId]];
        _logTextView.text = _logString;
        
        [self removeUserViewFromSuperview:userId];
        [self removeUserViewInfoFromArrayWithUserId:userId];
        [self refreshUserView:userId];

        if ([self isAdmin]) {
            [self releaseMergePositionForUserId:userId];
        }
    });
}

- (void)RTCSession:(QNRTCSession *)session didSubscribeUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: did subscribe userId: %@", userId);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ subscribe \n", userId]];
        _logTextView.text = _logString;
        
        BOOL userViewAddedSuperView = [self checkUserViewAddedSuperViewWithUserId:userId];
        if (!userViewAddedSuperView) {
            [self refreshUserView:userId hidden:NO];
        }
        
        if ([self isAdmin]) {
            NSInteger position = [self availableMergePositionForUserId:userId];
            if (position < 0) {
                return ;
            }

            CGRect rect = CGRectMake((2 - position / 3) * backgroundSize.width / 3, (2 - position % 3) * backgroundSize.height / 3, backgroundSize.width / 3, backgroundSize.height / 3);
            [self.session setMergeStreamLayoutWithUserId:userId frame:rect zIndex:1 muted:NO];
        }
    });
}

- (void)RTCSession:(QNRTCSession *)session didPublishOfRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: did publish of userId: %@", userId);
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ publish \n", userId]];
        _logTextView.text = _logString;
        [self.session subscribe:userId];
    });
}

- (void)RTCSession:(QNRTCSession *)session didUnpublishOfRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: did unpublish of userId: %@", userId);

    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ unpublish \n", userId]];
        _logTextView.text = _logString;
        
        // 重置 audio, video mute 信息
        QRDUserView *userView = [self getUserViewInfoWithUserId:userId];
        userView.videoMuted = NO;
        userView.audioMuted = NO;
        
        BOOL userViewAddedSuperView = [self checkUserViewAddedSuperViewWithUserId:userId];
        if (userViewAddedSuperView) {
            [self removeUserViewFromSuperview:userId];
            [self refreshUserView:userId hidden:YES];
        }

        if ([self isAdmin]) {
            [self releaseMergePositionForUserId:userId];
        }
    });
}

- (void)RTCSession:(QNRTCSession *)session didKickoutByUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: didKickoutByUserId: %@", userId);
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"kickoutByUserId: %@ \n", userId]];
        _logTextView.text = _logString;
        
        [self showAlertWithMessage:[NSString stringWithFormat:@"您已被用户 %@ 踢出房间!", userId] state:2];
    });
}

- (void)RTCSession:(QNRTCSession *)session didAudioMuted:(BOOL)muted byRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: didAudioMuted: %d byRemoteUserId: %@", muted, userId);
   
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ audioMuted: %d \n", userId, muted]];
        _logTextView.text = _logString;
        
        QRDUserView *userView = [self getUserViewInfoWithUserId:userId];
        userView.audioMuted = muted;
        [self updateUserViewInfoFromArrayWithUserId:userId userView:userView];
    });}

- (void)RTCSession:(QNRTCSession *)session didVideoMuted:(BOOL)muted byRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: didVideoMuted: %d byRemoteUserId: %@", muted, userId);
   
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ videoMuted: %d \n", userId, muted]];
        _logTextView.text = _logString;
        
        QRDUserView *userView = [self getUserViewInfoWithUserId:userId];
        userView.videoMuted = muted;
        [self updateUserViewInfoFromArrayWithUserId:userId userView:userView];
    });
}

- (QNVideoRender *)RTCSession:(QNRTCSession *)session firstVideoDidDecodeOfRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: first video frame decoded of userId: %@", userId);
    
    QNVideoRender *render = [[QNVideoRender alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ first video frame \n", userId]];
        _logTextView.text = _logString;
        
        QRDUserView *userView = [self getUserViewInfoWithUserId:userId];
        userView.videoMuted = userView.videoMuted; // 这么写的目的就是刷新下 UI。
        render.renderView = userView;
    });
    return render;
}

- (void)RTCSession:(QNRTCSession *)session didDetachRenderView:(UIView *)renderView ofRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: did detach remote view: %@", userId);
   
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ detach remote view \n", userId]];
        _logTextView.text = _logString;
        
        [renderView removeFromSuperview];
    });
}

- (void)RTCSession:(QNRTCSession *)session cameraSourceDidGetSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    //可以对 sampleBuffer 做美颜/滤镜等操作

    return;
}

- (void)RTCSession:(QNRTCSession *)session didGetStatistic:(NSDictionary *)statistic ofUserId:(NSString *)userId {
    if (![userId isEqualToString:self.userId]) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLogInfomationWithStatistic:statistic];
    });
}

#pragma mark - 合流相关

- (NSInteger)availableMergePositionForUserId:(NSString *)userId {
    for (NSInteger i = 0; i < 9; i++) {
        NSString *item = self.mergePositionArray[i];

        //出现各种重连时，同个 userId 还是放在原来的合流位置
        if (item && [item isEqualToString:userId]) {
            return i;
        }

        if (!item || [item isEqualToString:@""]) {
            self.mergePositionArray[i] = userId;
            return i;
        }
    }

    return -1;
}

- (void)releaseMergePositionForUserId:(NSString *)userId {
    for (NSInteger i = 0; i < 9; i++) {
        NSString *item = self.mergePositionArray[i];
        if ([item isEqualToString:userId]) {
            self.mergePositionArray[i] = @"";
        }
    }
}

- (BOOL)isAdmin {
    return [self.userId isEqualToString:@"admin"];
}

#pragma mark - 切换
- (void)viewSwitch:(UITapGestureRecognizer *)sender {
    [sender.view removeGestureRecognizer:sender];
    CGRect previewRect = _session.previewView.frame;
    CGRect videoViewRect = _videoView.frame;
    if (DOUBLE_VALUE_IS_ZERO(videoViewRect.size.width - QRD_SCREEN_WIDTH)) {
        [self.view sendSubviewToBack:_session.previewView];
        [_videoView addGestureRecognizer:sender];
    } else {
        [self.view sendSubviewToBack:_videoView];
        [_session.previewView addGestureRecognizer:sender];
    }
    _session.previewView.frame = videoViewRect;
    _videoView.frame = previewRect;
}

#pragma mark --- 点击空白 ---
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_hiddenEnable) {
        self.buttonView.hidden = !self.buttonView.hidden;
    }
}

- (void)updateLogInfomationWithStatistic:(NSDictionary *)statistic{
    CGFloat audioBitrate = [statistic[@"QNStatisticAudioBitrateKey"] floatValue]/1000;
    CGFloat audioPacketLossRate = [statistic[@"QNStatisticAudioPacketLossRateKey"] floatValue] * 100;
    CGFloat videoBitrate = [statistic[@"QNStatisticVideoBitrateKey"] floatValue]/1000;
    CGFloat videoFrameRate = [statistic[@"QNStatisticVideoFrameRateKey"] floatValue];
    CGFloat videoPacketLossRate = [statistic[@"QNStatisticVideoPacketLossRateKey"] floatValue] * 100;

    NSString *staticsString = [NSString stringWithFormat:@" AudioBitrate: %.f kb/s \n AudioPacketLossRate: %.f%% \n VideoBitrate: %.f kb/s \n VideoFrameRate: %.f fps\n VideoPacketLossRate: %.f%%", audioBitrate, audioPacketLossRate, videoBitrate, videoFrameRate, videoPacketLossRate];
    _statisTextView.text = staticsString;
    
    [_logView removeFromSuperview];
    [self.view insertSubview:_logView aboveSubview:self.view.subviews.lastObject];
}

#pragma mark - 更新 user UI
- (void)addUserViewInfoToArrayWithUserId:(NSString *)userId userView:(QRDUserView *)userView {
    NSDictionary *userDic = @{userId : userView};
    [_renderArray addObject:userDic];
}

- (void)updateUserViewInfoFromArrayWithUserId:(NSString *)userId userView:(QRDUserView *)userView {
    NSDictionary *userDic = @{userId : userView};
    for (int i = 0; i < _renderArray.count; i++) {
        NSDictionary *dic = _renderArray[i];
        if ([dic.allKeys containsObject:userId]) {
            [_renderArray replaceObjectAtIndex:i withObject:userDic];
        }
    }
}

- (void)removeUserViewInfoFromArrayWithUserId:(NSString *)userId {
    for (int i = 0; i < _renderArray.count; i++) {
        NSDictionary *dic = _renderArray[i];
        if ([dic.allKeys containsObject:userId]) {
            [_renderArray removeObject:dic];
        }
    }
}

- (QRDUserView *)getUserViewInfoWithUserId:(NSString *)userId {
    QRDUserView *userView = nil;
    for (int i = 0; i < _renderArray.count; i++) {
        NSDictionary *dic = _renderArray[i];
        if ([dic.allKeys containsObject:userId]) {
            userView = dic[userId];
        }
    }
    return userView;
}

- (void)refreshUserView:(NSString *)userId {
    [self refreshUserView:userId hidden:NO];
}

- (void)refreshUserView:(NSString *)userId hidden:(BOOL)hidden {
    [_viewSwitchGesture.view removeGestureRecognizer:_viewSwitchGesture];
    
    NSMutableArray *userIdInfoArray = _renderArray;
    if (hidden) {
        userIdInfoArray = [NSMutableArray arrayWithArray:_renderArray];
        for (int i = 0; i < userIdInfoArray.count; i++) {
            NSDictionary *dic = userIdInfoArray[i];
            if ([dic.allKeys containsObject:userId]) {
                NSDictionary *dicFromRenderArray = [_renderArray objectAtIndex:i];
                QRDUserView *userView = dicFromRenderArray[userId];
                userView.hidden = YES;
                
                [userIdInfoArray removeObject:dic];
                
                break;
            }
        }
    } else {
        for (int i = 0; i < userIdInfoArray.count; i++) {
            NSDictionary *dic = userIdInfoArray[i];
            if ([dic.allKeys containsObject:userId]) {
                NSDictionary *dicFromRenderArray = [_renderArray objectAtIndex:i];
                QRDUserView *userView = dicFromRenderArray[userId];
                userView.hidden = NO;
                
                break;
            }
        }
    }
    
    CGFloat topSpace = 0;
    if (QRD_iPhoneX) {
        topSpace = 40;
    }
    if (userIdInfoArray.count > 1) {
        _hiddenEnable = NO;
        _buttonView.hidden = NO;
        NSInteger renderWidth = 0.0;
        NSInteger columns = 0;
        NSInteger renderCount = userIdInfoArray.count + 1;
        if (renderCount <= 4) {
            renderWidth = QRD_SCREEN_WIDTH/2;
            columns = 2;
        }
        if (renderCount > 4 && renderCount <= 9) {
            renderWidth = QRD_SCREEN_WIDTH/3;
            columns = 3;
        }
        for (NSInteger i = 0; i < renderCount; i++) {
            NSInteger row = i / columns;
            NSInteger column = i % columns;
            if (i == renderCount - 1) {
                [_session.previewView removeFromSuperview];
                if (renderCount == 3) {
                    _session.previewView.frame = CGRectMake(renderWidth / 2, topSpace + row * renderWidth, renderWidth, renderWidth);
                } else{
                    _session.previewView.frame = CGRectMake(column * renderWidth, topSpace + row * renderWidth, renderWidth, renderWidth);
                }
                if (![_session.previewView.subviews containsObject:_ownMicroImageView]) {
                    [_session.previewView addSubview:_ownMicroImageView];
                    _ownMicroImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
                }
                _ownMicroImageView.frame = CGRectMake(renderWidth - 26, renderWidth - 34, 20, 26);
                [self.view addSubview:_session.previewView];
            } else{
                NSDictionary *dic = userIdInfoArray[i];
                QRDUserView *userView = [dic allValues][0];
                [userView removeFromSuperview];
                userView.frame = CGRectMake(column * renderWidth, topSpace + row * renderWidth, renderWidth, renderWidth);
                [self.view insertSubview:userView belowSubview:_logButton];
                
                userView.userIdBackgroundColor = _colorArray[i % 9];
            }
        }
    }
    else{
        _hiddenEnable = YES;
        [_session.previewView removeFromSuperview];
        [_ownMicroImageView removeFromSuperview];
        _session.previewView.frame = CGRectMake(0, 0, QRD_SCREEN_WIDTH, QRD_SCREEN_HEIGHT);
        [self.view insertSubview:self.session.previewView atIndex:0];
        
        if (userIdInfoArray.count == 1) {
            NSDictionary *dic = userIdInfoArray[0];
            _videoView = [dic allValues][0];
            [_videoView addGestureRecognizer:_viewSwitchGesture];
            [_videoView removeFromSuperview];
            _videoView.frame = CGRectMake(QRD_SCREEN_WIDTH - QRD_SCREEN_WIDTH/3, topSpace, QRD_SCREEN_WIDTH/3, QRD_SCREEN_WIDTH/3/9*16);
            [self.view insertSubview:_videoView belowSubview:_logButton];
            
            _videoView.userIdBackgroundColor = _colorArray[0 % 9];
        }
    }
    if (_logButton.selected) {
        [_logView removeFromSuperview];
        [self.view insertSubview:_logView aboveSubview:self.view.subviews.lastObject];
    }
    
    self.userIdLabel.backgroundColor = self.colorArray[userIdInfoArray.count];
}

- (void)removeUserViewFromSuperview:(NSString *)userId {
    NSDictionary *removeDic;
    for (NSDictionary *dic in _renderArray) {
        if ([dic.allKeys containsObject:userId]) {
            removeDic = dic;
        }
    }
    
    UIView *renderView = removeDic[userId];
    [renderView removeFromSuperview];
}

- (BOOL)checkUserViewAddedSuperViewWithUserId:(NSString *)userId {
    BOOL userViewAddedSuperView = NO;
    for (int i = 0; i < _renderArray.count; i++) {
        NSDictionary *dic = _renderArray[i];
        if ([dic.allKeys containsObject:userId]) {
            QRDUserView *userView = dic[userId];
            if (!userView.hidden) {
                userViewAddedSuperView = YES;
            }
            break;
        }
    }
    return userViewAddedSuperView;
}

#pragma mark - 长按用户视图 QRDUserView 的踢人逻辑
- (void)longPressUserView:(QRDUserView *)userView userId:(NSString *)userId {
    if (![self isAdmin]) {
        return;
    }
    
    _kickUserString = userId;
    [self showAlertWithMessage:[NSString stringWithFormat:@"是否要将用户 %@ 踢出房间 ？",_kickUserString] state:1];
}
          
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s, line: %d", __FUNCTION__, __LINE__);
}

@end
