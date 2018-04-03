//
//  DetailViewController.m
//  QNRTCKitDemo
//
//  Created by lawder on 2017/10/16.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "DetailViewController.h"
#import <QNRTCKit/QNRTCKit.h>


static NSString * const kQNRTCDemoAppId = @"d8lk7l4ed";

@interface DetailViewController ()<QNRTCSessionDelegate>

@property (nonatomic, strong) QNRTCSession *session;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *roomToken;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *toggleButton;
@property (nonatomic, strong) UIButton *muteAudioButton;
@property (nonatomic, strong) UIButton *muteVideoButton;
@property (nonatomic, strong) UIButton *conferenceButton;
@property (nonatomic, strong) UIButton *muteSpeakerButton;
@property (nonatomic, strong) UIButton *publishButton;

@property (nonatomic, assign) uint8_t mask;
@property (nonatomic, assign) CGSize screenSize;
@property (nonatomic, assign) CGSize remoteSize;

@property (nonatomic, strong) NSMutableArray *remoteUserArray;

@end


@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.navigationController setNavigationBarHidden:YES];
    self.remoteUserArray = [NSMutableArray new];
    self.screenSize = [[UIScreen mainScreen] bounds].size;
    self.remoteSize = CGSizeMake(self.screenSize.width / 3, self.screenSize.height / 3);

    [self setupUI];

    self.userId = [self getUserId];
    self.session = [[QNRTCSession alloc] init];
    self.session.delegate = self;
    [self.session startCapture];
    [self.view insertSubview:self.session.previewView atIndex:0];
    [self.session setBeautifyModeOn:YES];
    self.session.videoEncodeSize = CGSizeMake(240, 320);

    [self requestTokenWithCompletionHandler:^(NSError *error, NSString *token) {
        if (error) {
            [self showAlertWithMessage:error.localizedDescription];
            return ;
        }

        self.roomToken = token;
        self.conferenceButton.enabled = YES;
    }];
}

- (void)setupUI
{
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 66, 66)];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];

    CGSize size = [[UIScreen mainScreen] bounds].size;

    self.toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 66 - 20, 20, 66, 66)];
    [self.toggleButton setTitle:@"切换" forState:UIControlStateNormal];
    [self.toggleButton addTarget:self action:@selector(toggleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toggleButton];

    self.muteAudioButton = [[UIButton alloc] initWithFrame:CGRectMake(20, (size.height - 66) / 2, 100, 66)];
    [self.muteAudioButton setTitle:@"MuteAudio" forState:UIControlStateNormal];
    [self.muteAudioButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.muteAudioButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.muteAudioButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.muteAudioButton addTarget:self action:@selector(muteAudioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.muteAudioButton];

    self.muteVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 100 - 20, (size.height - 66) / 2, 100, 66)];
    [self.muteVideoButton setTitle:@"MuteVideo" forState:UIControlStateNormal];
    [self.muteVideoButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.muteVideoButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.muteVideoButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.muteVideoButton addTarget:self action:@selector(muteVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.muteVideoButton];

    self.conferenceButton = [[UIButton alloc] initWithFrame:CGRectMake(20, size.height - 66, 66, 66)];
    [self.conferenceButton setTitle:@"连麦" forState:UIControlStateNormal];
    [self.conferenceButton setTitle:@"停止" forState:UIControlStateSelected];
    [self.conferenceButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.conferenceButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.conferenceButton addTarget:self action:@selector(conferenceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.conferenceButton];
    self.conferenceButton.enabled = NO;

    self.muteSpeakerButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width / 2 - 50, size.height - 66, 100, 66)];
    [self.muteSpeakerButton setTitle:@"静音扬声器" forState:UIControlStateNormal];
    [self.muteSpeakerButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.muteSpeakerButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.muteSpeakerButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.muteSpeakerButton addTarget:self action:@selector(muteSpeakerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.muteSpeakerButton];

    self.publishButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 88 - 20, size.height - 66, 88, 66)];
    [self.publishButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.publishButton setTitle:@"取消发布" forState:UIControlStateSelected];
    [self.publishButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.publishButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.publishButton addTarget:self action:@selector(publishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.publishButton];
    self.publishButton.enabled = NO;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getUserId {
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSRange range = [deviceName rangeOfString:@" "];
    if (range.location != NSNotFound) {
        deviceName = [deviceName substringToIndex:range.location];
    }

    range = [deviceName rangeOfString:@"'"];
    if (range.location != NSNotFound) {
        deviceName = [deviceName substringToIndex:range.location];
    }

    return deviceName;
}

- (IBAction)backButtonClick:(id)sender
{
    [self.session leaveRoom];
    self.session = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)conferenceButtonClick:(id)sender
{
    if (!self.conferenceButton.isSelected) {
        self.conferenceButton.enabled = NO;
        [self.session joinRoomWithToken:self.roomToken];
        [self.session setMinBitrateBps:@(300 * 1000) currentBitrateBps:@(500 * 1000) maxBitrateBps:@(1200 * 1000)];
        self.session.statisticInterval = 3;
    }
    else {
        [self.session leaveRoom];
    }
    return;
}

- (IBAction)publishButtonClick:(id)sender {
    if (!self.publishButton.selected) {
        self.publishButton.enabled = NO;
        [self.session publishWithAudioEnabled:YES videoEnabled:YES];
    }
    else {
        [self.session unpublish];
        self.publishButton.selected = NO;
    }
}

- (IBAction)muteAudioButtonClick:(id)sender {
    self.muteAudioButton.selected = !self.self.muteAudioButton.selected;
    self.session.muteAudio = self.muteAudioButton.selected;
}

- (IBAction)muteVideoButtonClick:(id)sender {
    self.muteVideoButton.selected = !self.self.muteVideoButton.selected;
    self.session.muteVideo = self.muteVideoButton.selected;
}

- (IBAction)muteSpeakerButtonClick:(id)sender {
    self.muteSpeakerButton.selected = !self.self.muteSpeakerButton.selected;
    self.session.muteSpeaker = self.muteSpeakerButton.selected;
}

- (IBAction)toggleButtonClick:(id)sender {
    [self.session toggleCamera];
}

- (void)kickoutButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    UIView *view = button.superview;
    for (QNVideoRender *render in self.remoteUserArray) {
        if (render.renderView == view) {
            [self.session kickoutUser:render.userId];
        }
    }
}

- (NSInteger)availablePosition {
    for (NSInteger i = 2; i > 0; i--) {
        if ((self.mask & (1 << i)) == 0) {
            return i;
        }
    }

    return -1;
}

- (void)setPositionEnable:(NSInteger)position {
    self.mask &= ~(1 << position);
}

- (void)setPositionDisable:(NSInteger)position {
    self.mask |= (1 << position);
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 请求数据

- (void)requestTokenWithCompletionHandler:(void (^)(NSError *error, NSString *token))completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api-demo.qnsdk.com/v1/vdn/rtc/token/app/%@/room/%@/user/%@", kQNRTCDemoAppId, self.roomName, self.userId]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 5;

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

#pragma mark - QNRTCSessionDelegate

- (void)RTCSession:(QNRTCSession *)session didFailWithError:(NSError *)error {
    NSLog(@"QNRTCKitDemo: didFailWithError: %@", error);
    [self showAlertWithMessage:error.localizedDescription];
}

- (void)RTCSession:(QNRTCSession *)session roomStateDidChange:(QNRoomState)roomState {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (roomState == QNRoomStateConnected) {
            self.conferenceButton.selected = YES;
            self.conferenceButton.enabled = YES;
            self.publishButton.enabled = YES;
        }
        else if (roomState == QNRoomStateIdle) {
            self.conferenceButton.selected = NO;
            self.publishButton.selected = NO;
            self.publishButton.enabled = NO;
        }
    });
}

- (void)sessionDidPublishLocalMedia:(QNRTCSession *)session {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.publishButton.enabled = YES;
        self.publishButton.selected = YES;
    });
}

- (void)RTCSession:(QNRTCSession *)session didJoinOfRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: userId: %@ join room", userId);
}

- (void)RTCSession:(QNRTCSession *)session didLeaveOfRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: userId: %@ leave room", userId);
}

- (void)RTCSession:(QNRTCSession *)session didSubscribeUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: did subscribe userId: %@", userId);
}

- (void)RTCSession:(QNRTCSession *)session didPublishOfRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: did publish of userId: %@", userId);
    [self.session subscribe:userId];
}

- (void)RTCSession:(QNRTCSession *)session didUnpublishOfRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: did unpublish of userId: %@", userId);
}

- (void)RTCSession:(QNRTCSession *)session didKickoutByUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: didKickoutByUserId: %@", userId);
    NSString *message = [NSString stringWithFormat:@"didKickoutByUserId: %@", userId];
    [self showAlertWithMessage:message];
}

- (void)RTCSession:(QNRTCSession *)session didAudioMuted:(BOOL)muted byRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: didAudioMuted: %d byRemoteUserId: %@",muted, userId);
}

- (void)RTCSession:(QNRTCSession *)session didVideoMuted:(BOOL)muted byRemoteUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: didVideoMuted: %d byRemoteUserId: %@",muted, userId);
}

- (QNVideoRender *)RTCSession:(QNRTCSession *)session firstVideoDidDecodeOfRemoteUserId:(NSString *)userId {
    QNVideoRender *render = [[QNVideoRender alloc] init];
    [self.remoteUserArray addObject:render];
    NSInteger position = [self availablePosition];
    if (position < 0) {
        NSLog(@"no avilable position");
        return nil;
    }

    CGRect rect = CGRectMake(self.screenSize.width - self.remoteSize.width, position * self.remoteSize.height, self.remoteSize.width, self.remoteSize.height);
    render.renderView = [[QNVideoView alloc] initWithFrame:rect];
    [self.view insertSubview:render.renderView aboveSubview:self.session.previewView];
    [self setPositionDisable:position];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.remoteSize.width - 40, 0, 40, 40)];
    [button setTitle:@"踢出" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button addTarget:self action:@selector(kickoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [render.renderView addSubview:button];

    return render;
}

- (void)RTCSession:(QNRTCSession *)session didDetachRenderView:(UIView *)remoteView ofRemoteUserId:(nonnull NSString *)userId {
    [remoteView removeFromSuperview];
    double position = (NSInteger)(remoteView.center.y / (self.screenSize.height / 3));
    [self setPositionEnable:position];
}

- (void)RTCSession:(QNRTCSession *)session didGetStatistic:(NSDictionary *)statistic ofUserId:(NSString *)userId {
    NSLog(@"userId: %@, statistic: %@", userId, statistic);
}


@end
