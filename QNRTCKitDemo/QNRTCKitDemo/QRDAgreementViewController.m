//
//  UserDelegateVC.m
//  PLCodingShow
//
//  Created by   何舒 on 16/1/22.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "QRDAgreementViewController.h"

@interface QRDAgreementViewController ()

@end

@implementation QRDAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    // Do any additional setup after loading the view from its nib.
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"user_agreement" ofType:@"html"];
    NSURL * url = [NSURL fileURLWithPath:filePath];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    [self.userDelegateDataWeb loadRequest:urlRequest];
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
