//
//  AudioSourceMixExample.m
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/18.
//

#import "AudioSourceMixExample.h"
#import "AudioSourceMixControlView.h"
#import "AudioSourceTableViewCell.h"
#import "AudioSourceModel.h"

static NSString *sourceCellIdentifer = @"audioSourceCell";

#define Audio_Source_Tag 987000

@interface AudioSourceMixExample ()
<QNRTCClientDelegate,
QNAudioSourceMixerDelegate,
UITableViewDelegate,
UITableViewDataSource,
AudioSourceModelDelegate>

@property (nonatomic, strong) QNRTCClient *client;
@property (nonatomic, strong) QNMicrophoneAudioTrack *microphoneAudioTrack;
@property (nonatomic, strong) QNRemoteAudioTrack *remoteAudioTrack;
@property (nonatomic, strong) QNAudioSourceMixer *audioSourceMixer;
@property (nonatomic, assign) float audioMusicDuration;
@property (nonatomic, strong) AudioSourceMixControlView *controlView;
@property (nonatomic, copy) NSString *remoteUserID;
@property (nonatomic, strong) NSMutableArray *sourcesArray;
@property (nonatomic, strong) NSMutableArray *audioSourceArray;
@end

@implementation AudioSourceMixExample

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubviews];
    [self initRTC];
    [self loadAudioSources];
}

/*!
 * @warning 务必主动释放 SDK 资源
 */
- (void)clickBackItem {
    [super clickBackItem];

    if (self.microphoneAudioTrack) {
        if (self.audioSourceMixer) {
            [self.microphoneAudioTrack destroyAudioSourceMixer];
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
    self.tips = @"Tips：本示例仅展示一对一场景下的麦克风音频的发布和订阅，以及麦克风音频 Track 的音源混音功能。";
    
    // 音源混音控制面板
    self.controlView = [[[NSBundle mainBundle] loadNibNamed:@"AudioSourceMixControlView" owner:nil options:nil] lastObject];
    [self.controlView.playbackSwitch addTarget:self action:@selector(playbackSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView.microphoneMixVolumeSlider addTarget:self action:@selector(micInputVolumeSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView.audioPlayVolumeSlider addTarget:self action:@selector(audioPlayVolumeSliderAction:) forControlEvents:UIControlEventValueChanged];
    
    self.controlView.audioSourceTableView.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
    self.controlView.audioSourceTableView.scrollEnabled = NO;
    self.controlView.audioSourceTableView.delegate = self;
    self.controlView.audioSourceTableView.dataSource = self;
    [self.controlView.audioSourceTableView registerNib:[UINib nibWithNibName:@"AudioSourceTableViewCell" bundle:nil] forCellReuseIdentifier:sourceCellIdentifer];
    self.controlView.audioSourceTableView.rowHeight = 90.f;
    self.controlView.audioSourceTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.controlScrollView addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.controlScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(536);
    }];
    [self.controlView layoutIfNeeded];
    self.controlScrollView.contentSize = self.controlView.frame.size;
}

/*!
 * @abstract 加载音源资源
 */
- (void)loadAudioSources {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.sourcesArray = [NSMutableArray array];
        NSArray *sourceArray = @[@"mozart-16b-2c-44100hz.mp3",
                                 @"angle-16b-2c-48000hz.wav",
                                 @"whist-16b-2c-16000hz.m4a",
                                 @"ff-16b-2c-44100hz.aac"];
        for (NSInteger i = 0; i < sourceArray.count; i++) {
            NSString *sourceString = sourceArray[i];
            int sourceID = (int)i + Audio_Source_Tag;
            AudioSourceModel *sourceModel = [[AudioSourceModel alloc] initWithFileName:sourceString sourceID:sourceID];
            sourceModel.delegate = self;
            [self.sourcesArray addObject:sourceModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.controlView.audioSourceTableView reloadData];
        });
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
    self.audioSourceMixer = [self.microphoneAudioTrack createAudioSourceMixer:self];
    
    // 关闭自动订阅（示例仅针对 1v1 场景，所以此处将自动订阅关闭）
    self.client.autoSubscribe = NO;
    
    // 加入房间
    [self.client join:self.roomToken];
}

/*!
 * @abstract 发布 Track
 */
- (void)publish {
    __weak AudioSourceMixExample *weakSelf = self;
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

#pragma mark - QNAudioSourceMixerDelegate
/**
 * QNAudioSourceMixer 在运行过程中，发生错误的回调
 */
- (void)audioSourceMixer:(QNAudioSourceMixer *)audioSourceMixer didFailWithError:(NSError *)error {
    [self showAlertWithTitle:@"音源混音错误" message:error.localizedDescription];
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
    return _sourcesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioSourceTableViewCell *cell = (AudioSourceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:sourceCellIdentifer forIndexPath:indexPath];
    AudioSourceModel *model = self.sourcesArray[indexPath.row];
    cell.nameLabel.text = model.fileName;
    cell.startButton.tag = 100 + indexPath.row;
    cell.publishButton.tag = 200 + indexPath.row;
    [cell.startButton addTarget:self action:@selector(startStopAudioSource:) forControlEvents:UIControlEventTouchUpInside];
    [cell.publishButton addTarget:self action:@selector(publishEnableAudioSource:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)startStopAudioSource:(UIButton *)button {
    button.selected = !button.isSelected;
    NSInteger index = button.tag - 100;
    AudioSourceModel *model = self.sourcesArray[index];
    if (button.isSelected) {
        QNAudioSource *audioSource = [self.audioSourceMixer createAudioSourceWithSourceID:model.sourceID blockingMode:YES];
        [model loopRead];
    } else{
        [model cancelRead];
        [self.audioSourceMixer destroyAudioSourceWithSourceID:model.sourceID];
    }
}

- (void)publishEnableAudioSource:(UIButton *)button {
    button.selected = !button.isSelected;
    NSInteger index = button.tag - 200;
    AudioSourceModel *model = self.sourcesArray[index];
    [self.audioSourceMixer setPublishEnabled:!button.isSelected sourceID:model.sourceID];
}

#pragma mark - AudioSourceModelDelegate

- (void)audioSourceModel:(AudioSourceModel *)audioSourceModel audioBuffer:(AudioBuffer *)audioeBuffer asbd:(AudioStreamBasicDescription *)asbd {
    [self.audioSourceMixer pushAudioBuffer:audioeBuffer asbd:asbd sourceID:audioSourceModel.sourceID];
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
