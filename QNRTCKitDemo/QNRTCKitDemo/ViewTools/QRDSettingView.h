//
//  QRDSettingView.h
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/17.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QRDSettingType) {
    QRDSettingTypeConfig = 0,
    QRDSettingTypePrefer,
    QRDSettingTypeScene,
    QRDSettingTypeWare
};
@class QRDSettingView;
@protocol QRDSettingViewDelegate <NSObject>

@optional
- (void)settingView:(QRDSettingView *)settingView didGetSelectedIndex:(NSInteger)selectedIndex menuType:(QRDSettingType)menuType;
@end

@interface QRDSettingView : UIView
@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *appIdTextField;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *preferLabel;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *infoBackView;
@property (nonatomic, strong) UIView *preferBackView;
@property (nonatomic, assign) id<QRDSettingViewDelegate> delegate;
@property (nonatomic, strong) UIButton *defaultButton;
@property (nonatomic, strong) UIButton *voiceChatButton;
@property (nonatomic, strong) UIButton *soundEqualizeButton;
@property (nonatomic, strong) UIButton *uploadLogButton;
@property (nonatomic, strong) UIButton *customDefineButton;
@property (nonatomic, strong) UIButton *hardwareButton;
@property (nonatomic, strong) UIButton *softwareButton;

- (id)initWithFrame:(CGRect)frame configArray:(NSArray *)configArray preferArray:(NSArray *)preferArray config:(NSInteger)config prefer:(NSInteger)prefer placeholder:(NSString *)placeholder appId:(NSString *)appId scene:(NSInteger)scene ware:(NSInteger)ware;
- (void)hideConfigurationMenu;
- (void)hidePreferenceMenu;

@end



@interface QNSettingMenuViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UIImageView *selectImgView;

- (void)configreSubConfigString:(NSString *)configString isSelected:(BOOL)isSelected;
@end
