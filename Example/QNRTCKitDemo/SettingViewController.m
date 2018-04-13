//
//  SettingViewController.m
//  QNRTCKitDemo
//
//  Created by lawder on 2017/12/21.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "SettingViewController.h"

NSString * const RoomNameKey = @"RoomNameKey";


@interface SettingViewController ()

@property (nonatomic, strong) IBOutlet UITextField *textField;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *roomName = [userDefaults objectForKey:RoomNameKey];
    self.textField.text = roomName;
}

- (IBAction)saveButtonClick:(id)sender {
    if (!self.textField.text  || [self.textField.text isEqualToString:@""]) {
        [self showAlertWithMessage:@"房间名不能为空"];
        return;
    }

    [self.view endEditing:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.textField.text forKey:RoomNameKey];
    [userDefaults synchronize];
    [self showAlertWithMessage:@"保存成功"];
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
