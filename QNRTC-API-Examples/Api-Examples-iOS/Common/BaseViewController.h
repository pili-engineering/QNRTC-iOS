//
//  BaseViewController.h
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/24.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UILabel *localView;
@property (nonatomic, strong) UILabel *remoteView;
@property (nonatomic, strong) UILabel *localVolume;
@property (nonatomic, strong) UILabel *remoteVolume;
@property (nonatomic, strong) UIScrollView *controlScrollView;
@property (nonatomic, strong) UILabel *tipsView;
@property (nonatomic, copy) NSString *tips;

@property (nonatomic, copy) NSString *roomToken;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *userID;

- (void)clickBackItem;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelAction:(void(^__nullable)(void))cancelAction;

@end

NS_ASSUME_NONNULL_END
