//
//  QRDUserNameView.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/16.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDUserNameView.h"

@implementation QRDUserNameView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initUserNameView];
    }
    return self;
}

- (void)initUserNameView {
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    
    UIView *userBackView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, viewWidth - 10, 40)];
    userBackView.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    userBackView.layer.cornerRadius = 20;
    [self addSubview:userBackView];
    
    self.userTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, viewWidth - 50, 40)];
    self.userTextField.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    self.userTextField.placeholder = @"昵称";
    self.userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.userTextField.attributedPlaceholder];
    [placeholderAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [placeholderAttributedString length])];
    [placeholderAttributedString addAttribute:NSFontAttributeName value:QRD_LIGHT_FONT(11) range:NSMakeRange(0, [placeholderAttributedString length])];
    self.userTextField.attributedPlaceholder = placeholderAttributedString;
    self.userTextField.textAlignment = NSTextAlignmentLeft;
    self.userTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.userTextField.font = QRD_REGULAR_FONT(13);
    self.userTextField.textColor = [UIColor whiteColor];
    [userBackView addSubview:_userTextField];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 45, viewWidth - 50, 20)];
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.text = @"仅支持 3 ~ 64 位字母、数字、_ 和 - 的组合";
    hintLabel.font = QRD_LIGHT_FONT(10);
    [self addSubview:hintLabel];

    self.agreementButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 55, 44, 44)];
    [self.agreementButton setImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];
    [self.agreementButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    [self addSubview:self.agreementButton];

    NSString *agreementText = @"同意牛会议用户协议";
    NSRange rangeA = [agreementText rangeOfString:@"同意"];
    NSRange rangeB = [agreementText rangeOfString:@"牛会议用户协议"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:agreementText];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeA];
    [attributedString addAttribute:NSForegroundColorAttributeName value:QRD_COLOR_RGBA(45, 152, 212, 1) range:rangeB];

    self.agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 65, viewWidth - 50, 25)];
    self.agreementLabel.textColor = [UIColor whiteColor];
    self.agreementLabel.attributedText = attributedString;
    self.agreementLabel.font = QRD_LIGHT_FONT(10);
    self.agreementLabel.userInteractionEnabled = YES;
    [self addSubview:self.agreementLabel];

    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 100, viewWidth - 10, 40)];
    self.nextButton.backgroundColor = QRD_COLOR_RGBA(52,170,220,1);
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.titleLabel.font = QRD_REGULAR_FONT(14);
    [self.nextButton setTitle:@"保存昵称" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_nextButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
