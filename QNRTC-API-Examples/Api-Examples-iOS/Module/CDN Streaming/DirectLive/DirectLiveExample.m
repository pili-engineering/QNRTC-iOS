//
//  DirectLiveExample.m
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/24.
//

#import "DirectLiveExample.h"
#import "DirectLiveControlView.h"
#import "ScanViewController.h"

@interface DirectLiveExample () <QNRTCClientDelegate, ScanViewControllerDelegate>

@property (nonatomic, strong) QNRTCClient *client;
@property (nonatomic, strong) QNCameraVideoTrack *cameraVideoTrack;
@property (nonatomic, strong) QNMicrophoneAudioTrack *microphoneAudioTrack;
@property (nonatomic, strong) QNVideoGLView *localRenderView;
@property (nonatomic, strong) QNVideoGLView *remoteRenderView;
@property (nonatomic, strong) QNDirectLiveStreamingConfig *directLiveStreamingConfig;
@property (nonatomic, strong) DirectLiveControlView *controlView;
@property (nonatomic, copy) NSString *remoteUserID;
@property (nonatomic, assign) BOOL isStreaming;

@end

@implementation DirectLiveExample

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isStreaming = NO;
    [self loadSubviews];
    [self initRTC];
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
    self.tips = @"Tips：本示例仅展示一对一场景下本地或远端音视频 Track 的单路转推功能，使用转推功能需要在七牛后台开启对应 AppId 的转推功能开关。";
    
    // 添加转推控制视图
    self.controlView = [[[NSBundle mainBundle] loadNibNamed:@"DirectLiveControlView" owner:nil options:nil] lastObject];
    self.controlView.publishUrlTF.text = @"";
    [self.controlView.startButton addTarget:self action:@selector(startLiveStreaming) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.stopButton addTarget:self action:@selector(stopLiveStreaming) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)scanAction:(UIButton *)button {
    ScanViewController *scanVc = [ScanViewController new];
    scanVc.delegate = self;
    scanVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanVc animated:YES completion:nil];
}

- (void)scanQRResult:(NSString *)qrString {
    if (qrString.length != 0) {
        self.controlView.publishUrlTF.text = qrString;
    }
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
    
    // 自定义采集配置
    QNVideoEncoderConfig *videoConfig = [[QNVideoEncoderConfig alloc] initWithBitrate:1000 videoEncodeSize:CGSizeMake(720, 1280)];
    QNCameraVideoTrackConfig *cameraVideoTrackConfig = [[QNCameraVideoTrackConfig alloc] initWithSourceTag:@"camera"
                                                                                                   config:videoConfig
                                                                                         multiStreamEnable:NO];
    
    // 使用自定义配置创建相机采集视频 Track
    self.cameraVideoTrack = [QNRTC createCameraVideoTrackWithConfig:cameraVideoTrackConfig];
    
    // 设置采集分辨率（要保证预览分辨率 sessionPreset 不小于 QNCameraVideoTrackConfig 的编码分辨率 videoEncodeSize）
    self.cameraVideoTrack.videoFormat = AVCaptureSessionPreset1280x720;
    
    // 创建麦克风采集音频 Track
    self.microphoneAudioTrack = [QNRTC createMicrophoneAudioTrack];
        
    // 开启本地预览
    [self.cameraVideoTrack play:self.localRenderView];
    self.localRenderView.hidden = NO;
    
    // 关闭自动订阅（示例仅针对 1v1 场景，所以此处将自动订阅关闭）
    self.client.autoSubscribe = NO;

    // 加入房间
    [self.client join:self.roomToken];
}

/*!
 * @abstract 发布
 */
- (void)publish {
    __weak DirectLiveExample *weakSelf = self;
    [self.client publish:@[self.cameraVideoTrack, self.microphoneAudioTrack] completeCallback:^(BOOL onPublished, NSError *error) {
        if (onPublished) {
            [weakSelf showAlertWithTitle:@"房间状态" message:@"发布成功"];
        } else {
            [weakSelf showAlertWithTitle:@"房间状态" message:[NSString stringWithFormat:@"发布失败: %@", error.localizedDescription]];
        }
    }];
}

#pragma mark - 开始 / 停止转推、QNRTCClientDelegate 中转推相关回调
/*!
 * @abstract 开始转推。
 */
- (void)startLiveStreaming {
    // 校验是否在转推中
    if (self.isStreaming) {
        [self showAlertWithTitle:@"状态提示" message:@"请先停止转推任务"];
        return;
    }
    
    // 校验房间状态
    if (!(self.client.connectionState == QNConnectionStateConnected || self.client.connectionState == QNConnectionStateReconnected)) {
        [self showAlertWithTitle:@"状态提示" message:@"请先加入房间"];
        return;
    }
    
    // 校验转推地址
    if ([self.controlView.publishUrlTF.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"参数错误" message:@"请输入转推地址"];
        return;
    }
    
    // 创建单人转推，转推本地音视频 Track
    self.directLiveStreamingConfig = [[QNDirectLiveStreamingConfig alloc] init];
    self.directLiveStreamingConfig.publishUrl = self.controlView.publishUrlTF.text;
    self.directLiveStreamingConfig.streamID = [NSString stringWithFormat:@"%@-%@", self.roomName, self.userID];
    self.directLiveStreamingConfig.videoTrack = self.cameraVideoTrack;
    self.directLiveStreamingConfig.audioTrack = self.microphoneAudioTrack;
    [self.client startLiveStreamingWithDirect:self.directLiveStreamingConfig];
}

/*!
 * @abstract 停止转推。
 */
- (void)stopLiveStreaming {
    // 校验是否在转推中
    if (!self.isStreaming) {
        [self showAlertWithTitle:@"状态提示" message:@"请先开始转推任务"];
        return;
    }
    
    // 检验房间状态
    if (!(self.client.connectionState == QNConnectionStateConnected || self.client.connectionState == QNConnectionStateReconnected)) {
        [self showAlertWithTitle:@"状态提示" message:@"请先加入房间"];
        return;
    }
    // 停止单人转推
    [self.client stopLiveStreamingWithDirect:self.directLiveStreamingConfig];
}

/*!
 * @abstract 成功创建转推任务的回调。
 */
- (void)RTCClient:(QNRTCClient *)client didStartLiveStreaming:(NSString *)streamID {
    self.isStreaming = YES;
    [self showAlertWithTitle:@"状态提示" message:@"开始转推成功"];
}

/*!
 * @abstract 停止转推任务的回调。
 */
- (void)RTCClient:(QNRTCClient *)client didStopLiveStreaming:(NSString *)streamID {
    self.isStreaming = NO;
    [self showAlertWithTitle:@"状态提示" message:@"停止转推成功"];
}

/*!
 * @abstract 转推出错的回调。
 */
- (void)RTCClient:(QNRTCClient *)client didErrorLiveStreaming:(NSString *)streamID errorInfo:(QNLiveStreamingErrorInfo *)errorInfo {
    NSString *errorType = @"";
    switch (errorInfo.type) {
        case QNLiveStreamingTypeStart: errorType = @"QNLiveStreamingTypeStart"; break;
        case QNLiveStreamingTypeStop: errorType = @"QNLiveStreamingTypeStop"; break;
        default: break;
    }
    NSString *errorDesc = [NSString stringWithFormat:@"Error Type: %@\nError Desc: %@", errorType, errorInfo.error.localizedDescription];
    [self showAlertWithTitle:@"转推出错" message:errorDesc cancelAction:nil];
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

@end
