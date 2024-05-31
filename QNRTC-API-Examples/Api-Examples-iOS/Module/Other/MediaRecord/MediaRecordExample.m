//
//  MediaRecordExample.m
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2024/5/22.
//

#import "MediaRecordExample.h"
#import "MediaRecordControlView.h"
#import "ScanViewController.h"
@interface MediaRecordExample ()<QNRTCClientDelegate, QNLocalVideoTrackDelegate, QNRemoteVideoTrackDelegate, QNMediaRecorderDelegate, ScanViewControllerDelegate, UIDocumentPickerDelegate>

@property (nonatomic, strong) QNRTCClient *client;
@property (nonatomic, strong) QNCameraVideoTrack *cameraVideoTrack;
@property (nonatomic, strong) QNMicrophoneAudioTrack *microphoneAudioTrack;
@property (nonatomic, strong) QNVideoGLView *localRenderView;
@property (nonatomic, strong) QNVideoGLView *remoteRenderView;
@property (nonatomic, strong) MediaRecordControlView *controlView;
@property (nonatomic, copy) NSString *remoteUserID;
@property (nonatomic, strong) QNMediaRecorder *mediaRecorder;

@end

@implementation MediaRecordExample

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubviews];
    [self initRTC];
    self.mediaRecorder = [QNRTC createMediaRecorder];
    self.mediaRecorder.delegate = self;
}

/*!
 * @warning 务必主动释放 SDK 资源
 */
- (void)clickBackItem {
    [super clickBackItem];
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
    self.localView.text = @"本端视图";
    self.remoteView.text = @"远端视图";
    self.tips = @"Tips：\n"
    "1. 本示例仅展示一对一场景下，本地麦克风摄像头连麦时，音视频本地录制的功能。\n"
    "2. 使用音视频本地录制功能，需要通过 QNRTC 创建 QNMediaRecorder 对象。\n"
    "3. 开始录制前，应保证音频流或视频流已经发布，注意调用姿势。";
    
    // 添加消息发送控制视图
    self.controlView = [[[NSBundle mainBundle] loadNibNamed:@"MediaRecordControlView" owner:nil options:nil] lastObject];
    [self.controlView.startButton addTarget:self action:@selector(startButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.controlView.typeSegment.selectedSegmentIndex = 0;
    [self.controlScrollView addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.controlScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(140);
    }];
    [self.controlView layoutIfNeeded];
    self.controlScrollView.contentSize = self.controlView.frame.size;
    
    // 初始化本地预览视图
    self.localRenderView = [[QNVideoGLView alloc] init];
    [self.localView addSubview:self.localRenderView];
    self.localRenderView.hidden = YES;
    [self.localRenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.localView);
    }];
    
    // 初始化远端渲染视图
    self.remoteRenderView = [[QNVideoGLView alloc] init];
    self.remoteRenderView.fillMode = QNVideoFillModePreserveAspectRatioAndFill;
    [self.remoteView addSubview:self.remoteRenderView];
    self.remoteRenderView.hidden = YES;
    [self.remoteRenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.remoteView);
    }];
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
    QNClientConfig *config = [[QNClientConfig alloc] initWithMode:QNClientModeLive role:QNClientRoleBroadcaster];
    self.client = [QNRTC createRTCClient:config];
    self.client.delegate = self;
    
    // 使用默认配置初始化相机 Track
    self.cameraVideoTrack = [QNRTC createCameraVideoTrack];
    
    // 开启本地预览
    [self.cameraVideoTrack play:self.localRenderView];
    self.localRenderView.hidden = NO;
    
    // 创建麦克风音频 Track
    self.microphoneAudioTrack = [QNRTC createMicrophoneAudioTrack];
    
    // 关闭自动订阅（示例仅针对 1v1 场景，所以此处将自动订阅关闭）
    self.client.autoSubscribe = NO;

    // 加入房间
    [self.client join:self.roomToken];
}

/*!
 * @abstract 发布
 */
- (void)publish {
    __weak MediaRecordExample *weakSelf = self;
    [self.client publish:@[self.cameraVideoTrack, self.microphoneAudioTrack] completeCallback:^(BOOL onPublished, NSError *error) {
        if (onPublished) {
            [weakSelf showAlertWithTitle:@"房间状态" message:@"发布成功"];
        } else {
            [weakSelf showAlertWithTitle:@"房间状态" message:[NSString stringWithFormat:@"发布失败: %@", error.localizedDescription]];
        }
    }];
}

#pragma mark - button actions
- (void)startButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        NSString *filePath;
        QNMediaRecorderConfig *mediaConfig;
        if (self.roomToken.length != 0) {
            NSArray *componentArray = [self.roomToken componentsSeparatedByString:@":"];
            NSString *decodeString = [NSString base64DecodingString:componentArray[2]];
            NSDictionary *dic = [NSString dictionaryWithJSONString:decodeString];
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            filePath = [NSString stringWithFormat:@"%@/%@_%@_%@_%@", path, [QNRTC versionInfo], dic[ @"roomName"], dic[@"userId"], [self getCurrentTimes]];
            switch (self.controlView.typeSegment.selectedSegmentIndex) {
                case 0:
                    mediaConfig = [[QNMediaRecorderConfig alloc] initWithFilePath:[filePath stringByAppendingString:@".wav"] localAudioTrack:self.microphoneAudioTrack localVideoTrack:NULL];
                    break;
                case 1:
                    mediaConfig = [[QNMediaRecorderConfig alloc] initWithFilePath:[filePath stringByAppendingString:@".aac"] localAudioTrack:self.microphoneAudioTrack localVideoTrack:NULL];
                    break;
                case 2:
                    mediaConfig = [[QNMediaRecorderConfig alloc] initWithFilePath:[filePath stringByAppendingString:@".h264"] localAudioTrack:NULL localVideoTrack:self.cameraVideoTrack];
                    break;
                case 3:
                    mediaConfig = [[QNMediaRecorderConfig alloc] initWithFilePath:[filePath stringByAppendingString:@".mp4"] localAudioTrack:self.microphoneAudioTrack localVideoTrack:self.cameraVideoTrack];
                    break;
                default:
                    break;
            }
        } else {
            mediaConfig = [[QNMediaRecorderConfig alloc] initWithFilePath:nil localAudioTrack:self.microphoneAudioTrack localVideoTrack:self.cameraVideoTrack];
        }
        
        int result = [self.mediaRecorder startRecording:mediaConfig];
        if (result != 0) {
            [self showAlertWithTitle:@"错误" message:[NSString stringWithFormat:@"开始录制发生错误 %ld", result]];
        }
    } else {
        int result = [self.mediaRecorder stopRecording];
        if (result != 0) {
            [self showAlertWithTitle:@"错误" message:[NSString stringWithFormat:@"结束录制发生错误 %ld", result]];
        }
    }
}

#pragma mark - QNMediaRecorderDelegate

- (void)mediaRecorder:(QNMediaRecorder *)recorder infoDidUpdated:(QNMediaRecordInfo *)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (info.filePath.length != 0) {
            NSURL *documentURL = [NSURL fileURLWithPath:info.filePath];
            UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithURL:documentURL inMode:UIDocumentPickerModeExportToService];
            documentPicker.delegate = self;
            [self presentViewController:documentPicker animated:YES completion:nil];
        }
    });
}

- (void)mediaRecorder:(QNMediaRecorder *)recorder stateDidChanged:(QNMediaRecorderState)state reason:(QNMediaRecorderReasonCode)reason {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case QNMediaRecorderStateStopped:
                self.controlView.stateLabel.text = @"停止";
                break;
            case QNMediaRecorderStateRecording:
                self.controlView.stateLabel.text = @"录制中";
                break;
            case QNMediaRecorderStateError:
                self.controlView.stateLabel.text = @"错误";
                break;
            default:
                break;
        }
        if (state == QNMediaRecorderStateError) {
            [self showAlertWithTitle:@"错误" message:[NSString stringWithFormat:@"录制发生错误 %ld", reason]];
        }
    });
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSLog(@"Record audio file was saved");
    [self showAlertWithTitle:@"提示" message:@"已保存至文件"];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    NSLog(@"Record audio file picker was cancelled");
    [self showAlertWithTitle:@"提示" message:@"已取消保存"];
}

- (NSString*)getCurrentTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

/*!
 * @abstract QNRTCClientDelegate 中接收消息的回调
 */
- (void)RTCClient:(QNRTCClient *)client didReceiveMessage:(QNMessageInfo *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *receiveMessage = [NSString stringWithFormat:@"timestamp: %@\nidentifier: %@\nuserId: %@\ncontent: %@", message.timestamp, message.identifier, message.userID, message.content];
        [self showAlertWithTitle:@"收到消息" message:receiveMessage cancelAction:nil];
    });
}

#pragma mark - QNRTCClientDelegate 中其他回调
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
            [client subscribe:tracks];
        }
    });
}

/*!
 * @abstract 远端用户取消发布音/视频的回调。
 */
- (void)RTCClient:(QNRTCClient *)client didUserUnpublishTracks:(NSArray<QNRemoteTrack *> *)tracks ofUserID:(NSString *)userID {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.remoteUserID && [self.remoteUserID isEqualToString:userID]) {
            [client unsubscribe:tracks];
        }
    });
}

/*!
 * @abstract 远端用户视频首帧解码后的回调。
 */
- (void)RTCClient:(QNRTCClient *)client firstVideoDidDecodeOfTrack:(QNRemoteVideoTrack *)videoTrack remoteUserID:(NSString *)userID {
    [videoTrack play:self.remoteRenderView];
    self.remoteRenderView.hidden = NO;
}

/*!
 * @abstract 远端用户视频取消渲染到 renderView 上的回调。
 */
- (void)RTCClient:(QNRTCClient *)client didDetachRenderTrack:(QNRemoteVideoTrack *)videoTrack remoteUserID:(NSString *)userID {
    [videoTrack play:nil];
    self.remoteRenderView.hidden = YES;
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
