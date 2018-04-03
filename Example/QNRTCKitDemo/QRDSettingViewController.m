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
    _configDicArray = @[@{@"VideoSize":NSStringFromCGSize(CGSizeMake(288, 352)), @"FrameRate":@20, @"Bitrate":@500},
                   @{@"VideoSize":NSStringFromCGSize(CGSizeMake(480, 640)), @"FrameRate":@20, @"Bitrate":@600},
                   @{@"VideoSize":NSStringFromCGSize(CGSizeMake(544, 960)), @"FrameRate":@20, @"Bitrate":@800},
                   @{@"VideoSize":NSStringFromCGSize(CGSizeMake(720, 1280)), @"FrameRate":@20, @"Bitrate":@1200}];
    _configArray = @[@"288x352、20fps、500kbps",
                     @"480x640、20fps、600kbps",
                     @"544x960、20fps、800kbps",
                     @"720x1280、20fps、1200kbps"];
    NSInteger selectedIndex;
    _configDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"QN_SET_CONFIG"];
    if ([_configDicArray containsObject:_configDic]) {
        selectedIndex = [_configDicArray indexOfObject:_configDic];
    } else{
        selectedIndex = 1;
    }

    NSString *placeholderText = [[NSUserDefaults standardUserDefaults] objectForKey:@"QN_USER_ID"];
    _setingView = [[QRDSettingView alloc] initWithFrame:CGRectMake(QRD_SCREEN_WIDTH/2 - 150, QRD_LOGIN_TOP_SPACE, 308, 500) configArray:_configArray selectedIndex:selectedIndex  placeholderText:placeholderText];
    _setingView.userTextField.delegate = self;
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
    if (_setingView.userTextField.text.length == 0) {
        [self showAlertWithMessage:@"昵称未填写，无法保存！"];
    } else{
        _setingView.userTextField.text = [_setingView.userTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([self checkUserId:_setingView.userTextField.text]) {
            [[NSUserDefaults standardUserDefaults] setObject:_setingView.userTextField.text forKey:@"QN_USER_ID"];
            [[NSUserDefaults standardUserDefaults] setObject:_configDic forKey:@"QN_SET_CONFIG"];
            [self.navigationController popViewControllerAnimated:YES];
        } else{
            [self showAlertWithMessage:@"请按要求正确填写昵称！"];
        }
    }
}

- (BOOL)checkUserId:(NSString *)userId {
    NSString *regString = @"^[a-zA-Z0-9_-]{3,50}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regString];
    BOOL result = [predicate evaluateWithObject:userId];
    return result;
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
