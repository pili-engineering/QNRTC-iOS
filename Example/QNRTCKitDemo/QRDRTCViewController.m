//
//  QRDRTCViewController.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/18.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDRTCViewController.h"
#import <ReplayKit/ReplayKit.h>
#import "UIView+Alert.h"
#import <QNRTCKit/QNRTCKit.h>
#import "QRDMergeSettingView.h"

#define QN_DELAY_MS 5000

@interface QRDRTCViewController ()
<
QRDMergeSettingViewDelegate,
UITextFieldDelegate
>
@property (nonatomic, strong) QRDMergeSettingView *mergeSettingView;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) NSString *mergeJobId;
@property (nonatomic, strong) NSArray<QNMergeStreamLayout *> *layouts;

@property (nonatomic, strong) UIScrollView *mergeScrollView;
@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, strong) UILabel *forwardLabel;

/**
* 如果您的场景包括合流转推和单路转推的切换，那么需要维护一个 serialNum 的参数，代表流的优先级，
* 使其不断自增来实现 rtmp 流的无缝切换。
*
* QNMergeJob 以及 QNForwardJob 中 publishUrl 的格式为：rtmp://domain/app/stream?serialnum=xxx
*
* 切换流程推荐为：
* 1. 单路转推 -> 创建合流任务（以创建成功的回调为准） -> 停止单路转推
* 2. 合流转推 -> 创建单路转推任务（以创建成功的回调为准） -> 停止合流转推
*
* 注意：
* 1. 两种合流任务，推流地址应该保持一致，只有 serialnum 存在差异
* 2. 在两种推流任务切换的场景下，合流任务务必使用自定义合流任务，并指定推流地址的 serialnum
*/
@property (nonatomic, assign) NSInteger serialNum;

@end

@implementation QRDRTCViewController

- (void)dealloc {
    [self removeNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QRD_COLOR_RGBA(20, 20, 20, 1);
    
    self.serialNum = 0;
    self.videoEncodeSize = CGSizeFromString(_configDic[@"VideoSize"]);
    self.bitrate = [_configDic[@"Bitrate"] integerValue];
    
    // 配置核心类 QNRTCEngine
    [self setupEngine];
    
    [self setupBottomButtons];
    
    // 添加配置合流的交互界面
    if ([self isAdminUser:self.userId]) {
        [self setupMergeSettingView];
    }
    
    // 发送请求获取进入房间的 Token
    [self requestToken];
    
    self.logButton = [[UIButton alloc] init];
    [self.logButton setImage:[UIImage imageNamed:@"log-btn"] forState:UIControlStateNormal];
    [self.logButton addTarget:self action:@selector(logAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logButton];
    [self.view bringSubviewToFront:self.tableView];
    
    [self.logButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    self.mergeButton = [[UIButton alloc] init];
    [self.mergeButton setImage:[UIImage imageNamed:@"stream_merge"] forState:UIControlStateNormal];
    [self.mergeButton addTarget:self action:@selector(mergeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mergeButton];

    UILabel *mergeLabel = [[UILabel alloc] init];
    mergeLabel.font = [UIFont systemFontOfSize:14];
    mergeLabel.textAlignment = NSTextAlignmentCenter;
    mergeLabel.textColor = [UIColor whiteColor];
    mergeLabel.text = @"合流转推";
    [self.view addSubview:mergeLabel];
    
    self.forwardButton = [[UIButton alloc] init];
    [self.forwardButton setImage:[UIImage imageNamed:@"signal_stream"] forState:UIControlStateNormal];
    [self.forwardButton addTarget:self action:@selector(forwardAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forwardButton];
    
    self.forwardLabel = [[UILabel alloc] init];
    self.forwardLabel.font = [UIFont systemFontOfSize:14];
    self.forwardLabel.textAlignment = NSTextAlignmentCenter;
    self.forwardLabel.textColor = [UIColor whiteColor];
    self.forwardLabel.text = @"单路转推";
    [self.view addSubview:_forwardLabel];
    
    [self.mergeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.size.equalTo(CGSizeMake(55, 55));
    }];
    
    [mergeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mergeButton);
        make.top.equalTo(self.mergeButton.mas_bottom).offset(2);
    }];
    
    [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(self.mergeButton).offset(80);
        make.size.equalTo(CGSizeMake(55, 50));
    }];
    
    [self.forwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.forwardButton);
        make.top.equalTo(self.forwardButton.mas_bottom).offset(2);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logButton);
        make.top.equalTo(self.logButton.mas_bottom);
        make.width.height.equalTo(self.view).multipliedBy(0.6);
    }];
    self.tableView.hidden = YES;
}

- (void)conferenceAction:(UIButton *)conferenceButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stoptimer];
    // 离开房间
    [self.engine leaveRoom];
    
    [super viewDidDisappear:animated];
}

- (void)setTitle:(NSString *)title {
    if (nil == self.titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
        if (@available(iOS 9.0, *)) {
            self.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
        } else {
            self.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:self.titleLabel];
    }
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.view.center.x, self.logButton.center.y);
    [self.view bringSubviewToFront:self.titleLabel];
}

- (void)joinRTCRoom {
    [self.view showNormalLoadingWithTip:@"加入房间中..."];
    // 将获取生成的 token 传入 sdk
    // 6.使用有效的 token 加入房间
    [self.engine joinRoomWithToken:self.token];
}

- (void)requestToken {
    [self.view showFullLoadingWithTip:@"请求 token..."];
    __weak typeof(self) wself = self;
    // 获取 Token 必须要有 3个信息
    // 1. roomName 房间名
    // 2. userId 用户名
    // 3. appId id标识（相同的房间、相同的用户名，不同的 appId 将无法进入同一个房间）
    [QRDNetworkUtil requestTokenWithRoomName:self.roomName appId:self.appId userId:self.userId completionHandler:^(NSError *error, NSString *token) {
        
        [wself.view hideFullLoading];
        
        if (error) {
            [wself addLogString:error.description];
            [wself.view showFailTip:error.description];
            wself.title = @"请求 token 出错，请检查网络";
        } else {
            NSString *str = [NSString stringWithFormat:@"获取到 token: %@", token];
            [wself addLogString:str];
            
            wself.token = token;
            // 加入房间
            [wself joinRTCRoom];
        }
    }];
}

- (void)setupEngine {
    [QNRTCEngine enableFileLogging];
    
    // 1.初始化 RTC 核心类 QNRTCEngine
    self.engine = [[QNRTCEngine alloc] init];
    // 2.设置 QNRTCEngineDelegate 状态回调的代理
    self.engine.delegate = self;
    
    // 3.设置相关配置
    // 视频帧率
    self.engine.videoFrameRate = [_configDic[@"FrameRate"] integerValue];;
    // 设置统计信息回调的时间间隔，不设置的话，默认不会回调统计信息
    self.engine.statisticInterval = 5;
    // 打开 sdk 自带的美颜效果
    [self.engine setBeautifyModeOn:YES];
    
    [self.colorView addSubview:self.engine.previewView];
    [self.renderBackgroundView addSubview:self.colorView];
    
    // 4.设置摄像头采集的预览视频位置
    [self.engine.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.colorView);
    }];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.renderBackgroundView);
    }];
    
    [self.renderBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 5.启动摄像头采集
    // 注意：记得在 Info.list 中添加摄像头、麦克风的相关权限
    // NSCameraUsageDescription、NSMicrophoneUsageDescription
    [self.engine startCapture];
}

- (void)setupBottomButtons {
    
    self.bottomButtonView = [[UIView alloc] init];
    [self.view addSubview:self.bottomButtonView];
    
    UIButton* buttons[6];
    NSString *selectedImage[] = {
        @"microphone",
        @"loudspeaker",
        @"video-open",
        @"face-beauty-open",
        @"close-phone",
        @"camera-switch-front",
    };
    NSString *normalImage[] = {
        @"microphone-disable",
        @"loudspeaker-disable",
        @"video-close",
        @"face-beauty-close",
        @"close-phone",
        @"camera-switch-end",
    };
    SEL selectors[] = {
        @selector(microphoneAction:),
        @selector(loudspeakerAction:),
        @selector(videoAction:),
        @selector(beautyButtonClick:),
        @selector(conferenceAction:),
        @selector(toggleButtonClick:)
    };
    
    UIView *preView = nil;
    for (int i = 0; i < ARRAY_SIZE(normalImage); i ++) {
        buttons[i] = [[UIButton alloc] init];
        [buttons[i] setImage:[UIImage imageNamed:selectedImage[i]] forState:(UIControlStateSelected)];
        [buttons[i] setImage:[UIImage imageNamed:normalImage[i]] forState:(UIControlStateNormal)];
        [buttons[i] addTarget:self action:selectors[i] forControlEvents:(UIControlEventTouchUpInside)];
        [self.bottomButtonView addSubview:buttons[i]];
    }
    int index = 0;
    _microphoneButton = buttons[index ++];
    _speakerButton = buttons[index ++];
    _speakerButton.selected = YES;
    _videoButton = buttons[index ++];
    _beautyButton = buttons[index ++];
    _conferenceButton = buttons[index ++];
    _togCameraButton = buttons[index ++];
    _beautyButton.selected = YES;//默认打开美颜
    
    CGFloat buttonWidth = 54;
    NSInteger space = (UIScreen.mainScreen.bounds.size.width - buttonWidth * 3)/4;
    
    NSArray *array = [NSArray arrayWithObjects:&buttons[3] count:3];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedItemLength:buttonWidth leadSpacing:space tailSpacing:space];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(buttonWidth);
        make.bottom.equalTo(self.bottomButtonView).offset(-space * 0.8);
    }];
    
    preView = buttons[3];
    array = [NSArray arrayWithObjects:buttons count:3];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedItemLength:buttonWidth leadSpacing:space tailSpacing:space];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(buttonWidth);
        make.bottom.equalTo(preView.mas_top).offset(-space * 0.8);
    }];
    
    preView = buttons[0];
    [self.bottomButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.top.equalTo(preView.mas_top);
    }];
}

- (void)setupMergeSettingView {
    self.keyboardHeight = 0;
    
    self.mergeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height > 667 ? 420 : 400)];
    self.mergeScrollView.scrollEnabled = YES;
    self.mergeScrollView.showsVerticalScrollIndicator = YES;
    self.mergeScrollView.showsHorizontalScrollIndicator = NO;
    self.mergeScrollView.bounces = NO;
    [self.view addSubview:_mergeScrollView];

    self.mergeSettingView = [[QRDMergeSettingView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height > 667 ? 420 : 400) userId:self.userId roomName:self.roomName];
    self.mergeSettingView.delegate = self;
    self.mergeSettingView.mergeStreamSize = CGSizeMake(480, 848);
    
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, 80)];
    self.buttonView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    [self.view addSubview:_buttonView];
    _mergeSettingView.saveButton.frame = CGRectMake(20, 10, UIScreen.mainScreen.bounds.size.width - 40, 40);
    [self.buttonView addSubview:_mergeSettingView.saveButton];
    
    self.mergeSettingView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, self.mergeSettingView.totalHeight);
    [self.mergeScrollView addSubview:_mergeSettingView];

    self.mergeScrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, self.mergeSettingView.totalHeight);
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipe:)];
       downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downSwipe];
    
    [self addNotification];
}

- (void)showSettingView {
    CGRect rc = self.mergeScrollView.frame;
    [UIView animateWithDuration:.3 animations:^{
        self.mergeScrollView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - rc.size.height, rc.size.width, rc.size.height);
        _buttonView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height - 80, UIScreen.mainScreen.bounds.size.width , 80);

    }];
}

- (void)hideSettingView {
    self.mergeButton.selected = NO;
    CGRect rc = self.mergeScrollView.frame;
    [UIView animateWithDuration:.3 animations:^{
        self.mergeScrollView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, rc.size.width, rc.size.height);
        _buttonView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, 80);
    }];
}

- (void)requestRoomUserList {
    [self.view showFullLoadingWithTip:@"请求房间用户列表..."];
    __weak typeof(self) wself = self;
    
    [QRDNetworkUtil requestRoomUserListWithRoomName:self.roomName appId:self.appId completionHandler:^(NSError *error, NSDictionary *userListDic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.view hideFullLoading];
            
            if (error) {
                [wself.view showFailTip:error.description];
                [wself addLogString:@"请求用户列表出错，请检查网络😂"];
            } else {
                [wself dealRoomUsers:userListDic];
            }
        });
    }];
}

- (void)dealRoomUsers:(NSDictionary *)usersDic {
    NSArray * userArray = [usersDic objectForKey:@"users"];
    if (0 == userArray.count) {
        [self.view showTip:@"房间中暂时没有其他用户"];
        [self addLogString:@"房间中暂时没有其他用户"];
    }
    if ([self isAdminUser:self.userId]) {
        [self.mergeSettingView resetMergeFrame];
        [self.mergeSettingView resetUserList];
    } else{
        [self.view showTip:@"你不是 admin，无法操作合流"];
        [self addLogString:@"你不是 admin，无法操作合流"];
    }
}

- (BOOL)isAdmin {
    return [self.userId.lowercaseString isEqualToString:@"admin"];
}

- (BOOL)isAdminUser:(NSString *)userId {
    return [userId.lowercaseString isEqualToString:@"admin"];
}

#pragma mark - Notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    
    CGRect rc = self.mergeScrollView.frame;
    [UIView animateWithDuration:duration animations:^{
        self.mergeScrollView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - rc.size.height - _keyboardHeight - 20, rc.size.width, rc.size.height);
        _buttonView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height - 60 - _keyboardHeight, UIScreen.mainScreen.bounds.size.width, 80);
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    _keyboardHeight = 0;
    NSDictionary *userInfo = [aNotification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect rc = self.mergeScrollView.frame;
    [UIView animateWithDuration:duration animations:^{
        self.mergeScrollView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - rc.size.height, rc.size.width, rc.size.height);
        _buttonView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height - 80, UIScreen.mainScreen.bounds.size.width, 80);
    }];
}

- (void)keyboardWillChange:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    
    CGRect rc = self.mergeScrollView.frame;
    [UIView animateWithDuration:duration animations:^{
        self.mergeScrollView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - rc.size.height - _keyboardHeight - 20, rc.size.width, rc.size.height);
        _buttonView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height - 60 - _keyboardHeight, UIScreen.mainScreen.bounds.size.width, 80);
    }];
}

- (void)downSwipe:(UISwipeGestureRecognizer *)swipe {
    // 如果处于编辑状态，先关掉键盘，否则如果 settingView 处于显示状态，执行隐藏操作
    if (self.mergeSettingView.firstTrackXTextField.isFirstResponder) {
        [self.mergeSettingView.firstTrackXTextField resignFirstResponder];
    } else if (self.mergeSettingView.firstTrackYTextField.isFirstResponder) {
        [self.mergeSettingView.firstTrackYTextField resignFirstResponder];
    } else if (self.mergeSettingView.firstTrackZTextField.isFirstResponder) {
        [self.mergeSettingView.firstTrackZTextField resignFirstResponder];
    } else if (self.mergeSettingView.firstTrackWidthTextField.isFirstResponder) {
        [self.mergeSettingView.firstTrackWidthTextField resignFirstResponder];
    } else if (self.mergeSettingView.firstTrackHeightTextField.isFirstResponder) {
        [self.mergeSettingView.firstTrackHeightTextField resignFirstResponder];
    } else if (self.mergeSettingView.secondTrackXTextField.isFirstResponder) {
        [self.mergeSettingView.secondTrackXTextField resignFirstResponder];
    } else if (self.mergeSettingView.secondTrackYTextField.isFirstResponder) {
        [self.mergeSettingView.secondTrackYTextField resignFirstResponder];
    } else if (self.mergeSettingView.secondTrackZTextField.isFirstResponder) {
        [self.mergeSettingView.secondTrackZTextField resignFirstResponder];
    } else if (self.mergeSettingView.secondTrackWidthTextField.isFirstResponder) {
        [self.mergeSettingView.secondTrackWidthTextField resignFirstResponder];
    } else if (self.mergeSettingView.secondTrackHeightTextField.isFirstResponder) {
        [self.mergeSettingView.secondTrackHeightTextField resignFirstResponder];
        
    } else if (self.mergeSettingView.widthTextField.isFirstResponder) {
        [self.mergeSettingView.widthTextField resignFirstResponder];
    } else if (self.mergeSettingView.heightTextField.isFirstResponder) {
        [self.mergeSettingView.heightTextField resignFirstResponder];
    } else if (self.mergeSettingView.fpsTextField.isFirstResponder) {
        [self.mergeSettingView.fpsTextField resignFirstResponder];
        
    } else if (self.mergeSettingView.bitrateTextField.isFirstResponder) {
        [self.mergeSettingView.bitrateTextField resignFirstResponder];
    } else if (self.mergeSettingView.mergeIdTextField.isFirstResponder) {
        [self.mergeSettingView.mergeIdTextField resignFirstResponder];
    } else if (self.mergeSettingView.minbitrateTextField.isFirstResponder) {
        [self.mergeSettingView.minbitrateTextField resignFirstResponder];
    } else if (self.mergeSettingView.maxbitrateTextField.isFirstResponder) {
        [self.mergeSettingView.maxbitrateTextField resignFirstResponder];
    } else if (self.mergeSettingView.frame.origin.y < self.view.bounds.size.height) {
        [self hideSettingView];
        self.mergeButton.selected = NO;
    }
}

#pragma mark - QRDMergeSettingView

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didSetMergeLayouts:(NSArray<QNMergeStreamLayout *> *)layouts jobId:(NSString *)jobId {
    // 默认合流时，jobId 为 nil
    [self.engine setMergeStreamLayouts:layouts jobId:jobId];
}

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didRemoveMergeLayouts:(NSArray<QNMergeStreamLayout *> *)layouts jobId:(NSString *)jobId {
    [self.engine removeMergeStreamLayouts:layouts jobId:jobId];
}

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didGetMessage:(NSString *)message {
    if ([message isEqualToString:@"设置成功"] || [message isEqualToString:@"关闭合流成功"] ) {
        [self.view endEditing:YES];
        [self hideSettingView];
    }
    [self.view showFailTip:message];
}

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didUpdateTotalHeight:(CGFloat)totalHeight {
    self.mergeSettingView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, totalHeight);
    self.mergeScrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, totalHeight);
}

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didUpdateMergeConfiguration:(QNMergeStreamConfiguration *)streamConfiguration layouts:(nonnull NSArray<QNMergeStreamLayout *> *)layouts jobId:(nonnull NSString *)jobId {
    // 自定义 merge 需要先停止默认的合流
    // 然后配置相应的流信息 QNMergeStreamConfiguration，根据 jobId 以区分
    // 注意调用后有相应回调才能 setMergeStreamLayouts，否则会报错
    self.serialNum++;
    streamConfiguration.publishUrl = [NSString stringWithFormat:@"rtmp://pili-publish.qnsdk.com/sdk-live/%@?serialnum=%@", self.roomName, @(self.serialNum)];
    [self.engine createMergeStreamJobWithConfiguration:streamConfiguration];
    _layouts = layouts;
    _mergeJobId = jobId;
}

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didCloseMerge:(NSString *)jobId {
    [self.engine stopMergeStreamWithJobId:jobId];
}

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didUseDefaultMerge:(BOOL)isDefault {
    if (isDefault) {
        if (_forwardButton.selected) {
            _mergeSettingView.saveEnable = NO;
            [self showAlertWithMessage:@"由于目前已开启单路转推，若需切换到合流任务，请关闭单路转推或开启自定义合流任务！" title:@"提示" completionHandler:nil];
        } else{
            _mergeSettingView.saveEnable = YES;
        }
    } else{
        _mergeSettingView.saveEnable = YES;
    }
}

#pragma mark - 连麦时长计算

- (void)startTimer {
    [self stoptimer];
    self.durationTimer = [NSTimer timerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(timerAction)
                                               userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.durationTimer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    self.duration ++;
    NSString *str = [NSString stringWithFormat:@"%02ld:%02ld", self.duration / 60, self.duration % 60];
    self.title = str;
}

- (void)stoptimer {
    if (self.durationTimer) {
        [self.durationTimer invalidate];
        self.durationTimer = nil;
    }
}

- (void)beautyButtonClick:(UIButton *)beautyButton {
    beautyButton.selected = !beautyButton.selected;
    [self.engine setBeautifyModeOn:beautyButton.selected];
}

- (void)toggleButtonClick:(UIButton *)button {
    // 切换摄像头（前置/后置）
    [self.engine toggleCamera];
}

- (void)microphoneAction:(UIButton *)microphoneButton {
    self.microphoneButton.selected = !self.microphoneButton.isSelected;
    // 打开/关闭音频
    [self.engine muteAudio:!self.microphoneButton.isSelected];
}

- (void)loudspeakerAction:(UIButton *)loudspeakerButton {
    // 打开/关闭扬声器
    self.engine.muteSpeaker = !self.engine.isMuteSpeaker;
    loudspeakerButton.selected = !self.engine.isMuteSpeaker;
}

- (void)videoAction:(UIButton *)videoButton {
    videoButton.selected = !videoButton.isSelected;
    NSMutableArray *videoTracks = [[NSMutableArray alloc] init];
    if (self.screenTrackInfo) {
        self.screenTrackInfo.muted = !videoButton.isSelected;
        [videoTracks addObject:self.screenTrackInfo];
    }
    if (self.cameraTrackInfo) {
        [videoTracks addObject:self.cameraTrackInfo];
        self.cameraTrackInfo.muted = !videoButton.isSelected;
    }
    // 打开/关闭视频画面
    [self.engine muteTracks:videoTracks];
    
    // 对应实际关闭连麦视频画面的场景
    // 可根据需求显示或隐藏摄像头采集的预览视图
    self.engine.previewView.hidden = !videoButton.isSelected;
    [self checkSelfPreviewGesture];
}

- (void)logAction:(UIButton *)button {
    button.selected = !button.isSelected;
    if (button.selected) {
        if ([self.tableView numberOfRowsInSection:0] != self.logStringArray.count) {
            [self.tableView reloadData];
        }
    }
    self.tableView.hidden = !button.selected;
}

- (void)mergeAction:(UIButton *)button {
    if (![self isAdminUser:self.userId]) {
        [self.view showTip:@"你不是 admin，无法操作合流！"];
        return;
    }
    button.selected = !button.isSelected;
    if (button.selected) {
        [self showSettingView];
    } else {
        [self hideSettingView];
    }
}

- (void)forwardAction:(UIButton *)button {
    if (![self isAdminUser:self.userId]) {
        [self.view showTip:@"你不是 admin，无法开启单路转推！"];
        return;
    }
    if ((_mergeSettingView.customMergeSwitch.isOn && _mergeSettingView.mergeSwitch.isOn) ||
        !_mergeSettingView.mergeSwitch.isOn) {
        button.selected = !button.isSelected;
        if (button.selected) {
            self.serialNum++;
            QNForwardStreamConfiguration *forwardConfig = [[QNForwardStreamConfiguration alloc] init];
            forwardConfig.audioOnly = NO;
            forwardConfig.jobId = self.roomName;
            forwardConfig.publishUrl = [NSString stringWithFormat:@"rtmp://pili-publish.qnsdk.com/sdk-live/%@?serialnum=%@", self.roomName, @(self.serialNum)];
            forwardConfig.audioTrackInfo = self.audioTrackInfo;
            forwardConfig.videoTrackInfo = self.cameraTrackInfo;
            [self.engine createForwardJobWithConfiguration:forwardConfig];
        } else {
            [self.engine stopForwardJobWithJobId:self.roomName];
            self.forwardLabel.text = @"单路转推";
        }
    } else{
        [self showAlertWithMessage:@"在开始启动单路转推前，请主动关闭合流任务或打开自定义合流任务以保证正常切换！" title:@"提示" completionHandler:nil];
    }
}

- (void)publish {
    
    QNTrackInfo *audioTrack = [[QNTrackInfo alloc] initWithSourceType:QNRTCSourceTypeAudio master:YES];
    QNTrackInfo *cameraTrack =  [[QNTrackInfo alloc] initWithSourceType:(QNRTCSourceTypeCamera)
                                                                    tag:cameraTag
                                                                 master:YES
                                                             bitrateBps:self.bitrate
                                                        videoEncodeSize:self.videoEncodeSize];
    // 7.发布音频、视频 track
    // track 可通过 QNTrackInfo 配置
    [self.engine publishTracks:@[audioTrack, cameraTrack]];
}

- (void)showAlertWithMessage:(NSString *)message title:(NSString *)title completionHandler:(void (^)(void))handler
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - QNRTCEngineDelegate

/**
 * SDK 运行过程中发生错误会通过该方法回调，具体错误码的含义可以见 QNTypeDefines.h 文件
 */
- (void)RTCEngine:(QNRTCEngine *)engine didFailWithError:(NSError *)error {
    [super RTCEngine:engine didFailWithError:error];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view hiddenLoading];

        NSString *errorMessage = error.localizedDescription;
        if (error.code == QNRTCErrorReconnectTokenError) {
            errorMessage = @"重新进入房间超时";
        }
        [self showAlertWithMessage:errorMessage title:@"错误" completionHandler:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    });
}

/**
 * 房间状态变更的回调。当状态变为 QNRoomStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leaveRoom 即可
 */
- (void)RTCEngine:(QNRTCEngine *)engine roomStateDidChange:(QNRoomState)roomState {
    [super RTCEngine:engine roomStateDidChange:roomState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view hiddenLoading];
        
        if (QNRoomStateConnected == roomState || QNRoomStateReconnected == roomState) {
            [self startTimer];
        } else {
            [self stoptimer];
        }
        
        if (QNRoomStateConnected == roomState) {
            // 获取房间内用户
            [self requestRoomUserList];
            
            [self.view showSuccessTip:@"加入房间成功"];
            self.videoButton.selected = YES;
            self.microphoneButton.selected = YES;
            [self publish];
        } else if (QNRoomStateIdle == roomState) {
            self.videoButton.enabled = NO;
            self.videoButton.selected = NO;
        } else if (QNRoomStateReconnecting == roomState) {
            [self.view showNormalLoadingWithTip:@"正在重连..."];
            self.title = @"正在重连...";
            self.videoButton.enabled = NO;
            self.microphoneButton.enabled = NO;
        } else if (QNRoomStateReconnected == roomState) {
            [self.view showSuccessTip:@"重新加入房间成功"];
            self.videoButton.enabled = YES;
            self.microphoneButton.enabled = YES;
        }
    });
}

/**
* 调用 publish 发布本地音视频 tracks 后收到的回调
*/
- (void)RTCEngine:(QNRTCEngine *)engine didPublishLocalTracks:(NSArray<QNTrackInfo *> *)tracks {
    [super RTCEngine:engine didPublishLocalTracks:tracks];
    
    dispatch_main_async_safe(^{
        [self.view hiddenLoading];
        [self.view showSuccessTip:@"发布成功了"];
        
        for (QNTrackInfo *trackInfo in tracks) {
            if (trackInfo.kind == QNTrackKindAudio) {
                self.microphoneButton.enabled = YES;
                self.isAudioPublished = YES;
                self.audioTrackInfo = trackInfo;
                continue;
            }
            if (trackInfo.kind == QNTrackKindVideo) {
                if ([trackInfo.tag isEqualToString:screenTag]) {
                    self.screenTrackInfo = trackInfo;
                    self.isScreenPublished = YES;
                } else {
                    self.videoButton.enabled = YES;
                    self.isVideoPublished = YES;
                    self.cameraTrackInfo = trackInfo;
                }
                continue;
            }
        }
        
        [self.mergeSettingView addMergeInfoWithTracks:tracks userId:self.userId];
        [self.mergeSettingView resetMergeFrame];
        [self.mergeSettingView resetUserList];
    });
}

/**
* 远端用户发布音/视频的回调
*/
- (void)RTCEngine:(QNRTCEngine *)engine didPublishTracks:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId {
    [super RTCEngine:engine didPublishTracks:tracks ofRemoteUserId:userId];
    
    dispatch_main_async_safe(^{
        [self.mergeSettingView addMergeInfoWithTracks:tracks userId:userId];
        [self.mergeSettingView resetMergeFrame];
        [self.mergeSettingView resetUserList];
    });
}

/**
 * 远端用户取消发布音/视频的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didUnPublishTracks:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId {
    [super RTCEngine:engine didUnPublishTracks:tracks ofRemoteUserId:userId];
    
    dispatch_main_async_safe(^{
        for (QNTrackInfo *trackInfo in tracks) {
            QRDUserView *userView = [self userViewWithUserId:userId];
            QNTrackInfo *tempInfo = [userView trackInfoWithTrackId:trackInfo.trackId];
            if (tempInfo) {
                [userView.traks removeObject:tempInfo];
                
                if (trackInfo.kind == QNTrackKindVideo) {
                    if ([trackInfo.tag isEqualToString:screenTag]) {
                        [userView hideScreenView];
                    } else {
                        [userView hideCameraView];
                    }
                } else {
                    [userView setMuteViewHidden:YES];
                }
                
                if (0 == userView.traks.count) {
                    [self removeRenderViewFromSuperView:userView];
                }
            }
        }
        
        [self.mergeSettingView removeMergeInfoWithTracks:tracks userId:userId];
        [self.mergeSettingView resetMergeFrame];
        [self.mergeSettingView resetUserList];
    });
}

/**
* 远端用户离开房间的回调
*/
- (void)RTCEngine:(QNRTCEngine *)engine didLeaveOfRemoteUserId:(NSString *)userId {
    [super RTCEngine:engine didLeaveOfRemoteUserId:userId];
    dispatch_main_async_safe(^{
        [self.mergeSettingView removeMergeInfoWithUserId:userId];
        [self.mergeSettingView resetMergeFrame];
        [self.mergeSettingView resetUserList];
    })
}

- (void)RTCEngine:(QNRTCEngine *)engine didCreateMergeStreamWithJobId:(NSString *)jobId {
    dispatch_main_async_safe(^{
        [self.engine setMergeStreamLayouts:_layouts jobId:_mergeJobId];
        [self.view endEditing:YES];
        [self hideSettingView];
        [self.view showFailTip:@"创建自定义合流成功"];
        
        // 注意：
        // 1. A 房间中创建的转推任务，只能在 A 房间中进行销毁，无法在其他房间中销毁
        // 2. delayMillisecond 代表转推任务延迟关闭的时间，如果您的场景涉及到房间的切换以及不同转推任务
        // 的切换，为了保证切换场景下播放的连续性，建议您务必添加延迟关闭时间；
        // 3. 如果您的业务场景不涉及到跨房间的转推任务切换，可以不用设置延迟关闭时间，直接调用
        // - (void)stopForwardJobWithJobId:(NSString *)jobId; 即可，SDK 默认会立即停止转推任务
        [self.engine stopForwardJobWithJobId:jobId delayMillisecond:QN_DELAY_MS];
        self.forwardButton.selected = NO;
        self.forwardLabel.text = @"单路转推";
    });
}

/**
 * 被 userId 踢出的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didKickoutByUserId:(NSString *)userId {
    //    [super RTCSession:session didKickoutByUserId:userId];
    
    NSString *str = [NSString stringWithFormat:@"你被用户 %@ 踢出房间", userId];
    
    dispatch_main_async_safe(^{
        [self.view showTip:str];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    });
}

/**
* 调用 subscribe 订阅 userId 成功后收到的回调
*/
- (void)RTCEngine:(QNRTCEngine *)engine didSubscribeTracks:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId {
    [super RTCEngine:engine didSubscribeTracks:tracks ofRemoteUserId:userId];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (QNTrackInfo *trackInfo in tracks) {
            QRDUserView *userView = [self userViewWithUserId:userId];
            if (!userView) {
                userView = [self createUserViewWithTrackId:trackInfo.trackId userId:userId];
                [self.userViewArray addObject:userView];
                NSLog(@"createRenderViewWithTrackId: %@", trackInfo.trackId);
            }
            if (nil == userView.superview) {
                [self addRenderViewToSuperView:userView];
            }
            
            QNTrackInfo *tempInfo = [userView trackInfoWithTrackId:trackInfo.trackId];
            if (tempInfo) {
                [userView.traks removeObject:tempInfo];
            }
            [userView.traks addObject:trackInfo];
            
            if (trackInfo.kind == QNTrackKindVideo) {
                if ([trackInfo.tag isEqualToString:screenTag]) {
                    if (trackInfo.muted) {
                        [userView hideScreenView];
                    } else {
                        [userView showScreenView];
                    }
                } else {
                    if (trackInfo.muted) {
                        [userView hideCameraView];
                    } else {
                        [userView showCameraView];
                    }
                }
            } else if (trackInfo.kind == QNTrackKindAudio) {
                [userView setMuteViewHidden:NO];
                [userView setAudioMute:trackInfo.muted];
            }
        }
    });
}

/**
 * 远端用户视频首帧解码后的回调，如果需要渲染，则需要返回一个带 renderView 的 QNVideoRender 对象
 */
- (QNVideoRender *)RTCEngine:(QNRTCEngine *)engine firstVideoDidDecodeOfTrackId:(NSString *)trackId remoteUserId:(NSString *)userId {
    [super RTCEngine:engine firstVideoDidDecodeOfTrackId:trackId remoteUserId:userId];
    
    QRDUserView *userView = [self userViewWithUserId:userId];
    if (!userView) {
        [self.view showFailTip:@"逻辑错误了 firstVideoDidDecodeOfRemoteUserId 中没有获取到 VideoView"];
    }
    
    userView.contentMode = UIViewContentModeScaleAspectFit;
    QNVideoRender *render = [[QNVideoRender alloc] init];
    
    QNTrackInfo *trackInfo = [userView trackInfoWithTrackId:trackId];
    render.renderView =   [trackInfo.tag isEqualToString:screenTag] ? userView.screenView : userView.cameraView;
    return render;
}

/**
 * 远端用户视频取消渲染到 renderView 上的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didDetachRenderView:(UIView *)renderView ofTrackId:(NSString *)trackId remoteUserId:(NSString *)userId {
    [super RTCEngine:engine didDetachRenderView:renderView ofTrackId:trackId remoteUserId:userId];
    
    QRDUserView *userView = [self userViewWithUserId:userId];
    if (userView) {
        QNTrackInfo *trackInfo = [userView trackInfoWithTrackId:trackId];
        if ([trackInfo.tag isEqualToString:screenTag]) {
            [userView hideScreenView];
        } else {
            [userView hideCameraView];
        }
        //        [self removeRenderViewFromSuperView:userView];
    }
}

/**
 * 远端用户音频状态变更为 muted 的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didAudioMuted:(BOOL)muted ofTrackId:(NSString *)trackId byRemoteUserId:(NSString *)userId {
    [super RTCEngine:engine didAudioMuted:muted ofTrackId:trackId byRemoteUserId:userId];
    
    QRDUserView *userView = [self userViewWithUserId:userId];
    [userView setAudioMute:muted];
}

/**
 * 远端用户视频状态变更为 muted 的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didVideoMuted:(BOOL)muted ofTrackId:(NSString *)trackId byRemoteUserId:(NSString *)userId {
    [super RTCEngine:engine didVideoMuted:muted ofTrackId:trackId byRemoteUserId:userId];
    
    QRDUserView *userView = [self userViewWithUserId:userId];
    QNTrackInfo *trackInfo = [userView trackInfoWithTrackId:trackId];
    if ([trackInfo.tag isEqualToString:screenTag]) {
        if (muted) {
            [userView hideScreenView];
        } else {
            [userView showScreenView];
        }
    } else {
        if (muted) {
            [userView hideCameraView];
        } else {
            [userView showCameraView];
        }
    }
}

/**
 * 本地用户离开房间的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didLeaveOfLocalSuccess:(BOOL)success {
    [super RTCEngine:engine didLeaveOfLocalSuccess:success];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view showSuccessTip:@"离开房间成功"];
    });
}

/**
 * 单路转推创建成功的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didCreateForwardJobWithJobId:(NSString *)jobId {
    [super RTCEngine:engine didCreateForwardJobWithJobId:jobId];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.forwardLabel.text = @"停止转推";
        [self.view showSuccessTip:[NSString stringWithFormat:@"JobId 为 %@ 的单路转推，创建成功！", jobId]];
        
        // 注意：
        // 1. A 房间中创建的转推任务，只能在 A 房间中进行销毁，无法在其他房间中销毁
        // 2. delayMillisecond 代表转推任务延迟关闭的时间，如果您的场景涉及到房间的切换以及不同转推任务
        // 的切换，为了保证切换场景下播放的连续性，建议您务必添加延迟关闭时间；
        // 3. 如果您的业务场景不涉及到跨房间的转推任务切换，可以不用设置延迟关闭时间，直接调用
        // - (void)stopMergeStreamWithJobId:(NSString *)jobId; 即可，SDK 默认会立即停止转推任务
        [self.engine stopMergeStreamWithJobId:jobId delayMillisecond:QN_DELAY_MS];
        self.mergeButton.selected = NO;
        self.mergeSettingView.mergeSwitch.on = NO;
        self.mergeSettingView.customMergeSwitch.on = NO;
        [self.mergeSettingView updateSwitch];
    });
}

/**
* 远端用户发生重连
*/
- (void)RTCEngine:(QNRTCEngine *)engine didReconnectingRemoteUserId:(NSString *)userId {
   [super RTCEngine:engine didReconnectingRemoteUserId:userId];
   dispatch_async(dispatch_get_main_queue(), ^{
       [self.view showSuccessTip:[NSString stringWithFormat:@"远端用户 %@，发生了重连！", userId]];
   });
}

/**
* 远端用户重连成功
*/
- (void)RTCEngine:(QNRTCEngine *)engine didReconnectedRemoteUserId:(NSString *)userId {
   [super RTCEngine:engine didReconnectedRemoteUserId:userId];
   dispatch_async(dispatch_get_main_queue(), ^{
       [self.view showSuccessTip:[NSString stringWithFormat:@"远端用户 %@，重连成功了！", userId]];
   });
}
@end
