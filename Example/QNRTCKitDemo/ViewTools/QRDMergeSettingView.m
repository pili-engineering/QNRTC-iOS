//
//  QRDMergeSettingView.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2020/4/26.
//  Copyright © 2020 PILI. All rights reserved.
//

#import "QRDMergeSettingView.h"

static NSString *cameraTag = @"camera";
static NSString *screenTag = @"screen";

@interface QRDMergeSettingView()

@property (nonatomic, copy) NSString *mergeJobId;
@property (nonatomic, copy) NSString *mergeUserId;
@property (nonatomic, copy) NSString *roomName;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *beforeAddLayouts;

@property (nonatomic, assign) BOOL beforeMerge;
@property (nonatomic, assign) BOOL beforeCustom;

@property (nonatomic, assign, readwrite) CGFloat totalHeight;
@property (nonatomic, strong) QNMergeStreamConfiguration *customConfiguration;
@property (nonatomic, assign) QNVideoFillModeType videoFillMode;

@end

@implementation QRDMergeSettingView

- (id)initWithFrame:(CGRect)frame userId:(NSString *)userId roomName:(NSString *)roomName{
    if ([super initWithFrame:frame]) {
        
        self.mergeUserId = userId;
        self.roomName = roomName;
        self.mergeJobId = nil;
        
        self.customConfiguration = [QNMergeStreamConfiguration defaultConfiguration];
        self.customConfiguration.jobId = roomName;
        self.customConfiguration.publishUrl = [NSString stringWithFormat:@"rtmp://pili-publish.qnsdk.com/sdk-live/%@", _roomName];
        self.customConfiguration.minBitrateBps = 1000*1000;
        self.customConfiguration.maxBitrateBps = 1000*1000;
        self.customConfiguration.fillMode = QNVideoFillModePreserveAspectRatioAndFill;
              
        _videoFillMode = QNVideoFillModePreserveAspectRatioAndFill;
        
        self.contentView = [[UIView alloc] init];
        self.contentView.userInteractionEnabled = YES;
        [self addSubview:_contentView];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.equalTo(self);
        }];
        
        self.mergeInfoArray = [[NSMutableArray alloc] init];
        self.mergeUserArray = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        
        [self setupSettingView];
        
        self.beforeMerge = NO;
        self.beforeCustom = NO;
    }
    return self;
}

- (void)setupSettingView {
    
    self.saveButton = [[UIButton alloc] init];
    [_saveButton setBackgroundColor:QRD_COLOR_RGBA(52,170,220,1)];
    [_saveButton setTitle:@"提交" forState:(UIControlStateNormal)];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_saveButton setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _saveButton.layer.borderWidth = .5;
    _saveButton.layer.borderColor = [UIColor colorWithWhite:.6 alpha:.5].CGColor;
    _saveButton.layer.cornerRadius = 20;
    [_saveButton addTarget:self action:@selector(clickSaveButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    _mergeOpenLabel = [[UILabel alloc] init];
    _mergeOpenLabel.textColor = [UIColor grayColor];
    _mergeOpenLabel.textAlignment = NSTextAlignmentCenter;
    _mergeOpenLabel.font = [UIFont systemFontOfSize:14];
    _mergeOpenLabel.text = @"开启合流转推：";
    
    self.mergeSwitch = [[UISwitch alloc] init];
    [self.mergeSwitch setOnTintColor:QRD_COLOR_RGBA(52,170,220,1)];
    [self.mergeSwitch sizeToFit];
    
    self.userScorllView = [[UIScrollView alloc] init];
    
    _warnningLabel = [[UILabel alloc] init];
    _warnningLabel.textColor = [UIColor redColor];
    _warnningLabel.textAlignment = NSTextAlignmentCenter;
    _warnningLabel.font = [UIFont systemFontOfSize:12];
    _warnningLabel.text = @"每个用户的合流配置都需单独确认才可生效，否则会被重置";
    
    self.firstTrackTagLabel = [[UILabel alloc] init];
    self.firstTrackTagLabel.textColor = [UIColor grayColor];
    self.firstTrackTagLabel.font = [UIFont systemFontOfSize:14];
    self.firstTrackTagLabel.text = @"第一路流：";
    [self.firstTrackTagLabel sizeToFit];
    
    self.firstTrackSwitch = [[UISwitch alloc] init];
    [self.firstTrackSwitch setOnTintColor:QRD_COLOR_RGBA(52,170,220,1)];
    [self.firstTrackSwitch sizeToFit];
    
    self.firstTrackXTextField   = [self commonTextField:@"" alertText:@"X轴:"];
    self.firstTrackYTextField   = [self commonTextField:@"" alertText:@"Y轴:"];
    self.firstTrackZTextField    = [self commonTextField:@"" alertText:@"Z轴:"];
    self.firstTrackWidthTextField     = [self commonTextField:@"" alertText:@"宽度:"];
    self.firstTrackHeightTextField    = [self commonTextField:@"" alertText:@"高度:"];
    
    [self.contentView addSubview:self.mergeOpenLabel];
    [self.contentView addSubview:self.mergeSwitch];
    [self.contentView addSubview:self.userScorllView];
    [self.contentView addSubview:self.warnningLabel];

    [self.contentView addSubview:self.firstTrackTagLabel];
    [self.contentView addSubview:self.firstTrackSwitch];
    [self.contentView addSubview:self.firstTrackXTextField];
    [self.contentView addSubview:self.firstTrackYTextField];
    [self.contentView addSubview:self.firstTrackZTextField];
    [self.contentView addSubview:self.firstTrackWidthTextField];
    [self.contentView addSubview:self.firstTrackHeightTextField];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    
    [self.mergeOpenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.size.equalTo(CGSizeMake(100, 42));
    }];
    
    _totalHeight += 52;
    
    [self.mergeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mergeOpenLabel.mas_top);
        make.centerY.equalTo(_mergeOpenLabel);
        make.size.equalTo(self.mergeSwitch.bounds.size);
        make.left.equalTo(self.mergeOpenLabel.mas_right);
    }];
    
    _totalHeight += self.mergeSwitch.bounds.size.height;
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(1);
        make.top.equalTo(self.mergeOpenLabel.mas_bottom).offset(10);
    }];
       
    [self.userScorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(50);
    }];
    
    [_warnningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.userScorllView.mas_bottom);
        make.height.equalTo(22);
    }];
    
    _totalHeight += 73;
   
    [self.firstTrackTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(_warnningLabel.mas_bottom).offset(10);
        make.size.equalTo(self.firstTrackTagLabel.bounds.size);
    }];
        
    [self.firstTrackSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstTrackTagLabel.mas_right).offset(5);
        make.centerY.equalTo(self.firstTrackTagLabel);
        make.size.equalTo(self.firstTrackSwitch.bounds.size);
    }];
    
    _totalHeight += self.firstTrackTagLabel.bounds.size.height*2;

    NSArray *array = @[self.firstTrackXTextField, self.firstTrackYTextField, self.firstTrackZTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstTrackTagLabel.mas_bottom).offset(15);
        make.height.equalTo(30);
    }];
    
    array = @[self.firstTrackWidthTextField, self.firstTrackHeightTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:30 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstTrackYTextField.mas_bottom).offset(5);
        make.height.equalTo(self.firstTrackYTextField);
    }];
    
    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstTrackWidthTextField);
        make.right.equalTo(self.firstTrackHeightTextField);
        make.height.equalTo(1);
        make.top.equalTo(self.firstTrackHeightTextField.mas_bottom).offset(10);
    }];
    
    _totalHeight += 61;
    
    //============== second stream =============
    
    self.secondTrackTagLabel = [[UILabel alloc] init];
    self.secondTrackTagLabel.textColor = [UIColor grayColor];
    self.secondTrackTagLabel.font = [UIFont systemFontOfSize:14];
    self.secondTrackTagLabel.text = @"第二路流：";
    [self.secondTrackTagLabel sizeToFit];

    self.secondTrackSwitch = [[UISwitch alloc] init];
    [self.secondTrackSwitch setOnTintColor:QRD_COLOR_RGBA(52,170,220,1)];
    [self.secondTrackSwitch sizeToFit];
    
    self.secondTrackXTextField   = [self commonTextField:@"" alertText:@"X轴:"];
    self.secondTrackYTextField   = [self commonTextField:@"" alertText:@"Y轴:"];
    self.secondTrackZTextField    = [self commonTextField:@"" alertText:@"Z轴:"];
    self.secondTrackWidthTextField     = [self commonTextField:@"" alertText:@"宽度:"];
    self.secondTrackHeightTextField    = [self commonTextField:@"" alertText:@"高度:"];
    
    [self.contentView addSubview:self.secondTrackTagLabel];
    [self.contentView addSubview:self.secondTrackSwitch];
    [self.contentView addSubview:self.secondTrackXTextField];
    [self.contentView addSubview:self.secondTrackYTextField];
    [self.contentView addSubview:self.secondTrackZTextField];
    [self.contentView addSubview:self.secondTrackWidthTextField];
    [self.contentView addSubview:self.secondTrackHeightTextField];
    
    [self.secondTrackTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.firstTrackHeightTextField.mas_bottom).offset(25);
        make.size.equalTo(self.secondTrackTagLabel.bounds.size);
    }];
    
    
    [self.secondTrackSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondTrackTagLabel.mas_right).offset(5);
        make.centerY.equalTo(self.secondTrackTagLabel);
        make.size.equalTo(self.secondTrackSwitch.bounds.size);
    }];
    
    _totalHeight += (25 + self.secondTrackTagLabel.bounds.size.height*2);

    array = @[self.secondTrackXTextField, self.secondTrackYTextField, self.secondTrackZTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondTrackTagLabel.mas_bottom).offset(15);
        make.height.equalTo(30);
    }];
    
    array = @[self.secondTrackWidthTextField, self.secondTrackHeightTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:30 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondTrackYTextField.mas_bottom).offset(5);
        make.height.equalTo(self.secondTrackYTextField);
    }];
    
    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondTrackWidthTextField);
        make.right.equalTo(self.secondTrackHeightTextField);
        make.height.equalTo(1);
        make.top.equalTo(self.secondTrackHeightTextField.mas_bottom).offset(10);
    }];
    
    _totalHeight += 61;
    
    //============== audio =============
    
    UILabel *audioLabel = [[UILabel alloc] init];
    audioLabel.textColor = [UIColor grayColor];
    audioLabel.font = [UIFont systemFontOfSize:12];
    audioLabel.text = @"音频流设置:";
    [audioLabel sizeToFit];
    
    self.audioTrackSwitch = [[UISwitch alloc] init];
    [self.audioTrackSwitch setOnTintColor:QRD_COLOR_RGBA(52,170,220,1)];
    [self.audioTrackSwitch sizeToFit];

    [self.contentView addSubview:audioLabel];
    [self.contentView addSubview:self.audioTrackSwitch];

    [audioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstTrackXTextField);
        make.size.equalTo(audioLabel.bounds.size);
        make.top.equalTo(line.mas_bottom).offset(15);
    }];
    
    [self.audioTrackSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(audioLabel.mas_right).offset(5);
        make.centerY.equalTo(audioLabel);
        make.size.equalTo(self.audioTrackSwitch.bounds.size);
    }];
        
    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
      
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioTrackSwitch.mas_bottom).offset(8);
        make.left.right.equalTo(self);
        make.height.equalTo(1);
    }];
    
    _totalHeight += (audioLabel.bounds.size.height + self.audioTrackSwitch.bounds.size.height + 1);
    
    //============== custom merge =============
    
    _customMergeOpenLabel = [[UILabel alloc] init];
    _customMergeOpenLabel.textColor = [UIColor grayColor];
    _customMergeOpenLabel.textAlignment = NSTextAlignmentLeft;
    _customMergeOpenLabel.font = [UIFont systemFontOfSize:14];
    _customMergeOpenLabel.text = @"自定义合流配置：";
    
    self.customMergeSwitch = [[UISwitch alloc] init];
    [self.customMergeSwitch setOnTintColor:QRD_COLOR_RGBA(52,170,220,1)];
    [self.customMergeSwitch sizeToFit];
    [self.customMergeSwitch addTarget:self action:@selector(openCustomMerge:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:_customMergeOpenLabel];
    [self.contentView addSubview:_customMergeSwitch];
    
    [_customMergeOpenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.contentView).offset(20);
         make.size.equalTo(CGSizeMake(120, 42));
         make.top.equalTo(line.mas_bottom).offset(10);
    }];
     
    [_customMergeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.customMergeOpenLabel.mas_right);
         make.centerY.equalTo(_customMergeOpenLabel);
         make.size.equalTo(self.customMergeSwitch.bounds.size);
    }];
     
    _totalHeight += (58 + self.customMergeSwitch.bounds.size.height);
    
    if (self.frame.size.height <= 667) {
        _totalHeight += 40;
    }
    
    self.streamInfoLabel = [[UILabel alloc] init];
    self.streamInfoLabel.textColor = [UIColor grayColor];
    self.streamInfoLabel.font = [UIFont systemFontOfSize:14];
    self.streamInfoLabel.text = @"推流地址：";
    [self.streamInfoLabel sizeToFit];
    
    self.streamURLLabel = [[UILabel alloc] init];
    self.streamURLLabel.textColor = [UIColor grayColor];
    self.streamURLLabel.font = [UIFont systemFontOfSize:12];
    self.streamURLLabel.text = self.customConfiguration.publishUrl;
    [self.streamURLLabel sizeToFit];
    
    self.widthTextField = [self commonTextField:@"" alertText:@"宽度:"];
    self.heightTextField = [self commonTextField:@"" alertText:@"高度:"];
    self.mergeIdTextField = [self commonTextField:@"" alertText:@"合流 Id:"];
    self.fpsTextField = [self commonTextField:@"" alertText:@"帧率:"];
    self.bitrateTextField = [self commonTextField:@"" alertText:@"码率:"];
    self.minbitrateTextField = [self commonTextField:@"" alertText:@"最小码率:"];
    self.maxbitrateTextField = [self commonTextField:@"" alertText:@"最大码率:"];
    
    self.fillModeLabel = [[UILabel alloc] init];
    self.fillModeLabel.textColor = [UIColor grayColor];
    self.fillModeLabel.font = [UIFont systemFontOfSize:14];
    self.fillModeLabel.text = @"画面填充方式：";
    [self.fillModeLabel sizeToFit];

    self.aspectFillButton = [self commonButton];
    self.aspectFillButton.tag = 1001;
    self.aspectFillButton.selected = YES;
    UILabel *fillLabel = [[UILabel alloc] init];
    fillLabel.textColor = [UIColor grayColor];
    fillLabel.font = [UIFont systemFontOfSize:12];
    fillLabel.textAlignment = NSTextAlignmentLeft;
    fillLabel.text = @"ASPECT_FILL";
    [fillLabel sizeToFit];
    
    self.aspectFitButton = [self commonButton];
    self.aspectFitButton.tag = 1002;
    UILabel *fitLabel = [[UILabel alloc] init];
    fitLabel.textColor = [UIColor grayColor];
    fitLabel.font = [UIFont systemFontOfSize:12];
    fitLabel.textAlignment = NSTextAlignmentLeft;
    fitLabel.text = @"ASPECT_FIT";
    [fitLabel sizeToFit];
    
    self.scaleFitButton = [self commonButton];
    self.scaleFitButton.tag = 1003;
    UILabel *scaleFitLabel = [[UILabel alloc] init];
    scaleFitLabel.textColor = [UIColor grayColor];
    scaleFitLabel.font = [UIFont systemFontOfSize:12];
    scaleFitLabel.textAlignment = NSTextAlignmentLeft;
    scaleFitLabel.text = @"SCALE_FIT";
    [scaleFitLabel sizeToFit];


    [self.contentView addSubview:_streamInfoLabel];
    [self.contentView addSubview:_streamURLLabel];
    
    [self.contentView addSubview:_widthTextField];
    [self.contentView addSubview:_heightTextField];
    [self.contentView addSubview:_mergeIdTextField];
    [self.contentView addSubview:_fpsTextField];
    [self.contentView addSubview:_bitrateTextField];
    [self.contentView addSubview:_minbitrateTextField];
    [self.contentView addSubview:_maxbitrateTextField];
    
    [self.contentView addSubview:_fillModeLabel];
    [self.contentView addSubview:_aspectFillButton];
    [self.contentView addSubview:fillLabel];
    [self.contentView addSubview:_aspectFitButton];
    [self.contentView addSubview:fitLabel];
    [self.contentView addSubview:_scaleFitButton];
    [self.contentView addSubview:scaleFitLabel];
    
    [_streamInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customMergeOpenLabel.mas_left);
        make.top.equalTo(_customMergeOpenLabel.mas_bottom);
        make.size.equalTo(CGSizeMake(80, 32));
    }];
      
    [_streamURLLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_streamInfoLabel.mas_right);
        make.top.equalTo(_customMergeOpenLabel.mas_bottom);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(32);
    }];
    
    array = @[self.widthTextField, self.heightTextField, self.fpsTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.streamInfoLabel.mas_bottom).offset(10);
        make.height.equalTo(30);
    }];
     
    array = @[self.mergeIdTextField, self.bitrateTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:30 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.widthTextField.mas_bottom).offset(5);
        make.height.equalTo(self.secondTrackYTextField);
    }];
    
    array = @[self.minbitrateTextField, self.maxbitrateTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:30 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mergeIdTextField.mas_bottom).offset(5);
        make.height.equalTo(self.secondTrackYTextField);
    }];
    
    
    [_fillModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(_minbitrateTextField.mas_bottom).offset(8);
    }];
        
    [_aspectFillButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fillModeLabel.mas_left);
        make.top.equalTo(_fillModeLabel.mas_bottom);
        make.size.equalTo(CGSizeMake(32, 32));
    }];
    
    [fillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aspectFillButton.mas_right);
        make.centerY.equalTo(_aspectFillButton.centerY);
    }];

    [_aspectFitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fillLabel.mas_right);
        make.centerY.equalTo(_aspectFillButton.centerY);
        make.size.equalTo(CGSizeMake(32, 32));
    }];
    
    [fitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aspectFitButton.mas_right);
        make.centerY.equalTo(_aspectFillButton.centerY);
    }];

    [_scaleFitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fitLabel.mas_right);
        make.centerY.equalTo(_aspectFillButton.centerY);
        make.size.equalTo(CGSizeMake(32, 32));
    }];
    
    [scaleFitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scaleFitButton.mas_right);
        make.centerY.equalTo(_aspectFillButton.centerY);
    }];
}

- (void)clickSaveButton {
    
    if (!self.mergeSwitch.isOn && self.beforeMerge == NO) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didGetMessage:)]) {
            [self.delegate mergeSettingView:self didGetMessage:@"未开启合流，配置未生效"];
        }
        return;
    }
    
    NSInteger firstTrackXValue = [self.firstTrackXTextField.text integerValue];
    NSInteger firstTrackYValue = [self.firstTrackYTextField.text integerValue];
    NSInteger firstTrackZValue = [self.firstTrackZTextField.text integerValue];
    NSInteger firstTrackWValue = [self.firstTrackWidthTextField.text integerValue];
    NSInteger firstTrackHValue = [self.firstTrackHeightTextField.text integerValue];
    BOOL firstTrackMerged = self.firstTrackSwitch.isOn;
    
    NSInteger secondTrackXValue = [self.secondTrackXTextField.text integerValue];
    NSInteger secondTrackYValue = [self.secondTrackYTextField.text integerValue];
    NSInteger secondTrackZValue = [self.secondTrackZTextField.text integerValue];
    NSInteger secondTrackWValue = [self.secondTrackWidthTextField.text integerValue];
    NSInteger secondTrackHValue = [self.secondTrackHeightTextField.text integerValue];
    BOOL secondTrackMerged = self.secondTrackSwitch.isOn;
    
    BOOL audioTrackMerged = self.audioTrackSwitch.isOn;
    
    NSInteger widthValue = [self.widthTextField.text integerValue];
    NSInteger heightValue = [self.heightTextField.text integerValue];
    NSInteger fpsValue = [self.fpsTextField.text integerValue];
    NSInteger bitrateValue = [self.bitrateTextField.text integerValue] * 1000;
    NSInteger minBitrateValue = [self.minbitrateTextField.text integerValue] * 1000;
    NSInteger maxBitrateValue = [self.maxbitrateTextField.text integerValue] * 1000;
    NSString *jobId = self.mergeIdTextField.text;
    
    BOOL customMerge = self.customMergeSwitch.isOn;
       
    if (!(self.firstTrackMergeInfo || self.secondTrackMergeInfo || self.audioTrackMergeInfo)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didGetMessage:)]) {
            [self.delegate mergeSettingView:self didGetMessage:@"出现未知错误，请重试"];
        }
        return;
    }
    
    if (firstTrackMerged) {
        if (0 == firstTrackWValue || 0 == firstTrackHValue) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didGetMessage:)]) {
                [self.delegate mergeSettingView:self didGetMessage:@"宽高数据不可以为 0"];
            }
            return;
        }
    }
    
    if (secondTrackMerged) {
        if (0 == secondTrackWValue || 0 == secondTrackHValue) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didGetMessage:)]) {
                [self.delegate mergeSettingView:self didGetMessage:@"宽高数据不可以为 0"];
            }
            return;
        }
    }
    
    if (customMerge) {
        if (0 == widthValue || 0 == heightValue) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didGetMessage:)]) {
                [self.delegate mergeSettingView:self didGetMessage:@"宽高数据不可以为 0"];
            }
            return;
        }
    }

    BOOL firstTrackChanged = NO;
    BOOL secondTrackChanged = NO;
    BOOL audioTrackChanged = NO;
    
    BOOL mergeOpenChanged = NO;
    BOOL customChanged = NO;
    
    CGRect firstTrackFrame = CGRectMake(firstTrackXValue, firstTrackYValue, firstTrackWValue, firstTrackHValue);
    CGRect secondTrackFrame = CGRectMake(secondTrackXValue, secondTrackYValue, secondTrackWValue, secondTrackHValue);
    
    if (self.firstTrackMergeInfo) {
        if (!CGRectEqualToRect(firstTrackFrame, self.firstTrackMergeInfo.mergeFrame) ||
            firstTrackZValue != self.firstTrackMergeInfo.zIndex ||
            firstTrackMerged != self.firstTrackMergeInfo.isMerged) {
            firstTrackChanged = YES;
        }
    }
    
    if (self.secondTrackMergeInfo) {
        if (!CGRectEqualToRect(secondTrackFrame, self.secondTrackMergeInfo.mergeFrame) ||
            secondTrackZValue != self.secondTrackMergeInfo.zIndex ||
            secondTrackMerged != self.secondTrackMergeInfo.isMerged) {
            secondTrackChanged = YES;
        }
    }
    
    if (self.audioTrackMergeInfo) {
        if (audioTrackMerged != self.audioTrackMergeInfo.isMerged) {
            audioTrackChanged = YES;
        }
    }
    
    if (self.beforeCustom != self.customMergeSwitch.isOn) {
        customChanged = YES;
    }
    
    if (self.beforeMerge != self.mergeSwitch.isOn) {
        mergeOpenChanged = YES;
    }
    
    if (self.mergeSwitch.isOn == NO) {
        self.customMergeSwitch.on = NO;
        if (self.beforeCustom) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didCloseMerge:)]) {
                [self.delegate mergeSettingView:self didCloseMerge:_customConfiguration.jobId];
            }
        } else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didCloseMerge:)]) {
                [self.delegate mergeSettingView:self didCloseMerge:nil];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didGetMessage:)]) {
            [self.delegate mergeSettingView:self didGetMessage:@"关闭合流成功"];
        }
        return;
    } else{
        if (self.beforeCustom != self.customMergeSwitch.isOn) {
            if (self.customMergeSwitch.isOn == NO) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didCloseMerge:)]) {
                    [self.delegate mergeSettingView:self didCloseMerge:_customConfiguration.jobId];
                }
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didCloseMerge:)]) {
                    [self.delegate mergeSettingView:self didCloseMerge:nil];
                }
            }
         }
    }
    self.beforeMerge = self.mergeSwitch.isOn;
    
    if (customMerge) {
        _mergeJobId = jobId;
        if (widthValue != _customConfiguration.width ||
            heightValue != _customConfiguration.height ||
            fpsValue != _customConfiguration.fps ||
            bitrateValue != _customConfiguration.bitrateBps ||
            minBitrateValue != _customConfiguration.minBitrateBps ||
            maxBitrateValue != _customConfiguration.maxBitrateBps ||
            _videoFillMode != _customConfiguration.fillMode) {
            customChanged = YES;
            
            _customConfiguration.width = (int)widthValue;
            _customConfiguration.height = (int)heightValue;
            _customConfiguration.fps = (int)fpsValue;
            _customConfiguration.bitrateBps = bitrateValue;
            _customConfiguration.minBitrateBps = minBitrateValue;
            _customConfiguration.maxBitrateBps = maxBitrateValue;
            _customConfiguration.jobId = jobId;
            _customConfiguration.fillMode = _videoFillMode;
        }
    } else{
        _mergeJobId = nil;
    }
    
    if (!(firstTrackChanged || audioTrackChanged || secondTrackChanged || mergeOpenChanged || customChanged)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didGetMessage:)]) {
            [self.delegate mergeSettingView:self didGetMessage:@"没做任何改变"];
        }
        return ;
    }
    
    NSMutableArray *addLayouts = [[NSMutableArray alloc] init];
    NSMutableArray *removeLayouts = [[NSMutableArray alloc] init];
    if (self.firstTrackMergeInfo) {
        self.firstTrackMergeInfo.mergeFrame = firstTrackFrame;
        self.firstTrackMergeInfo.zIndex = firstTrackZValue;
        self.firstTrackMergeInfo.merged = firstTrackMerged;
        
        QNMergeStreamLayout *layout = [[QNMergeStreamLayout alloc] init];
        layout.frame = firstTrackFrame;
        layout.zIndex = firstTrackZValue;
        layout.trackId = self.firstTrackMergeInfo.trackId;
        if (firstTrackMerged) {
            [addLayouts addObject:layout];
        } else {
            [removeLayouts addObject:layout];
        }
    }
    
    if (self.secondTrackMergeInfo) {
        self.secondTrackMergeInfo.mergeFrame = secondTrackFrame;
        self.secondTrackMergeInfo.zIndex = secondTrackZValue;
        self.secondTrackMergeInfo.merged = secondTrackMerged;
        
        QNMergeStreamLayout *layout = [[QNMergeStreamLayout alloc] init];
        layout.frame = secondTrackFrame;
        layout.zIndex = secondTrackZValue;
        layout.trackId = self.secondTrackMergeInfo.trackId;
        if (secondTrackMerged) {
            [addLayouts addObject:layout];
        } else {
            [removeLayouts addObject:layout];
        }
    }
    
    if (self.audioTrackMergeInfo) {
        self.audioTrackMergeInfo.merged = audioTrackMerged;
    
        QNMergeStreamLayout *audioLayout = [[QNMergeStreamLayout alloc] init];
        audioLayout.trackId = self.audioTrackMergeInfo.trackId;
        if (audioTrackMerged) {
            [addLayouts addObject:audioLayout];
        } else {
            [removeLayouts addObject:audioLayout];
        }
    }
    
    if (self.mergeSwitch.isOn) {
        if (self.beforeCustom != self.customMergeSwitch.isOn) {
            self.beforeCustom = self.customMergeSwitch.isOn;
        }
        
        if (removeLayouts.count) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didRemoveMergeLayouts:jobId:)]) {
                [self.delegate mergeSettingView:self didRemoveMergeLayouts:removeLayouts jobId:_mergeJobId];
            }
        }
        
        if (customMerge) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didUpdateMergeConfiguration:layouts:jobId:)]) {
                [self.delegate mergeSettingView:self didUpdateMergeConfiguration:_customConfiguration layouts:addLayouts jobId:_mergeJobId];
            }
            return;
        }
        
        if (addLayouts.count) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didSetMergeLayouts:jobId:)]) {
                [self.delegate mergeSettingView:self didSetMergeLayouts:addLayouts jobId:_mergeJobId];
            }
        }
       
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didGetMessage:)]) {
            [self.delegate mergeSettingView:self didGetMessage:@"设置成功"];
        }
    }
}

- (void)openCustomMerge:(UISwitch *)custom {
    if (custom.on) {
         _totalHeight += (190 + self.fillModeLabel.bounds.size.height);
    } else {
         _totalHeight -= (190 + self.fillModeLabel.bounds.size.height);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didUpdateTotalHeight:)]) {
        [self.delegate mergeSettingView:self didUpdateTotalHeight:_totalHeight];
    }
}

#pragma mark - merge info

- (void)addMergeInfoWithTracks:(NSArray *)tracks userId:(NSString *)userId {
    
    for (QNTrackInfo *trackInfo in tracks) {
        QRDMergeInfo *mergeInfo = [[QRDMergeInfo alloc] init];
        mergeInfo.trackId = trackInfo.trackId;
        mergeInfo.userId = userId;
        mergeInfo.kind = trackInfo.kind;
        mergeInfo.merged = YES;
        mergeInfo.trackTag = trackInfo.tag;
        
        if (trackInfo.kind == QNTrackKindVideo) {
            [self.mergeInfoArray insertObject:mergeInfo atIndex:0];
        }
        else {
            [self.mergeInfoArray addObject:mergeInfo];
        }
    }
    
    if (![self.mergeUserArray containsObject:userId]) {
        [self.mergeUserArray addObject:userId];
    }
}

- (void)removeMergeInfoWithTracks:(NSArray *)tracks userId:(NSString *)userId {
    for (QNTrackInfo *trackInfo in tracks) {
        [self removeMergeInfoWithTrackId:trackInfo.trackId];
    }
    
    BOOL deleteUser = YES;
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if ([info.userId isEqualToString:userId]) {
            deleteUser = NO;
            break;
        }
    }
    if (deleteUser) {
        [self.mergeUserArray removeObject:userId];
    }
}

- (void)removeMergeInfoWithUserId:(NSString *)userId {
    if (self.mergeInfoArray.count <= 0) {
        return;
    }
    
    for (NSInteger index = self.mergeInfoArray.count - 1; index >= 0; index--) {
        QRDMergeInfo *info = self.mergeInfoArray[index];
        if ([info.userId isEqualToString:userId]) {
            [self.mergeInfoArray removeObject:info];
        }
    }
    
    [self.mergeUserArray removeObject:userId];
}

- (void)removeMergeInfoWithTrackId:(NSString *)trackId {
    if (self.mergeInfoArray.count <= 0) {
        return;
    }
    
    for (NSInteger index = self.mergeInfoArray.count - 1; index >= 0; index--) {
        QRDMergeInfo *info = self.mergeInfoArray[index];
        if ([info.trackId isEqualToString:trackId]) {
            [self.mergeInfoArray removeObject:info];
        }
    }
}

#pragma mark - reset

- (void)resetMergeFrame {

    //  每当有用户发布或者取消发布的时候，都重置合流参数
    NSMutableArray *videoMergeArray = [[NSMutableArray alloc] init];
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if (info.merged && QNTrackKindVideo == info.kind) {
            [videoMergeArray addObject:info];
        }
    }
    
    if (videoMergeArray.count > 0) {
        NSArray *mergeFrameArray = [self getTrackMergeFrame:(int)videoMergeArray.count];
        
        for (int i = 0; i < mergeFrameArray.count; i ++) {
            QRDMergeInfo * info = [videoMergeArray objectAtIndex:i ];
            info.mergeFrame = [[mergeFrameArray objectAtIndex:i] CGRectValue];
        }
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if (info.isMerged) {
            QNMergeStreamLayout *layout = [[QNMergeStreamLayout alloc] init];
            layout.trackId = info.trackId;
            layout.frame = info.mergeFrame;
            layout.zIndex = info.zIndex;
            [array addObject:layout];
        }
    }
    
    if (self.mergeSwitch.isOn) {
        if (array.count > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didSetMergeLayouts:jobId:)]) {
                [self.delegate mergeSettingView:self didSetMergeLayouts:array jobId:self.mergeJobId];
            }
        }
    }
}

- (void)resetUserList {
    if (!self.userScorllView) {
        return;
    }
    
    for (UIView *subView in self.userScorllView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIView *preView = nil;
    __block CGFloat totalWidth = 0;
    for (int i = 0; i < self.mergeUserArray.count; i ++) {
        NSString *userId = self.mergeUserArray[i];
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:userId forState:(UIControlStateNormal)];
        [button sizeToFit];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button setTitleColor:QRD_COLOR_RGBA(52,170,220,1) forState:(UIControlStateSelected)];
        [button addTarget:self action:@selector(clickUserHeaderButton:) forControlEvents:(UIControlEventTouchUpInside)];
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 15;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.userScorllView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (preView) {
                make.left.equalTo(preView.mas_right).offset(20);
            } else {
                make.left.equalTo(self.userScorllView).offset(20);
            }
            CGFloat width = button.bounds.size.width + 10;
            totalWidth += width;
            totalWidth += 20;
            make.size.equalTo(CGSizeMake(width > 50 ? width : 50 , 30));
            make.centerY.equalTo(self.userScorllView);
        }];
        
        if (0 == i) {
            [self clickUserHeaderButton:button];
        }
        if (self.mergeInfoArray.count - 1 == i) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.userScorllView).offset(20);
            }];
        }
        preView = button;
    }
    self.userScorllView.contentSize = CGSizeMake(totalWidth + 20, self.userScorllView.bounds.size.height);
}

- (void)clickUserHeaderButton:(UIButton *)button {
    
    // 如果一个用户有多路视频，最多支持设置前两路视频
    
    if (button.selected) {
        return;
    }
    self.firstTrackMergeInfo = nil;
    self.secondTrackMergeInfo = nil;
    self.audioTrackMergeInfo = nil;
    
    self.selectedUserId = [button titleForState:(UIControlStateNormal)];
    
    for (UIView *subview in self.userScorllView.subviews) {
        subview.layer.borderColor = [UIColor grayColor].CGColor;
        if ([subview isKindOfClass:UIButton.class]) {
            [(UIButton *)subview setSelected:NO];
        }
    }
    button.selected = YES;
    button.layer.borderColor = QRD_COLOR_RGBA(52,170,220,1).CGColor;
    
    NSMutableArray *videoInfos = [self getVideoMergeInfoWithUserId:self.selectedUserId];
    self.audioTrackMergeInfo = [self getAudioMergeInfoWithUserId:self.selectedUserId];

    if (!(videoInfos.count || self.audioTrackMergeInfo)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mergeSettingView:didGetMessage:)]) {
            [self.delegate mergeSettingView:self didGetMessage:@"该 track 不存在或者已取消发布了哦"];
        }
        return;
    }
    
    // 先查找是否有 tag 为 cameraTag 或者为 screenTag 的 track，有的话，先拿出来
    for (int i = 0; i < videoInfos.count; i ++) {
        QRDMergeInfo *info = videoInfos[i];
        if ([info.trackTag isEqualToString:cameraTag]) {
            self.firstTrackMergeInfo = info;
            [videoInfos removeObject:info];
            i --;
        } else if ([info.trackTag isEqualToString:screenTag]) {
            self.secondTrackMergeInfo = info;
            [videoInfos removeObject:info];
            i --;
        }
    }

    if (!self.firstTrackMergeInfo && videoInfos.count) {
        self.firstTrackMergeInfo = videoInfos.firstObject;
        [videoInfos removeObjectAtIndex:0];
    }
    
    if (!self.secondTrackMergeInfo && videoInfos.count) {
        self.secondTrackMergeInfo = videoInfos.firstObject;
        [videoInfos removeObjectAtIndex:0];
    }
    
    [self enableFirstTrackCtrls:nil != self.firstTrackMergeInfo];
    [self enableSecondTrackCtrls:nil != self.secondTrackMergeInfo];
    [self enableAudioTrackCtrls:nil != self.audioTrackMergeInfo];
    
    self.firstTrackXTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackMergeInfo.mergeFrame.origin.x];
    self.firstTrackYTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackMergeInfo.mergeFrame.origin.y];
    self.firstTrackZTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackMergeInfo.zIndex];
    self.firstTrackWidthTextField.text  = [NSString stringWithFormat:@"%d",(int)self.firstTrackMergeInfo.mergeFrame.size.width];
    self.firstTrackHeightTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackMergeInfo.mergeFrame.size.height];
    [self.firstTrackSwitch setOn:self.firstTrackMergeInfo.merged animated:YES];
    
    self.secondTrackXTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackMergeInfo.mergeFrame.origin.x];
    self.secondTrackYTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackMergeInfo.mergeFrame.origin.y];
    self.secondTrackZTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackMergeInfo.zIndex];
    self.secondTrackWidthTextField.text  = [NSString stringWithFormat:@"%d",(int)self.secondTrackMergeInfo.mergeFrame.size.width];
    self.secondTrackHeightTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackMergeInfo.mergeFrame.size.height];
    [self.secondTrackSwitch setOn:self.secondTrackMergeInfo.merged animated:YES];
    
    [self.audioTrackSwitch setOn:self.audioTrackMergeInfo.isMerged animated:YES];
    
    self.widthTextField.text = [NSString stringWithFormat:@"%d",self.customConfiguration.width];
    self.heightTextField.text = [NSString stringWithFormat:@"%d",self.customConfiguration.height];
    self.fpsTextField.text = [NSString stringWithFormat:@"%d",self.customConfiguration.fps];
    self.bitrateTextField.text  = [NSString stringWithFormat:@"%d",(int)self.customConfiguration.bitrateBps/1000];
    self.mergeIdTextField.text = [NSString stringWithFormat:@"%@",self.customConfiguration.jobId];
    self.minbitrateTextField.text = [NSString stringWithFormat:@"%d",(int)self.customConfiguration.minBitrateBps/1000];
    self.maxbitrateTextField.text = [NSString stringWithFormat:@"%d",(int)self.customConfiguration.maxBitrateBps/1000];
    
    // UI 展示处理
    if (self.firstTrackMergeInfo.trackTag.length) {
        NSString *text = [NSString stringWithFormat:@"%@：",self.firstTrackMergeInfo.trackTag];
        if ([self.firstTrackMergeInfo.trackTag isEqualToString:cameraTag]) {
            text = @"相机流设置：";
        }
        self.firstTrackTagLabel.text = text;
    } else {
        self.firstTrackTagLabel.text = self.firstTrackMergeInfo ? @"第一路流：" : @"没有流，不需设置：";
    }
    
    if (self.secondTrackMergeInfo.trackTag.length) {
        NSString *text = [NSString stringWithFormat:@"%@：",self.firstTrackMergeInfo.trackTag];
        if ([self.secondTrackMergeInfo.trackTag isEqualToString:screenTag]) {
            text = @"屏幕录制流设置：";
        }
        self.secondTrackTagLabel.text = text;
    } else {
        self.secondTrackTagLabel.text = self.secondTrackMergeInfo ? @"第二路流：" : @"没有流，不需设置：";
    }
    
    [self.firstTrackTagLabel sizeToFit];
    [self.secondTrackTagLabel sizeToFit];
    
    [self.firstTrackTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.warnningLabel.mas_bottom).offset(10);
        make.size.equalTo(self.firstTrackTagLabel.bounds.size);
    }];
    [self.secondTrackTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.firstTrackHeightTextField.mas_bottom).offset(25);
        make.size.equalTo(self.secondTrackTagLabel.bounds.size);
    }];
    
    [UIView animateWithDuration:.25 animations:^{
        [self layoutIfNeeded];
    }];
}

- (NSArray <NSValue *>*)getTrackMergeFrame:(int)count {
    
    NSMutableArray *frameArray = [[NSMutableArray alloc] init];
    if (1 == count) {
        CGRect rc = CGRectMake(0, 0, self.mergeStreamSize.width, self.mergeStreamSize.height);
        NSValue *value = [NSValue valueWithCGRect:rc];
        [frameArray addObject:value];
        return frameArray;
    }
    
    int power = log2(count);
    int bigFrameCount = pow(2, power);
    int left = count - bigFrameCount;
    
    int widthPower = power / 2;
    int heightPower = power - power / 2;
    
    CGRect *pRect = (CGRect *)malloc(sizeof(CGRect) * bigFrameCount);
    int row = pow(2, heightPower);
    int col = pow(2, widthPower);
    CGFloat width = self.mergeStreamSize.width / (pow(2, widthPower));
    CGFloat height = self.mergeStreamSize.height / (pow(2, heightPower));
    
    for (int i = 0; i < row; i ++) {
        for (int j = 0; j < col; j ++) {
            pRect[i * col + j].origin.x = j * width;
            pRect[i * col + j].origin.y = i * height;
            pRect[i * col + j].size.width = width;
            pRect[i * col + j].size.height = height;
        }
    }
    
    if (power % 2 == 0) {
        // 需要横着补刀
        for (int i = 0; i < left; i ++) {
            CGRect rc = pRect[i];
            CGRect rc1 = rc;
            rc1.size.height = rc.size.height / 2;
            CGRect rc2 = rc;
            rc2.origin.y = rc.origin.y + rc.size.height / 2;
            rc2.size.height = rc.size.height / 2;
            
            NSValue *value = [NSValue valueWithCGRect:rc1];
            [frameArray addObject:value];
            value = [NSValue valueWithCGRect:rc2];
            [frameArray addObject:value];
        }
        for (int i = left; i < bigFrameCount; i ++) {
            CGRect rc = pRect[i];
            NSValue *value = [NSValue valueWithCGRect:rc];
            [frameArray addObject:value];
        }
    } else {
        // 需要竖着补刀
        for (int i = 0; i < left; i ++) {
            CGRect rc = pRect[i];
            CGRect rc1 = rc;
            rc1.size.width = rc.size.width / 2;
            CGRect rc2 = rc;
            rc2.origin.x = rc.origin.x + rc.size.width / 2;
            rc2.size.width = rc.size.width / 2;
            
            NSValue *value = [NSValue valueWithCGRect:rc1];
            [frameArray addObject:value];
            value = [NSValue valueWithCGRect:rc2];
            [frameArray addObject:value];
        }
        
        for (int i = left; i < bigFrameCount; i ++) {
            CGRect rc = pRect[i];
            NSValue *value = [NSValue valueWithCGRect:rc];
            [frameArray addObject:value];
        }
    }
    
    free(pRect);
    
    return frameArray;
}


- (void)enableFirstTrackCtrls:(BOOL)enable {
    self.firstTrackWidthTextField.enabled = enable;
    self.firstTrackHeightTextField.enabled = enable;
    self.firstTrackXTextField.enabled = enable;
    self.firstTrackYTextField.enabled = enable;
    self.firstTrackZTextField.enabled = enable;
    self.firstTrackSwitch.enabled = enable;
}

- (void)enableSecondTrackCtrls:(BOOL)enable {
    self.secondTrackWidthTextField.enabled = enable;
    self.secondTrackHeightTextField.enabled = enable;
    self.secondTrackXTextField.enabled = enable;
    self.secondTrackYTextField.enabled = enable;
    self.secondTrackZTextField.enabled = enable;
    self.secondTrackSwitch.enabled = enable;
}

- (void)enableAudioTrackCtrls:(BOOL)enable {
    self.audioTrackSwitch.enabled = enable;
}

- (NSMutableArray *)getVideoMergeInfoWithUserId:(NSString *)userId {
    
    NSMutableArray *videoMergeInfos = nil;
    
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if ([info.userId isEqualToString:userId] && info.kind == QNTrackKindVideo) {
            if (!videoMergeInfos) {
                videoMergeInfos = [[NSMutableArray alloc] init];
            }
            [videoMergeInfos addObject:info];
        }
    }
    return videoMergeInfos;
}

- (QRDMergeInfo *)getAudioMergeInfoWithUserId:(NSString *)userId {
    for (QRDMergeInfo *info in self.mergeInfoArray) {
        if ([info.userId isEqualToString:userId] && info.kind == QNTrackKindAudio) {
            return info;
        }
    }
    return nil;
}

- (void)viewFillMode:(UIButton *)button {
    if (!button.selected) {
        button.selected = YES;
        if (button.tag == 1001) {
            _videoFillMode = QNVideoFillModePreserveAspectRatioAndFill;
            self.aspectFitButton.selected = NO;
            self.scaleFitButton.selected = NO;
        }
        if (button.tag == 1002) {
            _videoFillMode = QNVideoFillModePreserveAspectRatio;
            self.aspectFillButton.selected = NO;
            self.scaleFitButton.selected = NO;
        }
        if (button.tag == 1003) {
            _videoFillMode = QNVideoFillModeStretch;
            self.aspectFitButton.selected = NO;
            self.aspectFillButton.selected = NO;
        }
    }
}

- (UIButton *)commonButton {
    UIImage *normalImage = [UIImage imageNamed:@"noChoose"];
    UIImage *selectedImage = [UIImage imageNamed:@"choose"];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button addTarget:self action:@selector(viewFillMode:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UITextField *)commonTextField:(NSString *)placeholder alertText:(NSString *)alertText {
    return [self commonTextField:placeholder alertText:alertText keyboardType:UIKeyboardTypeNumberPad];
}

- (UITextField *)commonTextField:(NSString *)placeholder alertText:(NSString *)alertText keyboardType:(UIKeyboardType)keyboardType {
    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.keyboardType = keyboardType;
    textFiled.returnKeyType = UIReturnKeyNext;
    textFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes: @{NSForegroundColorAttributeName : [UIColor colorWithWhite:.5 alpha:1]}];
    textFiled.font = [UIFont systemFontOfSize:12];
    textFiled.layer.borderWidth = 1.0;
    textFiled.layer.borderColor = [UIColor colorWithWhite:.6 alpha:.5].CGColor;
    textFiled.layer.cornerRadius = 15;
    textFiled.clipsToBounds = YES;
    textFiled.delegate = self;
    textFiled.textColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = alertText;
    leftLabel.font = [UIFont systemFontOfSize:12];
    leftLabel.textColor = [UIColor grayColor];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [leftLabel sizeToFit];
    leftLabel.frame = CGRectMake(0, 0, leftLabel.bounds.size.width + 10, 22);
    textFiled.leftView = leftLabel;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    
    return textFiled;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
