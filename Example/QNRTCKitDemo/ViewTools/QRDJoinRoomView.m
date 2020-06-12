//
//  QRDJoinRoomView.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/16.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDJoinRoomView.h"

@implementation QRDJoinRoomView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initJoinRoomView];
    }
    return self;
}

- (void)initJoinRoomView {
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    
    UIView *roomBackView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, viewWidth - 10, 40)];
    roomBackView.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    roomBackView.layer.cornerRadius = 20;
    [self addSubview:roomBackView];
    
    self.roomTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, viewWidth - 50, 40)];
    self.roomTextField.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    self.roomTextField.placeholder = @"房间名称";
    self.roomTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.roomTextField.attributedPlaceholder];
    [placeholderAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [placeholderAttributedString length])];
    [placeholderAttributedString addAttribute:NSFontAttributeName value:QRD_LIGHT_FONT(11) range:NSMakeRange(0, [placeholderAttributedString length])];
    self.roomTextField.attributedPlaceholder = placeholderAttributedString;
    self.roomTextField.textAlignment = NSTextAlignmentLeft;
    self.roomTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.roomTextField.font = QRD_REGULAR_FONT(13);
    self.roomTextField.textColor = [UIColor whiteColor];
    [roomBackView addSubview:_roomTextField];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 45, viewWidth - 50, 54)];
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.numberOfLines = 0;
    hintLabel.text = @"如果没有该房间，则会自动创建，房间名仅支持 3 ~ 64 位字母、数字、_ 和 - 的组合";
    hintLabel.font = QRD_LIGHT_FONT(10);
    [self addSubview:hintLabel];
    
    UIImage *normalImage = [UIImage imageNamed:@"noChoose"];
    UIImage *selectedImage = [UIImage imageNamed:@"choose"];

    self.confButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 100, 44, 44)];
    [self.confButton setImage:normalImage forState:UIControlStateNormal];
    [self.confButton setImage:selectedImage forState:UIControlStateSelected];
    [self addSubview:self.confButton];

    UILabel *confLabel = [[UILabel alloc] initWithFrame:CGRectMake(69, 100, 48, 44)];
    confLabel.textColor = [UIColor whiteColor];
    confLabel.numberOfLines = 0;
    confLabel.text = @"视频通话";
    confLabel.font = QRD_LIGHT_FONT(12);
    [self addSubview:confLabel];

    self.audioCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.audioCallButton.frame = CGRectMake(viewWidth - 60 - 48 - 44, 100, 44, 44);
    [self.audioCallButton setImage:normalImage forState:UIControlStateNormal];
    [self.audioCallButton setImage:selectedImage forState:UIControlStateSelected];
    [self addSubview:self.audioCallButton];
    
    UILabel *audioCallLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 60 - 48, 100, 48, 44)];
    audioCallLabel.textColor = [UIColor whiteColor];
    audioCallLabel.numberOfLines = 0;
    audioCallLabel.text = @"音频通话";
    audioCallLabel.font = QRD_LIGHT_FONT(12);
    [self addSubview:audioCallLabel];
    
    self.screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.screenButton.frame = CGRectMake(25, 150, 44, 44);
    [self.screenButton setImage:normalImage forState:UIControlStateNormal];
    [self.screenButton setImage:selectedImage forState:UIControlStateSelected];
    [self addSubview:self.screenButton];

    UILabel *screenLabel = [[UILabel alloc] initWithFrame:CGRectMake(69, 150, 48, 44)];
    screenLabel.textColor = [UIColor whiteColor];
    screenLabel.numberOfLines = 0;
    screenLabel.text = @"屏幕分享";
    screenLabel.font = QRD_LIGHT_FONT(12);
    [self addSubview:screenLabel];

    self.multiTrackButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    self.multiTrackButton.frame = CGRectMake(viewWidth - 60 - 48 - 44, 150, 44, 44);
    [self.multiTrackButton setImage:normalImage forState:UIControlStateNormal];
    [self.multiTrackButton setImage:selectedImage forState:UIControlStateSelected];
    [self addSubview:self.multiTrackButton];
    
    UILabel *multiTrackLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 60 - 48, 150, 110, 44)];
    multiTrackLabel.textColor = [UIColor whiteColor];
    multiTrackLabel.numberOfLines = 0;
    multiTrackLabel.text = @"视频通话+屏幕分享";
    multiTrackLabel.font = QRD_LIGHT_FONT(12);
    [self addSubview:multiTrackLabel];
    
    self.joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.joinButton.frame = CGRectMake(5, 210, viewWidth - 10, 40);
    self.joinButton.backgroundColor = QRD_COLOR_RGBA(52,170,220,1);
    self.joinButton.layer.cornerRadius = 20;
    self.joinButton.titleLabel.font = QRD_REGULAR_FONT(14);
    [self.joinButton setTitle:@"会议房间" forState:UIControlStateNormal];
    [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_joinButton];
    
    self.liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.liveButton.frame = CGRectMake(5, 270, viewWidth - 10, 40);
    self.liveButton.backgroundColor = QRD_COLOR_RGBA(52,170,220,1);
    self.liveButton.layer.cornerRadius = 20;
    self.liveButton.titleLabel.font = QRD_REGULAR_FONT(14);
    [self.liveButton setTitle:@"观看直播" forState:UIControlStateNormal];
    [self.liveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_liveButton];
    
    UILabel *mergeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 320, viewWidth - 50, 22)];
    mergeLabel.textColor = [UIColor whiteColor];
    mergeLabel.text = @"只有 admin 才有合流权限";
    mergeLabel.font = QRD_LIGHT_FONT(10);
    mergeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:mergeLabel];}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
