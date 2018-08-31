//
//  QRDLiveView.h
//  QNRTCKitDemo
//
//  Created by 朱玥静 on 2018/7/25.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRDMergeInfo.h"

@interface QRDLiveView : UIView
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UITextField *xValueField;
@property (nonatomic, strong) UITextField *yValueField;
@property (nonatomic, strong) UITextField *zValueField;
@property (nonatomic, strong) UITextField *heightField;
@property (nonatomic, strong) UITextField *widthField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *liveSetting;
@property (nonatomic, strong) UIView *liveDetailSetting;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView *liveScreenView;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UISwitch *soundSwitchButton;
@property (nonatomic, strong) UISwitch *videoSwitchButton;
@property (nonatomic, strong) NSString *selectedUserName;

@property (nonatomic, weak) NSMutableArray *mergeInfoArray;

- (void)hideSubConfigurationMenu;
- (void)showSubConfigurationMenu;
- (void)hideAllSubConfiguration;

- (void)resetTextFieldString;

- (void)resetUserButton:(NSUInteger)count userNames:(NSArray *)userNames;

@end
