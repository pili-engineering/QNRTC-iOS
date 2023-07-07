//
//  QRDLoginViewController.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/16.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDLoginViewController.h"
#import "QRDSettingViewController.h"
#import "QRDRTCViewController.h"
#import "QRDAgreementViewController.h"
#import "QRDUserNameView.h"
#import "QRDJoinRoomView.h"
#import "QRDScreenRecorderViewController.h"
#import "QRDScreenMainViewController.h"
#import "QRDPureAudioViewController.h"
#import "QRDPlayerViewController.h"

@interface QRDLoginViewController ()
<
UITextFieldDelegate
>
@property (nonatomic, strong) QRDUserNameView *userView;
@property (nonatomic, strong) QRDJoinRoomView *joinRoomView;
@property (nonatomic, strong) UIButton *setButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *userString;

/**
 判断是否受英文状态下的自动补全影响（带来了特殊字符）
 */
@property (nonatomic, assign) BOOL resultCorrect;
@end

@implementation QRDLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.view.backgroundColor = QRD_GROUND_COLOR;
    
    _userString = [[NSUserDefaults standardUserDefaults] objectForKey:QN_USER_ID_KEY];
    
    BOOL isStorage = NO;
    if (_userString.length != 0) {
        isStorage = YES;
    }
    [self setupLoginViewWithStorage:isStorage];
    [self setupLogoView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(95, QRD_LOGIN_TOP_SPACE + 192, QRD_SCREEN_WIDTH - 198, QRD_SCREEN_HEIGHT - QRD_LOGIN_TOP_SPACE - 340)];
    self.imageView.image = [UIImage imageNamed:@"qn_niu"];
    [self.view insertSubview:_imageView atIndex:0];
}

- (void)setupLoginViewWithStorage:(BOOL)storage {
    if (storage) {
        [self setupJoinRoomView];
    } else{
        _userView = [[QRDUserNameView alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH/2 - 150, QRD_LOGIN_TOP_SPACE, 308, 152)];
        _userView.userTextField.delegate = self;
        [_userView.nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tapgesturerecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreementLabelTapped:)];
        [_userView.agreementLabel addGestureRecognizer:tapgesturerecognizer];
        [_userView.agreementButton addTarget:self action:@selector(agreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_userView];
    }
}

- (void)setupJoinRoomView {
    _resultCorrect = NO;
    
    _joinRoomView = [[QRDJoinRoomView alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH/2 - 150, QRD_LOGIN_TOP_SPACE, 308, 310)];
    _joinRoomView.roomTextField.delegate = self;
    NSString *roomName = [[NSUserDefaults standardUserDefaults] objectForKey:QN_ROOM_NAME_KEY];
    _joinRoomView.roomTextField.text = roomName;
    // 直接使用缓存房间名时，不走 textFieldDidEndEditing 影响判断，故先做校验并返回结果
    _resultCorrect = [self checkRoomName:roomName];
    [self.view addSubview:_joinRoomView];

    _joinRoomView.confButton.selected = YES;
    [_joinRoomView.confButton addTarget:self action:@selector(confButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_joinRoomView.audioCallButton addTarget:self action:@selector(audioCallButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_joinRoomView.screenButton addTarget:self action:@selector(screenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_joinRoomView.joinButton addTarget:self action:@selector(joinAction:) forControlEvents:UIControlEventTouchUpInside];

    [_joinRoomView.liveButton addTarget:self action:@selector(liveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_joinRoomView.multiTrackButton addTarget:self action:@selector(multiTrackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _setButton.frame = CGRectMake(QRD_SCREEN_WIDTH - 40, QRD_LOGIN_TOP_SPACE - 68, 24, 24);
    [_setButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [_setButton addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_setButton];
    
    self.imageView.frame = CGRectMake(95, QRD_LOGIN_TOP_SPACE + 242, QRD_SCREEN_WIDTH - 190, QRD_SCREEN_HEIGHT - QRD_LOGIN_TOP_SPACE - 340);
}

- (void)setupLogoView {
    CGFloat bottomSpace = QRD_SCREEN_HEIGHT - 60;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH/2 - 1, bottomSpace - 29, 2, 22)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH/2 - 57, bottomSpace - 36, 36, 36)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImageView];
    
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH/2 + 19, bottomSpace - 36, 68, 36)];
    logoLabel.textColor = [UIColor whiteColor];
    logoLabel.textAlignment = NSTextAlignmentLeft;
    logoLabel.font = QRD_LIGHT_FONT(16);
    logoLabel.text = @"牛会议";
    [self.view addSubview:logoLabel];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, bottomSpace + 12, QRD_SCREEN_WIDTH - 40, 10)];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"版本号：%@  SDK 版本：%@", version, [QNRTC versionInfo]];
    versionLabel.font = QRD_LIGHT_FONT(10);
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    [self.view bringSubviewToFront:versionLabel];
}

#pragma mark - button action
- (void)nextAction:(UIButton *)next {
    [_userView.userTextField resignFirstResponder];
    if (!_userView.agreementButton.selected) {
        [self showAlertWithMessage:@"需要同意用户协议才能继续！"];
        return;
    }

    if (_userView.userTextField.text.length != 0) {
        _userView.userTextField.text = [_userView.userTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([self checkUserId:_userView.userTextField.text] && _resultCorrect) {
            _userString = _userView.userTextField.text;
            [[NSUserDefaults standardUserDefaults] setObject:_userString forKey:QN_USER_ID_KEY];
            [_userView removeFromSuperview];
            [self setupJoinRoomView];
        } else{
            [self showAlertWithMessage:@"请按要求正确填写昵称！"];
        }
    } else{
        [self showAlertWithMessage:@"请填写昵称！"];
    }
}

- (void)joinAction:(UIButton *)join {
    [self.view endEditing:YES];
    
    NSString *roomName;
    if (_joinRoomView.roomTextField.text.length != 0) {
        _joinRoomView.roomTextField.text = [_joinRoomView.roomTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([self checkRoomName:_joinRoomView.roomTextField.text] && _resultCorrect) {
            roomName = _joinRoomView.roomTextField.text;
        } else{
            [self showAlertWithMessage:@"请按要求正确填写房间名称！"];
            return;
        }
    } else{
        [self showAlertWithMessage:@"请填写房间名称！"];
        return;
    }

    NSDictionary *configDic = [[NSUserDefaults standardUserDefaults] objectForKey:QN_SET_CONFIG_KEY];
    if (!configDic) {
        configDic = @{@"VideoSize":NSStringFromCGSize(CGSizeMake(480, 640)), @"FrameRate":@15, @"Bitrate":@(400)};
    } else if (![configDic objectForKey:@"Bitrate"]) {
        // 如果不存在 Bitrate key，做一下兼容处理
        configDic = @{@"VideoSize":NSStringFromCGSize(CGSizeMake(480, 640)), @"FrameRate":@15, @"Bitrate":@(400)};
        [[NSUserDefaults standardUserDefaults] setObject:configDic forKey:QN_SET_CONFIG_KEY];
    }
    NSNumber *preferValue = [[NSUserDefaults standardUserDefaults] objectForKey:QN_SET_PREFER_KEY];
    NSNumber *senceValue = [[NSUserDefaults standardUserDefaults] objectForKey:QN_SET_SCENE_KEY];
    NSNumber *wareValue = [[NSUserDefaults standardUserDefaults] objectForKey:QN_SET_WARE_KEY];

    [[NSUserDefaults standardUserDefaults] setObject:roomName forKey:QN_ROOM_NAME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 校验缓存的 userId
    if (![self checkUserId:_userString]) {
        [self showAlertWithMessage:@"请点击右上角设置按钮，将昵称修改正确并保存后，再进房间！\n Please click the Settings button in the upper right corner，after the nickname is modified correctly and saved successfully，then enter the room again！"];
    } else{
        if (_joinRoomView.confButton.selected) {
            // 连麦主入口
            QRDRTCViewController *rtcVC = [[QRDRTCViewController alloc] init];
            rtcVC.configDic = configDic;
            rtcVC.preferValue = preferValue;
            rtcVC.senceValue = senceValue;
            rtcVC.wareValue = wareValue;
            rtcVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:rtcVC animated:YES completion:nil];
        }
        else if (_joinRoomView.audioCallButton.selected) {
            // 纯音频连麦入口
            QRDPureAudioViewController *rtcVC = [[QRDPureAudioViewController alloc] init];
            rtcVC.configDic = configDic;
            rtcVC.preferValue = preferValue;
            rtcVC.senceValue = senceValue;
            rtcVC.wareValue = wareValue;
            rtcVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:rtcVC animated:YES completion:nil];
        }
        else if (_joinRoomView.screenButton.selected) {
            // 录屏入口
            QRDScreenRecorderViewController *recorderViewController = [[QRDScreenRecorderViewController alloc] init];
            recorderViewController.configDic = configDic;
            recorderViewController.preferValue = preferValue;
            recorderViewController.senceValue = senceValue;
            recorderViewController.wareValue = wareValue;
            recorderViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:recorderViewController animated:YES completion:nil];
        } else if (_joinRoomView.multiTrackButton.selected) {
            // 录屏连麦入口
            QRDScreenMainViewController *vc = [[QRDScreenMainViewController alloc] init];
            vc.configDic = configDic;
            vc.preferValue = preferValue;
            vc.senceValue = senceValue;
            vc.wareValue = wareValue;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

- (void)settingAction:(UIButton *)setting {
    QRDSettingViewController *settingVC = [[QRDSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)liveButtonClick:(UIButton *)liveButton {
    [self.view endEditing:YES];

    NSString *roomName;
    if (_joinRoomView.roomTextField.text.length != 0) {
        _joinRoomView.roomTextField.text = [_joinRoomView.roomTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([self checkRoomName:_joinRoomView.roomTextField.text] && _resultCorrect) {
            roomName = _joinRoomView.roomTextField.text;
        } else{
            [self showAlertWithMessage:@"请按要求正确填写房间名称！"];
            return;
        }
    } else{
        [self showAlertWithMessage:@"请填写房间名称！"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:roomName forKey:QN_ROOM_NAME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // 校验缓存的 userId
    if (![self checkUserId:_userString]) {
        [self showAlertWithMessage:@"请点击右上角设置按钮，将昵称修改正确并保存后，再进房间！\n Please click the Settings button in the upper right corner，after the nickname is modified correctly and saved successfully，then enter the room again！"];
    } else{
        QRDPlayerViewController *playerViewController = [[QRDPlayerViewController alloc] init];
        playerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:playerViewController animated:YES completion:nil];
    }
}

- (void)agreementButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.isSelected;
}

- (void)confButtonClick:(id)sender {
    _joinRoomView.confButton.selected = YES;
    _joinRoomView.audioCallButton.selected = NO;
    _joinRoomView.screenButton.selected = NO;
    _joinRoomView.multiTrackButton.selected = NO;
}

- (void)audioCallButtonClick:(id)sender {
    _joinRoomView.confButton.selected = NO;
    _joinRoomView.audioCallButton.selected = YES;
    _joinRoomView.screenButton.selected = NO;
    _joinRoomView.multiTrackButton.selected = NO;
}

- (void)multiTrackButtonClick:(id)sender {
    _joinRoomView.confButton.selected = NO;
    _joinRoomView.audioCallButton.selected = NO;
    _joinRoomView.screenButton.selected = NO;
    _joinRoomView.multiTrackButton.selected = YES;
}

- (void)screenButtonClick:(id)sender {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 11.0) {
        [self showAlertWithMessage:@"录屏分享仅支持 iOS 11 及以上系统"];
        return;
    }

    _joinRoomView.confButton.selected = NO;
    _joinRoomView.audioCallButton.selected = NO;
    _joinRoomView.screenButton.selected = YES;
    _joinRoomView.multiTrackButton.selected = NO;
}

- (void)agreementLabelTapped:(id)sender {
    QRDAgreementViewController *agreementViewController = [[QRDAgreementViewController alloc] init];
    agreementViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:agreementViewController animated:YES completion:nil];
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([textField isEqual:_userView.userTextField]) {
        _resultCorrect = [self checkUserId:text];
    }
    if ([textField isEqual:_joinRoomView.roomTextField]) {
        _resultCorrect = [self checkRoomName:text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

#pragma mark --- 点击空白 ---
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark --- 键盘回收 ---
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (BOOL)checkUserId:(NSString *)userId {
    NSString *regString = @"^[a-zA-Z0-9_-]{3,50}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regString];
    BOOL result = [predicate evaluateWithObject:userId];
    return result;
}

- (BOOL)checkRoomName:(NSString *)roomName {
    NSString *regString = @"^[a-zA-Z0-9_-]{3,64}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regString];
    BOOL result = [predicate evaluateWithObject:roomName];
    return result;
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
