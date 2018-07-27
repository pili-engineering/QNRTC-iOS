//
//  QRDSettingView.h
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/17.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QRDSettingView;
@protocol QRDSettingViewDelegate <NSObject>

@optional
- (void)settingView:(QRDSettingView *)settingView didGetSelectedIndex:(NSInteger)selectedIndex;
@end

@interface QRDSettingView : UIView
@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *appIdTextField;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *infoBackView;
@property (nonatomic, assign) id<QRDSettingViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame configArray:(NSArray *)configArray selectedIndex:(NSInteger)selectedIndex placeholderText:(NSString *)placeholderText appIdText:(NSString *)appIdText;
- (void)hideSubConfigurationMenu;
@end



@interface QNSettingMenuViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UIImageView *selectImgView;

- (void)configreSubConfigString:(NSString *)configString isSelected:(BOOL)isSelected;
@end
