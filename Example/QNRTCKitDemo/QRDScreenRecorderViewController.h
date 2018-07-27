//
//  QRDScreenRecorderViewController.h
//  QNRTCKitDemo
//
//  Created by lawder on 2018/6/15.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRDScreenRecorderViewController : UIViewController

@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, strong) NSDictionary *configDic;

@end
