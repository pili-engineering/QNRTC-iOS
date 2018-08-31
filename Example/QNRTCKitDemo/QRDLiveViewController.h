//
//  QRDLiveViewController.h
//  QNRTCKitDemo
//
//  Created by 朱玥静 on 2018/7/25.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRDLiveViewController : UIViewController
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, assign) BOOL adminExisting;

@end
