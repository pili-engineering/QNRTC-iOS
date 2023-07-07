//
//  QNDCustomDefineView.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2023/6/15.
//  Copyright © 2023 PILI. All rights reserved.
//

#import "QNDCustomDefineView.h"

@implementation QNDCustomDefineView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
        self.layer.cornerRadius = 20;
        [self initCustomDefineView];
    }
    return self;
}

- (void)initCustomDefineView {
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, viewWidth - 10, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"自定义参数配置";
    titleLabel.font = QRD_LIGHT_FONT(13);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UIView *encodeBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 65, viewWidth - 20, 40)];
    encodeBackView.backgroundColor = [UIColor blackColor];
    encodeBackView.layer.cornerRadius = 20;
    [self addSubview:encodeBackView];
    
    self.encodeSizeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, viewWidth - 60, 40)];
    self.encodeSizeTextField.backgroundColor = [UIColor blackColor];
    self.encodeSizeTextField.placeholder = @"分辨率   格式参照：720x1280，先宽后高";
    self.encodeSizeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSMutableAttributedString *encodeSizePlaceAttributeStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.encodeSizeTextField.attributedPlaceholder];
    [encodeSizePlaceAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [encodeSizePlaceAttributeStr length])];
    [encodeSizePlaceAttributeStr addAttribute:NSFontAttributeName value:QRD_LIGHT_FONT(11) range:NSMakeRange(0, [encodeSizePlaceAttributeStr length])];
    self.encodeSizeTextField.attributedPlaceholder = encodeSizePlaceAttributeStr;
    self.encodeSizeTextField.textAlignment = NSTextAlignmentLeft;
    self.encodeSizeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.encodeSizeTextField.font = QRD_REGULAR_FONT(13);
    self.encodeSizeTextField.textColor = [UIColor whiteColor];
    [encodeBackView addSubview:_encodeSizeTextField];
    
    UILabel *encodeHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 90, viewWidth - 60, 54)];
    encodeHintLabel.textColor = [UIColor whiteColor];
    encodeHintLabel.numberOfLines = 0;
    encodeHintLabel.text = @"无法达到设置值时，以实际采集输入为准";
    encodeHintLabel.font = QRD_LIGHT_FONT(10);
    [self addSubview:encodeHintLabel];
    
    UIView *bitrateBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 140, viewWidth - 20, 40)];
    bitrateBackView.backgroundColor = [UIColor blackColor];
    bitrateBackView.layer.cornerRadius = 20;
    [self addSubview:bitrateBackView];
    
    self.bitrateTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, viewWidth - 60, 40)];
    self.bitrateTextField.backgroundColor = [UIColor blackColor];
    self.bitrateTextField.placeholder = @"码率     单位：kbps";
    self.bitrateTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSMutableAttributedString *bitratePlaceAttributeStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.bitrateTextField.attributedPlaceholder];
    [bitratePlaceAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [bitratePlaceAttributeStr length])];
    [bitratePlaceAttributeStr addAttribute:NSFontAttributeName value:QRD_LIGHT_FONT(11) range:NSMakeRange(0, [bitratePlaceAttributeStr length])];
    self.bitrateTextField.attributedPlaceholder = bitratePlaceAttributeStr;
    self.bitrateTextField.textAlignment = NSTextAlignmentLeft;
    self.bitrateTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.bitrateTextField.font = QRD_REGULAR_FONT(13);
    self.bitrateTextField.textColor = [UIColor whiteColor];
    [bitrateBackView addSubview:_bitrateTextField];
    
    UILabel *bitrateHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 170, viewWidth - 60, 54)];
    bitrateHintLabel.textColor = [UIColor whiteColor];
    bitrateHintLabel.numberOfLines = 0;
    bitrateHintLabel.text = @"实际会受视频质量等级配置影响而变化";
    bitrateHintLabel.font = QRD_LIGHT_FONT(10);
    [self addSubview:bitrateHintLabel];
    
    UIView *frameBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 210, viewWidth - 20, 40)];
    frameBackView.backgroundColor = [UIColor blackColor];
    frameBackView.layer.cornerRadius = 20;
    [self addSubview:frameBackView];
    
    self.frameRateTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, viewWidth - 60, 40)];
    self.frameRateTextField.backgroundColor = [UIColor blackColor];
    self.frameRateTextField.placeholder = @"帧率     单位：fps";
    self.frameRateTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSMutableAttributedString *framePlaceAttributeStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.frameRateTextField.attributedPlaceholder];
    [framePlaceAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [framePlaceAttributeStr length])];
    [framePlaceAttributeStr addAttribute:NSFontAttributeName value:QRD_LIGHT_FONT(11) range:NSMakeRange(0, [framePlaceAttributeStr length])];
    self.frameRateTextField.attributedPlaceholder = framePlaceAttributeStr;
    self.frameRateTextField.textAlignment = NSTextAlignmentLeft;
    self.frameRateTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.frameRateTextField.font = QRD_REGULAR_FONT(13);
    self.frameRateTextField.textColor = [UIColor whiteColor];
    [frameBackView addSubview:_frameRateTextField];
    
    UILabel *frameHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 235, viewWidth - 60, 54)];
    frameHintLabel.textColor = [UIColor whiteColor];
    frameHintLabel.numberOfLines = 0;
    frameHintLabel.text = @"无法达到设置值时，以实际采集输入为准";
    frameHintLabel.font = QRD_LIGHT_FONT(10);
    [self addSubview:frameHintLabel];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 290, viewWidth - 30, 95)];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.font = QRD_LIGHT_FONT(10);
    self.infoLabel.numberOfLines = 0;
    [self addSubview:_infoLabel];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 390, viewWidth/2 - 30, 40)];
    self.cancelButton.backgroundColor = QRD_COLOR_RGBA(52,170,220,1);
    self.cancelButton.layer.cornerRadius = 20;
    self.cancelButton.titleLabel.font = QRD_REGULAR_FONT(14);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_cancelButton];
    
    self.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2 + 30 - 20, 390, viewWidth/2 - 30, 40)];
    self.sureButton.backgroundColor = QRD_COLOR_RGBA(52,170,220,1);
    self.sureButton.layer.cornerRadius = 20;
    self.sureButton.titleLabel.font = QRD_REGULAR_FONT(14);
    [self.sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_sureButton];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
