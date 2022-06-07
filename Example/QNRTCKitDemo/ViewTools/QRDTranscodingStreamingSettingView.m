//
//  QRDTranscodingStreamingSettingView.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2020/4/26.
//  Copyright © 2020 PILI. All rights reserved.
//

#import "QRDTranscodingStreamingSettingView.h"

static NSString *cameraTag = @"camera";
static NSString *screenTag = @"screen";

@interface QRDTranscodingStreamingSettingView()

@property (nonatomic, copy) NSString *transcodingStreamingSteamID;
@property (nonatomic, copy) NSString *transcodingStreamingUserID;
@property (nonatomic, copy) NSString *roomName;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *beforeAddLayouts;

@property (nonatomic, assign) BOOL beforeMerge;
@property (nonatomic, assign) BOOL beforeCustom;

@property (nonatomic, assign, readwrite) CGFloat totalHeight;
@property (nonatomic, assign) QNVideoFillModeType videoFillMode;

@property (nonatomic, assign) BOOL transcodingStreamingOpenChanged;
@property (nonatomic, assign) BOOL customChanged;

@end

@implementation QRDTranscodingStreamingSettingView

- (id)initWithFrame:(CGRect)frame userId:(NSString *)userId roomName:(NSString *)roomName{
    if ([super initWithFrame:frame]) {
        
        self.saveEnable = NO;
        self.transcodingStreamingUserID = userId;
        self.roomName = roomName;
        self.transcodingStreamingSteamID = nil;
        
        self.customConfiguration = [QNTranscodingLiveStreamingConfig defaultConfiguration];
        self.customConfiguration.streamID = roomName;
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
        
        self.transcodingStreamingInfoArray = [[NSMutableArray alloc] init];
        self.transcodingStreamingUserArray = [[NSMutableArray alloc] init];
        
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
    
    self.cancelButton = [[UIButton alloc] init];
    [_cancelButton setBackgroundColor:QRD_COLOR_RGBA(52,170,220,1)];
    [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _cancelButton.layer.borderWidth = .5;
    _cancelButton.layer.borderColor = [UIColor colorWithWhite:.6 alpha:.5].CGColor;
    _cancelButton.layer.cornerRadius = 10;
    [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    _transcodingStreamingOpenLabel = [[UILabel alloc] init];
    _transcodingStreamingOpenLabel.textColor = [UIColor grayColor];
    _transcodingStreamingOpenLabel.textAlignment = NSTextAlignmentCenter;
    _transcodingStreamingOpenLabel.font = [UIFont systemFontOfSize:14];
    _transcodingStreamingOpenLabel.text = @"开启合流转推：";
    
    self.transcodingStreamingSwitch = [[UISwitch alloc] init];
    [self.transcodingStreamingSwitch setOnTintColor:QRD_COLOR_RGBA(52,170,220,1)];
    [self.transcodingStreamingSwitch sizeToFit];
    
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
    
    [self.contentView addSubview:self.transcodingStreamingOpenLabel];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.transcodingStreamingSwitch];
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
    
    [self.transcodingStreamingOpenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.size.equalTo(CGSizeMake(100, 42));
    }];
    
    _totalHeight += 52;
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transcodingStreamingOpenLabel.mas_top);
        make.centerY.equalTo(_transcodingStreamingOpenLabel);
        make.size.equalTo(self.transcodingStreamingSwitch.bounds.size);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    [self.transcodingStreamingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transcodingStreamingOpenLabel.mas_top);
        make.centerY.equalTo(_transcodingStreamingOpenLabel);
        make.size.equalTo(self.transcodingStreamingSwitch.bounds.size);
        make.left.equalTo(self.transcodingStreamingOpenLabel.mas_right);
    }];
    
    _totalHeight += self.transcodingStreamingSwitch.bounds.size.height;
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(1);
        make.top.equalTo(self.transcodingStreamingOpenLabel.mas_bottom).offset(10);
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
    
    _customTranscodingStreamingOpenLabel = [[UILabel alloc] init];
    _customTranscodingStreamingOpenLabel.textColor = [UIColor grayColor];
    _customTranscodingStreamingOpenLabel.textAlignment = NSTextAlignmentLeft;
    _customTranscodingStreamingOpenLabel.font = [UIFont systemFontOfSize:14];
    _customTranscodingStreamingOpenLabel.text = @"自定义合流配置：";
    
    self.customTranscodingStreamingSwitch = [[UISwitch alloc] init];
    [self.customTranscodingStreamingSwitch setOnTintColor:QRD_COLOR_RGBA(52,170,220,1)];
    [self.customTranscodingStreamingSwitch sizeToFit];
    [self.customTranscodingStreamingSwitch addTarget:self action:@selector(openCustomTranscodingStreaming:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:_customTranscodingStreamingOpenLabel];
    [self.contentView addSubview:_customTranscodingStreamingSwitch];
    
    [_customTranscodingStreamingOpenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.contentView).offset(20);
         make.size.equalTo(CGSizeMake(120, 42));
         make.top.equalTo(line.mas_bottom).offset(10);
    }];
     
    [_customTranscodingStreamingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.customTranscodingStreamingOpenLabel.mas_right);
         make.centerY.equalTo(_customTranscodingStreamingOpenLabel);
         make.size.equalTo(self.customTranscodingStreamingSwitch.bounds.size);
    }];
     
    _totalHeight += (58 + self.customTranscodingStreamingSwitch.bounds.size.height);
    
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
    self.transcodingStreamingIdTextField = [self commonTextField:@"" alertText:@"合流 Id:"];
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
    [self.contentView addSubview:_transcodingStreamingIdTextField];
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
        make.left.equalTo(self.customTranscodingStreamingOpenLabel.mas_left);
        make.top.equalTo(_customTranscodingStreamingOpenLabel.mas_bottom);
        make.size.equalTo(CGSizeMake(80, 32));
    }];
      
    [_streamURLLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_streamInfoLabel.mas_right);
        make.top.equalTo(_customTranscodingStreamingOpenLabel.mas_bottom);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(32);
    }];
    
    array = @[self.widthTextField, self.heightTextField, self.fpsTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.streamInfoLabel.mas_bottom).offset(10);
        make.height.equalTo(30);
    }];
     
    array = @[self.transcodingStreamingIdTextField, self.bitrateTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:30 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.widthTextField.mas_bottom).offset(5);
        make.height.equalTo(self.secondTrackYTextField);
    }];
    
    array = @[self.minbitrateTextField, self.maxbitrateTextField];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:30 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transcodingStreamingIdTextField.mas_bottom).offset(5);
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

- (void)clickCancelButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didGetMessage:)]) {
        [self.delegate transcodingStreamingSettingView:self didGetMessage:@"取消设置"];
    }
}

- (void)clickSaveButton {
    
    if (!self.transcodingStreamingSwitch.isOn && self.beforeMerge == NO) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didGetMessage:)]) {
            [self.delegate transcodingStreamingSettingView:self didGetMessage:@"未开启合流，配置未生效"];
        }
        return;
    }
    
    if (self.transcodingStreamingSwitch.isOn) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didUseDefaultTranscodingStreaming:)]) {
            [self.delegate transcodingStreamingSettingView:self didUseDefaultTranscodingStreaming:!self.customTranscodingStreamingSwitch.isOn];
        }
        if (!self.saveEnable) {
            return;
        }
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
    NSString *streamID = self.transcodingStreamingIdTextField.text;
    
    BOOL customMerge = self.customTranscodingStreamingSwitch.isOn;
       
    if (!(self.firstTrackTranscodingStreamingInfo || self.secondTrackTranscodingStreamingInfo || self.audioTrackTranscodingStreamingInfo)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didGetMessage:)]) {
            [self.delegate transcodingStreamingSettingView:self didGetMessage:@"出现未知错误，请重试"];
        }
        return;
    }
    
    if (firstTrackMerged) {
        if (0 == firstTrackWValue || 0 == firstTrackHValue) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didGetMessage:)]) {
                [self.delegate transcodingStreamingSettingView:self didGetMessage:@"宽高数据不可以为 0"];
            }
            return;
        }
    }
    
    if (secondTrackMerged) {
        if (0 == secondTrackWValue || 0 == secondTrackHValue) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didGetMessage:)]) {
                [self.delegate transcodingStreamingSettingView:self didGetMessage:@"宽高数据不可以为 0"];
            }
            return;
        }
    }
    
    if (customMerge) {
        if (0 == widthValue || 0 == heightValue) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didGetMessage:)]) {
                [self.delegate transcodingStreamingSettingView:self didGetMessage:@"宽高数据不可以为 0"];
            }
            return;
        }
    }

    BOOL firstTrackChanged = NO;
    BOOL secondTrackChanged = NO;
    BOOL audioTrackChanged = NO;
    
    CGRect firstTrackFrame = CGRectMake(firstTrackXValue, firstTrackYValue, firstTrackWValue, firstTrackHValue);
    CGRect secondTrackFrame = CGRectMake(secondTrackXValue, secondTrackYValue, secondTrackWValue, secondTrackHValue);
    
    if (self.firstTrackTranscodingStreamingInfo) {
        if (!CGRectEqualToRect(firstTrackFrame, self.firstTrackTranscodingStreamingInfo.mergeFrame) ||
            firstTrackZValue != self.firstTrackTranscodingStreamingInfo.zIndex ||
            firstTrackMerged != self.firstTrackTranscodingStreamingInfo.isMerged) {
            firstTrackChanged = YES;
        }
    }
    
    if (self.secondTrackTranscodingStreamingInfo) {
        if (!CGRectEqualToRect(secondTrackFrame, self.secondTrackTranscodingStreamingInfo.mergeFrame) ||
            secondTrackZValue != self.secondTrackTranscodingStreamingInfo.zIndex ||
            secondTrackMerged != self.secondTrackTranscodingStreamingInfo.isMerged) {
            secondTrackChanged = YES;
        }
    }
    
    if (self.audioTrackTranscodingStreamingInfo) {
        if (audioTrackMerged != self.audioTrackTranscodingStreamingInfo.isMerged) {
            audioTrackChanged = YES;
        }
    }
    
    if (self.beforeCustom != self.customTranscodingStreamingSwitch.isOn) {
        _customChanged = YES;
    }
    
    if (self.beforeMerge != self.transcodingStreamingSwitch.isOn) {
        _transcodingStreamingOpenChanged = YES;
    }
    
    if (self.transcodingStreamingSwitch.isOn == NO) {
        self.customTranscodingStreamingSwitch.on = NO;
        if (self.beforeCustom) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didCloseTranscodingLiveStreaming:)]) {
                [self.delegate transcodingStreamingSettingView:self didCloseTranscodingLiveStreaming:_customConfiguration];
            }
        } else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didCloseTranscodingLiveStreaming:)]) {
                [self.delegate transcodingStreamingSettingView:self didCloseTranscodingLiveStreaming:[QNTranscodingLiveStreamingConfig defaultConfiguration]];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didGetMessage:)]) {
            [self.delegate transcodingStreamingSettingView:self didGetMessage:@"关闭合流成功"];
        }
        return;
    } else{
        if (self.beforeCustom != self.customTranscodingStreamingSwitch.isOn) {
            if (self.customTranscodingStreamingSwitch.isOn == NO) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didCloseTranscodingLiveStreaming:)]) {
                    [self.delegate transcodingStreamingSettingView:self didCloseTranscodingLiveStreaming:_customConfiguration];
                }
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didCloseTranscodingLiveStreaming:)]) {
                    [self.delegate transcodingStreamingSettingView:self didCloseTranscodingLiveStreaming:[QNTranscodingLiveStreamingConfig defaultConfiguration]];
                }
            }
         }
    }
    self.beforeMerge = self.transcodingStreamingSwitch.isOn;
    
    if (customMerge) {
        _transcodingStreamingSteamID = streamID;
        if (widthValue != _customConfiguration.width ||
            heightValue != _customConfiguration.height ||
            fpsValue != _customConfiguration.fps ||
            bitrateValue != _customConfiguration.bitrateBps ||
            minBitrateValue != _customConfiguration.minBitrateBps ||
            maxBitrateValue != _customConfiguration.maxBitrateBps ||
            _videoFillMode != _customConfiguration.fillMode) {
            _customChanged = YES;
            
            _customConfiguration.width = (int)widthValue;
            _customConfiguration.height = (int)heightValue;
            _customConfiguration.fps = (int)fpsValue;
            _customConfiguration.bitrateBps = bitrateValue;
            _customConfiguration.minBitrateBps = minBitrateValue;
            _customConfiguration.maxBitrateBps = maxBitrateValue;
            _customConfiguration.streamID = streamID;
            _customConfiguration.fillMode = _videoFillMode;
        }
    } else{
        _transcodingStreamingSteamID = nil;
    }
    
    if (!(firstTrackChanged || audioTrackChanged || secondTrackChanged || _transcodingStreamingOpenChanged || _customChanged)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didGetMessage:)]) {
            [self.delegate transcodingStreamingSettingView:self didGetMessage:@"没做任何改变"];
        }
        return ;
    }
    
    NSMutableArray *addLayouts = [[NSMutableArray alloc] init];
    NSMutableArray *removeLayouts = [[NSMutableArray alloc] init];
    if (self.firstTrackTranscodingStreamingInfo) {
        self.firstTrackTranscodingStreamingInfo.mergeFrame = firstTrackFrame;
        self.firstTrackTranscodingStreamingInfo.zIndex = firstTrackZValue;
        self.firstTrackTranscodingStreamingInfo.merged = firstTrackMerged;
        
        QNTranscodingLiveStreamingTrack *layoutTrack = [[QNTranscodingLiveStreamingTrack alloc] init];
        layoutTrack.frame = firstTrackFrame;
        layoutTrack.zOrder = firstTrackZValue;
        layoutTrack.trackID = self.firstTrackTranscodingStreamingInfo.trackId;
        if (firstTrackMerged) {
            [addLayouts addObject:layoutTrack];
        } else {
            [removeLayouts addObject:layoutTrack];
        }
    }
    
    if (self.secondTrackTranscodingStreamingInfo) {
        self.secondTrackTranscodingStreamingInfo.mergeFrame = secondTrackFrame;
        self.secondTrackTranscodingStreamingInfo.zIndex = secondTrackZValue;
        self.secondTrackTranscodingStreamingInfo.merged = secondTrackMerged;
        
        QNTranscodingLiveStreamingTrack *layoutTrack = [[QNTranscodingLiveStreamingTrack alloc] init];
        layoutTrack.frame = secondTrackFrame;
        layoutTrack.zOrder = secondTrackZValue;
        layoutTrack.trackID = self.secondTrackTranscodingStreamingInfo.trackId;
        if (secondTrackMerged) {
            [addLayouts addObject:layoutTrack];
        } else {
            [removeLayouts addObject:layoutTrack];
        }
    }
    
    if (self.audioTrackTranscodingStreamingInfo) {
        self.audioTrackTranscodingStreamingInfo.merged = audioTrackMerged;
    
        QNTranscodingLiveStreamingTrack *audioLayout = [[QNTranscodingLiveStreamingTrack alloc] init];
        audioLayout.trackID = self.audioTrackTranscodingStreamingInfo.trackId;
        if (audioTrackMerged) {
            [addLayouts addObject:audioLayout];
        } else {
            [removeLayouts addObject:audioLayout];
        }
    }
    
    if (self.transcodingStreamingSwitch.isOn) {
        if (self.beforeCustom != self.customTranscodingStreamingSwitch.isOn) {
            self.beforeCustom = self.customTranscodingStreamingSwitch.isOn;
        }
        
        if (removeLayouts.count) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didRemoveTranscodingLiveStreamingTracks:streamID:)]) {
                [self.delegate transcodingStreamingSettingView:self didRemoveTranscodingLiveStreamingTracks:removeLayouts streamID:_transcodingStreamingSteamID];
            }
        }
        
        if (customMerge) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didUpdateTranscodingStreamingConfiguration:layouts:streamID:)]) {

                [self.delegate transcodingStreamingSettingView:self didUpdateTranscodingStreamingConfiguration:_customConfiguration layouts:addLayouts streamID:_transcodingStreamingSteamID];
            }
            return;
        }
        
        if (addLayouts.count) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didSetTranscodingStreamingLayouts:streamID:)]) {
                [self.delegate transcodingStreamingSettingView:self didSetTranscodingStreamingLayouts:addLayouts streamID:_transcodingStreamingSteamID];
            }
        }
       
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didGetMessage:)]) {
            [self.delegate transcodingStreamingSettingView:self didGetMessage:@"设置成功"];
        }
    }
}

- (void)openCustomTranscodingStreaming:(UISwitch *)custom {
    if (custom.on) {
         _totalHeight += (190 + self.fillModeLabel.bounds.size.height);
    } else {
         _totalHeight -= (190 + self.fillModeLabel.bounds.size.height);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didUpdateTotalHeight:)]) {
        [self.delegate transcodingStreamingSettingView:self didUpdateTotalHeight:_totalHeight];
    }
}

#pragma mark - merge info

- (void)addTranscodingStreamingInfoWithTracks:(NSArray *)tracks userId:(NSString *)userId {
    
    for (QNTrack *track in tracks) {
        QRDTranscodingStreamingInfo *mergeInfo = [[QRDTranscodingStreamingInfo alloc] init];
        mergeInfo.trackId = track.trackID;
        mergeInfo.userId = userId;
        mergeInfo.kind = track.kind;
        mergeInfo.merged = YES;
        mergeInfo.trackTag = track.tag;
        
        if (track.kind == QNTrackKindVideo) {
            [self.transcodingStreamingInfoArray insertObject:mergeInfo atIndex:0];
        }
        else {
            [self.transcodingStreamingInfoArray addObject:mergeInfo];
        }
    }
    
    if (![self.transcodingStreamingUserArray containsObject:userId]) {
        [self.transcodingStreamingUserArray addObject:userId];
    }
}

- (void)removeTranscodingStreamingInfoWithTracks:(NSArray *)tracks userId:(NSString *)userId {
    for (QNTrack *track in tracks) {
        [self removeTranscodingStreamingInfoWithTrackId:track.trackID];
    }
    
    BOOL deleteUser = YES;
    for (QRDTranscodingStreamingInfo *info in self.transcodingStreamingInfoArray) {
        if ([info.userId isEqualToString:userId]) {
            deleteUser = NO;
            break;
        }
    }
    if (deleteUser) {
        [self.transcodingStreamingUserArray removeObject:userId];
    }
}

- (void)removeTranscodingStreamingInfoWithUserId:(NSString *)userId {
    if (self.transcodingStreamingInfoArray.count <= 0) {
        return;
    }
    
    for (NSInteger index = self.transcodingStreamingInfoArray.count - 1; index >= 0; index--) {
        QRDTranscodingStreamingInfo *info = self.transcodingStreamingInfoArray[index];
        if ([info.userId isEqualToString:userId]) {
            [self.transcodingStreamingInfoArray removeObject:info];
        }
    }
    
    [self.transcodingStreamingUserArray removeObject:userId];
}

- (void)removeTranscodingStreamingInfoWithTrackId:(NSString *)trackId {
    if (self.transcodingStreamingInfoArray.count <= 0) {
        return;
    }
    
    for (NSInteger index = self.transcodingStreamingInfoArray.count - 1; index >= 0; index--) {
        QRDTranscodingStreamingInfo *info = self.transcodingStreamingInfoArray[index];
        if ([info.trackId isEqualToString:trackId]) {
            [self.transcodingStreamingInfoArray removeObject:info];
        }
    }
}

- (void)updateSwitch {
    if (self.beforeCustom != self.customTranscodingStreamingSwitch.isOn) {
        _customChanged = YES;
    }
    
    if (self.beforeMerge != self.transcodingStreamingSwitch.isOn) {
        _transcodingStreamingOpenChanged = YES;
    }
}

#pragma mark - reset

- (void)resetTranscodingStreamingFrame {

    //  每当有用户发布或者取消发布的时候，都重置合流参数
    NSMutableArray *videoMergeArray = [[NSMutableArray alloc] init];
    for (QRDTranscodingStreamingInfo *info in self.transcodingStreamingInfoArray) {
        if (info.merged && QNTrackKindVideo == info.kind) {
            [videoMergeArray addObject:info];
        }
    }
    
    if (videoMergeArray.count > 0) {
        NSArray *mergeFrameArray = [self getTrackMergeFrame:(int)videoMergeArray.count];
        
        for (int i = 0; i < mergeFrameArray.count; i ++) {
            QRDTranscodingStreamingInfo * info = [videoMergeArray objectAtIndex:i ];
            info.mergeFrame = [[mergeFrameArray objectAtIndex:i] CGRectValue];
        }
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (QRDTranscodingStreamingInfo *info in self.transcodingStreamingInfoArray) {
        if (info.isMerged) {
            QNTranscodingLiveStreamingTrack *layoutTrack = [[QNTranscodingLiveStreamingTrack alloc] init];
            layoutTrack.trackID = info.trackId;
            layoutTrack.frame = info.mergeFrame;
            layoutTrack.zOrder = info.zIndex;
            [array addObject:layoutTrack];
        }
    }
    
    if (self.transcodingStreamingSwitch.isOn) {
        if (array.count > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didSetTranscodingStreamingLayouts:streamID:)]) {
                [self.delegate transcodingStreamingSettingView:self didSetTranscodingStreamingLayouts:array streamID:self.transcodingStreamingSteamID];
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
    for (int i = 0; i < self.transcodingStreamingUserArray.count; i ++) {
        NSString *userId = self.transcodingStreamingUserArray[i];
        
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
        if (self.transcodingStreamingInfoArray.count - 1 == i) {
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
    self.firstTrackTranscodingStreamingInfo = nil;
    self.secondTrackTranscodingStreamingInfo = nil;
    self.audioTrackTranscodingStreamingInfo = nil;
    
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
    self.audioTrackTranscodingStreamingInfo = [self getAudioMergeInfoWithUserId:self.selectedUserId];

    if (!(videoInfos.count || self.audioTrackTranscodingStreamingInfo)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(transcodingStreamingSettingView:didGetMessage:)]) {
            [self.delegate transcodingStreamingSettingView:self didGetMessage:@"该 track 不存在或者已取消发布了哦"];
        }
        return;
    }
    
    // 先查找是否有 tag 为 cameraTag 或者为 screenTag 的 track，有的话，先拿出来
    for (int i = 0; i < videoInfos.count; i ++) {
        QRDTranscodingStreamingInfo *info = videoInfos[i];
        if ([info.trackTag isEqualToString:cameraTag]) {
            self.firstTrackTranscodingStreamingInfo = info;
            [videoInfos removeObject:info];
            i --;
        } else if ([info.trackTag isEqualToString:screenTag]) {
            self.secondTrackTranscodingStreamingInfo = info;
            [videoInfos removeObject:info];
            i --;
        }
    }

    if (!self.firstTrackTranscodingStreamingInfo && videoInfos.count) {
        self.firstTrackTranscodingStreamingInfo = videoInfos.firstObject;
        [videoInfos removeObjectAtIndex:0];
    }
    
    if (!self.secondTrackTranscodingStreamingInfo && videoInfos.count) {
        self.secondTrackTranscodingStreamingInfo = videoInfos.firstObject;
        [videoInfos removeObjectAtIndex:0];
    }
    
    [self enableFirstTrackCtrls:nil != self.firstTrackTranscodingStreamingInfo];
    [self enableSecondTrackCtrls:nil != self.secondTrackTranscodingStreamingInfo];
    [self enableAudioTrackCtrls:nil != self.audioTrackTranscodingStreamingInfo];
    
    self.firstTrackXTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackTranscodingStreamingInfo.mergeFrame.origin.x];
    self.firstTrackYTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackTranscodingStreamingInfo.mergeFrame.origin.y];
    self.firstTrackZTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackTranscodingStreamingInfo.zIndex];
    self.firstTrackWidthTextField.text  = [NSString stringWithFormat:@"%d",(int)self.firstTrackTranscodingStreamingInfo.mergeFrame.size.width];
    self.firstTrackHeightTextField.text = [NSString stringWithFormat:@"%d",(int)self.firstTrackTranscodingStreamingInfo.mergeFrame.size.height];
    [self.firstTrackSwitch setOn:self.firstTrackTranscodingStreamingInfo.merged animated:YES];
    
    self.secondTrackXTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackTranscodingStreamingInfo.mergeFrame.origin.x];
    self.secondTrackYTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackTranscodingStreamingInfo.mergeFrame.origin.y];
    self.secondTrackZTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackTranscodingStreamingInfo.zIndex];
    self.secondTrackWidthTextField.text  = [NSString stringWithFormat:@"%d",(int)self.secondTrackTranscodingStreamingInfo.mergeFrame.size.width];
    self.secondTrackHeightTextField.text = [NSString stringWithFormat:@"%d",(int)self.secondTrackTranscodingStreamingInfo.mergeFrame.size.height];
    [self.secondTrackSwitch setOn:self.secondTrackTranscodingStreamingInfo.merged animated:YES];
    
    [self.audioTrackSwitch setOn:self.audioTrackTranscodingStreamingInfo.isMerged animated:YES];
    
    self.widthTextField.text = [NSString stringWithFormat:@"%d",self.customConfiguration.width];
    self.heightTextField.text = [NSString stringWithFormat:@"%d",self.customConfiguration.height];
    self.fpsTextField.text = [NSString stringWithFormat:@"%d",self.customConfiguration.fps];
    self.bitrateTextField.text  = [NSString stringWithFormat:@"%d",(int)self.customConfiguration.bitrateBps/1000];
    self.transcodingStreamingIdTextField.text = [NSString stringWithFormat:@"%@",self.customConfiguration.streamID];
    self.minbitrateTextField.text = [NSString stringWithFormat:@"%d",(int)self.customConfiguration.minBitrateBps/1000];
    self.maxbitrateTextField.text = [NSString stringWithFormat:@"%d",(int)self.customConfiguration.maxBitrateBps/1000];
    
    // UI 展示处理
    if (self.firstTrackTranscodingStreamingInfo.trackTag.length) {
        NSString *text = [NSString stringWithFormat:@"%@：",self.firstTrackTranscodingStreamingInfo.trackTag];
        if ([self.firstTrackTranscodingStreamingInfo.trackTag isEqualToString:cameraTag]) {
            text = @"相机流设置：";
        }
        self.firstTrackTagLabel.text = text;
    } else {
        self.firstTrackTagLabel.text = self.firstTrackTranscodingStreamingInfo ? @"第一路流：" : @"没有流，不需设置：";
    }
    
    if (self.secondTrackTranscodingStreamingInfo.trackTag.length) {
        NSString *text = [NSString stringWithFormat:@"%@：",self.firstTrackTranscodingStreamingInfo.trackTag];
        if ([self.secondTrackTranscodingStreamingInfo.trackTag isEqualToString:screenTag]) {
            text = @"屏幕录制流设置：";
        }
        self.secondTrackTagLabel.text = text;
    } else {
        self.secondTrackTagLabel.text = self.secondTrackTranscodingStreamingInfo ? @"第二路流：" : @"没有流，不需设置：";
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
        CGRect rc = CGRectMake(0, 0, self.transcodingStreamingStreamSize.width, self.transcodingStreamingStreamSize.height);
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
    CGFloat width = self.transcodingStreamingStreamSize.width / (pow(2, widthPower));
    CGFloat height = self.transcodingStreamingStreamSize.height / (pow(2, heightPower));
    
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
    
    for (QRDTranscodingStreamingInfo *info in self.transcodingStreamingInfoArray) {
        if ([info.userId isEqualToString:userId] && info.kind == QNTrackKindVideo) {
            if (!videoMergeInfos) {
                videoMergeInfos = [[NSMutableArray alloc] init];
            }
            [videoMergeInfos addObject:info];
        }
    }
    return videoMergeInfos;
}

- (QRDTranscodingStreamingInfo *)getAudioMergeInfoWithUserId:(NSString *)userId {
    for (QRDTranscodingStreamingInfo *info in self.transcodingStreamingInfoArray) {
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
