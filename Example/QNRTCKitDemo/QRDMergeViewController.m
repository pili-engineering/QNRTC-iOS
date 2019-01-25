//
//  QRDMergeViewController.m
//  QNRTCKitDemo
//
//  Created by hxiongan on 2019/1/8.
//  Copyright © 2019年 PILI. All rights reserved.
//

#import "QRDMergeViewController.h"
#import "QRDPublicHeader.h"
#import <QNRTCKit/QNRTCKit.h>
#import <PLPlayerKit/PLPlayerKit.h>
#import "QRDMergeInfo.h"
#import "UIView+Alert.h"
#import "QRDNetworkUtil.h"
#import <Masonry.h>
#import "QRDRTCViewController.h"

@interface QRDMergeViewController ()
<
PLPlayerDelegate,
UITextFieldDelegate,
QNRTCEngineDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) LogTableView *logTableView;
@property (nonatomic, strong) NSMutableArray *logStringArray;

@property (nonatomic, strong) QNRTCEngine *engine;
@property (nonatomic, strong) PLPlayer *player;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) UIView *settingView;

@property (nonatomic, strong) UITextField *firstTrackXTextField;
@property (nonatomic, strong) UITextField *firstTrackYTextField;
@property (nonatomic, strong) UITextField *firstTrackZTextField;
@property (nonatomic, strong) UITextField *firstTrackWidthTextField;
@property (nonatomic, strong) UITextField *firstTrackHeightTextField;

@property (nonatomic, strong) UITextField *secondTrackXTextField;
@property (nonatomic, strong) UITextField *secondTrackYTextField;
@property (nonatomic, strong) UITextField *secondTrackZTextField;
@property (nonatomic, strong) UITextField *secondTrackWidthTextField;
@property (nonatomic, strong) UITextField *secondTrackHeightTextField;

@property (nonatomic, strong) UILabel *firstTrackTagLabel;
@property (nonatomic, strong) UILabel *secondTrackTagLabel;
@property (nonatomic, strong) UISwitch *firstTrackSwitch;
@property (nonatomic, strong) UISwitch *secondTrackSwitch;
@property (nonatomic, strong) UISwitch *audioTrackSwitch;

@property (nonatomic, strong) UIScrollView *userScorllView;

@property (nonatomic, strong) NSMutableArray *mergeUserArray;
@property (nonatomic, strong) NSMutableArray *mergeInfoArray;
@property (nonatomic, strong) NSString *selectedUserId;
@property (nonatomic, assign) CGSize mergeStreamSize;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) NSString *mergeJobId;

@property (nonatomic, weak) QRDMergeInfo *firstTrackMergeInfo;
@property (nonatomic, weak) QRDMergeInfo *secondTrackMergeInfo;
@property (nonatomic, weak) QRDMergeInfo *audioTrackMergeInfo;

@property (nonatomic, strong) NSString *mergeUserId;

@end

@implementation QRDMergeViewController

- (void)dealloc {
    [self removeNotification];
    self.logTableView.dataSource = nil;
    self.logTableView.delegate = nil;
    NSLog(@"[dealloc]==> %@", self.description);
}

- (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] stringForKey:QN_USER_ID_KEY];
}

- (NSString *)roomName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:QN_ROOM_NAME_KEY];
}

- (NSString *)appId {
    NSString *appId = [[NSUserDefaults standardUserDefaults] stringForKey:QN_APP_ID_KEY];
    if (0 == appId.length) {
        appId = QN_RTC_DEMO_APPID;
        [[NSUserDefaults standardUserDefaults] setObject:appId forKey:QN_APP_ID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return appId;
}

- (BOOL)isAdmin {
    return [self.userId.lowercaseString isEqualToString:@"admin"];
}

- (BOOL)isAdminUser:(NSString *)userId {
    return [userId.lowercaseString isEqualToString:@"admin"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mergeUserId = self.userId;
    self.logStringArray = [[NSMutableArray alloc] init];
    self.keyboardHeight = 0;
    self.mergeStreamSize = CGSizeMake(480, 848);
    
    [self setupPlayer];
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"set_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.size.equalTo(CGSizeMake(44, 44));
    }];
    
    UIButton *logButton = [[UIButton alloc] init];
    [logButton setImage:[UIImage imageNamed:@"log-btn"] forState:(UIControlStateNormal)];
    [logButton addTarget:self action:@selector(clickLogButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:logButton];
    [logButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.size.equalTo(CGSizeMake(44, 44));
    }];

    self.logTableView = [[LogTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.logTableView.dataSource = self;
    self.logTableView.delegate = self;
    [self.view addSubview:self.logTableView];
    self.logTableView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.3];
    self.logTableView.separatorColor = [UIColor clearColor];

    [self.logTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(logButton);
        make.top.equalTo(logButton.mas_bottom);
        make.width.height.equalTo(self.view).multipliedBy(0.6);
    }];
    self.logTableView.hidden = YES;
    
    self.mergeInfoArray = [[NSMutableArray alloc] init];
    self.mergeUserArray = [[NSMutableArray alloc] init];
    [self setupEngine];
    [self requestRoomUserList];
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipe:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downSwipe];
    
    [self addNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(replayStream) object:nil];
    if ([self isAdminUser:self.mergeUserId]) {
        [self stopMergeStream];
    }
    [self.engine leaveRoom];
    [self.player stop];
    [super viewDidDisappear:animated];
}

- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [self resetSettingViewFrame:duration];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    _keyboardHeight = 0;
    NSDictionary *userInfo = [aNotification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self resetSettingViewFrame:duration];
}

- (void)keyboardWillChange:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    
    [self resetSettingViewFrame:duration];
}

#pragma mark - UI

- (void)resetSettingViewFrame:(CGFloat)duration {
    
    if (self.settingView.frame.origin.y < self.view.bounds.size.height) {
        CGRect rc = self.settingView.frame;
        [self.settingView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(rc.size.height);
            make.bottom.equalTo(self.view).offset(-self.keyboardHeight);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)downSwipe:(UISwipeGestureRecognizer *)swipe {
    // 如果处于编辑状态，先关掉键盘，否则如果 settingView 处于显示状态，执行隐藏操作
    if (self.firstTrackXTextField.isFirstResponder) {
        [self.firstTrackXTextField resignFirstResponder];
    } else if (self.firstTrackYTextField.isFirstResponder) {
        [self.firstTrackYTextField resignFirstResponder];
    } else if (self.firstTrackZTextField.isFirstResponder) {
        [self.firstTrackZTextField resignFirstResponder];
    } else if (self.firstTrackWidthTextField.isFirstResponder) {
        [self.firstTrackWidthTextField resignFirstResponder];
    } else if (self.firstTrackHeightTextField.isFirstResponder) {
        [self.firstTrackHeightTextField resignFirstResponder];
    } else if (self.secondTrackXTextField.isFirstResponder) {
        [self.secondTrackXTextField resignFirstResponder];
    } else if (self.secondTrackYTextField.isFirstResponder) {
        [self.secondTrackYTextField resignFirstResponder];
    } else if (self.secondTrackZTextField.isFirstResponder) {
        [self.secondTrackZTextField resignFirstResponder];
    } else if (self.secondTrackWidthTextField.isFirstResponder) {
        [self.secondTrackWidthTextField resignFirstResponder];
    } else if (self.secondTrackHeightTextField.isFirstResponder) {
        [self.secondTrackHeightTextField resignFirstResponder];
    } else if (self.settingView.frame.origin.y < self.view.bounds.size.height) {
        [self hideSettingView];
    }
}

- (void)showSettingView {
    CGRect rc = self.settingView.bounds;
    [self.settingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(rc.size.height);
    }];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideSettingView {
    CGRect rc = self.settingView.bounds;
    [self.settingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.equalTo(rc.size.height);
    }];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (UITextField *)commonTextField:(NSString *)placeholder alertText:(NSString *)alertText {
    return [self commonTextField:placeholder alertText:alertText keyboardType:UIKeyboardTypeNumberPad];
}

- (UITextField *)commonTextField:(NSString *)placeholder alertText:(NSString *)alertText keyboardType:(UIKeyboardType)keyboardType {
    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.keyboardType = keyboardType;
    textFiled.returnKeyType = UIReturnKeyNext;
    textFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes: @{NSForegroundColorAttributeName : [UIColor colorWithWhite:.5 alpha:1]}];
    textFiled.font = [UIFont systemFontOfSize:12];
    textFiled.layer.borderWidth = 1.0;
    textFiled.layer.borderColor = [UIColor colorWithWhite:.6 alpha:.5].CGColor;
    textFiled.layer.cornerRadius = 15;
    textFiled.clipsToBounds = YES;
    textFiled.delegate = self;
    textFiled.textColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = alertText;
    leftLabel.font = [UIFont systemFontOfSize:12];
    leftLabel.textColor = [UIColor grayColor];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [leftLabel sizeToFit];
    leftLabel.frame = CGRectMake(0, 0, leftLabel.bounds.size.width + 10, 22);
    textFiled.leftView = leftLabel;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    
    return textFiled;
}

- (void)setupSettingView {
    // 无论是不是 admin，都显示设置按钮，在用户点击设置按钮的时候，再提示不是管理员不能设置参数
    UIButton *settingButton = [[UIButton alloc] init];
    settingButton.backgroundColor = QRD_COLOR_RGBA(52,170,220,1);
    settingButton.layer.cornerRadius = 27.5;
    settingButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [settingButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [settingButton setTitle:@"设置" forState:(UIControlStateNormal)];
    [settingButton addTarget:self action:@selector(clickSettingButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:settingButton];
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(55, 55));
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-50);
    }];
    
    self.settingView = [[UIView alloc] init];
    self.settingView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setBackgroundColor:QRD_COLOR_RGBA(52,170,220,1)];
    [saveButton setTitle:@"提交" forState:(UIControlStateNormal)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
    [saveButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    saveButton.layer.borderWidth = .5;
    saveButton.layer.borderColor = [UIColor colorWithWhite:.6 alpha:.5].CGColor;
    saveButton.layer.cornerRadius = 20;
    [saveButton addTarget:self action:@selector(clickSaveButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.settingView addSubview:saveButton];
    
    self.userScorllView = [[UIScrollView alloc] init];
    
    self.firstTrackTagLabel = [[UILabel alloc] init];
    self.firstTrackTagLabel.textColor = [UIColor grayColor];
    self.firstTrackTagLabel.font = [UIFont systemFontOfSize:14];
    self.firstTrackTagLabel.text = @"第一路流：";
    [self.firstTrackTagLabel sizeToFit];
    
    self.firstTrackSwitch = [[UISwitch alloc] init];
    [self.firstTrackSwitch setOnTintColor:QRD_COLOR_RGBA(52,170,220,1)];
    [self.firstTrackSwitch sizeToFit];
    
    self.firstTrackXTextField   = [self commonTextField:@"" alertText:@"X轴:"];
    self.firstTrackYTextField   = [self commonTextField:@"" alertText:@"Y轴:"];
    self.firstTrackZTextField    = [self commonTextField:@"" alertText:@"Z轴:"];
    self.firstTrackWidthTextField     = [self commonTextField:@"" alertText:@"宽度:"];
    self.firstTrackHeightTextField    = [self commonTextField:@"" alertText:@"高度:"];
    
    [self.view addSubview:self.settingView];
    [self.settingView addSubview:self.userScorllView];
    [self.settingView addSubview:self.firstTrackTagLabel];
    [self.settingView addSubview:self.firstTrackSwitch];
    [self.settingView addSubview:self.firstTrackXTextField];
    [self.settingView addSubview:self.firstTrackYTextField];
    [self.settingView addSubview:self.firstTrackZTextField];
    [self.settingView addSubview:self.firstTrackWidthTextField];
    [self.settingView addSubview:self.firstTrackHeightTextField];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.settingView addSubview:line];
    
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.equalTo(UIScreen.mainScreen.bounds.size.height > 667 ? 420 : 400);
    }];
    
    [self.userScorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.settingView);
        make.height.equalTo(50);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.settingView);
        make.height.equalTo(1);
        make.top.equalTo(self.userScorllView.mas_bottom);
    }];
    
    [self.firstTrackTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.settingView).offset(20);
        make.top.equalTo(self.userScorllView.mas_bottom).offset(15);
        make.size.equalTo(self.firstTrackTagLabel.bounds.size);
    }];
    
    [self.firstTrackSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstTrackTagLabel.mas_right).offset(5);
        make.centerY.equalTo(self.firstTrackTagLabel);
        make.size.equalTo(self.firstTrackSwitch.bounds.size);
    }];
    
    NSArray *array = @[self.firstTrackXTextField, self.firstTrackYTextField, self.firstTrackZTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstTrackTagLabel.mas_bottom).offset(15);
        make.height.equalTo(30);
    }];
    
    array = @[self.firstTrackWidthTextField, self.firstTrackHeightTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:30 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstTrackYTextField.mas_bottom).offset(5);
        make.height.equalTo(self.firstTrackYTextField);
    }];
    
    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.settingView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstTrackWidthTextField);
        make.right.equalTo(self.firstTrackHeightTextField);
        make.height.equalTo(1);
        make.top.equalTo(self.firstTrackHeightTextField.mas_bottom).offset(10);
    }];
    
    //============== second stream =============
    
    self.secondTrackTagLabel = [[UILabel alloc] init];
    self.secondTrackTagLabel.textColor = [UIColor grayColor];
    self.secondTrackTagLabel.font = [UIFont systemFontOfSize:14];
    self.secondTrackTagLabel.text = @"第二路流：";
    [self.secondTrackTagLabel sizeToFit];

    self.secondTrackSwitch = [[UISwitch alloc] init];
    [self.secondTrackSwitch setOnTintColor:QRD_COLOR_RGBA(52,170,220,1)];
    [self.secondTrackSwitch sizeToFit];
    
    self.secondTrackXTextField   = [self commonTextField:@"" alertText:@"X轴:"];
    self.secondTrackYTextField   = [self commonTextField:@"" alertText:@"Y轴:"];
    self.secondTrackZTextField    = [self commonTextField:@"" alertText:@"Z轴:"];
    self.secondTrackWidthTextField     = [self commonTextField:@"" alertText:@"宽度:"];
    self.secondTrackHeightTextField    = [self commonTextField:@"" alertText:@"高度:"];
    
    [self.settingView addSubview:self.secondTrackTagLabel];
    [self.settingView addSubview:self.secondTrackSwitch];
    [self.settingView addSubview:self.secondTrackXTextField];
    [self.settingView addSubview:self.secondTrackYTextField];
    [self.settingView addSubview:self.secondTrackZTextField];
    [self.settingView addSubview:self.secondTrackWidthTextField];
    [self.settingView addSubview:self.secondTrackHeightTextField];
    
    [self.secondTrackTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.settingView).offset(20);
        make.top.equalTo(self.firstTrackHeightTextField.mas_bottom).offset(25);
        make.size.equalTo(self.secondTrackTagLabel.bounds.size);
    }];
    
    [self.secondTrackSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondTrackTagLabel.mas_right).offset(5);
        make.centerY.equalTo(self.secondTrackTagLabel);
        make.size.equalTo(self.secondTrackSwitch.bounds.size);
    }];
    
    array = @[self.secondTrackXTextField, self.secondTrackYTextField, self.secondTrackZTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondTrackTagLabel.mas_bottom).offset(15);
        make.height.equalTo(30);
    }];
    
    array = @[self.secondTrackWidthTextField, self.secondTrackHeightTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:30 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondTrackYTextField.mas_bottom).offset(5);
        make.height.equalTo(self.secondTrackYTextField);
    }];
    
    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.settingView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondTrackWidthTextField);
        make.right.equalTo(self.secondTrackHeightTextField);
        make.height.equalTo(1);
        make.top.equalTo(self.secondTrackHeightTextField.mas_bottom).offset(10);
    }];
    
    //============== audio =============
    
    UILabel *audioLabel = [[UILabel alloc] init];
    audioLabel.textColor = [UIColor grayColor];
    audioLabel.font = [UIFont systemFontOfSize:12];
    audioLabel.text = @"音频流设置:";
    [audioLabel sizeToFit];
    
    self.audioTrackSwitch = [[UISwitch alloc] init];
    [self.audioTrackSwitch setOnTintColor:QRD_COLOR_RGBA(52,170,220,1)];
    [self.audioTrackSwitch sizeToFit];

    [self.settingView addSubview:audioLabel];
    [self.settingView addSubview:self.audioTrackSwitch];

    [audioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstTrackXTextField);
        make.size.equalTo(audioLabel.bounds.size);
        make.top.equalTo(line.mas_bottom).offset(15);
    }];
    
    [self.audioTrackSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(audioLabel.mas_right).offset(5);
        make.centerY.equalTo(audioLabel);
        make.size.equalTo(self.audioTrackSwitch.bounds.size);
    }];
    
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondTrackXTextField);
        make.right.equalTo(self.secondTrackZTextField);
        make.top.equalTo(self.audioTrackSwitch.mas_bottom).offset(15);
        make.height.equalTo(40);
    }];
}

- (void)dealRoomUsers:(NSDictionary *)usersDic {
    NSArray * userArray = [usersDic objectForKey:@"users"];
    if (0 == userArray.count) {
        [self.view showTip:@"房间中暂时没有其他用户"];
        [self addLogString:@"房间中暂时没有其他用户"];
    }
    
    BOOL isAdminExist = NO;
    for (NSDictionary *dic in userArray) {
        NSString *userId =[dic objectForKey:@"userId"];
        if ([self isAdminUser:userId]) {
            isAdminExist = YES;
        }
    }
    
    NSString *logStr = nil;
    if (![self isAdmin]) {
        if (!isAdminExist) {
            self.mergeUserId = @"admin";
            logStr = @"房间中不存在 admin，你将以 admin 身份控制合流";
        }
    }
    
    if (logStr) {
        [self.view showSuccessTip:logStr];
        [self addLogString:logStr];
    }
    
    [self requestToken];
    
    if ([self isAdminUser:self.mergeUserId]) {
        [self setupSettingView];
    }
}

- (void)joinRTCRoom {
    [self.view showNormalLoadingWithTip:@"加入房间中..."];
    [self.engine joinRoomWithToken:self.token];
}

- (void)setupEngine {
    self.engine = [[QNRTCEngine alloc] init];
    self.engine.delegate = self;
    self.engine.statisticInterval = 3;
    self.engine.autoSubscribe = NO;
}

- (void)setupPlayer {
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
    
    [option setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:nil option:option];
    [self.view  insertSubview:self.player.playerView atIndex:0];
    [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    self.player.delegate = self;
}

- (QRDMergeInfo *)getAudioMergeInfoWithUserId:(NSString *)userId {
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if ([info.userId isEqualToString:userId] && info.kind == QNTrackKindAudio) {
            return info;
        }
    }
    return nil;
}

- (NSMutableArray *)getVideoMergeInfoWithUserId:(NSString *)userId {
    
    NSMutableArray *videoMergeInfos = nil;
    
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if ([info.userId isEqualToString:userId] && info.kind == QNTrackKindVideo) {
            if (!videoMergeInfos) {
                videoMergeInfos = [[NSMutableArray alloc] init];
            }
            [videoMergeInfos addObject:info];
        }
    }
    return videoMergeInfos;
}

- (void)addMergeInfoWithTracks:(NSArray *)tracks userId:(NSString *)userId {
    
    for (QNTrackInfo *trackInfo in tracks) {
        QRDMergeInfo *mergeInfo = [[QRDMergeInfo alloc] init];
        mergeInfo.trackId = trackInfo.trackId;
        mergeInfo.userId = userId;
        mergeInfo.kind = trackInfo.kind;
        mergeInfo.merged = YES;
        mergeInfo.trackTag = trackInfo.tag;
        
        if (trackInfo.kind == QNTrackKindVideo) {
            [self.mergeInfoArray insertObject:mergeInfo atIndex:0];
        }
        else {
            [self.mergeInfoArray addObject:mergeInfo];
        }
    }
    
    if (![self.mergeUserArray containsObject:userId]) {
        [self.mergeUserArray addObject:userId];
    }
}

- (void)removeMergeInfoWithTracks:(NSArray *)tracks userId:(NSString *)userId {
    for (QNTrackInfo *trackInfo in tracks) {
        [self removeMergeInfoWithTrackId:trackInfo.trackId];
    }
    
    BOOL deleteUser = YES;
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if ([info.userId isEqualToString:userId]) {
            deleteUser = NO;
            break;
        }
    }
    if (deleteUser) {
        [self.mergeUserArray removeObject:userId];
    }
}

- (void)removeMergeInfoWithUserId:(NSString *)userId {
    if (self.mergeInfoArray.count <= 0) {
        return;
    }
    
    for (NSInteger index = self.mergeInfoArray.count - 1; index >= 0; index--) {
        QRDMergeInfo *info = self.mergeInfoArray[index];
        if ([info.userId isEqualToString:userId]) {
            [self.mergeInfoArray removeObject:info];
        }
    }
    
    [self.mergeUserArray removeObject:userId];
}

- (void)removeMergeInfoWithTrackId:(NSString *)trackId {
    if (self.mergeInfoArray.count <= 0) {
        return;
    }
    
    for (NSInteger index = self.mergeInfoArray.count - 1; index >= 0; index--) {
        QRDMergeInfo *info = self.mergeInfoArray[index];
        if ([info.trackId isEqualToString:trackId]) {
            [self.mergeInfoArray removeObject:info];
        }
    }
}

- (void)resetMergeFrame {

    //  每当有用户发布或者取消发布的时候，都重置合流参数
    NSMutableArray *videoMergeArray = [[NSMutableArray alloc] init];
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if (info.merged && QNTrackKindVideo == info.kind) {
            [videoMergeArray addObject:info];
        }
    }
    
    if (videoMergeArray.count > 0) {
        NSArray *mergeFrameArray = [self getTrackMergeFrame:(int)videoMergeArray.count];
        
        for (int i = 0; i < mergeFrameArray.count; i ++) {
            QRDMergeInfo * info = [videoMergeArray objectAtIndex:i ];
            info.mergeFrame = [[mergeFrameArray objectAtIndex:i] CGRectValue];
        }
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if (info.isMerged) {
            QNMergeStreamLayout *layout = [[QNMergeStreamLayout alloc] init];
            layout.trackId = info.trackId;
            layout.frame = info.mergeFrame;
            layout.zIndex = info.zIndex;
            [array addObject:layout];
        }
    }
    
    if (array.count > 0) {
        [self.engine setMergeStreamLayouts:array jobId:self.mergeJobId];
    }
}

- (void)resetUserList {
    if (!self.userScorllView) {
        return;
    }
    
    for (UIView *subView in self.userScorllView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIView *preView = nil;
    __block CGFloat totalWidth = 0;
    for (int i = 0; i < self.mergeUserArray.count; i ++) {
        NSString *userId = self.mergeUserArray[i];
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:userId forState:(UIControlStateNormal)];
        [button sizeToFit];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button setTitleColor:QRD_COLOR_RGBA(52,170,220,1) forState:(UIControlStateSelected)];
        [button addTarget:self action:@selector(clickUserHeaderButton:) forControlEvents:(UIControlEventTouchUpInside)];
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 15;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.userScorllView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (preView) {
                make.left.equalTo(preView.mas_right).offset(20);
            } else {
                make.left.equalTo(self.userScorllView).offset(20);
            }
            CGFloat width = button.bounds.size.width + 10;
            totalWidth += width;
            totalWidth += 20;
            make.size.equalTo(CGSizeMake(width > 50 ? width : 50 , 30));
            make.centerY.equalTo(self.userScorllView);
        }];
        
        if (0 == i) {
            [self clickUserHeaderButton:button];
        }
        if (self.mergeInfoArray.count - 1 == i) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.userScorllView).offset(20);
            }];
        }
        preView = button;
    }
    self.userScorllView.contentSize = CGSizeMake(totalWidth + 20, self.userScorllView.bounds.size.height);
}

- (void)stopMergeStream {
    [self.engine stopMergeStreamWithJobId:self.mergeJobId];
}

- (void)enableFirstTrackCtrls:(BOOL)enable {
    self.firstTrackWidthTextField.enabled = enable;
    self.firstTrackHeightTextField.enabled = enable;
    self.firstTrackXTextField.enabled = enable;
    self.firstTrackYTextField.enabled = enable;
    self.firstTrackZTextField.enabled = enable;
    self.firstTrackSwitch.enabled = enable;
}

- (void)enableSecondTrackCtrls:(BOOL)enable {
    self.secondTrackWidthTextField.enabled = enable;
    self.secondTrackHeightTextField.enabled = enable;
    self.secondTrackXTextField.enabled = enable;
    self.secondTrackYTextField.enabled = enable;
    self.secondTrackZTextField.enabled = enable;
    self.secondTrackSwitch.enabled = enable;
}

- (void)enableAudioTrackCtrls:(BOOL)enable {
    self.audioTrackSwitch.enabled = enable;
}

- (void)clickSettingButton:(UIButton *)button {
    if (self.mergeInfoArray.count <= 0) {
        [self.view showFailTip:@"房间内没有流"];
        return;
    }
    
    [self showSettingView];
}

- (void)clickUserHeaderButton:(UIButton *)button {
    
    // 如果一个用户有多路视频，最多支持设置前两路视频
    
    if (button.selected) {
        return;
    }
    self.firstTrackMergeInfo = nil;
    self.secondTrackMergeInfo = nil;
    self.audioTrackMergeInfo = nil;
    
    self.selectedUserId = [button titleForState:(UIControlStateNormal)];
    
    for (UIView *subview in self.userScorllView.subviews) {
        subview.layer.borderColor = [UIColor grayColor].CGColor;
        if ([subview isKindOfClass:UIButton.class]) {
            [(UIButton *)subview setSelected:NO];
        }
    }
    button.selected = YES;
    button.layer.borderColor = QRD_COLOR_RGBA(52,170,220,1).CGColor;
    
    NSMutableArray *videoInfos = [self getVideoMergeInfoWithUserId:self.selectedUserId];
    self.audioTrackMergeInfo = [self getAudioMergeInfoWithUserId:self.selectedUserId];

    if (!(videoInfos.count || self.audioTrackMergeInfo)) {
        [self.view showFailTip:@"该 track 不存在或者已取消发布了哦"];
        return;
    }
    
    // 先查找是否有 tag 为 cameraTag 或者为 screenTag 的 track，有的话，先拿出来
    for (int i = 0; i < videoInfos.count; i ++) {
        QRDMergeInfo *info = videoInfos[i];
        if ([info.trackTag isEqualToString:cameraTag]) {
            self.firstTrackMergeInfo = info;
            [videoInfos removeObject:info];
            i --;
        } else if ([info.trackTag isEqualToString:screenTag]) {
            self.secondTrackMergeInfo = info;
            [videoInfos removeObject:info];
            i --;
        }
    }

    if (!self.firstTrackMergeInfo && videoInfos.count) {
        self.firstTrackMergeInfo = videoInfos.firstObject;
        [videoInfos removeObjectAtIndex:0];
    }
    
    if (!self.secondTrackMergeInfo && videoInfos.count) {
        self.secondTrackMergeInfo = videoInfos.firstObject;
        [videoInfos removeObjectAtIndex:0];
    }
    
    [self enableFirstTrackCtrls:nil != self.firstTrackMergeInfo];
    [self enableSecondTrackCtrls:nil != self.secondTrackMergeInfo];
    [self enableAudioTrackCtrls:nil != self.audioTrackMergeInfo];
    
    self.firstTrackXTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackMergeInfo.mergeFrame.origin.x];
    self.firstTrackYTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackMergeInfo.mergeFrame.origin.y];
    self.firstTrackZTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackMergeInfo.zIndex];
    self.firstTrackWidthTextField.text  = [NSString stringWithFormat:@"%d",(int)self.firstTrackMergeInfo.mergeFrame.size.width];
    self.firstTrackHeightTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackMergeInfo.mergeFrame.size.height];
    [self.firstTrackSwitch setOn:self.firstTrackMergeInfo.merged animated:YES];
    
    self.secondTrackXTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackMergeInfo.mergeFrame.origin.x];
    self.secondTrackYTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackMergeInfo.mergeFrame.origin.y];
    self.secondTrackZTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackMergeInfo.zIndex];
    self.secondTrackWidthTextField.text  = [NSString stringWithFormat:@"%d",(int)self.secondTrackMergeInfo.mergeFrame.size.width];
    self.secondTrackHeightTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackMergeInfo.mergeFrame.size.height];
    [self.secondTrackSwitch setOn:self.secondTrackMergeInfo.merged animated:YES];
    
    [self.audioTrackSwitch setOn:self.audioTrackMergeInfo.isMerged animated:YES];
    
    // UI 展示处理
    if (self.firstTrackMergeInfo.trackTag.length) {
        NSString *text = [NSString stringWithFormat:@"%@：",self.firstTrackMergeInfo.trackTag];
        if ([self.firstTrackMergeInfo.trackTag isEqualToString:cameraTag]) {
            text = @"相机流设置：";
        }
        self.firstTrackTagLabel.text = text;
    } else {
        self.firstTrackTagLabel.text = self.firstTrackMergeInfo ? @"第一路流：" : @"没有流，不需设置：";
    }
    
    if (self.secondTrackMergeInfo.trackTag.length) {
        NSString *text = [NSString stringWithFormat:@"%@：",self.firstTrackMergeInfo.trackTag];
        if ([self.secondTrackMergeInfo.trackTag isEqualToString:screenTag]) {
            text = @"屏幕录制流设置：";
        }
        self.secondTrackTagLabel.text = text;
    } else {
        self.secondTrackTagLabel.text = self.secondTrackMergeInfo ? @"第二路流：" : @"没有流，不需设置：";
    }
    
    [self.firstTrackTagLabel sizeToFit];
    [self.secondTrackTagLabel sizeToFit];
    
    [self.firstTrackTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.settingView).offset(20);
        make.top.equalTo(self.userScorllView.mas_bottom).offset(15);
        make.size.equalTo(self.firstTrackTagLabel.bounds.size);
    }];
    [self.secondTrackTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.settingView).offset(20);
        make.top.equalTo(self.firstTrackHeightTextField.mas_bottom).offset(25);
        make.size.equalTo(self.secondTrackTagLabel.bounds.size);
    }];
    
    [UIView animateWithDuration:.25 animations:^{
        [self.settingView layoutIfNeeded];
    }];
}

- (void)clickSaveButton {
    
    NSInteger firstTrackXValue = [self.firstTrackXTextField.text integerValue];
    NSInteger firstTrackYValue = [self.firstTrackYTextField.text integerValue];
    NSInteger firstTrackZValue = [self.firstTrackZTextField.text integerValue];
    NSInteger firstTrackWValue = [self.firstTrackWidthTextField.text integerValue];
    NSInteger firstTrackHValue = [self.firstTrackHeightTextField.text integerValue];
    BOOL firstTrackMerged = self.firstTrackSwitch.isOn;
    
    NSInteger secondTrackXValue = [self.secondTrackXTextField.text integerValue];
    NSInteger secondTrackYValue = [self.secondTrackYTextField.text integerValue];
    NSInteger secondTrackZValue = [self.secondTrackZTextField.text integerValue];
    NSInteger secondTrackWValue = [self.secondTrackWidthTextField.text integerValue];
    NSInteger secondTrackHValue = [self.secondTrackHeightTextField.text integerValue];
    BOOL secondTrackMerged = self.secondTrackSwitch.isOn;
    
    BOOL audioTrackMerged = self.audioTrackSwitch.isOn;
    
    if (!(self.firstTrackMergeInfo || self.secondTrackMergeInfo || self.audioTrackMergeInfo)) {
        [self.view showFailTip:@"出现未知错误，请重试"];
        return;
    }
    
    if (firstTrackMerged) {
        if (0 == firstTrackWValue || 0 == firstTrackHValue) {
            [self.view showFailTip:@"宽高数据不可以为 0"];
            return;
        }
    }
    
    if (secondTrackMerged) {
        if (0 == secondTrackWValue || 0 == secondTrackHValue) {
            [self.view showFailTip:@"宽高数据不可以为 0"];
            return;
        }
    }

    BOOL firstTrackChanged = NO;
    BOOL secondTrackChanged = NO;
    BOOL audioTrackChanged = NO;
    
    CGRect firstTrackFrame = CGRectMake(firstTrackXValue, firstTrackYValue, firstTrackWValue, firstTrackHValue);
    CGRect secondTrackFrame = CGRectMake(secondTrackXValue, secondTrackYValue, secondTrackWValue, secondTrackHValue);
    
    if (self.firstTrackMergeInfo) {
        if (!CGRectEqualToRect(firstTrackFrame, self.firstTrackMergeInfo.mergeFrame) ||
            firstTrackZValue != self.firstTrackMergeInfo.zIndex ||
            firstTrackMerged != self.firstTrackMergeInfo.isMerged) {
            firstTrackChanged = YES;
        }
    }
    
    if (self.secondTrackMergeInfo) {
        if (!CGRectEqualToRect(secondTrackFrame, self.secondTrackMergeInfo.mergeFrame) ||
            secondTrackZValue != self.secondTrackMergeInfo.zIndex ||
            secondTrackMerged != self.secondTrackMergeInfo.isMerged) {
            secondTrackChanged = YES;
        }
    }
    
    if (self.audioTrackMergeInfo) {
        if (audioTrackMerged != self.audioTrackMergeInfo.isMerged) {
            audioTrackChanged = YES;
        }
    }
    
    if (!(firstTrackChanged || audioTrackChanged || secondTrackChanged)) {
        [self.view showFailTip:@"没做任何改变"];
        return ;
    }
    
    NSMutableArray *addLayouts = [[NSMutableArray alloc] init];
    NSMutableArray *removeLayouts = [[NSMutableArray alloc] init];
    if (self.firstTrackMergeInfo && firstTrackChanged) {
        self.firstTrackMergeInfo.mergeFrame = firstTrackFrame;
        self.firstTrackMergeInfo.zIndex = firstTrackZValue;
        self.firstTrackMergeInfo.merged = firstTrackMerged;
        
        QNMergeStreamLayout *layout = [[QNMergeStreamLayout alloc] init];
        layout.frame = firstTrackFrame;
        layout.zIndex = firstTrackZValue;
        layout.trackId = self.firstTrackMergeInfo.trackId;
        if (firstTrackMerged) {
            [addLayouts addObject:layout];
        } else {
            [removeLayouts addObject:layout];
        }
    }
    
    if (self.secondTrackMergeInfo && secondTrackChanged) {
        self.secondTrackMergeInfo.mergeFrame = secondTrackFrame;
        self.secondTrackMergeInfo.zIndex = secondTrackZValue;
        self.secondTrackMergeInfo.merged = secondTrackMerged;
        
        QNMergeStreamLayout *layout = [[QNMergeStreamLayout alloc] init];
        layout.frame = secondTrackFrame;
        layout.zIndex = secondTrackZValue;
        layout.trackId = self.secondTrackMergeInfo.trackId;
        if (secondTrackMerged) {
            [addLayouts addObject:layout];
        } else {
            [removeLayouts addObject:layout];
        }
    }
    
    if (self.audioTrackMergeInfo && audioTrackChanged) {
        self.audioTrackMergeInfo.merged = audioTrackMerged;
    
        QNMergeStreamLayout *audioLayout = [[QNMergeStreamLayout alloc] init];
        audioLayout.trackId = self.audioTrackMergeInfo.trackId;
        if (audioTrackMerged) {
            [addLayouts addObject:audioLayout];
        } else {
            [removeLayouts addObject:audioLayout];
        }
    }
    
    if (addLayouts.count) {
        [self.engine setMergeStreamLayouts:addLayouts jobId:self.mergeJobId];
    }
    if (removeLayouts.count) {
        [self.engine removeMergeStreamLayouts:removeLayouts jobId:self.mergeJobId];
    }
    
    [self.view endEditing:YES];
    [self hideSettingView];
    [self.view showSuccessTip:@"设置成功"];
}

#pragma mark - Request

- (void)requestRoomUserList {
    [self.view showFullLoadingWithTip:@"请求房间用户列表..."];
    __weak typeof(self) wself = self;
    
    [QRDNetworkUtil requestRoomUserListWithRoomName:self.roomName appId:self.appId completionHandler:^(NSError *error, NSDictionary *userListDic) {
        [wself.view hideFullLoading];
        
        if (error) {
            [wself.view showFailTip:error.description];
            [wself addLogString:@"请求用户列表出错，请检查网络😂"];
        } else {
            [wself dealRoomUsers:userListDic];
        }
    }];
}

- (void)requestToken {
    [self.view showFullLoadingWithTip:@"请求 token..."];
    __weak typeof(self) wself = self;
    [QRDNetworkUtil requestTokenWithRoomName:self.roomName appId:self.appId userId:self.mergeUserId completionHandler:^(NSError *error, NSString *token) {
        
        [wself.view hideFullLoading];
        
        if (error) {
            [wself.view showFailTip:error.description];
            [wself addLogString:@"请求 token 出错，请检查网络😂"];
        } else {
            NSString *str = [NSString stringWithFormat:@"获取到 token: %@", token];
            [self addLogString:str];
            
            wself.token = token;
            [wself joinRTCRoom];
        }
    }];
}

#pragma mark - QNRTCEngineDelegate

/**
 * SDK 运行过程中发生错误会通过该方法回调，具体错误码的含义可以见 QNTypeDefines.h 文件
 */
- (void)RTCEngine:(QNRTCEngine *)engine didFailWithError:(NSError *)error {
    
    NSString *str = [NSString stringWithFormat:@"SDK 运行过程中发生错误会通过该方法回调，具体错误码的含义可以见 QNTypeDefines.h 文件:\nerror: %@",  error];
    [self addLogString:str];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view hiddenLoading];
        [self.view showFailTip:error.localizedDescription];
    });
}

/**
 * 房间状态变更的回调。当状态变为 QNRoomStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leaveRoom 即可
 */
- (void)RTCEngine:(QNRTCEngine *)engine roomStateDidChange:(QNRoomState)roomState {
    
    NSDictionary *roomStateDictionary =  @{
                                           @(QNRoomStateIdle) : @"Idle",
                                           @(QNRoomStateConnecting) : @"Connecting",
                                           @(QNRoomStateConnected): @"Connected",
                                           @(QNRoomStateReconnecting) : @"Reconnecting",
                                           @(QNRoomStateReconnected) : @"Reconnected"
                                           };
    NSString *str = [NSString stringWithFormat:@"房间状态变更的回调。当状态变为 QNRoomStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leaveRoom 即可:\nroomState: %@",  roomStateDictionary[@(roomState)]];
    [self addLogString:str];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.view hiddenLoading];
        
        if (QNRoomStateConnected == roomState) {
            dispatch_main_async_safe(^{
                [self resetMergeFrame];
                [self resetUserList];
                [self playStream];
            });
        } else if (QNRoomStateReconnecting == roomState) {
            [self.view showNormalLoadingWithTip:@"正在重连..."];
        } else if (QNRoomStateReconnected == roomState) {
            [self.view showSuccessTip:@"重新加入房间成功"];
        }
    });
}

/**
 * 远端用户发布音/视频的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didPublishTracks:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId {
    
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ 发布成功的回调:\nTracks: %@",  userId, tracks];
    [self addLogString:str];
    
    dispatch_main_async_safe(^{
        [self addMergeInfoWithTracks:tracks userId:userId];
        [self resetMergeFrame];
        [self resetUserList];
    });
}

/**
 * 远端用户取消发布音/视频的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didUnPublishTracks:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId {
    
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ 取消发布的回调:\nTracks: %@",  userId, tracks];
    [self addLogString:str];

    dispatch_main_async_safe(^{
        [self removeMergeInfoWithTracks:tracks userId:userId];
        [self resetMergeFrame];
        [self resetUserList];
    })
}

- (void)RTCEngine:(QNRTCEngine *)engine didLeaveOfRemoteUserId:(NSString *)userId {
    
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ 离开房间的回调", userId];
    [self addLogString:str];

    dispatch_main_async_safe(^{
        [self removeMergeInfoWithUserId:userId];
        [self resetMergeFrame];
        [self resetUserList];
    })
}

- (void)RTCEngine:(QNRTCEngine *)engine didCreateMergeStreamWithJobId:(NSString *)jobId {
    NSString *str = [NSString stringWithFormat:@"创建合流 id 成功了, jobId: %@", jobId];
    [self addLogString:str];
    dispatch_main_async_safe(^{
        self.title = @"合流已创建";
        [self.view hiddenLoading];
        [self.view showSuccessTip:str];
        
        [self resetMergeFrame];
        [self resetUserList];
        [self playStream];
    });
}

/**
 * 远端用户加入房间的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didJoinOfRemoteUserId:(NSString *)userId userData:(NSString *)userData {
    NSString *str = [NSString stringWithFormat:@"远端用户加入房间的回调:\nuserId: %@, userData: %@",  userId, userData];
    [self addLogString:str];
}

/**
 * 被 userId 踢出的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didKickoutByUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"被远端用户: %@ 踢出的回调",  userId];
    [self addLogString:str];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view showTip:str];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

/**
 * 远端用户音频状态变更为 muted 的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didAudioMuted:(BOOL)muted ofTrackId:(NSString *)trackId byRemoteUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ trackId: %@ 音频状态变更为: %d 的回调",  userId, trackId, muted];
    [self addLogString:str];
}

/**
 * 远端用户视频状态变更为 muted 的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didVideoMuted:(BOOL)muted ofTrackId:(NSString *)trackId byRemoteUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ trackId: %@ 视频状态变更为: %d 的回调",  userId, trackId, muted];
    [self addLogString:str];
}

#pragma mark - PLPlayerDelegate

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    NSString *str = [NSString stringWithFormat:@"Player Errro: %@", error];
    [self addLogString:str];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(replayStream) object:nil];
    [self performSelector:@selector(replayStream) withObject:nil afterDelay:1];
}

#pragma mark - Private

- (void)playStream {
    NSString * urlString = [self playUrl];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:urlString];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view showSuccessTip:@"直播流地址已经复制到剪切板"];
    });
    
    [self.player playWithURL:[NSURL URLWithString:[self playUrl]] sameSource:YES];
}

- (void)replayStream {
    [self.player playWithURL:[NSURL URLWithString:[self playUrl]] sameSource:YES];
}

- (NSString *)playUrl {
    
    if ([self.appId isEqualToString:QN_RTC_DEMO_APPID]) {
        return [NSString stringWithFormat:@"rtmp://pili-rtmp.qnsdk.com/sdk-live/%@",self.roomName];
    }
    
    return [NSString stringWithFormat:@"rtmp://pili-rtmp.qnsdk.com/sdk-live/%@_%@",self.appId, self.roomName];
}

- (NSArray <NSValue *>*)getTrackMergeFrame:(int)count {
    
    NSMutableArray *frameArray = [[NSMutableArray alloc] init];
    if (1 == count) {
        CGRect rc = CGRectMake(0, 0, self.mergeStreamSize.width, self.mergeStreamSize.height);
        NSValue *value = [NSValue valueWithCGRect:rc];
        [frameArray addObject:value];
        return frameArray;
    }
    
    int power = log2(count);
    int bigFrameCount = pow(2, power);
    int left = count - bigFrameCount;
    
    int widthPower = power / 2;
    int heightPower = power - power / 2;
    
    CGRect *pRect = (CGRect *)malloc(sizeof(CGRect) * bigFrameCount);
    int row = pow(2, heightPower);
    int col = pow(2, widthPower);
    CGFloat width = self.mergeStreamSize.width / (pow(2, widthPower));
    CGFloat height = self.mergeStreamSize.height / (pow(2, heightPower));
    
    for (int i = 0; i < row; i ++) {
        for (int j = 0; j < col; j ++) {
            pRect[i * col + j].origin.x = j * width;
            pRect[i * col + j].origin.y = i * height;
            pRect[i * col + j].size.width = width;
            pRect[i * col + j].size.height = height;
        }
    }
    
    if (power % 2 == 0) {
        // 需要横着补刀
        for (int i = 0; i < left; i ++) {
            CGRect rc = pRect[i];
            CGRect rc1 = rc;
            rc1.size.height = rc.size.height / 2;
            CGRect rc2 = rc;
            rc2.origin.y = rc.origin.y + rc.size.height / 2;
            rc2.size.height = rc.size.height / 2;
            
            NSValue *value = [NSValue valueWithCGRect:rc1];
            [frameArray addObject:value];
            value = [NSValue valueWithCGRect:rc2];
            [frameArray addObject:value];
        }
        for (int i = left; i < bigFrameCount; i ++) {
            CGRect rc = pRect[i];
            NSValue *value = [NSValue valueWithCGRect:rc];
            [frameArray addObject:value];
        }
    } else {
        // 需要竖着补刀
        for (int i = 0; i < left; i ++) {
            CGRect rc = pRect[i];
            CGRect rc1 = rc;
            rc1.size.width = rc.size.width / 2;
            CGRect rc2 = rc;
            rc2.origin.x = rc.origin.x + rc.size.width / 2;
            rc2.size.width = rc.size.width / 2;
            
            NSValue *value = [NSValue valueWithCGRect:rc1];
            [frameArray addObject:value];
            value = [NSValue valueWithCGRect:rc2];
            [frameArray addObject:value];
        }
        
        for (int i = left; i < bigFrameCount; i ++) {
            CGRect rc = pRect[i];
            NSValue *value = [NSValue valueWithCGRect:rc];
            [frameArray addObject:value];
        }
    }
    
    free(pRect);
    
    return frameArray;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource && log

- (void)clickLogButton {
    self.logTableView.hidden = !self.logTableView.isHidden;
    if (!self.logTableView.hidden) {
        if ([self.logTableView numberOfRowsInSection:0] != self.logStringArray.count) {
            [self.logTableView reloadData];
        }
    }
}

- (void)addLogString:(NSString *)logString {
    NSLog(@"%@", logString);
    
    @synchronized(_logStringArray) {
        [self.logStringArray addObject:logString];
    }
    
    dispatch_main_async_safe(^{
        // 只有日志 view 是显示的时候，才去更新 UI
        if (!self.logTableView.hidden) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self.logTableView selector:@selector(reloadData) object:nil];
            [self.logTableView performSelector:@selector(reloadData) withObject:nil afterDelay:.2];
        }
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    @synchronized(_logStringArray) {
        return self.logStringArray.count > 0 ? 1 : 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @synchronized(_logStringArray) {
        return _logStringArray.count;
    }
}

static const int cLabelTag = 10;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reuseIdentifier"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.tag = cLabelTag;
        
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(cell.contentView).offset(5);
            make.right.bottom.equalTo(cell.contentView).offset(-5);
        }];
    }
    
    UILabel *label = [cell.contentView viewWithTag:cLabelTag];
    @synchronized(_logStringArray) {
        if (_logStringArray.count > indexPath.row) {
            label.text = _logStringArray[indexPath.row];
        } else {
            label.text = @"Unknown message";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.logTableView.isScrolling = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.logTableView.isScrolling = decelerate;
    if (!decelerate) {
        CGFloat offset = fabs(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y);
        NSLog(@"value = %f", offset);
        // 这里小于 10 就算到底部了
        self.logTableView.isBottom =  offset < 10;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.logTableView.isScrolling = NO;
    
    CGFloat offset = fabs(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y);
    NSLog(@"value = %f", offset);
    // 这里小于 10 就算到底部了
    self.logTableView.isBottom =  offset < 10;
}

@end
