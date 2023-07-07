//
//  QNDCustomDefineView.h
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2023/6/15.
//  Copyright © 2023 PILI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNDCustomDefineView : UIView
@property (nonatomic, strong) UITextField *encodeSizeTextField;
@property (nonatomic, strong) UITextField *bitrateTextField;
@property (nonatomic, strong) UITextField *frameRateTextField;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UILabel *infoLabel;
@end

NS_ASSUME_NONNULL_END
