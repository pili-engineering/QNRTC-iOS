//
//  QRDLiveViewController.m
//  QNRTCKitDemo
//
//  Created by 朱玥静 on 2018/7/25.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDLiveViewController.h"
#import "QRDLiveView.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import <QNRTCKit/QNRTCKit.h>

static CGSize backgroundSize = {480, 848};

@interface QRDLiveViewController ()
<
QNRTCSessionDelegate,
PLPlayerDelegate
>

@property (nonatomic, strong) QRDLiveView *liveView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) PLPlayer *player;
@property (nonatomic, strong) QNRTCSession *session;
@property (nonatomic, strong) NSString *roomToken;
@property (nonatomic, strong) UIButton *logButton;
@property (nonatomic, strong) UIView *logView;
@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, copy)   NSString *logString;
@property (nonatomic, assign) BOOL reconnecting;
@property (nonatomic, strong) NSMutableArray *renderArray;

@property (nonatomic, strong) NSMutableArray<NSString *> *userList;

@property (nonatomic, strong) NSMutableArray<QRDMergeInfo *> *mergeInfoArray;

@property (nonatomic, strong) UIActivityIndicatorView *waitingView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation QRDLiveViewController

- (void)dealloc {
    NSLog(@"[dealloc] %@", self.description);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QRD_GROUND_COLOR;
    
    self.renderArray = [NSMutableArray array];
    self.userList = [NSMutableArray array];
    self.mergeInfoArray = [[NSMutableArray alloc] init];
    
    _backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_backButton setTintColor:[UIColor whiteColor]];
    _backButton.frame = CGRectMake(10, QRD_LOGIN_TOP_SPACE - 67, 44, 44);
    [_backButton setTitle:@"返回" forState:(UIControlStateNormal)];
    [_backButton addTarget:self action:@selector(getBackAction:) forControlEvents:UIControlEventTouchUpInside];
   
    _logButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, QRD_LOGIN_TOP_SPACE - 67, 44, 44)];
    [_logButton setImage:[UIImage imageNamed:@"log-btn"] forState:UIControlStateNormal];
    [_logButton addTarget:self action:@selector(logAction:) forControlEvents:UIControlEventTouchUpInside];

    [self setupLiveView];
    [self setupRTCLogView];
    [self.view addSubview:_logButton];
    [self.view addSubview:_backButton];

    [self setupPlayer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(replayStream) object:nil];
    [self.player stop];
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![self.player isPlaying]) {
        [self.player play];
    }
}

- (void)setupLiveView {
    
    _liveView = [[QRDLiveView alloc]initWithFrame:CGRectMake(0, 0, QRD_SCREEN_WIDTH, QRD_SCREEN_HEIGHT)];
    _liveView.mergeInfoArray = self.mergeInfoArray;
    [_liveView.settingButton addTarget:self action:@selector(settingClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [_liveView.confirmButton addTarget:self action:@selector(saveAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self requestUserListWithCompletionHandler:^(NSError *error, NSDictionary *userListDic) {
        if (error) {
            [self showAlertWithMessage:error.localizedDescription state:0];
            return ;
        }
        
        [_userList removeAllObjects];
        
        NSArray * userListArr = [userListDic objectForKey:@"users"];
        for (NSDictionary * dict in userListArr) {
            NSString * str =[dict objectForKey:@"userId"];
            [_userList addObject:str];
        }
        
        if (([_userList isKindOfClass:[NSArray class]] && _userList.count == 0)) {
            [self showAlertWithMessage:@"找不到会议直播，请确定该房间是否有其他用户发布流。"];
        } else {
            if(![self adminExist:_userList]) {
                self.userId = @"admin";
                [self showAutoDismissMessage:@"现在房间里没有 admin，您已成为 admin 并拥有了合流权限"];
            }
            [self setupRTCSession];
        }
    }];
    
    [self.view addSubview: _liveView];
}

- (void)showWaiting:(NSString *)tips {
    if (nil == self.waitingView) {
        self.waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        self.waitingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
        self.waitingView.frame = self.view.bounds;
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.font = [UIFont systemFontOfSize:14];
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.numberOfLines = 0;
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    self.tipLabel.text = tips;
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    
    CGRect rc = [tips boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 60, 300) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: self.tipLabel.font, NSParagraphStyleAttributeName: style} context:nil];
    self.tipLabel.frame = CGRectMake((self.view.bounds.size.width - rc.size.width)/2, self.view.center.y + rc.size.height / 2 + 20, rc.size.width, rc.size.height);
    
    [self.view addSubview:self.waitingView];
    [self.view addSubview:self.tipLabel];
    [self.waitingView startAnimating];
}

- (void)hideWaiting {
    [self.waitingView stopAnimating];
    [self.waitingView removeFromSuperview];
    [self.tipLabel removeFromSuperview];
}

- (void)setupPlayer {
    NSLog(@"播放地址: %@", _url.absoluteString);
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
    
    [option setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:_url option:option];
    [_liveView.liveScreenView addSubview:self.player.playerView];
    self.player.playerView.frame = _liveView.liveScreenView.bounds;
    
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    self.player.delegate = self;
}

- (void)setupRTCSession {
    self.session = [[QNRTCSession alloc] init];
    self.session.delegate = self;
    [self requestTokenWithCompletionHandler:^(NSError *error, NSString *token) {
        if (error) {
            [self showAlertWithMessage:error.localizedDescription state:0];
            return ;
        }
        self.roomToken = token;
        [self.session joinRoomWithToken:_roomToken];
    }];
}

- (void)setupRTCLogView {
    
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    self.logString = [NSString stringWithFormat:@"version: %@\nbundle id:\n%@\n", [QNRTCSession versionInfo], bundleId];

    CGFloat logViewWidth = QRD_SCREEN_WIDTH/1.7;
    CGFloat statisTextHeight = logViewWidth/2;
    if (QRD_SCREEN_WIDTH == 320) {
        statisTextHeight = logViewWidth/2 * 1.2;
    }
    
    _logView = [[UIView alloc] initWithFrame:CGRectMake(_liveView.viewWidth - 15 - logViewWidth, self.logButton.frame.origin.y + self.logButton.frame.size.height, logViewWidth, QRD_SCREEN_WIDTH)];
    _logView.backgroundColor = QRD_COLOR_RGBA(73, 73, 75, 0.5);
    _logView.hidden = YES;
    [self.view insertSubview:_logView aboveSubview:_liveView.liveScreenView];
    
    _logTextView = [[UITextView alloc] initWithFrame:_logView.bounds];
    _logTextView.backgroundColor = [UIColor clearColor];
    _logTextView.textColor =  QRD_COLOR_RGBA(255, 255, 255, 1);
    _logTextView.font = QRD_LIGHT_FONT(13);
    _logTextView.editable = NO;
    [_logView addSubview:_logTextView];
}


#pragma mark - button action
- (void)logAction:(UIButton *)logButton {
    logButton.selected = !logButton.selected;
    _logView.hidden = !logButton.selected;
    if (logButton.selected) {
        [_logView removeFromSuperview];
        [self.view insertSubview:_logView aboveSubview:_liveView.liveScreenView];
    }
}

- (void)saveAction:(UIButton *)save {
    
    BOOL frameTextShow = NO;
    _liveView.xValueField.text = [_liveView.xValueField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    _liveView.yValueField.text = [_liveView.yValueField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    _liveView.zValueField.text = [_liveView.zValueField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    _liveView.heightField.text = [_liveView.heightField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    _liveView.widthField.text = [_liveView.widthField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    float xValue = [_liveView.xValueField.text floatValue];
    float yValue = [_liveView.yValueField.text floatValue];
    float zValue = [_liveView.zValueField.text integerValue];
    float hValue = [_liveView.heightField.text floatValue];
    float wValue = [_liveView.widthField.text floatValue];
    
    BOOL isHidden = !_liveView.videoSwitchButton.isOn;
    BOOL isMute = !_liveView.soundSwitchButton.isOn;
    
    if (isHidden) {
        frameTextShow = YES;
    } else {
        if ([self checkStringLengthZero:_liveView.xValueField.text]) {
            [self showAlertWithMessage:@"x 轴数据不可以为空哦！"];
        }else if([self checkStringLengthZero:_liveView.yValueField.text]){
            [self showAlertWithMessage:@"y 轴数据不可以为空哦！"];
        }else if ([self checkStringLengthZero:_liveView.zValueField.text]){
            [self showAlertWithMessage:@"z 轴数据不可以为空哦！"];
        }else if ([self checkStringLengthZero:_liveView.heightField.text]){
            [self showAlertWithMessage:@"高度不可以为空哦！"];
        }else if ([self checkStringLengthZero:_liveView.widthField.text]){
            [self showAlertWithMessage:@"宽度不可以为空哦！"];
        }else{
            frameTextShow = YES;
        }
    }
    
    if (frameTextShow) {
        CGRect frame = CGRectMake(xValue, yValue, wValue, hValue);
        [self setMergeLayout:_liveView.selectedUserName frame:frame index:zValue mute:isMute hidden:isHidden];
        
        [self showAutoDismissMessage:@"设置成功"];
        [self.liveView hideAllSubConfiguration];
    }
}

- (void)setMergeLayout:(NSString *)userId frame:(CGRect)frame index:(NSInteger)zIndex mute:(BOOL)isMute hidden:(BOOL)isHidden {
    
    [self.session setMergeStreamLayoutWithUserId:userId
                                           frame:isHidden ? CGRectZero : frame
                                          zIndex:zIndex
                                           muted:isMute];
    // 保存信息
    QRDMergeInfo *mergeInfo = nil;
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if ([info.userId isEqualToString:userId]) {
            mergeInfo = info;
        }
    }
    if (!mergeInfo) {
        mergeInfo = [[QRDMergeInfo alloc] init];
        mergeInfo.userId = userId;
        [self.mergeInfoArray addObject:mergeInfo];
    }
    
    mergeInfo.mute      = isMute;
    mergeInfo.hidden    = isHidden;
    mergeInfo.mergeFrame= frame;
    mergeInfo.zIndex    = zIndex;
}

- (void)settingClick:(UIButton *)settingButton {
    if([self isAdmin:self.userId]){
        [self.liveView showSubConfigurationMenu];
    }else{
         [self showAlertWithMessage:@"您不是 admin，没有合流权限哦"];
    }
}

- (void)getBackAction:(UIButton *)back {
    if ([self isAdmin:self.userId]) {
        [self.session stopMergeStream];
    }
    [self.session leaveRoom];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAutoDismissMessage:(NSString *)message {
    
    if (!message.length) return;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = message;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.layer.cornerRadius = 5;
    label.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
    label.clipsToBounds = YES;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    
    CGRect rc = [message boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 60, 300) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: label.font, NSParagraphStyleAttributeName: style} context:nil];
    rc.size.width = rc.size.width + 20;
    rc.size.height = rc.size.height + 20;
    if (rc.size.height < 40) {
        rc.size.height = 40;
    }
    if (rc.size.width < 80) {
        rc.size.width = 80;
    }
    label.bounds = CGRectMake(0, 0, rc.size.width, rc.size.height);
    label.center = self.view.center;
    
    [self.view addSubview:label];
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)message state:(NSInteger)state {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

                           
#pragma mark - 请求数据
- (void)requestTokenWithCompletionHandler:(void (^)(NSError *error, NSString *token))completionHandler {
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

- (void)requestUserListWithCompletionHandler:(void (^)(NSError *error, NSDictionary *userListDic))completionHandler {
#warning
    /*
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     */

    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api-demo.qnsdk.com/v1/rtc/users/app/%@/room/%@", self.appId, self.roomName]];
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
        
        NSDictionary * userListDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, userListDic);
        });
    }];
    [task resume];
}


#pragma mark - 判断
- (BOOL)checkMuted {
    return  _liveView.soundSwitchButton.on == YES;
}

- (BOOL)checkStringLengthZero:(NSString *)string {
    return 0 == string.length;
}

- (BOOL)adminExist:(NSArray<NSString *> *)publishingUserlist {
    for(NSString *str in publishingUserlist){
        if ([self isAdmin:str]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isAdmin:(NSString *)string {
    return [string isEqualToString:@"admin"];
}


#pragma mark - QNRTCSessionDelegate
/**
 * SDK 运行过程中发生错误会通过该方法回调，具体错误码的含义可以见 QNTypeDefines.h 文件
 */
- (void)RTCSession:(QNRTCSession *)session didFailWithError:(NSError *)error {
    NSLog(@"QNRTCKitDemo: didFailWithError: %@", error);
    [self showAlertWithMessage:error.localizedDescription];
    [self hideWaiting];
}

/**
 * 房间状态变更的回调。当状态变为 QNRoomStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leaveRoom 即可
 */
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
            [self hideWaiting];
            [self resetButton];
            
            if ([self isAdmin:self.userId]) {
                [self mergeStream];
            }
        } else if (roomState == QNRoomStateIdle) {
            
        } else if (roomState == QNRoomStateReconnecting) {
            
            [self showWaiting:@"正在重连..."];
        }
    });
}

/**
 * 远端用户加入房间的回调
 */
- (void)RTCSession:(QNRTCSession *)session didJoinOfRemoteUserId:(NSString *)userId {
    NSLog(@"(void)RTCSession:(QNRTCSession *)session didJoinOfRemoteUserId:(NSString *)userId");
    dispatch_async(dispatch_get_main_queue(), ^{
    _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ join room \n", userId]];
    _logTextView.text = _logString;
    });
};

/**
 * 远端用户离开房间的回调
 */
- (void)RTCSession:(QNRTCSession *)session didLeaveOfRemoteUserId:(NSString *)userId {
    NSLog(@"RTCSession:(QNRTCSession *)session didLeaveOfRemoteUserId:(NSString *)userId");
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ leave room \n", userId]];
        _logTextView.text = _logString;
        [self resetButton];
        
        if ([self isAdmin:self.userId]) {
            if (0 == self.session.publishingUserList.count) {
                [self.session stopMergeStream];
                [self showAlertWithMessage:@"没人直播啦，请换个房间看看吧"];
            }
        }
    });
};

/**
 * 远端用户发布音/视频的回调
 */
- (void)RTCSession:(QNRTCSession *)session didPublishOfRemoteUserId:(NSString *)userId {
    NSLog(@"RTCSession:(QNRTCSession *)session didPublishOfRemoteUserId:(NSString *)userId");
    NSLog(@"QNRTCKitDemo: did publish of userId: %@", userId);
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ publish \n", userId]];
        _logTextView.text = _logString;
        if (self.session.roomState == QNRoomStateConnected) {
            [self resetButton];
            if ([self isAdmin:self.userId]) {
                [self mergeStream];
            }
        }
    });
};

/**
 * 远端用户取消发布音/视频的回调
 */
- (void)RTCSession:(QNRTCSession *)session didUnpublishOfRemoteUserId:(NSString *)userId {
    NSLog(@"RTCSession:(QNRTCSession *)session didUnpublishOfRemoteUserId:(NSString *)userId");
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"userId: %@ unpublish \n", userId]];
        _logTextView.text = _logString;

        [self resetButton];
        
        if ([self isAdmin:self.userId]) {
            if (0 == self.session.publishingUserList.count) {
                [self.session stopMergeStream];
            }
        }
    });
};

- (void)RTCSession:(QNRTCSession *)session didKickoutByUserId:(NSString *)userId {
    NSLog(@"QNRTCKitDemo: didKickoutByUserId: %@", userId);
    dispatch_async(dispatch_get_main_queue(), ^{
        _logString = [_logString stringByAppendingString:[NSString stringWithFormat:@"kickoutByUserId: %@ \n", userId]];
        _logTextView.text = _logString;
        
        [self showAlertWithMessage:[NSString stringWithFormat:@"您已被用户 %@ 踢出房间!", userId] state:2];
    });
}

#pragma mark - 用户列表显示相关

- (void)resetButton {
    [_liveView resetUserButton:self.session.publishingUserList.count userNames:self.session.publishingUserList];
}

#pragma mark - 合流相关
- (void)mergeStream {
    
    int col = ceil(sqrt(self.session.publishingUserList.count));
    
    CGFloat width = backgroundSize.width / col;
    CGFloat height = backgroundSize.height / col;
    
    for (int i = 0; i < col; i ++) {
        for (int j = 0; j < col; j ++) {
            NSInteger index = i * col + j;
            if (index >= self.session.publishingUserList.count) break;
            
            NSString *userId = [self.session.publishingUserList objectAtIndex:index];
            
            QRDMergeInfo *mergeInfo = nil;
            for (QRDMergeInfo * info in self.mergeInfoArray) {
                if ([info.userId isEqualToString:userId]) {
                    mergeInfo = info;
                }
            }
            
            CGRect rc = CGRectMake(j * width, i * height, width, height);
            if (mergeInfo) {
                [self setMergeLayout:userId frame:rc index:index mute:mergeInfo.isMute hidden:mergeInfo.isHidden];
            } else {
                [self setMergeLayout:userId frame:rc index:index mute:NO hidden:NO];
            }
        }
    }
    
    [_liveView resetTextFieldString];
}


#pragma mark - 点击空白
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.liveView hideSubConfigurationMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)replayStream {
    [self.player play];
}

#pragma mark - PLPlayerDelegate
- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    NSLog(@"Player Errro: %@", error);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(replayStream) object:nil];
    [self performSelector:@selector(replayStream) withObject:nil afterDelay:1];
}

@end
