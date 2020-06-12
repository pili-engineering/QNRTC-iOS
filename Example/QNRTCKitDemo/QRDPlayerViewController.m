//
//  QRDPlayerViewController.m
//  QNRTCKitDemo
//
//  Created by hxiongan on 2019/1/8.
//  Copyright © 2019年 PILI. All rights reserved.
//

#import "QRDPlayerViewController.h"
#import "QRDRTCViewController.h"
#import "QRDPublicHeader.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "UIView+Alert.h"
#import "QRDNetworkUtil.h"
#import <Masonry.h>

@interface QRDPlayerViewController ()
<
PLPlayerDelegate
>

@property (nonatomic, strong) UILabel *infoLabelView;
@property (nonatomic, strong) NSMutableArray *logStringArray;

@property (nonatomic, strong) PLPlayer *player;
@property (nonatomic, strong) NSString *url;

@end

@implementation QRDPlayerViewController

- (void)dealloc {
    NSLog(@"[dealloc]==> %@", self.description);
}

- (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] stringForKey:QN_USER_ID_KEY];
}

- (NSString *)roomName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:QN_ROOM_NAME_KEY];
}

- (NSString *)appId {
    NSString *appId = [[NSUserDefaults standardUserDefaults] stringForKey:QN_APP_ID_KEY];
    if (0 == appId.length) {
        appId = QN_RTC_DEMO_APPID;
        [[NSUserDefaults standardUserDefaults] setObject:appId forKey:QN_APP_ID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return appId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.logStringArray = [[NSMutableArray alloc] init];
    
    if ([self.appId isEqualToString:QN_RTC_DEMO_APPID]) {
        _url = [NSString stringWithFormat:@"rtmp://pili-rtmp.qnsdk.com/sdk-live/%@",self.roomName];
    } else {
        _url = [NSString stringWithFormat:@"rtmp://pili-rtmp.qnsdk.com/sdk-live/%@_%@",self.appId, self.roomName];
    }
    
    [self setupPlayer];
    
    UILabel *urlLabel = [[UILabel alloc] init];
    urlLabel.numberOfLines = 0;
    [urlLabel setText:_url];
    [urlLabel setFont:[UIFont systemFontOfSize:12]];
    [urlLabel setTextColor:[UIColor whiteColor]];
    urlLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:urlLabel];
    [urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.size.equalTo(CGSizeMake(QRD_SCREEN_WIDTH - 80, 44));
    }];
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"set_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.size.equalTo(CGSizeMake(44, 44));
    }];
    
    UIButton *logButton = [[UIButton alloc] init];
    [logButton setImage:[UIImage imageNamed:@"log-btn"] forState:(UIControlStateNormal)];
    [logButton addTarget:self action:@selector(clickLogButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:logButton];
    [logButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.size.equalTo(CGSizeMake(44, 44));
    }];

    self.infoLabelView = [[UILabel alloc] init];
    self.infoLabelView.textColor = [UIColor whiteColor];
    self.infoLabelView.textAlignment = NSTextAlignmentLeft;
    self.infoLabelView.numberOfLines = 0;
    self.infoLabelView.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.infoLabelView];
    self.infoLabelView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.3];

    [self.infoLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(logButton);
        make.top.equalTo(logButton.mas_bottom);
        make.size.equalTo(CGSizeMake(160, 66));
    }];
    self.infoLabelView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player stop];
}

- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupPlayer {
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
    
    [option setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:[NSURL URLWithString:_url] option:option];
    [self.view insertSubview:self.player.playerView atIndex:0];
    [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    self.player.delegate = self;
    
    [self.player play];
}

#pragma mark - PLPlayerDelegate

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Player Errro: %@", error);
    });
}

- (void)player:(PLPlayer *)player width:(int)width height:(int)height {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Width: %d \nHeight: %d", width, height);
    });
}

- (void)player:(PLPlayer *)player willRenderFrame:(CVPixelBufferRef)frame pts:(int64_t)pts sarNumerator:(int)sarNumerator sarDenominator:(int)sarDenominator {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = [NSString stringWithFormat:@"  VideoBitrate: %.f kb/s \n  VideoFPS: %d", player.bitrate, player.videoFPS];
        self.infoLabelView.text = str;
    });
}

- (void)clickLogButton {
    self.infoLabelView.hidden = !self.infoLabelView.isHidden;
}

@end
