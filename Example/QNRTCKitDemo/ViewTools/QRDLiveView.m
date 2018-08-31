//
//  QRDLiveView.m
//  QNRTCKitDemo
//
//  Created by 朱玥静 on 2018/7/25.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDLiveView.h"
@interface QRDLiveView ()
/* <
UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate
>*/
@property (nonatomic, assign) BOOL keyboardIsShow;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView * memberList;
@property (nonatomic, strong) NSString * userNameForShow;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSMutableArray *userListArray;

@end


@implementation QRDLiveView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor redColor];
    if (self) {
        self.backgroundColor = QRD_GROUND_COLOR;
        _viewWidth = CGRectGetWidth(frame);
        _viewHeight = CGRectGetHeight(frame);
        _keyboardIsShow = NO;
        self.userListArray = [NSMutableArray array];
        [self initLiveView];
    }
    return self;
}

- (UITextField *)commomTextFiled:(CGRect)frame {
    
    UITextField *textFiled = [[UITextField alloc] initWithFrame:frame];
    textFiled.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    textFiled.layer.cornerRadius = 5;
    textFiled.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, frame.size.height)];
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    if (@available(iOS 10.0, *)) {
        textFiled.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    } else {
        textFiled.keyboardType = UIKeyboardTypePhonePad;
    }
    textFiled.font = QRD_REGULAR_FONT(13);
    textFiled.textColor = [UIColor whiteColor];
    
    return textFiled;
}

- (UILabel *)commonLabel:(CGRect)frame text:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.font = QRD_LIGHT_FONT(13);
    label.textAlignment = NSTextAlignmentLeft;
    label.text = text;
    
    return label;
}

-(void)initLiveView {
    //直播view
    _liveScreenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, 0.68*_viewHeight)];
    _liveScreenView.backgroundColor = [UIColor grayColor];
    _liveScreenView.layer.cornerRadius = 20;
    [self addSubview:_liveScreenView];
    
    //只有一个button的设置页面
    _liveSetting = [[UIView alloc] initWithFrame:CGRectMake(0, 0.68*_viewHeight, _viewWidth, _viewHeight - 0.68*_viewHeight)];
    _liveSetting.backgroundColor = [UIColor blackColor];
    [self addSubview:_liveSetting];
    
    //设置指示button+view
    _settingButton = [[UIButton alloc] initWithFrame:CGRectMake((_viewWidth - 60)/2, (0.32*_viewHeight - 60)/2, 60, 60)];
    _settingButton.backgroundColor = QRD_COLOR_RGBA(218, 75, 74, 1);
    _settingButton.layer.cornerRadius = 30;
    [_settingButton setImage:[UIImage imageNamed:@"live_setting"] forState:UIControlStateNormal];
    [_liveSetting addSubview:_settingButton];

    //Thursday
    //详细设置view
    _liveDetailSetting = [[UIView alloc] initWithFrame:CGRectMake(0, _viewHeight, _viewWidth, 0.5*_viewHeight)];
    _liveDetailSetting.backgroundColor = QRD_COLOR_RGBA(53, 53, 53, 1);
    [self addSubview:_liveDetailSetting];
    
    // 创建UIScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 10, _viewWidth, 100); // frame中的size指UIScrollView的可视范围
    _scrollView.backgroundColor = [UIColor clearColor];
    [_liveDetailSetting addSubview:_scrollView];
    
    //观众列表view
    _memberList = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 740, 100)];
    _memberList.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_memberList];
    // 设置UIScrollView的滚动范围（内容大小）
    _scrollView.contentSize = _memberList.frame.size;
    // 隐藏水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    // 去掉弹簧效果
    _scrollView.bounces = NO;
    
    UIButton * rectangleImg = [[UIButton alloc] initWithFrame:CGRectMake((_viewWidth - 90)/2, 5, 90, 5)];
    rectangleImg.backgroundColor = [UIColor grayColor];
    rectangleImg.layer.cornerRadius = 5;
    rectangleImg.tag = 100;

    [_liveDetailSetting addSubview:rectangleImg];
    
    //详细xyz宽高设置view
    UIView * layoutSetting = [[UIView alloc] initWithFrame:CGRectMake(0, 110, _viewWidth, 200)];
    layoutSetting.backgroundColor = [UIColor clearColor];
    [_liveDetailSetting addSubview:layoutSetting];
    
    UILabel *xLabel = [self commonLabel:CGRectMake(10, 10, 40, 25) text:@"x轴"];
    self.xValueField = [self commomTextFiled:CGRectMake(55, 10, 50, 25)];
    [layoutSetting addSubview:xLabel];
    [layoutSetting addSubview:_xValueField];
    
    UILabel *yLabel = [self commonLabel:CGRectMake(115, 10, 40, 25) text:@"y轴"];
    self.yValueField = [self commomTextFiled:CGRectMake(160, 10, 50, 25)];
    [layoutSetting addSubview:yLabel];
    [layoutSetting addSubview:_yValueField];
    
    UILabel *zLabel = [self commonLabel:(CGRect)CGRectMake(220, 10, 40, 25) text:@"z轴"];
    self.zValueField = [self commomTextFiled:CGRectMake(265, 10, 50, 25)];
    [layoutSetting addSubview:zLabel];
    [layoutSetting addSubview:_zValueField];
    
    UILabel *widthLabel = [self commonLabel:CGRectMake(10, 60, 40, 25) text:@"宽度"];
    self.widthField = [self commomTextFiled:CGRectMake(55, 60, 50, 25)];
    [layoutSetting addSubview:widthLabel];
    [layoutSetting addSubview:_widthField];
    
    UILabel *heightLabel = [self commonLabel:CGRectMake(115, 60, 40, 25) text:@"高度"];
    self.heightField = [self commomTextFiled:CGRectMake(160, 60, 50, 25)];
    [layoutSetting addSubview:heightLabel];
    [layoutSetting addSubview:_heightField];
    
    UILabel *soundLabel = [self commonLabel:CGRectMake(10, 110, 40, 25) text:@"声音"];
    soundLabel.textAlignment = NSTextAlignmentLeft;
    [layoutSetting addSubview:soundLabel];
    
    _soundSwitchButton = [[UISwitch alloc] initWithFrame:CGRectMake(55, 110, 50, 25)];
    [_soundSwitchButton setOn:YES animated:YES];
    [layoutSetting addSubview:_soundSwitchButton];

    UILabel *videoLabel = [self commonLabel:CGRectMake(115, 110, 40, 25) text:@"视频"];
    videoLabel.textAlignment = NSTextAlignmentLeft;
    [layoutSetting addSubview:videoLabel];
    
    _videoSwitchButton = [[UISwitch alloc] initWithFrame:CGRectMake(160, 110, 50, 25)];
    [_videoSwitchButton setOn:YES animated:YES];
    [layoutSetting addSubview:_videoSwitchButton];
    
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 110, 60, 30)];
    self.confirmButton.backgroundColor = QRD_COLOR_RGBA(52,170,200,1);
    self.confirmButton.layer.cornerRadius = 10;
    self.confirmButton.titleLabel.font = QRD_REGULAR_FONT(13);
    [self.confirmButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [layoutSetting addSubview:_confirmButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
}

- (void)resetDetailViewFrame:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
    _liveDetailSetting.frame = CGRectMake(0, self.bounds.size.height - _liveDetailSetting.bounds.size.height - _keyboardHeight, _liveDetailSetting.bounds.size.width, _liveDetailSetting.bounds.size.height);
    }];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    
    [self resetDetailViewFrame:duration];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    _keyboardHeight = 0;
    NSDictionary *userInfo = [aNotification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self resetDetailViewFrame:duration];
}

- (void)keyboardWillChange:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    
    [self resetDetailViewFrame:duration];
}

- (void)resetUserButton:(NSUInteger)count userNames:(NSArray *)userNames {
    
    NSArray * subviews = _memberList.subviews;
    for (UIView * view in subviews) {
        if (view.tag!=100) {
            [view removeFromSuperview];
        }
    }
   
    if (userNames.count != 0) {
        _memberList.frame = CGRectMake(0, 10, 80 * count + 20, 100);
        _scrollView.contentSize = _memberList.frame.size;
         [self dynamicButton:count userNames:userNames];
        _selectedUserName = userNames[0];
    }
}

- (void)dynamicButton:(NSUInteger)count userNames:(NSArray *)userNames {
    CGFloat w = 0;
    CGFloat h = 10;
    int colorCount = 0;
    
    [_userListArray removeAllObjects];
    for (NSString * str in userNames) {
        [_userListArray addObject:str];
    }
    
    for (int i = 0; i < userNames.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self settingColor:button buttonsColor:colorCount];
        colorCount += 1 ;
        if (colorCount > 3) {
            colorCount = 0;
        }
        button.layer.cornerRadius = 30;
        button.tag = i;
        if (button.tag == 0) {
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            button.layer.borderWidth = 3;
            button.selected = YES;
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //显示取前3个字符串
        _userNameForShow = [self getSubString:userNames[i] toIndex:3];
        //为button赋值
        [button setTitle:_userNameForShow forState:UIControlStateNormal];
        button.showsTouchWhenHighlighted = NO;
        //获得ID
        [button addTarget:self action:@selector(getUserId:) forControlEvents:UIControlEventTouchUpInside];
        //设置button的frame
        button.frame = CGRectMake(20 + w, h, 60 ,60);
        w = button.frame.size.width + button.frame.origin.x;
        [_memberList addSubview:button];
    }
}

- (NSString *)getSubString:(NSString *)srcString toIndex:(NSInteger)toIndex {
    CGFloat strlength = [srcString length];
    NSString * subString = [[NSString alloc] init];
    if (strlength > 0 && strlength <= toIndex) {
        subString = srcString;
    }else{
        subString = [srcString substringToIndex:toIndex];
    }
    return subString;
}

- (void)resetTextFieldString {
    for (UIView *subView in self.memberList.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            if (button.selected) {
                [self getUserId:button];
            }
        }
    }
}

- (void)getUserId:(UIButton *)button {
    
    NSArray *subviews = _memberList.subviews;
    for (int i = 0; i < subviews.count; i++) {
        UIView * subview = [subviews objectAtIndex:i];
        if ([subview isKindOfClass:UIButton.class]) {
            UIButton *tempButton = (UIButton *)subview;
            tempButton.selected = NO;
            tempButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 3;
    button.selected = YES;
    _selectedUserName = _userListArray[button.tag];
    
    QRDMergeInfo *mergeInfo = nil;
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if ([info.userId isEqualToString:_selectedUserName]) {
            mergeInfo = info;
        }
    }
    if (mergeInfo) {
        self.xValueField.text = [NSString stringWithFormat:@"%d",(int)mergeInfo.mergeFrame.origin.x];
        self.yValueField.text = [NSString stringWithFormat:@"%d",(int)mergeInfo.mergeFrame.origin.y];
        self.zValueField.text = [NSString stringWithFormat:@"%d",(int)mergeInfo.zIndex];
        self.widthField.text  = [NSString stringWithFormat:@"%d",(int)mergeInfo.mergeFrame.size.width];
        self.heightField.text = [NSString stringWithFormat:@"%d",(int)mergeInfo.mergeFrame.size.height];
        [self.soundSwitchButton setOn:!mergeInfo.isMute animated:YES];
        [self.videoSwitchButton setOn:!mergeInfo.isHidden animated:YES];
    }
}

- (void)settingColor:(UIButton *)button buttonsColor:(int)count {
        switch (count) {
            case 0:
                [button setBackgroundColor:QRD_COLOR_RGBA(218, 75, 74, 1)];
                break;
            case 1:
                [button setBackgroundColor:QRD_COLOR_RGBA(88, 140, 238, 1)];
                break;
            case 2:
                [button setBackgroundColor:QRD_COLOR_RGBA(248, 207, 95, 1)];
                break;
            case 3:
                [button setBackgroundColor:QRD_COLOR_RGBA(77, 159, 103, 1)];
                break;
                
            default:
                break;
        }
   }

- (void)showSubConfigurationMenu {
    [UIView animateWithDuration:0.25 animations:^{
        _liveDetailSetting.frame = CGRectMake(0, self.bounds.size.height - _liveDetailSetting.bounds.size.height, _liveDetailSetting.bounds.size.width, _liveDetailSetting.bounds.size.height);
    }];
}

- (void)hideSubConfigurationMenu {
    
    if ([self.xValueField isFirstResponder]) {
        [self.xValueField resignFirstResponder];
    } else if ([self.yValueField isFirstResponder]) {
        [self.yValueField resignFirstResponder];
    } else if ([self.zValueField isFirstResponder]) {
        [self.zValueField resignFirstResponder];
    } else if ([self.widthField isFirstResponder]) {
        [self.widthField resignFirstResponder];
    } else if ([self.heightField isFirstResponder]) {
        [self.heightField resignFirstResponder];
    } else {
        [UIView animateWithDuration:.25 animations:^{
            _liveDetailSetting.frame = CGRectMake(0, self.bounds.size.height, _liveDetailSetting.bounds.size.width, _liveDetailSetting.bounds.size.height);
        }];
    }
}

- (void)hideAllSubConfiguration {
    [self hideSubConfigurationMenu];
    [UIView animateWithDuration:.25 animations:^{
        _liveDetailSetting.frame = CGRectMake(0, self.bounds.size.height, _liveDetailSetting.bounds.size.width, _liveDetailSetting.bounds.size.height);
    }];
}

@end
