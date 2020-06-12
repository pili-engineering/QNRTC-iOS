//
//  QRDSettingViewController.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/17.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDSettingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRDSettingView.h"


@interface QRDSettingViewController ()
<
UITextFieldDelegate,
QRDSettingViewDelegate
>
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) QRDSettingView *setingView;
@property (nonatomic, strong) NSArray *configArray;
@property (nonatomic, strong) NSArray *configDicArray;
@property (nonatomic, strong) NSDictionary *configDic;

/**
 判断是否受英文状态下的自动补全影响（带来了特殊字符）
 */
@property (nonatomic, assign) BOOL resultCorrect;
@end

@implementation QRDSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QRD_GROUND_COLOR;
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, QRD_LOGIN_TOP_SPACE - 67, 26, 26)];
    [_backButton setImage:[UIImage imageNamed:@"set_back"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(getBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    [self setupSettingView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(95, QRD_LOGIN_TOP_SPACE + 212, QRD_SCREEN_WIDTH - 198, QRD_SCREEN_HEIGHT - QRD_LOGIN_TOP_SPACE - 340)];
    imageView.image = [UIImage imageNamed:@"qn_niu"];
    [self.view insertSubview:imageView atIndex:0];
}

- (void)setupSettingView {
    /**
    * 视频的分辨率，码率和帧率设置会影响到连麦质量；更高的分辨率和帧率也就意味着需要更大的码率和更好的网络环境。
    *
    * 首先，建议您根据实际产品情况选择分辨率，在不超过视频源分辨率的情况下更高的分辨率对应着更好的质量，
    * 在具体数值上，建议您根据下表或者常见的视频分辨率来做设置；
    * 然后，可以根据您的实际情况来选择帧率，帧率越高更能表现运动画面效果；通常设置为25或者30即可；
    * 最后，选择合适的码率设置，如果实际场景中有运动情况较多，可以参考下表中选择上限值。
    *
    * 如果您需要的分辨率或者帧率不在下表中，可以按比例来推算出一个合适的码率值，如:
    * A 分辨率 x B 帧率  =  2000kbps
    * 则：
    * A / 2 分辨率 x B 帧率 = 1000kbps
    */
    _configDicArray = @[@{@"VideoSize":NSStringFromCGSize(CGSizeMake(288, 352)), @"FrameRate":@15, @"Bitrate":@(400*1000)},
                   @{@"VideoSize":NSStringFromCGSize(CGSizeMake(480, 640)), @"FrameRate":@20, @"Bitrate":@(800*1000) },
                   @{@"VideoSize":NSStringFromCGSize(CGSizeMake(544, 960)), @"FrameRate":@25, @"Bitrate":@(1200*1000)},
                   @{@"VideoSize":NSStringFromCGSize(CGSizeMake(720, 1280)), @"FrameRate":@30, @"Bitrate":@(2000*1000)}];
    _configArray = @[@"288x352、15fps、400kbps",
                     @"480x640、20fps、800kbps",
                     @"544x960、25fps、1200kbps",
                     @"720x1280、30fps、2000kbps"];
    NSInteger selectedIndex;
    _configDic = [self getValueForKey:QN_SET_CONFIG_KEY];
    if ([_configDicArray containsObject:_configDic]) {
        selectedIndex = [_configDicArray indexOfObject:_configDic];
    } else{
        selectedIndex = 1;
    }

    NSString *placeholderText = [self getValueForKey:QN_USER_ID_KEY];
    NSString *appIdText = [self getValueForKey:QN_APP_ID_KEY];
    if ([self checkStringLengthZero:appIdText]) {
        appIdText = QN_RTC_DEMO_APPID;
    }
    _setingView = [[QRDSettingView alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH/2 - 150, QRD_LOGIN_TOP_SPACE, 308, 500) configArray:_configArray selectedIndex:selectedIndex  placeholderText:placeholderText appIdText:appIdText];
    _setingView.userTextField.delegate = self;
    _setingView.appIdTextField.delegate = self;
    _setingView.delegate = self;
    [_setingView.saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _setingView];
    
    
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

    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH / 2 - 20, bottomSpace + 12, 40, 10)];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"v%@", version];
    versionLabel.font = QRD_LIGHT_FONT(10);
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    [self.view bringSubviewToFront:versionLabel];
}


#pragma mark ---- QRDSettingViewDelegate ----
- (void)settingView:(QRDSettingView *)settingView didGetSelectedIndex:(NSInteger)selectedIndex {
    _configDic = _configDicArray[selectedIndex];
}

#pragma mark - button action

- (void)getBackAction:(UIButton *)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction:(UIButton *)save {
    [self.view endEditing:YES];
    
    BOOL userIdAvailable = NO;
    _setingView.userTextField.text = [_setingView.userTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *userIdText = [self getValueForKey:QN_USER_ID_KEY];
    
    // userTextField 内容发生变更，则检验
    if (![userIdText isEqualToString:_setingView.userTextField.text]) {
        if ([self checkStringLengthZero:_setingView.userTextField.text]) {
            [self showAlertWithMessage:@"昵称未填写，无法保存！"];
        } else{
            if ([self checkUserId:_setingView.userTextField.text] && _resultCorrect) {
                userIdAvailable = YES;
            } else{
                [self showAlertWithMessage:@"请按要求正确填写昵称！"];
            }
        }
    } else{
        userIdAvailable = YES;
    }
    
    _setingView.appIdTextField.text = [_setingView.appIdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self checkStringLengthZero:_setingView.appIdTextField.text]) {
        _setingView.appIdTextField.text = QN_RTC_DEMO_APPID;
    }
    
    if (userIdAvailable) {
        [self saveValue:_setingView.userTextField.text forKey:QN_USER_ID_KEY];
        [self saveValue:_setingView.appIdTextField.text forKey:QN_APP_ID_KEY];
        [self saveValue:_configDic forKey:QN_SET_CONFIG_KEY];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)checkUserId:(NSString *)userId {
    NSString *regString = @"^[a-zA-Z0-9_-]{3,50}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regString];
    BOOL result = [predicate evaluateWithObject:userId];
    return result;
}

- (BOOL)checkStringLengthZero:(NSString *)string {
    return 0 == string.length;
}

- (id)getValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)saveValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    _resultCorrect = [self checkUserId:text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

#pragma mark --- 键盘回收 ---
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --- 点击空白 ---
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.setingView hideSubConfigurationMenu];
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
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
