//
//  AudioEffectMixExample.m
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/6/13.
//

#import "AudioEffectMixExample.h"
#import "AudioEffectMixControlView.h"
#import "AudioEffectTableViewCell.h"

static NSString *effectCellIdentifer = @"audioEffectCell";

#define Audio_Effect_Tag 654000

@interface AudioEffectMixExample ()
<QNRTCClientDelegate,
QNAudioEffectMixerDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) QNRTCClient *client;
@property (nonatomic, strong) QNMicrophoneAudioTrack *microphoneAudioTrack;
@property (nonatomic, strong) QNRemoteAudioTrack *remoteAudioTrack;
@property (nonatomic, strong) QNAudioEffectMixer *audioEffectMixer;
@property (nonatomic, assign) float audioMusicDuration;
@property (nonatomic, strong) AudioEffectMixControlView *controlView;
@property (nonatomic, copy) NSString *remoteUserID;
@property (nonatomic, strong) NSArray *effectSourceArray;
@property (nonatomic, strong) NSMutableArray *audioEffectArray;
@property (nonatomic, strong) NSMutableArray *selectedEffectArray;
@property (nonatomic, strong) NSMutableDictionary *effectStateDic;
@end

@implementation AudioEffectMixExample

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubviews];
    [self initRTC];
    [self loadAudioEffectSources];
}

/*!
 * @warning 务必主动释放 SDK 资源
 */
- (void)clickBackItem {
    [super clickBackItem];
    
    if (self.microphoneAudioTrack) {
        if (self.audioEffectMixer) {
            [self.audioEffectMixer stopAll];
            [self.microphoneAudioTrack destroyAudioEffectMixer];
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
    self.tips = @"Tips：本示例仅展示一对一场景下的麦克风音频的发布和订阅，以及麦克风音频 Track 的音效混音功能。";
    
    // 音效混音控制面板
    self.controlView = [[[NSBundle mainBundle] loadNibNamed:@"AudioEffectMixControlView" owner:nil options:nil] lastObject];
    [self.controlView.stopAllButton setTitle:@"Stop All" forState:UIControlStateNormal];
    [self.controlView.pauseAllButton setTitle:@"Pause All" forState:UIControlStateNormal];
    [self.controlView.pauseAllButton setTitle:@"Resume All" forState:UIControlStateSelected];
    
    [self.controlView.stopAllButton addTarget:self action:@selector(stopAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.pauseAllButton addTarget:self action:@selector(resumePauseAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.playbackSwitch addTarget:self action:@selector(playbackSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView.microphoneMixVolumeSlider addTarget:self action:@selector(micInputVolumeSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView.audioPlayVolumeSlider addTarget:self action:@selector(audioPlayVolumeSliderAction:) forControlEvents:UIControlEventValueChanged];
    
    self.controlView.audioEffectTableView.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
    self.controlView.audioEffectTableView.scrollEnabled = NO;
    self.controlView.audioEffectTableView.delegate = self;
    self.controlView.audioEffectTableView.dataSource = self;
    [self.controlView.audioEffectTableView registerNib:[UINib nibWithNibName:@"AudioEffectTableViewCell" bundle:nil] forCellReuseIdentifier:effectCellIdentifer];
    self.controlView.audioEffectTableView.rowHeight = 60.f;
    self.controlView.audioEffectTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.controlScrollView addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.controlScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(496);
    }];
    [self.controlView layoutIfNeeded];
    self.controlScrollView.contentSize = self.controlView.frame.size;
}

/*!
 * @abstract 加载音效资源
 */
- (void)loadAudioEffectSources {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.audioEffectArray = [NSMutableArray array];
        self.selectedEffectArray = [NSMutableArray array];
        self.effectStateDic = [NSMutableDictionary dictionary];
        // 音频格式支持：aac、mp3、mp4、wav、m4r、caf、ogg、opus、m4a、flac
        self.effectSourceArray = @[@"mozart-16b-2c-44100hz.mp3",
                                   @"angle-16b-2c-48000hz.wav",
                                   @"whist-16b-2c-16000hz.m4a",
                                   @"ff-16b-2c-44100hz.aac",
                                   @"gs-16b-1c-8000hz.amr"];
        for (NSInteger i = 0; i < self.effectSourceArray.count; i++) {
            NSString *sourceString = self.effectSourceArray[i];
            int effectID = (int)i + Audio_Effect_Tag;
            NSArray *strArray = [sourceString componentsSeparatedByString:@"."];
            NSString *effectString = [[NSBundle mainBundle] pathForResource:strArray[0] ofType:strArray[1]];
            QNAudioEffect *audioEffect = [self.audioEffectMixer createAudioEffectWithEffectID:effectID filePath:effectString];
            [audioEffect setLoopCount:1];
            [self.audioEffectArray addObject:audioEffect];
            [self.effectStateDic setValue:@0 forKey:sourceString];
        }
    });
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
    
    // 设置混音回调代理
    self.audioEffectMixer = [self.microphoneAudioTrack createAudioEffectMixer:self];
    
    // 关闭自动订阅（示例仅针对 1v1 场景，所以此处将自动订阅关闭）
    self.client.autoSubscribe = NO;
    
    // 加入房间
    [self.client join:self.roomToken];
}

/*!
 * @abstract 发布 Track
 */
- (void)publish {
    __weak AudioEffectMixExample *weakSelf = self;
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

#pragma mark - 混音面板控制事件

/**
 * 点击停止所有音效混音
 */
- (void)stopAllButtonAction:(UIButton *)button {
    [self.audioEffectMixer stopAll];
    for (NSInteger i = 0; i < self.effectSourceArray.count; i++) {
        NSString *sourceString = self.effectSourceArray[i];
        [self.effectStateDic setValue:@0 forKey:sourceString];
        [self.controlView.audioEffectTableView reloadData];
    }
}

/**
 * 点击暂停/恢复所有音效混音
 */
- (void)resumePauseAllButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.isSelected) {
        [self.audioEffectMixer pauseAll];
        for (NSInteger i = 0; i < self.effectSourceArray.count; i++) {
            NSString *sourceString = self.effectSourceArray[i];
            NSInteger state = [[self.effectStateDic objectForKey:sourceString] integerValue];
            if (state != 0) {
                [self.effectStateDic setValue:@2 forKey:sourceString];
                [self.controlView.audioEffectTableView reloadData];
            }
        }
    } else{
        [self.audioEffectMixer resumeAll];
        for (NSInteger i = 0; i < self.effectSourceArray.count; i++) {
            NSString *sourceString = self.effectSourceArray[i];
            NSInteger state = [[self.effectStateDic objectForKey:sourceString] integerValue];
            if (state != 0) {
                [self.effectStateDic setValue:@1 forKey:sourceString];
                [self.controlView.audioEffectTableView reloadData];
            }
        }
    }
}

/**
 * 拖拽进度条，设置混音时麦克风的输入音量
 */
- (void)playbackSwitchAction:(UISwitch *)switcher {
    [self.microphoneAudioTrack setEarMonitorEnabled:switcher.isOn];
}

/**
 * 拖拽进度条，设置混音时麦克风的输入音量
 */
- (void)micInputVolumeSliderAction:(UISlider *)slider {
    [self.microphoneAudioTrack setVolume:slider.value];
}

/**
 * 拖拽进度条，设置混音时音频文件的实时播放音量
 */
- (void)audioPlayVolumeSliderAction:(UISlider *)slider {
    [self.microphoneAudioTrack setPlayingVolume:slider.value];
}

#pragma mark - QNAudioEffectMixerDelegate
/**
 * QNAudioEffectMixer 在运行过程中，发生错误的回调
 */
- (void)audioEffectMixer:(QNAudioEffectMixer *)audioEffectMixer didFailWithError:(NSError *)error {
    [self showAlertWithTitle:@"音效混音错误" message:error.localizedDescription];
}

/**
 * QNAudioEffectMixer 在运行过程中，混音完成的回调
 */
- (void)audioEffectMixer:(QNAudioEffectMixer *)audioEffectMixer didFinished:(int)effectID {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger index = effectID - Audio_Effect_Tag;
        NSString *sourceString = self.effectSourceArray[index];
        [self showAlertWithTitle:@"音效混音完成" message:sourceString];
        [self.effectStateDic setValue:@0 forKey:sourceString];
        [self.controlView.audioEffectTableView reloadData];
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

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _audioEffectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioEffectTableViewCell *cell = (AudioEffectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:effectCellIdentifer forIndexPath:indexPath];
    NSString *sourceString = self.effectSourceArray[indexPath.row];
    cell.nameLabel.text = sourceString;
    cell.startButton.tag = 100 + indexPath.row;
    cell.pauseButton.tag = 200 + indexPath.row;
    [cell.startButton addTarget:self action:@selector(startStopAudioEffect:) forControlEvents:UIControlEventTouchUpInside];
    [cell.pauseButton addTarget:self action:@selector(pauseResumeAudioEffect:) forControlEvents:UIControlEventTouchUpInside];
    NSInteger state = [[self.effectStateDic objectForKey:sourceString] integerValue];
    if (state == 0) {
        cell.startButton.selected = NO;
        cell.pauseButton.selected = NO;
    } else if (state == 1) {
        cell.startButton.selected = YES;
        cell.pauseButton.selected = NO;
    } else if (state == 2) {
        cell.startButton.selected = YES;
        cell.pauseButton.selected = YES;
    }
    return cell;
}

- (void)startStopAudioEffect:(UIButton *)button {
    button.selected = !button.selected;
    NSInteger index = button.tag - 100;
    NSString *sourceString = self.effectSourceArray[index];
    QNAudioEffect *audioEffect = self.audioEffectArray[index];
    int effectID = [audioEffect getID];
    if (button.isSelected) {
        [self.audioEffectMixer start:effectID];
        [self.effectStateDic setValue:@1 forKey:sourceString];
    } else{
        [self.audioEffectMixer stop:effectID];
        [self.effectStateDic setValue:@0 forKey:sourceString];
    }
}

- (void)pauseResumeAudioEffect:(UIButton *)button {
    button.selected = !button.selected;
    NSInteger index = button.tag - 200;
    NSString *sourceString = self.effectSourceArray[index];
    QNAudioEffect *audioEffect = self.audioEffectArray[index];
    int effectID = [audioEffect getID];
    if (button.isSelected) {
        [self.audioEffectMixer pause:effectID];
        [self.effectStateDic setValue:@2 forKey:sourceString];
    } else{
        [self.audioEffectMixer resume:effectID];
        [self.effectStateDic setValue:@1 forKey:sourceString];
    }
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
