//
//  MediaPlayerExample.m
//  Api-Examples-iOS
//
//  Created by tony on 2024/8/14.
//

#import "MediaPlayerExample.h"
#import <QNRTCKit/QNRTC.h>
#import <QNRTCKit/QNMediaPlayer.h>
#import <Masonry/Masonry.h>

@interface MediaPlayerExample () <QNMediaPlayerDelegate, QNRTCClientDelegate>
@property (nonatomic, strong) QNRTCClient* rtcClient;
@property (nonatomic, strong) QNMediaPlayer *mediaPlayer;
@property (nonatomic, strong) QNVideoGLView *preview;
@property (nonatomic, strong) QNMediaSource *source;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UIButton *resumeBtn;
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) UIButton *joinBtn;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) NSMutableArray* publishTracks;
@property (nonatomic, strong) UITextView* logTextView;
@property (nonatomic, strong) NSString* logString;
@property (nonatomic, assign) BOOL isPublished;
@property (nonatomic, assign) BOOL isJoined;
@end

@implementation MediaPlayerExample

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.publishTracks removeAllObjects];
    [self.rtcClient leave];
    [QNRTC deinit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self loadSubview];
    
    // QNRTC 配置
    [QNRTC enableFileLogging];
    QNRTCConfiguration* configuration = [[QNRTCConfiguration alloc] initWithPolicy:QNRTCPolicyForceUDP audioScene:QNAudioSceneDefault reconnectionTimeout:10 encoderType:QNVideoEncoderToolboxH264];
    [QNRTC initRTC:configuration];
    
    // 创建内置媒体播放器
    self.mediaPlayer = [QNRTC createMediaPlayer];
    self.mediaPlayer.delegate = self;
    [self.mediaPlayer setView:self.preview];
    self.source = [[QNMediaSource alloc] init];
    self.source.url = @"http://demovideos.qiniushawn.top/bbk-bt709.mp4";
    
    // 创建 client
    self.rtcClient = [QNRTC createRTCClient];
    self.rtcClient.delegate = self;
    
    // 获取要发布的媒体播放器 track
    self.publishTracks = [[NSMutableArray alloc] init];
    QNCustomAudioTrack* audioTrack = [self.mediaPlayer getMediaPlayerAudioTrack];
    QNCustomVideoTrack* videoTrack = [self.mediaPlayer getMediaPlayerVideoTrack];
    [self.publishTracks addObject:audioTrack];
    [self.publishTracks addObject:videoTrack];
}

- (void)loadSubview {
    self.tips = @"Tips：\n"
    "1. 本示例展示内置播放器基本功能，以及将播放器音视频发布到房间内的功能。\n"
    "2. 使用内置播放器功能，需要通过 QNRTC 创建 QNMediaPlayer 对象。\n";
    
    self.preview = [[QNVideoGLView alloc] init];
    self.preview.fillMode = QNVideoFillModePreserveAspectRatio;
    [self.view addSubview:self.preview];
    [self.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(.4);
    }];
    
    self.progressSlider = [[UISlider alloc] init];
    [self.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.preview).offset(10);
        make.bottom.right.equalTo(self.preview).offset(-20);
    }];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setTitle:@"play" forState:UIControlStateNormal];
    [self.playBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.playBtn];
    [self.playBtn addTarget:self action:@selector(playBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pauseBtn setTitle:@"pause" forState:UIControlStateNormal];
    [self.pauseBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.pauseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.pauseBtn];
    [self.pauseBtn addTarget:self action:@selector(pauseBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    [self.stopBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.stopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.stopBtn];
    [self.stopBtn addTarget:self action:@selector(stopBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.resumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.resumeBtn setTitle:@"resume" forState:UIControlStateNormal];
    [self.resumeBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.resumeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.resumeBtn];
    [self.resumeBtn addTarget:self action:@selector(resumeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.publishBtn setTitle:@"publish" forState:UIControlStateNormal];
    [self.publishBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.publishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.publishBtn];
    [self.publishBtn addTarget:self action:@selector(publishBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.joinBtn setTitle:@"join" forState:UIControlStateNormal];
    [self.joinBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.joinBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.joinBtn];
    [self.joinBtn addTarget:self action:@selector(joinBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *controlArray = [[NSMutableArray alloc] init];
    [controlArray addObject:self.playBtn];
    [controlArray addObject:self.pauseBtn];
    [controlArray addObject:self.stopBtn];
    [controlArray addObject:self.resumeBtn];
    [controlArray addObject:self.joinBtn];
    [controlArray addObject:self.publishBtn];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / controlArray.count;
    [controlArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:width leadSpacing:0 tailSpacing:0];
    [controlArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.preview.mas_bottom).offset(30);
        make.height.mas_equalTo(60);
    }];
    
    self.logString = [[NSString alloc] init];
    self.logTextView = [[UITextView alloc] init];
    self.logTextView.backgroundColor = [UIColor clearColor];
    self.logTextView.editable = NO;
    [self.view addSubview:self.logTextView];
    [self.logTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publishBtn.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
}

- (void)playBtnDidClicked:(UIButton *)btn {
    [self.mediaPlayer play:self.source];
}

- (void)resumeBtnDidClicked:(UIButton *)btn {
    [self.mediaPlayer resume];
}

- (void)pauseBtnDidClicked:(UIButton *)btn {
    [self.mediaPlayer pause];
}

- (void)stopBtnDidClicked:(UIButton *)btn {
    [self.mediaPlayer stop];
}

- (void)progressSliderValueChanged:(UISlider *)slider {
    int position = slider.value;
    [self addLogString:[NSString stringWithFormat:@"seek to:%d", position]];
    int ret = [self.mediaPlayer seek:position];
    if (ret != 0) {
        [self addLogString:@"seek 失败"];
    }
}

- (void)joinBtnDidClicked:(UIButton *)btn {
    [self joinRTCRoom];
}

- (void)publishBtnDidClicked:(UIButton *)btn {
    if (self.isPublished) {
        [self.publishBtn setTitle:@"publish" forState:UIControlStateNormal];
        [self.rtcClient unpublish:self.publishTracks];
        [self addLogString:@"取消发布"];
        self.isPublished = NO;
    } else {
        [self.rtcClient publish:self.publishTracks completeCallback:^(BOOL onPublished, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isPublished = onPublished;
                if (onPublished) {
                    [self addLogString:@"发布成功"];
                    [self.publishBtn setTitle:@"unpublish" forState:UIControlStateNormal];
                } else {
                    [self addLogString:@"发布失败"];
                    [self addLogString:error.debugDescription];
                }
            });
        }];
    }
}

- (void)joinRTCRoom {
    if (self.isJoined) {
        if (self.isPublished) {
            [self.rtcClient unpublish:self.publishTracks];
            [self.publishBtn setTitle:@"publish" forState:UIControlStateNormal];
            [self addLogString:@"取消发布"];
            self.isPublished = NO;
        }
        [self.rtcClient leave];
    } else {
        [self addLogString:@"加入房间中..."];
        if (self.roomToken) {
            [self.rtcClient join:self.roomToken];
        } else {
            [self addLogString:@"无效的 token..."];
        }
    }
}

- (void)addLogString:(NSString *)str {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.logString = [self.logString stringByAppendingString:[NSString stringWithFormat:@"\n%@", str]];
        self.logTextView.text = self.logString;
    });
}


#pragma mark - QNMediaPlayerDelegate
- (void)mediaPlayer:(QNMediaPlayer *)player didPlayerStateChanged:(QNPlayerState)state {
    switch (state) {
        case QNPlayerStateIdle: {
            [self addLogString:@"停止播放"];
            if (self.isPublished) {
                [self.rtcClient unpublish:self.publishTracks];
                [self addLogString:@"取消发布"];
            }
        }
            break;
        case QNPlayerStatePlaying: {
            [self addLogString:@"播放成功"];
            NSLog(@"duration:%d", [player getDuration]);
            [self addLogString:[NSString stringWithFormat:@"duration(ms): %d", [player getDuration]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressSlider setMaximumValue:[player getDuration]];
            });
        }
            break;
        case QNPlayerStatePrepare: {
            [self addLogString:@"准备播放"];
        }
            break;
        case QNPlayerStatePause: {
            [self addLogString:@"暂停播放"];
        }
            break;
        default:
            break;
    }
}

- (void)mediaPlayer:(QNMediaPlayer *)player didPlayerPositionChanged:(NSUInteger)position {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressSlider setValue:position animated:YES];
    });
}


- (void)mediaPlayer:(QNMediaPlayer *)player didPlayerEvent:(QNPlayerEvent)event eventInfo:(nonnull QNPlayerEventInfo *)info {
    switch (event) {
        case QNPlayerEventFirstRender:
            [self addLogString:@"首帧视频渲染"];
            break;
        case QNPlayerEventOpenFileFailed:
            [self addLogString:@"打开文件失败"];
            break;
        case QNPlayerEventDecoderFailed:
            [self addLogString:@"初始化解码器失败"];
            break;
        default:
            break;
    }
}

#pragma mark - QNRTCClientDelegate
- (void)RTCClient:(QNRTCClient *)client didConnectionStateChanged:(QNConnectionState)state disconnectedInfo:(QNConnectionDisconnectedInfo *)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case QNConnectionStateConnected: {
                self.isJoined = YES;
                [self addLogString:@"加房成功"];
                [self.joinBtn setTitle:@"leave" forState:UIControlStateNormal];
            }
                break;
            case QNConnectionStateDisconnected: {
                self.isJoined = NO;
                [self addLogString:@"离开房间"];
                [self.joinBtn setTitle:@"join" forState:UIControlStateNormal];
                break;
            }
            default:
                break;
        }
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
