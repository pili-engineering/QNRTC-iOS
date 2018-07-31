//
//  QRDRTCViewController.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/18.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDRTCViewController.h"
#import <QNRTCKit/QNRTCKit.h>

#define QRD_BUTTON_SPACE (QRD_SCREEN_WIDTH - 54 * 3)/4


static CGSize backgroundSize = {480, 848};

@interface QRDRTCViewController ()
<
QNRTCSessionDelegate
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
@property (nonatomic, strong) NSMutableDictionary *muteDic;

@property (nonatomic, strong) NSString *roomToken;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, copy) NSString *kickUserString;

@property (nonatomic, assign) BOOL reconnecting;

@property (nonatomic, strong) NSMutableArray *mergePositionArray;
@property (nonatomic, strong) QNVideoView *videoView;
@property (nonatomic, strong) UITapGestureRecognizer *viewSwitchGesture;



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
    self.muteDic = [NSMutableDictionary new];
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
    self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    self.session.videoEncodeSize = CGSizeFromString(_configDic[@"VideoSize"]);
    self.session.videoFrameRate = [_configDic[@"FrameRate"] integerValue];
    self.session.statisticInterval = 3.0;
    [self.session startCapture];
    [self.view insertSubview:self.session.previewView atIndex:0];

    self.userIdLabel = [[UILabel alloc] initWithFrame:self.session.previewView.bounds];
    self.userIdLabel.backgroundColor = self.colorArray[0];
    self.userIdLabel.textColor = [UIColor whiteColor];
    self.userIdLabel.textAlignment = NSTextAlignmentCenter;
    self.userIdLabel.text = self.userId;
    self.userIdLabel.hidden = YES;
    self.userIdLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.session.previewView addSubview:self.userIdLabel];
    
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
        [self.session joinRoomWithToken:_roomToken];
        // 当设置的最低码率，远高于弱网下的常规传输码率值时，会严重影响连麦的画面流畅度
        // 故建议若非场景带宽需求限制，不设置连麦码率或者设置最低码率值不过高的效果较好
//        [self.session setMinBitrateBps:200 * 1000 maxBitrateBps:1000 * 1000];
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
    
    _conferenceButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 32, 136, 64, 64)];
    [_conferenceButton setImage:[UIImage imageNamed:@"close-phone"] forState:UIControlStateNormal];
    [_conferenceButton addTarget:self action:@selector(conferenceAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_conferenceButton];
    
    _toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH - QRD_BUTTON_SPACE - 54, 136, 54, 54)];
    [_toggleButton setImage:[UIImage imageNamed:@"camera-switch-front"] forState:UIControlStateSelected];
    [_toggleButton setImage:[UIImage imageNamed:@"camera-switch-end"] forState:UIControlStateNormal];
    [_toggleButton addTarget:self action:@selector(toggleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_toggleButton];
    
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
            [self.session stopCapture];
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
            [self.session stopCapture];
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
                self.videoButton.enabled = YES;
                self.microphoneButton.enabled = YES;
                self.reconnecting = NO;
                return ;
            }

            self.videoButton.enabled = YES;
            self.videoButton.selected = YES;
            self.microphoneButton.selected = YES;
            self.speakerButton.selected = YES;
            [self.session publishWithAudioEnabled:YES videoEnabled:YES];
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
        self.videoButton.enabled = YES;

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
    });
}

- (void)RTCSession:(QNRTCSession *)session didLeaveOfRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: userId: %@ leave room", userId);
    [self.muteDic removeObjectForKey:userId];

    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ leave room \n", userId]];
        _logTextView.text = _logString;

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
        [self showUserStateWithUserId:userId];

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
    [self.muteDic removeObjectForKey:userId];

    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ unpublish \n", userId]];
        _logTextView.text = _logString;

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
        [self recordMuteState:muted userId:userId isAudio:YES];
        [self showUserStateWithUserId:userId];
    });}

- (void)RTCSession:(QNRTCSession *)session didVideoMuted:(BOOL)muted byRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: didVideoMuted: %d byRemoteUserId: %@", muted, userId);
   
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ videoMuted: %d \n", userId, muted]];
        _logTextView.text = _logString;
        [self recordMuteState:muted userId:userId isAudio:NO];
        [self showUserStateWithUserId:userId];
    });
}

- (QNVideoRender *)RTCSession:(QNRTCSession *)session firstVideoDidDecodeOfRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: first video frame decoded of userId: %@", userId);
    
    QNVideoRender *render = [[QNVideoRender alloc] init];
    render.renderView = [self addRenderViewWithUserId:userId];
    render.renderView.contentMode = UIViewContentModeScaleAspectFit;
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ first video frame \n", userId]];
        _logTextView.text = _logString;
        [self showUserStateWithUserId:userId];
    });
    return render;
}

- (void)RTCSession:(QNRTCSession *)session didDetachRenderView:(UIView *)renderView ofRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: did detach remote view: %@", userId);
   
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ detach remote view \n", userId]];
        _logTextView.text = _logString;
        [renderView removeFromSuperview];
        [self removeRenderView:renderView userId:userId];
        [self showUserStateWithUserId:userId];
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


#pragma mark - 记录状态

- (void)recordMuteState:(BOOL)muted userId:(NSString *)userId isAudio:(BOOL)isAudio{
    NSString *keyString = @"video";
    if (isAudio) {
        keyString = @"audio";
    }

    NSDictionary *currentDic = self.muteDic[userId];
    NSDictionary *newDic = nil;
    if (currentDic) {
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:currentDic];
        [mDic setObject:@(muted) forKey:keyString];
        newDic = [mDic copy];
    }
    else {
        newDic = @{keyString: @(muted)};
    }

    [self.muteDic setObject:newDic forKey:userId];
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
    return [self.userId.lowercaseString containsString:@"admin"];
}

#pragma mark - 是否音视频状态展示
- (void)showUserStateWithUserId:(NSString *)userId {
    NSDictionary *currentDic = self.muteDic[userId];
    BOOL audioMute = [currentDic[@"audio"] boolValue];
    BOOL videoMute = [currentDic[@"video"] boolValue];
    
    QNVideoView *videoView;
    for (NSDictionary *dic in _renderArray) {
        if ([dic.allKeys containsObject:userId]) {
            videoView = dic[userId];
            UIImageView *imageView;
            UILabel *label;
            for (id subId in videoView.subviews) {
                if ([subId isKindOfClass:[UIImageView class]]) {
                    imageView = (UIImageView *)subId;
                }
                if ([subId isKindOfClass:[UILabel class]]) {
                    label = (UILabel *)subId;
                }
            }
            
            if (videoMute) {
                label.frame = CGRectMake(0, 0, CGRectGetWidth(videoView.frame),  CGRectGetHeight(videoView.frame));
                label.hidden = NO;
            } else {
                label.hidden = YES;
            }
            
            imageView.frame = CGRectMake(CGRectGetWidth(videoView.frame) - 26, CGRectGetHeight(videoView.frame) - 34, 20, 26);
            if (audioMute) {
                imageView.image = [UIImage imageNamed:@"microphone-disable"];
            } else {
                imageView.image = [UIImage imageNamed:@"un_mute_audio"];
            }
        }
    }
}

#pragma mark - 布局房间人数变化时的视图

- (QNVideoView *)addRenderViewWithUserId:(NSString *)userId {
    QNVideoView *videoView = [[QNVideoView alloc] initWithFrame:CGRectZero];
    [_renderArray addObject:@{userId:videoView}];
    [self layoutRenderViewWithUserId:userId];
    NSDictionary *dic = _renderArray.lastObject;
    videoView = dic[userId];
    return videoView;
}

- (void)removeRenderView:(UIView *)remoteView userId:(NSString *)userId{
    NSDictionary *removeDic;
    for (NSDictionary *dic in _renderArray) {
        if ([dic.allKeys containsObject:userId]) {
            removeDic = dic;
        }
    }
    [_renderArray removeObject:removeDic];
    [self layoutRenderViewWithUserId:userId];
}

- (void)layoutRenderViewWithUserId:(NSString *)userId {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_viewSwitchGesture.view removeGestureRecognizer:_viewSwitchGesture];
        CGFloat topSpace = 0;
        if (QRD_iPhoneX) {
            topSpace = 40;
        }
        if (_renderArray.count > 1) {
            _hiddenEnable = NO;
            _buttonView.hidden = NO;
            NSInteger renderWidth = 0.0;
            NSInteger columns = 0;
            NSInteger renderCount = _renderArray.count + 1;
            if (renderCount <= 4) {
                renderWidth = QRD_SCREEN_WIDTH/2;
                columns = 2;
            }
            if (renderCount > 4 && renderCount <= 9) {
                renderWidth = QRD_SCREEN_WIDTH/3;
                columns = 3;
            }
            NSMutableArray *renderViewArray = [NSMutableArray array];
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
                    NSDictionary *dic = _renderArray[i];
                    QNVideoView *videoView = [dic allValues][0];
                    [videoView removeFromSuperview];
                    videoView.frame = CGRectMake(column * renderWidth, topSpace + row * renderWidth, renderWidth, renderWidth);
                    [self.view insertSubview:videoView belowSubview:_logButton];
                    
                    [self dependsWhetherLoadedWithVideoView:videoView index:i renderDic:dic];
                    [renderViewArray addObject:@{dic.allKeys[0]:videoView}];
                }
            }
            _renderArray = [NSMutableArray arrayWithArray:[renderViewArray copy]];
        } else{
            _hiddenEnable = YES;
            [_session.previewView removeFromSuperview];
            [_ownMicroImageView removeFromSuperview];
            _session.previewView.frame = CGRectMake(0, 0, QRD_SCREEN_WIDTH, QRD_SCREEN_HEIGHT);
            [self.view insertSubview:self.session.previewView atIndex:0];
            
            if (_renderArray.count == 1) {
                
                NSDictionary *dic = _renderArray[0];
                _videoView = [dic allValues][0];
                [_videoView addGestureRecognizer:_viewSwitchGesture];
                [_videoView removeFromSuperview];
                _videoView.frame = CGRectMake(QRD_SCREEN_WIDTH - QRD_SCREEN_WIDTH/3, topSpace, QRD_SCREEN_WIDTH/3,
                                              QRD_SCREEN_WIDTH/3/9*16);
                [self.view insertSubview:_videoView belowSubview:_logButton];
                
                [self dependsWhetherLoadedWithVideoView:_videoView index:0 renderDic:dic];
                [_renderArray replaceObjectAtIndex:0 withObject:@{[_renderArray[0] allKeys][0]:_videoView}];
            }
        }
        if (_logButton.selected) {
            [_logView removeFromSuperview];
            [self.view insertSubview:_logView aboveSubview:self.view.subviews.lastObject];
        }
        
        self.userIdLabel.backgroundColor = self.colorArray[_renderArray.count];
    });
}

- (void)viewSwitch:(UITapGestureRecognizer *)sender {
    [sender.view removeGestureRecognizer:sender];
    CGRect previewRect = _session.previewView.frame;
    CGRect videoViewRect = _videoView.frame;
    if (videoViewRect.size.width == QRD_SCREEN_WIDTH) {
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

- (QNVideoView *)dependsWhetherLoadedWithVideoView:(QNVideoView *)videoView index:(NSUInteger)index renderDic:(NSDictionary *)renderDic {
    BOOL isHave = [self judgeArealdyHaveWithVideoView:videoView];
    if (!isHave) {
        CGFloat videoWidth = CGRectGetWidth(videoView.frame);
        CGFloat videoHeight = CGRectGetHeight(videoView.frame);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, videoWidth, videoHeight)];
        label.userInteractionEnabled = YES;
        label.backgroundColor = _colorArray[index % 9];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [renderDic allKeys][0];
        label.hidden = YES;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [videoView insertSubview:label aboveSubview:videoView.subviews.lastObject];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(videoWidth - 26, videoHeight - 34, 20, 26)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"microphone-disable"];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [videoView insertSubview:imageView aboveSubview:videoView.subviews.lastObject];
        
        UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressViewAction:)];
        longPressGest.minimumPressDuration = 3;
        longPressGest.allowableMovement = 20;
        [videoView addGestureRecognizer:longPressGest];
    
    } else{
        UILabel *label;
        for (id subId in videoView.subviews) {
            if ([subId isKindOfClass:[UILabel class]]) {
                label = (UILabel *)subId;
            }
        }
        
        if (label) {
            label.backgroundColor = _colorArray[index % 9];
        }
    }
    return videoView;
}

- (void)longPressViewAction:(UILongPressGestureRecognizer *)longPressGest {
    if (![self isAdmin]) {
        return;
    }
    
    QNVideoView *videoView = (QNVideoView *)longPressGest.view;
    for (NSDictionary *dic in _renderArray) {
        if (dic.allValues[0] == videoView) {
            _kickUserString = dic.allKeys[0];
            [self showAlertWithMessage:[NSString stringWithFormat:@"是否要将用户 %@ 踢出房间 ？",_kickUserString] state:1];
        }
    }
}

- (BOOL)judgeArealdyHaveWithVideoView:(QNVideoView *)videoView {
    for (id subId in videoView.subviews) {
        if ([subId isKindOfClass:[UIImageView class]]) {
            return YES;
        }
    }
    return NO;
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
          
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
