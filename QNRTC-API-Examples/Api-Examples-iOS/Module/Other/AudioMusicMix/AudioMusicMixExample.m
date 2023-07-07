//
//  AudioMusicMixExample.m
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/24.
//

#import "AudioMusicMixExample.h"
#import "AudioMusicMixControlView.h"

@interface AudioMusicMixExample () <QNRTCClientDelegate, QNAudioMusicMixerDelegate>

@property (nonatomic, strong) QNRTCClient *client;
@property (nonatomic, strong) QNMicrophoneAudioTrack *microphoneAudioTrack;
@property (nonatomic, strong) QNRemoteAudioTrack *remoteAudioTrack;
@property (nonatomic, strong) QNAudioMusicMixer *audioMusicMixer;
@property (nonatomic, assign) float audioMusicDuration;
@property (nonatomic, strong) AudioMusicMixControlView *controlView;
@property (nonatomic, copy) NSString *remoteUserID;

@end

@implementation AudioMusicMixExample

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubviews];
    [self initRTC];
}

/*!
 * @warning 务必主动释放 SDK 资源
 */
- (void)clickBackItem {
    [super clickBackItem];
    
    if (self.microphoneAudioTrack) {
        if (self.audioMusicMixer) {
            [self.audioMusicMixer stop];
            [self.microphoneAudioTrack destroyAudioMusicMixer];
        }
        [self.microphoneAudioTrack destroy];
    }
    // 离开房间  释放 client
    [self.client leave];
    self.client.delegate = nil;
    self.client = nil;
    
    // 清理配置
    [QNRTC deinit];
}

/*!
 * @abstract 初始化视图
 */
- (void)loadSubviews {
    self.localView.text = @"本地音频 Track";
    self.localView.hidden = YES;
    self.remoteView.text = @"远端音频 Track";
    self.remoteView.hidden = YES;
    self.tips = @"Tips：本示例仅展示一对一场景下的麦克风音频的发布和订阅，以及麦克风音频 Track 的音乐混音功能。";
    
    // 音乐混音控制面板
    self.controlView = [[[NSBundle mainBundle] loadNibNamed:@"AudioMusicMixControlView" owner:nil options:nil] lastObject];
    self.controlView.musicUrlTF.text = [[NSBundle mainBundle] pathForResource:@"Pursue" ofType:@"mp3"];
    [self.controlView.playStopButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.controlView.playStopButton setTitle:@"Stop" forState:UIControlStateSelected];
    [self.controlView.resumePauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [self.controlView.resumePauseButton setTitle:@"Resume" forState:UIControlStateSelected];
    [self.controlView.currentTimeSlider addTarget:self action:@selector(currentTimeSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView.micInputVolumeSlider addTarget:self action:@selector(micInputVolumeSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView.musicInputVolumeSlider addTarget:self action:@selector(musicInputVolumeSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView.musicPlayVolumeSlider addTarget:self action:@selector(musicPlayVolumeSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView.playStopButton addTarget:self action:@selector(playStopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.resumePauseButton addTarget:self action:@selector(resumePauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.playbackSwitch addTarget:self action:@selector(playbackSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.controlScrollView addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.controlScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(360);
    }];
    [self.controlView layoutIfNeeded];
    self.controlScrollView.contentSize = self.controlView.frame.size;
}

/*!
 * @abstract 初始化 RTC
 */
- (void)initRTC {
    
    // QNRTC 配置
    [QNRTC enableFileLogging];
    QNRTCConfiguration *configuration = [QNRTCConfiguration defaultConfiguration];
    [QNRTC initRTC:configuration];
    
    // 创建 client
    self.client = [QNRTC createRTCClient];
    self.client.delegate = self;
    
    // 使用默认配置创建麦克风音频 Track
    self.microphoneAudioTrack = [QNRTC createMicrophoneAudioTrack];
    
    // 设置麦克风输入音量
    [self.microphoneAudioTrack setVolume:1.0];
    // 设置音频播放音量
    [self.microphoneAudioTrack setPlayingVolume:1.0];
    // 设置返听
    [self.microphoneAudioTrack setEarMonitorEnabled:NO];
    
    // 设置音乐混音回调代理
    self.audioMusicMixer = [self.microphoneAudioTrack createAudioMusicMixer:self.controlView.musicUrlTF.text musicMixerDelegate:self];
    // 设置音乐混音输入音量
    [self.audioMusicMixer setMusicVolume:1.0];
    // 获取音乐总时长
    self.audioMusicDuration = (float)[QNAudioMusicMixer getDuration:self.controlView.musicUrlTF.text] / 1000.0;
    
    // 关闭自动订阅（示例仅针对 1v1 场景，所以此处将自动订阅关闭）
    self.client.autoSubscribe = NO;
    
    // 加入房间
    [self.client join:self.roomToken];
}

/*!
 * @abstract 发布 Track
 */
- (void)publish {
    __weak AudioMusicMixExample *weakSelf = self;
    [self.client publish:@[self.microphoneAudioTrack] completeCallback:^(BOOL onPublished, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (onPublished) {
                [weakSelf showAlertWithTitle:@"房间状态" message:@"发布成功"];
                weakSelf.localView.hidden = NO;
            } else {
                [weakSelf showAlertWithTitle:@"房间状态" message:[NSString stringWithFormat:@"发布失败: %@", error.localizedDescription]];
            }
        });
    }];
}

#pragma mark - 音乐混音面板控制事件
/**
 * 拖拽进度条，在拖拽结束调用 seekTo
 */
- (void)currentTimeSliderAction:(UISlider *)slider {
    [self.audioMusicMixer seekTo:slider.value * self.audioMusicDuration * 1000.0];
}

/**
 * 拖拽进度条，设置混音时麦克风的输入音量
 */
- (void)micInputVolumeSliderAction:(UISlider *)slider {
    [self.microphoneAudioTrack setVolume:slider.value];
}

/**
 * 拖拽进度条，设置音乐混音时音频文件的输入音量
 */
- (void)musicInputVolumeSliderAction:(UISlider *)slider {
    [self.audioMusicMixer setMusicVolume:slider.value];
}

/**
 * 拖拽进度条，设置混音时音频文件的实时播放音量
 */
- (void)musicPlayVolumeSliderAction:(UISlider *)slider {
    [self.microphoneAudioTrack setPlayingVolume:slider.value];
}

/**
 * 点击开始/停止混音
 */
- (void)playStopButtonAction:(UIButton *)button {
    if (!button.isSelected) {
        [self.audioMusicMixer start:(int)[self.controlView.loopTimeTF.text integerValue]];
    } else {
        [self.audioMusicMixer stop];
    }
}

/**
 * 点击继续/暂停混音
 */
- (void)resumePauseButtonAction:(UIButton *)button {
    if (!button.isSelected) {
        [self.audioMusicMixer pause];
    } else {
        [self.audioMusicMixer resume];
    }
}

- (void)playbackSwitchAction:(UISwitch *)switcher {
    [self.microphoneAudioTrack setEarMonitorEnabled:switcher.isOn];
}

#pragma mark - QNAudioMusicMixerDelegate
/**
 * QNAudioMusicMixer 在运行过程中，发生错误的回调
 */
- (void)audioMusicMixer:(QNAudioMusicMixer *)audioMusicMixer didFailWithError:(NSError *)error {
    [self showAlertWithTitle:@"音乐混音错误" message:error.localizedDescription];
}

/**
 * QNAudioMusicMixer 在运行过程中，音乐混音状态发生变化的回调
 */
- (void)audioMusicMixer:(QNAudioMusicMixer *)audioMusicMixer didStateChanged:(QNAudioMusicMixerState)musicMixerState {
    NSString *musicMixerStateDes = @"";
    switch (musicMixerState) {
        case QNAudioMusicMixerStateIdle: musicMixerStateDes = @"初始状态";  break;
        case QNAudioMusicMixerStateMixing: musicMixerStateDes = @"正在混音"; break;
        case QNAudioMusicMixerStatePaused: musicMixerStateDes = @"暂停混音"; break;
        case QNAudioMusicMixerStateStopped: musicMixerStateDes = @"停止混音"; break;
        case QNAudioMusicMixerStateCompleted: musicMixerStateDes = @"混音完成"; break;
        default: break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (musicMixerState == QNAudioMusicMixerStatePaused) {
            self.controlView.resumePauseButton.selected = YES;
        } else {
            self.controlView.resumePauseButton.selected = NO;
        }
        
        if (musicMixerState == QNAudioMusicMixerStateIdle
            || musicMixerState == QNAudioMusicMixerStateStopped
            || musicMixerState == QNAudioMusicMixerStateCompleted) {
            
            self.controlView.playStopButton.selected = NO;
            self.controlView.currentTimeLabel.text = @"00:00 / 00:00";
            self.controlView.currentTimeSlider.value = 0;
        } else {
            self.controlView.playStopButton.selected = YES;
        }
    });
    
    
    [self showAlertWithTitle:@"音乐混音状态" message:musicMixerStateDes];
}

/**
 * QNAudioMusicMixer 在运行过程中，音乐混音进度的回调
 */
- (void)audioMusicMixer:(QNAudioMusicMixer *)audioMusicMixer didMixing:(int64_t)currentPosition {
    dispatch_async(dispatch_get_main_queue(), ^{
        float currentTime = (float)currentPosition / 1000.0;
        // 更新进度 label
        NSInteger durationSeconds = (NSInteger)self.audioMusicDuration % 60;
        NSInteger durationMinites = (NSInteger)self.audioMusicDuration / 60;
        NSInteger currentSeconds = (NSInteger)currentTime % 60;
        NSInteger currentMinites = (NSInteger)currentTime / 60;
        NSString *currentTimeDesc = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", currentMinites, currentSeconds, durationMinites, durationSeconds];
        self.controlView.currentTimeLabel.text = currentTimeDesc;
        
        // 更新进度 slider
        self.controlView.currentTimeSlider.value = currentTime / self.audioMusicDuration;
    });
}

#pragma mark - QNRTCClientDelegate
/*!
 * @abstract 房间状态变更的回调。
 */
- (void)RTCClient:(QNRTCClient *)client didConnectionStateChanged:(QNConnectionState)state disconnectedInfo:(QNConnectionDisconnectedInfo *)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (state == QNConnectionStateConnected) {
            // 已加入房间
            [self showAlertWithTitle:@"房间状态" message:@"已加入房间"];
            [self publish];
        } else if (state == QNConnectionStateDisconnected) {
            // 空闲状态  此时应查看回调 info 的具体信息做进一步处理
            switch (info.reason) {
                case QNConnectionDisconnectedReasonKickedOut: {
                    [self showAlertWithTitle:@"房间状态" message:@"已离开房间：被踢出房间" cancelAction:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
                    break;
                case QNConnectionDisconnectedReasonLeave: {
                    [self showAlertWithTitle:@"房间状态" message:@"已离开房间：主动离开房间" cancelAction:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
                    break;
                case QNConnectionDisconnectedReasonRoomClosed: {
                    [self showAlertWithTitle:@"房间状态" message:@"已离开房间：房间已关闭" cancelAction:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
                    break;
                case QNConnectionDisconnectedReasonRoomFull: {
                    [self showAlertWithTitle:@"房间状态" message:@"已离开房间：房间人数已满" cancelAction:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
                    break;
                case QNConnectionDisconnectedReasonError: {
                    NSString *errorMessage = info.error.localizedDescription;
                    if (info.error.code == QNRTCErrorReconnectFailed) {
                        errorMessage = @"重新进入房间超时";
                    }
                    [self showAlertWithTitle:@"房间状态" message:[NSString stringWithFormat:@"已离开房间：%@", errorMessage] cancelAction:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
                    break;
                default:
                    break;
            }
        } else if (state == QNConnectionStateReconnecting) {
            // 重连中
            [self showAlertWithTitle:@"房间状态" message:@"重连中"];
        } else if (state == QNConnectionStateReconnected) {
            // 重连成功
            [self showAlertWithTitle:@"房间状态" message:@"重连成功"];
        }
    });
}

/*!
 * @abstract 远端用户加入房间的回调。
 */
- (void)RTCClient:(QNRTCClient *)client didJoinOfUserID:(NSString *)userID userData:(NSString *)userData {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 示例仅支持一对一的通话，因此这里记录首次加入房间的远端 userID
        if (self.remoteUserID) {
            [self showAlertWithTitle:@"房间状态" message:[NSString stringWithFormat:@"%@ 加入房间，将不做订阅", userID]];
        } else {
            self.remoteUserID = userID;
            [self showAlertWithTitle:@"房间状态" message:[NSString stringWithFormat:@"%@ 加入房间", userID]];
        }
    });
}

/*!
 * @abstract 远端用户离开房间的回调。
 */
- (void)RTCClient:(QNRTCClient *)client didLeaveOfUserID:(NSString *)userID {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 重置 remoteUserID
        if ([self.remoteUserID isEqualToString:userID]) {
            self.remoteUserID = nil;
            [self showAlertWithTitle:@"房间状态" message:[NSString stringWithFormat:@"%@ 离开房间", userID]];
        }
    });
}

/*!
 * @abstract 远端用户发布音/视频的回调。
 */
- (void)RTCClient:(QNRTCClient *)client didUserPublishTracks:(NSArray<QNRemoteTrack *> *)tracks ofUserID:(NSString *)userID {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.remoteUserID && [self.remoteUserID isEqualToString:userID]) {
            for (QNRemoteTrack *remoteTrack in tracks) {
                if (remoteTrack.kind == QNTrackKindAudio) {
                    [client subscribe:@[remoteTrack]];
                    break;
                }
            }
        }
    });
}

/*!
 * @abstract 远端用户取消发布音/视频的回调。
 */
- (void)RTCClient:(QNRTCClient *)client didUserUnpublishTracks:(NSArray<QNRemoteTrack *> *)tracks ofUserID:(NSString *)userID {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (QNRemoteTrack *track in tracks) {
            if ([track.trackID isEqualToString:self.remoteAudioTrack.trackID]) {
                [client unsubscribe:@[track]];
                self.remoteAudioTrack = nil;
                self.remoteView.hidden = YES;
                break;
            }
        }
    });
}

/*!
 * @abstract 订阅远端用户成功的回调。
 *
 * @since v4.0.0
 */
- (void)RTCClient:(QNRTCClient *)client didSubscribedRemoteVideoTracks:(NSArray<QNRemoteVideoTrack *> *)videoTracks audioTracks:(NSArray<QNRemoteAudioTrack *> *)audioTracks ofUserID:(NSString *)userID {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.remoteUserID isEqualToString:userID]) {
            BOOL hasAudioTrack = NO;
            for (QNRemoteAudioTrack *track in audioTracks) {
                self.remoteAudioTrack = (QNRemoteAudioTrack *)track;
                hasAudioTrack = YES;
                break;
            }
            if (hasAudioTrack) {
                self.remoteView.hidden = NO;
            }
        }
    });
}

@end
