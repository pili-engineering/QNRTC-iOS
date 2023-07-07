//
//  QRDSettingView.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/17.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDSettingView.h"
#define QRD_CONFIGMENU_TOP_SPACE 120
#define QRD_PREFERMENU_TOP_SPACE 205

static NSString *configCellIdentifier = @"configMenu";
static NSString *preferCellIdentifier = @"preferMenu";

@interface QRDSettingView ()
<
UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate
>
@property (nonatomic, strong) UIImageView *configSelectImageView;
@property (nonatomic, strong) UIImageView *preferSelectImageView;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) BOOL isShowConfig;
@property (nonatomic, assign) BOOL isShowPrefer;
@property (nonatomic, assign) NSInteger configSelectedIndex;
@property (nonatomic, assign) NSInteger preferSelectedIndex;
@property (nonatomic, assign) NSInteger sceneSelectedIndex;
@property (nonatomic, assign) NSInteger wareSelectedIndex;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, copy) NSString *appIdText;

@property (nonatomic, strong) NSArray *configArray;
@property (nonatomic, strong) CALayer *configMenuLayer;
@property (nonatomic, strong) UITableView *configMenuTabView;
@property (nonatomic, strong) NSArray *preferArray;
@property (nonatomic, strong) CALayer *preferMenuLayer;
@property (nonatomic, strong) UITableView *preferMenuTabView;

@end

@implementation QRDSettingView

- (id)initWithFrame:(CGRect)frame configArray:(NSArray *)configArray preferArray:(NSArray *)preferArray config:(NSInteger)config prefer:(NSInteger)prefer placeholder:(NSString *)placeholder appId:(NSString *)appId scene:(NSInteger)scene ware:(NSInteger)ware{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _viewWidth = CGRectGetWidth(frame);
        _configArray = configArray;
        _preferArray = preferArray;
        _isShowConfig = NO;
        _isShowPrefer = NO;
        _configSelectedIndex = config;
        _preferSelectedIndex = prefer;
        _sceneSelectedIndex = scene;
        _wareSelectedIndex = ware;
        _placeholderText = placeholder;
        _appIdText = appId;
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
    
    self.configSelectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth - 56, 6, 30, 28)];
    self.configSelectImageView.userInteractionEnabled = YES;
    self.configSelectImageView.image = [UIImage imageNamed:@"up_down"];
    [_infoBackView addSubview:_configSelectImageView];
    
    UITapGestureRecognizer *configTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConfigMenuAction:)];
    configTap.delegate = self;
    [_infoBackView addGestureRecognizer:configTap];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _viewWidth - 78, 40)];
    self.infoLabel.userInteractionEnabled = YES;
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.text = _configArray[_configSelectedIndex];
    self.infoLabel.font = QRD_REGULAR_FONT(13);
    [_infoBackView addSubview:_infoLabel];
    
    UIImage *normalImage = [UIImage imageNamed:@"noChoose"];
    UIImage *selectedImage = [UIImage imageNamed:@"choose"];
    
    self.hardwareButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 125, 40, 44)];
    [self.hardwareButton setImage:normalImage forState:UIControlStateNormal];
    [self.hardwareButton setImage:selectedImage forState:UIControlStateSelected];
    [self addSubview:self.hardwareButton];

    UILabel *hardwareLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 125, 48, 44)];
    hardwareLabel.textColor = [UIColor whiteColor];
    hardwareLabel.numberOfLines = 0;
    hardwareLabel.text = @"硬编";
    hardwareLabel.font = QRD_LIGHT_FONT(12);
    [self addSubview:hardwareLabel];

    self.softwareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.softwareButton.frame = CGRectMake(_viewWidth - 125, 125, 40, 44);
    [self.softwareButton setImage:normalImage forState:UIControlStateNormal];
    [self.softwareButton setImage:selectedImage forState:UIControlStateSelected];
    [self addSubview:self.softwareButton];
    
    UILabel *softwareLabel = [[UILabel alloc] initWithFrame:CGRectMake(_viewWidth - 85, 125, 48, 44)];
    softwareLabel.textColor = [UIColor whiteColor];
    softwareLabel.numberOfLines = 0;
    softwareLabel.text = @"软编";
    softwareLabel.font = QRD_LIGHT_FONT(12);
    [self addSubview:softwareLabel];
    
    if (_wareSelectedIndex == 0) {
        self.hardwareButton.selected = YES;
    }
    if (_wareSelectedIndex == 1) {
        self.softwareButton.selected = YES;
    }
    [self.hardwareButton addTarget:self action:@selector(hardwareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.softwareButton addTarget:self action:@selector(softwareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.preferBackView = [[UIView alloc] initWithFrame:CGRectMake(5, 170, _viewWidth - 10, 40)];
    self.preferBackView.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    self.preferBackView.layer.cornerRadius = 20;
    [self addSubview:_preferBackView];
    
    UITapGestureRecognizer *preferTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPreferMenuAction:)];
    preferTap.delegate = self;
    [_preferBackView addGestureRecognizer:preferTap];
    
    self.preferLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _viewWidth - 78, 40)];
    self.preferLabel.userInteractionEnabled = YES;
    self.preferLabel.textColor = [UIColor whiteColor];
    self.preferLabel.text = _preferArray[_preferSelectedIndex];
    self.preferLabel.font = QRD_REGULAR_FONT(13);
    [_preferBackView addSubview:_preferLabel];
    
    self.preferSelectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth - 56, 6, 30, 28)];
    self.preferSelectImageView.userInteractionEnabled = YES;
    self.preferSelectImageView.image = [UIImage imageNamed:@"up_down"];
    [_preferBackView addSubview:_preferSelectImageView];

    self.defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 215, 40, 44)];
    [self.defaultButton setImage:normalImage forState:UIControlStateNormal];
    [self.defaultButton setImage:selectedImage forState:UIControlStateSelected];
    [self addSubview:self.defaultButton];

    UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 215, 48, 44)];
    defaultLabel.textColor = [UIColor whiteColor];
    defaultLabel.numberOfLines = 0;
    defaultLabel.text = @"默认";
    defaultLabel.font = QRD_LIGHT_FONT(12);
    [self addSubview:defaultLabel];

    self.voiceChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceChatButton.frame = CGRectMake(_viewWidth - 210, 215, 40, 44);
    [self.voiceChatButton setImage:normalImage forState:UIControlStateNormal];
    [self.voiceChatButton setImage:selectedImage forState:UIControlStateSelected];
    [self addSubview:self.voiceChatButton];
    
    UILabel *voiceChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(_viewWidth - 170, 215, 48, 44)];
    voiceChatLabel.textColor = [UIColor whiteColor];
    voiceChatLabel.numberOfLines = 0;
    voiceChatLabel.text = @"通话模式";
    voiceChatLabel.font = QRD_LIGHT_FONT(12);
    [self addSubview:voiceChatLabel];
    
    self.soundEqualizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.soundEqualizeButton.frame = CGRectMake(_viewWidth - 110, 215, 40, 44);
    [self.soundEqualizeButton setImage:normalImage forState:UIControlStateNormal];
    [self.soundEqualizeButton setImage:selectedImage forState:UIControlStateSelected];
    [self addSubview:self.soundEqualizeButton];

    UILabel *soundEqualizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_viewWidth - 68, 215, 48, 44)];
    soundEqualizeLabel.textColor = [UIColor whiteColor];
    soundEqualizeLabel.numberOfLines = 0;
    soundEqualizeLabel.text = @"音质均衡";
    soundEqualizeLabel.font = QRD_LIGHT_FONT(12);
    [self addSubview:soundEqualizeLabel];
    
    if (_sceneSelectedIndex == 0) {
        self.defaultButton.selected = YES;
    }
    if (_sceneSelectedIndex == 1) {
        self.voiceChatButton.selected = YES;
    }
    if (_sceneSelectedIndex == 2) {
        self.soundEqualizeButton.selected = YES;
    }
    
    [self.defaultButton addTarget:self action:@selector(defaultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceChatButton addTarget:self action:@selector(voiceChatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.soundEqualizeButton addTarget:self action:@selector(soundEqualizeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    //Appid
    UIView *appIdBackView = [[UIView alloc] initWithFrame:CGRectMake(5, 260, _viewWidth - 10, 40)];
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
    
    UILabel *idHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 300, _viewWidth - 50, 27)];
    idHintLabel.textColor = [UIColor whiteColor];
    idHintLabel.text = @"请输入您的企业专用AppID";
    idHintLabel.font = QRD_LIGHT_FONT(10);
    [self addSubview:idHintLabel];
    
    self.uploadLogButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 330, 44, 44)];
    [self.uploadLogButton setImage:[UIImage imageNamed:@"qn_upload_log"] forState:UIControlStateNormal];
    [self addSubview:_uploadLogButton];
    
    UILabel *uploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 330, 48, 44)];
    uploadLabel.textColor = [UIColor whiteColor];
    uploadLabel.numberOfLines = 0;
    uploadLabel.text = @"上传日志";
    uploadLabel.font = QRD_LIGHT_FONT(12);
    [self addSubview:uploadLabel];
    
    self.customDefineButton = [[UIButton alloc] initWithFrame:CGRectMake(_viewWidth - 140, 330, 44, 44)];
    [self.customDefineButton setImage:[UIImage imageNamed:@"qn_custom_define"] forState:UIControlStateNormal];
    [self addSubview:_customDefineButton];
    
    UILabel *customDefineLabel = [[UILabel alloc] initWithFrame:CGRectMake(_viewWidth - 95, 330, 68, 44)];
    customDefineLabel.textColor = [UIColor whiteColor];
    customDefineLabel.numberOfLines = 0;
    customDefineLabel.text = @"自定义参数";
    customDefineLabel.font = QRD_LIGHT_FONT(12);
    [self addSubview:customDefineLabel];
    
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 400, _viewWidth - 10, 40)];
    self.saveButton.backgroundColor = QRD_COLOR_RGBA(52,170,220,1);
    self.saveButton.layer.cornerRadius = 20;
    self.saveButton.titleLabel.font = QRD_REGULAR_FONT(14);
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_saveButton];
}

- (void)initSubConfigurationMenu {
    self.configMenuLayer = [CALayer layer];
    self.configMenuLayer.frame = CGRectMake(20, QRD_CONFIGMENU_TOP_SPACE, _viewWidth - 40, 0);
    self.configMenuLayer.backgroundColor = QRD_COLOR_RGBA(73, 73, 75, 1).CGColor;
    self.configMenuLayer.shadowColor = QRD_COLOR_RGBA(75, 75, 75, 1).CGColor;
    self.configMenuLayer.shadowOffset = CGSizeMake(1, 1);
    self.configMenuLayer.shadowOpacity = 1;
    self.configMenuLayer.shadowRadius = 8;
    self.configMenuLayer.cornerRadius = 8;
    
    self.configMenuTabView = [[UITableView alloc] initWithFrame:CGRectMake(20, QRD_CONFIGMENU_TOP_SPACE, _viewWidth - 40, 0) style:UITableViewStylePlain];
    self.configMenuTabView.backgroundColor = QRD_COLOR_RGBA(73, 73, 75, 1);
    self.configMenuTabView.scrollEnabled = NO;
    self.configMenuTabView.layer.cornerRadius = 6;
    self.configMenuTabView.clipsToBounds = YES;
    self.configMenuTabView.delegate = self;
    self.configMenuTabView.dataSource = self;
    self.configMenuTabView.rowHeight = 36.5;
    self.configMenuTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.configMenuTabView registerClass:[QNSettingMenuViewCell class] forCellReuseIdentifier:configCellIdentifier];
    [_configMenuTabView reloadData];
    
    [self.layer addSublayer:_configMenuLayer];
    [self bringSubviewToFront:_configMenuTabView];
    [self addSubview:_configMenuTabView];
    
    self.preferMenuLayer = [CALayer layer];
    self.preferMenuLayer.frame = CGRectMake(20, QRD_PREFERMENU_TOP_SPACE, _viewWidth - 40, 0);
    self.preferMenuLayer.backgroundColor = QRD_COLOR_RGBA(73, 73, 75, 1).CGColor;
    self.preferMenuLayer.shadowColor = QRD_COLOR_RGBA(75, 75, 75, 1).CGColor;
    self.preferMenuLayer.shadowOffset = CGSizeMake(1, 1);
    self.preferMenuLayer.shadowOpacity = 1;
    self.preferMenuLayer.shadowRadius = 8;
    self.preferMenuLayer.cornerRadius = 8;
    
    self.preferMenuTabView = [[UITableView alloc] initWithFrame:CGRectMake(20, QRD_PREFERMENU_TOP_SPACE, _viewWidth - 40, 0) style:UITableViewStylePlain];
    self.preferMenuTabView.backgroundColor = QRD_COLOR_RGBA(73, 73, 75, 1);
    self.preferMenuTabView.scrollEnabled = NO;
    self.preferMenuTabView.layer.cornerRadius = 6;
    self.preferMenuTabView.clipsToBounds = YES;
    self.preferMenuTabView.delegate = self;
    self.preferMenuTabView.dataSource = self;
    self.preferMenuTabView.rowHeight = 36.5;
    self.preferMenuTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.preferMenuTabView registerClass:[QNSettingMenuViewCell class] forCellReuseIdentifier:preferCellIdentifier];
    [_preferMenuTabView reloadData];
    
    [self.layer addSublayer:_preferMenuLayer];
    [self bringSubviewToFront:_preferMenuTabView];
    [self addSubview:_preferMenuTabView];
}

- (void)tapConfigMenuAction:(UITapGestureRecognizer *)tap {
    _isShowConfig = !_isShowConfig;
    if (_isShowConfig) {
        [self hidePreferenceMenu];
        [self showConfigurationMenu];
    } else{
        [self hideConfigurationMenu];
    }
}

- (void)tapPreferMenuAction:(UITapGestureRecognizer *)tap {
    _isShowPrefer = !_isShowPrefer;
    if (_isShowPrefer) {
        [self hideConfigurationMenu];
        [self showPreferenceMenu];
    } else{
        [self hidePreferenceMenu];
    }
}

- (void)hardwareButtonClick:(id)sender {
    self.hardwareButton.selected = YES;
    self.softwareButton.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingView:didGetSelectedIndex:menuType:)]) {
        [self.delegate settingView:self didGetSelectedIndex:0 menuType:QRDSettingTypeWare];
    }
}

- (void)softwareButtonClick:(id)sender {
    self.hardwareButton.selected = NO;
    self.softwareButton.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingView:didGetSelectedIndex:menuType:)]) {
        [self.delegate settingView:self didGetSelectedIndex:1 menuType:QRDSettingTypeWare];
    }
}

- (void)defaultButtonClick:(id)sender {
    self.defaultButton.selected = YES;
    self.voiceChatButton.selected = NO;
    self.soundEqualizeButton.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingView:didGetSelectedIndex:menuType:)]) {
        [self.delegate settingView:self didGetSelectedIndex:0 menuType:QRDSettingTypeScene];
    }
}

- (void)voiceChatButtonClick:(id)sender {
    self.defaultButton.selected = NO;
    self.voiceChatButton.selected = YES;
    self.soundEqualizeButton.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingView:didGetSelectedIndex:menuType:)]) {
        [self.delegate settingView:self didGetSelectedIndex:1 menuType:QRDSettingTypeScene];
    }
}

- (void)soundEqualizeButtonClick:(id)sender {
    self.defaultButton.selected = NO;
    self.voiceChatButton.selected = NO;
    self.soundEqualizeButton.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingView:didGetSelectedIndex:menuType:)]) {
        [self.delegate settingView:self didGetSelectedIndex:2 menuType:QRDSettingTypeScene];
    }
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_configMenuTabView]) {
        return _configArray.count;
    } else {
        return _preferArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_configMenuTabView]) {
        QNSettingMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:configCellIdentifier forIndexPath:indexPath];
        [cell configreSubConfigString:_configArray[indexPath.row] isSelected:(indexPath.row == _configSelectedIndex ? YES : NO)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        QNSettingMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:preferCellIdentifier forIndexPath:indexPath];
        [cell configreSubConfigString:_preferArray[indexPath.row] isSelected:(indexPath.row == _preferSelectedIndex ? YES : NO)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_configMenuTabView]) {
        _infoLabel.text = _configArray[indexPath.row];
        [self hideConfigurationMenu];
        _configSelectedIndex = indexPath.row;
        [_configMenuTabView reloadData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(settingView:didGetSelectedIndex:menuType:)]) {
            [self.delegate settingView:self didGetSelectedIndex:_configSelectedIndex menuType:QRDSettingTypeConfig];
        }
    } else {
        _preferLabel.text = _preferArray[indexPath.row];
        [self hidePreferenceMenu];
        _preferSelectedIndex = indexPath.row;
        [_preferMenuTabView reloadData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(settingView:didGetSelectedIndex:menuType:)]) {
            [self.delegate settingView:self didGetSelectedIndex:_preferSelectedIndex menuType:QRDSettingTypePrefer];
        }
    }
}

- (void)showConfigurationMenu {
    self.configSelectImageView.image = [UIImage imageNamed:@"down_up"];
    [UIView animateWithDuration:0.2 animations:^{
        _configMenuLayer.frame = CGRectMake(20, QRD_CONFIGMENU_TOP_SPACE, _viewWidth - 40, 36.5 * _configArray.count);
        _configMenuTabView.frame = CGRectMake(20, QRD_CONFIGMENU_TOP_SPACE, _viewWidth - 40, 36.5 * _configArray.count);
    } completion:^(BOOL finished) {

    }];
}

- (void)hideConfigurationMenu {
    [UIView animateWithDuration:0.2 animations:^{
        _configMenuLayer.frame = CGRectMake(20, QRD_CONFIGMENU_TOP_SPACE, _viewWidth - 40, 0);
        _configMenuTabView.frame = CGRectMake(20, QRD_CONFIGMENU_TOP_SPACE, _viewWidth - 40, 0);
    } completion:^(BOOL finished) {
        self.configSelectImageView.image = [UIImage imageNamed:@"up_down"];
        self.isShowConfig = NO;
    }];
}

- (void)showPreferenceMenu {
    self.preferSelectImageView.image = [UIImage imageNamed:@"down_up"];
    [UIView animateWithDuration:0.2 animations:^{
        _preferMenuLayer.frame = CGRectMake(20, QRD_PREFERMENU_TOP_SPACE, _viewWidth - 40, 36.5 * _preferArray.count);
        _preferMenuTabView.frame = CGRectMake(20, QRD_PREFERMENU_TOP_SPACE, _viewWidth - 40, 36.5 * _preferArray.count);
    } completion:^(BOOL finished) {

    }];
}

- (void)hidePreferenceMenu {
    [UIView animateWithDuration:0.2 animations:^{
        _preferMenuLayer.frame = CGRectMake(20, QRD_PREFERMENU_TOP_SPACE, _viewWidth - 40, 0);
        _preferMenuTabView.frame = CGRectMake(20, QRD_PREFERMENU_TOP_SPACE, _viewWidth - 40, 0);
    } completion:^(BOOL finished) {
        self.preferSelectImageView.image = [UIImage imageNamed:@"up_down"];
        self.isShowPrefer = NO;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == _infoBackView || touch.view  == _infoLabel || touch.view == _configSelectImageView ||
        touch.view == _preferBackView || touch.view  == _preferLabel || touch.view == _preferSelectImageView) {
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
