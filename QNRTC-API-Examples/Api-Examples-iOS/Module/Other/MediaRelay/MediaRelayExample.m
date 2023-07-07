//
//  MediaRelayExample.m
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/25.
//

#import "MediaRelayExample.h"
#import "MediaRelayControlView.h"
#import "ScanViewController.h"
@interface MediaRelayExample ()<QNRTCClientDelegate, QNLocalVideoTrackDelegate, QNRemoteVideoTrackDelegate, ScanViewControllerDelegate>

@property (nonatomic, strong) QNRTCClient *client;
@property (nonatomic, strong) QNCameraVideoTrack *cameraVideoTrack;
@property (nonatomic, strong) QNMicrophoneAudioTrack *microphoneAudioTrack;
@property (nonatomic, strong) QNVideoGLView *localRenderView;
@property (nonatomic, strong) QNVideoGLView *remoteRenderView;
@property (nonatomic, strong) MediaRelayControlView  *controlView;
@property (nonatomic, copy) NSString *remoteUserID;
@property (nonatomic, strong) QNRoomMediaRelayInfo *srcMediaRelayInfo;

@end

@implementation MediaRelayExample

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubviews];
    [self initRTC];
    self.srcMediaRelayInfo = [[QNRoomMediaRelayInfo alloc] initWithToken:self.roomToken];
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
    "1. 本示例仅展示一对一场景下跨房媒体转发的开始、更新和停止功能。\n"
    "2. 使用跨房媒体转发功能，需要设置直播场景 QNClientModeLive 且角色为 QNClientRoleBroadcaster。\n"
    "3. 更新跨房媒体转发 updateRoomMediaRelay 为全量配置接口，使用时需要注意调用姿势。";
    
    // 添加消息发送控制视图
    self.controlView = [[[NSBundle mainBundle] loadNibNamed:@"MediaRelayControlView" owner:nil options:nil] lastObject];
    [self.controlView.scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.startMediaRelayButton addTarget:self action:@selector(startMediaRelayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.controlView.stopMediaRelayButton.hidden = YES;
    [self.controlView.stopMediaRelayButton addTarget:self action:@selector(stopMediaRelayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlScrollView addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.controlScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(240);
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
    __weak MediaRelayExample *weakSelf = self;
    [self.client publish:@[self.cameraVideoTrack, self.microphoneAudioTrack] completeCallback:^(BOOL onPublished, NSError *error) {
        if (onPublished) {
            [weakSelf showAlertWithTitle:@"房间状态" message:@"发布成功"];
        } else {
            [weakSelf showAlertWithTitle:@"房间状态" message:[NSString stringWithFormat:@"发布失败: %@", error.localizedDescription]];
        }
    }];
}

#pragma mark - button actions

- (void)startMediaRelayButtonAction:(UIButton  *)button {
    [self.view endEditing:YES];
    
    if (self.controlView.destRoomTokenTextField.text.length == 0) {
        [self showAlertWithTitle:@"错误" message:@"目标房间 Token 不能为空"];
        return;
    }

    NSString *destRoomTokenString = self.controlView.destRoomTokenTextField.text;
    if ([destRoomTokenString containsString:@":"]) {
        NSDictionary *dic = [self getDic:destRoomTokenString];
        if (dic) {
            if (!button.selected) {
                QNRoomMediaRelayInfo *destMediaRelayInfo = [[QNRoomMediaRelayInfo alloc] initWithToken:destRoomTokenString];
                QNRoomMediaRelayConfiguration *mediaRelayConfig = [[QNRoomMediaRelayConfiguration alloc] init];
                [mediaRelayConfig setSrcRoomInfo:_srcMediaRelayInfo];
                [mediaRelayConfig setDestRoomInfo:destMediaRelayInfo forRoomName:dic[@"roomName"]];
                [self.client startRoomMediaRelay:mediaRelayConfig completeCallback:^(NSDictionary *state, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            NSLog(@"开始跨房失败 %@", error);
                            [self showAlertWithTitle:@"错误" message:[NSString stringWithFormat:@"开始跨房失败 %ld", (long)error.code]];
                        } else{
                            button.selected = !button.isSelected;
                            [self showAlertWithTitle:@"提示" message:@"开始跨房成功"];
                            self.controlView.stopMediaRelayButton.hidden = NO;
                        }
                    });
                }];
            } else{
                QNRoomMediaRelayInfo *destMediaRelayInfo = [[QNRoomMediaRelayInfo alloc] initWithToken:destRoomTokenString];
                QNRoomMediaRelayConfiguration *mediaRelayConfig = [[QNRoomMediaRelayConfiguration alloc] init];
                [mediaRelayConfig setSrcRoomInfo:_srcMediaRelayInfo];
                [mediaRelayConfig setDestRoomInfo:destMediaRelayInfo forRoomName:dic[@"roomName"]];
                [self.client updateRoomMediaRelay:mediaRelayConfig completeCallback:^(NSDictionary *state, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            NSLog(@"更新跨房失败 %@", error);
                            [self showAlertWithTitle:@"错误" message:[NSString stringWithFormat:@"更新跨房失败", (long)error.code]];
                        } else{
                            [self showAlertWithTitle:@"提示" message:@"更新跨房成功"];
                            self.controlView.stopMediaRelayButton.hidden = NO;
                        }
                    });
                }];
            }
        } else{
            [self showAlertWithTitle:@"错误" message:@"目标房间 Token 不规范"];
        }
    } else {
        [self showAlertWithTitle:@"错误" message:@"目标房间 Token 不规范"];
    }
}

- (void)stopMediaRelayButtonAction:(UIButton *)button {
    [self.view endEditing:YES];
    [self.client stopRoomMediaRelay:^(NSDictionary *state, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"停止跨房失败 %@", error);
                [self showAlertWithTitle:@"错误" message:[NSString stringWithFormat:@"停止跨房失败", (long)error.code]];
            } else{
                [self showAlertWithTitle:@"提示" message:@"停止跨房成功"];
                self.controlView.startMediaRelayButton.selected = NO;
                self.controlView.stopMediaRelayButton.hidden = YES;
            }
        });
    }];
}

- (void)scanAction:(UIButton *)button {
    ScanViewController *scanVc = [ScanViewController new];
    scanVc.delegate = self;
    scanVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanVc animated:YES completion:nil];
}

- (void)scanQRResult:(NSString *)qrString {
    if (qrString.length != 0) {
        self.controlView.destRoomTokenTextField.text = qrString;
        [self getDic:qrString];
    }
}

- (NSDictionary *)getDic:(NSString *)destRoomTokenString {
    NSArray *componentArray = [destRoomTokenString componentsSeparatedByString:@":"];
    if (componentArray && componentArray.count >= 3) {
        NSString *decodeString = [NSString base64DecodingString:componentArray[2]];
        if (decodeString.length != 0) {
            self.controlView.tokenInfoLabel.text = decodeString;
            return [NSString dictionaryWithJSONString:decodeString];
        } else {
            self.controlView.tokenInfoLabel.text = @"输入的 Token 不合法";
            [self showAlertWithTitle:@"错误" message:@"输入的 Token 不合法，请重新输入"];
            return nil;
        }
    } else {
        return nil;
    }
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
