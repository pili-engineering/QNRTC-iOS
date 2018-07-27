//
//  QRDRTCViewController.h
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/18.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRDRTCViewController : UIViewController
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, strong) NSDictionary *configDic;

@end
