//
//  QRDSettingView.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/17.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDSettingView.h"
#define QRD_SUBMENU_TOP_SPACE 120

static NSString *cellIdentifier = @"subMenu";
@interface QRDSettingView ()
<
UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate
>
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, copy) NSString *appIdText;

@property (nonatomic, strong) NSArray *configArray;
@property (nonatomic, strong) CALayer *configMenuLayer;
@property (nonatomic, strong) UITableView *configMenuTabView;


@end

@implementation QRDSettingView
- (id)initWithFrame:(CGRect)frame configArray:(NSArray *)configArray selectedIndex:(NSInteger)selectedIndex placeholderText:(NSString *)placeholderText appIdText:(NSString *)appIdText{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _viewWidth = CGRectGetWidth(frame);
        _configArray = configArray;
        _isShow = NO;
        _selectedIndex = selectedIndex;
        _placeholderText = placeholderText;
        _appIdText = appIdText;
        [self initSettingView];
        [self initSubConfigurationMenu];
    }
    return self;
}

- (void)initSettingView {
    
    UIView *roomBackView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, _viewWidth - 10, 40)];
    roomBackView.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    roomBackView.layer.cornerRadius = 20;
    [self addSubview:roomBackView];
    
    UILabel *userHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
    userHintLabel.textColor = [UIColor whiteColor];
    userHintLabel.font = QRD_LIGHT_FONT(12);
    userHintLabel.textAlignment = NSTextAlignmentLeft;
    userHintLabel.text = @"昵称";
    [roomBackView addSubview:userHintLabel];
    
    self.userTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, _viewWidth - 110, 40)];
    self.userTextField.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    self.userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userTextField.textAlignment = NSTextAlignmentLeft;
    self.userTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.userTextField.font = QRD_REGULAR_FONT(13);
    self.userTextField.textColor = [UIColor whiteColor];
    self.userTextField.text = _placeholderText;

    [roomBackView addSubview:_userTextField];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 45, _viewWidth - 50, 27)];
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.text = @"仅支持 3 ~ 64 位字母、数字、_ 和 - 的组合";
    hintLabel.font = QRD_LIGHT_FONT(10);
    [self addSubview:hintLabel];
    
    self.infoBackView = [[UIView alloc] initWithFrame:CGRectMake(5, 84, _viewWidth - 10, 40)];
    self.infoBackView.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    self.infoBackView.layer.cornerRadius = 20;
    [self addSubview:_infoBackView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenuAction:)];
    tap.delegate = self;
    [_infoBackView addGestureRecognizer:tap];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _viewWidth - 78, 40)];
    self.infoLabel.userInteractionEnabled = YES;
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.text = _configArray[_selectedIndex];
    self.infoLabel.font = QRD_REGULAR_FONT(13);
    [_infoBackView addSubview:_infoLabel];
    
    self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth - 56, 6, 30, 28)];
    self.selectImageView.userInteractionEnabled = YES;
    self.selectImageView.image = [UIImage imageNamed:@"up_down"];
    [_infoBackView addSubview:_selectImageView];
    
    //Appid
    UIView *appIdBackView = [[UIView alloc] initWithFrame:CGRectMake(5, 164, _viewWidth - 10, 40)];
    appIdBackView.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    appIdBackView.layer.cornerRadius = 20;
    [self addSubview:appIdBackView];
    
    UILabel *appIdHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
    appIdHintLabel.textColor = [UIColor whiteColor];
    appIdHintLabel.font = QRD_LIGHT_FONT(12);
    appIdHintLabel.textAlignment = NSTextAlignmentLeft;
    appIdHintLabel.text = @"AppID";
    appIdHintLabel.backgroundColor =QRD_COLOR_RGBA(73,73,75,1);
    [appIdBackView addSubview:appIdHintLabel];
    
    self.appIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, _viewWidth - 110, 40)];
    self.appIdTextField.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    self.appIdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.appIdTextField.textAlignment = NSTextAlignmentLeft;
    self.appIdTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.appIdTextField.font = QRD_REGULAR_FONT(13);
    self.appIdTextField.textColor = [UIColor whiteColor];
    self.appIdTextField.text = _appIdText;
    
    [appIdBackView addSubview:_appIdTextField];
    
    UILabel *idHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 204, _viewWidth - 50, 27)];
    idHintLabel.textColor = [UIColor whiteColor];
    idHintLabel.text = @"请输入您的企业专用AppID";
    idHintLabel.font = QRD_LIGHT_FONT(10);
    [self addSubview:idHintLabel];
    
    
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 250, _viewWidth - 10, 40)];
    self.saveButton.backgroundColor = QRD_COLOR_RGBA(52,170,220,1);
    self.saveButton.layer.cornerRadius = 20;
    self.saveButton.titleLabel.font = QRD_REGULAR_FONT(14);
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_saveButton];
}

- (void)initSubConfigurationMenu {
    self.configMenuLayer = [CALayer layer];
    self.configMenuLayer.frame = CGRectMake(20, QRD_SUBMENU_TOP_SPACE, _viewWidth - 40, 0);
    self.configMenuLayer.backgroundColor = QRD_COLOR_RGBA(73, 73, 75, 1).CGColor;
    self.configMenuLayer.shadowColor = QRD_COLOR_RGBA(75, 75, 75, 1).CGColor;
    self.configMenuLayer.shadowOffset = CGSizeMake(1, 1);
    self.configMenuLayer.shadowOpacity = 1;
    self.configMenuLayer.shadowRadius = 8;
    self.configMenuLayer.cornerRadius = 8;
    
    self.configMenuTabView = [[UITableView alloc] initWithFrame:CGRectMake(20, QRD_SUBMENU_TOP_SPACE, _viewWidth - 40, 0) style:UITableViewStylePlain];
    self.configMenuTabView.backgroundColor = QRD_COLOR_RGBA(73, 73, 75, 1);
    self.configMenuTabView.scrollEnabled = NO;
    self.configMenuTabView.layer.cornerRadius = 6;
    self.configMenuTabView.clipsToBounds = YES;
    self.configMenuTabView.delegate = self;
    self.configMenuTabView.dataSource = self;
    self.configMenuTabView.rowHeight = 36.5;
    self.configMenuTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.configMenuTabView registerClass:[QNSettingMenuViewCell class] forCellReuseIdentifier:cellIdentifier];
    [_configMenuTabView reloadData];
    
    [self.layer addSublayer:_configMenuLayer];
    [self bringSubviewToFront:_configMenuTabView];
    [self addSubview:_configMenuTabView];
}

- (void)tapMenuAction:(UITapGestureRecognizer *)tap {
    _isShow = !_isShow;
    if (_isShow) {
        [self showSubConfigurationMenu];
    } else{
        [self hideSubConfigurationMenu];
    }
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _configArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QNSettingMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell configreSubConfigString:_configArray[indexPath.row] isSelected:(indexPath.row == _selectedIndex ? YES : NO)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _infoLabel.text = _configArray[indexPath.row];
    [self hideSubConfigurationMenu];
    _selectedIndex = indexPath.row;
    [_configMenuTabView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingView:didGetSelectedIndex:)]) {
        [self.delegate settingView:self didGetSelectedIndex:_selectedIndex];
    }
}

- (void)showSubConfigurationMenu {
    _isShow = YES;
    self.selectImageView.image = [UIImage imageNamed:@"down_up"];
    [UIView animateWithDuration:0.2 animations:^{
        _configMenuLayer.frame = CGRectMake(20, QRD_SUBMENU_TOP_SPACE, _viewWidth - 40, 36.5 * _configArray.count);
        _configMenuTabView.frame = CGRectMake(20, QRD_SUBMENU_TOP_SPACE, _viewWidth - 40, 36.5 * _configArray.count);
    } completion:^(BOOL finished) {

    }];
}

- (void)hideSubConfigurationMenu {
    _isShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _configMenuLayer.frame = CGRectMake(20, QRD_SUBMENU_TOP_SPACE, _viewWidth - 40, 0);
        _configMenuTabView.frame = CGRectMake(20, QRD_SUBMENU_TOP_SPACE, _viewWidth - 40, 0);
    } completion:^(BOOL finished) {
        self.selectImageView.image = [UIImage imageNamed:@"up_down"];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == _infoBackView || touch.view  == _infoLabel || touch.view == _selectImageView) {
        return YES;
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
   
   
@implementation QNSettingMenuViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
        CGFloat contentWidth = CGRectGetWidth(self.contentView.frame);
        
        self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 235, 26)];
        self.menuLabel.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
        self.menuLabel.font = QRD_REGULAR_FONT(12);
        self.menuLabel.textColor = [UIColor whiteColor];
        self.menuLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_menuLabel];
        
        self.selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 12, 16, 12)];
        self.selectImgView.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
        self.selectImgView.image = [UIImage imageNamed:@"menu_sel"];
        [self.contentView addSubview:_selectImgView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 36, 256, 0.5)];
        lineView.backgroundColor = QRD_COLOR_RGBA(195, 198, 198, 1);
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)configreSubConfigString:(NSString *)configString isSelected:(BOOL)isSelected
{
    self.menuLabel.text = configString;
    if (isSelected) {
        self.menuLabel.font = QRD_BOLD_FONT(13);
        self.selectImgView.hidden = NO;
    }
    else{
        self.menuLabel.font = QRD_REGULAR_FONT(12);
        self.selectImgView.hidden = YES;
    }
}
@end
