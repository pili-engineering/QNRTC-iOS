//
//  CameraVideoExample.m
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/24.
//

#import "CameraVideoExample.h"
#import "CameraVideoControlView.h"

@interface CameraVideoExample () <QNRTCClientDelegate, QNLocalVideoTrackDelegate, QNRemoteVideoTrackDelegate>

@property (nonatomic, strong) QNRTCClient *client;
@property (nonatomic, strong) QNCameraVideoTrack *cameraVideoTrack;
@property (nonatomic, strong) QNMicrophoneAudioTrack *microphoneAudioTrack;
@property (nonatomic, strong) QNVideoGLView *localRenderView;
@property (nonatomic, strong) QNVideoGLView *remoteRenderView;
@property (nonatomic, strong) CameraVideoControlView *controlView;
@property (nonatomic, copy) NSString *remoteUserID;

@end

@implementation CameraVideoExample

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
    self.tips = @"Tips：本示例仅展示一对一场景下 SDK 内置摄像头采集视频 Track 和麦克风采集音频 Track 的发布和订阅，以及基于摄像头视频 Track 的美颜功能。";
    
    // 添加美颜参数控制视图
    self.controlView = [[[NSBundle mainBundle] loadNibNamed:@"CameraVideoControlView" owner:nil options:nil] lastObject];
    [self.controlView.beautySwitch addTarget:self action:@selector(beautySwitchAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView.beautyStrengthSlider addTarget:self action:@selector(beautyStrengthSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView.beautyReddenSlider addTarget:self action:@selector(beautyReddenSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView.beautyWhitenSlider addTarget:self action:@selector(beautyWhitenSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlScrollView addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.controlScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(200);
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
    self.client = [QNRTC createRTCClient];
    self.client.delegate = self;
    
    // 创建相机视频 Track 配置
    QNVideoEncoderConfig *videoConfig = [[QNVideoEncoderConfig alloc] initWithBitrate:600 videoEncodeSize:CGSizeMake(480, 640)];
    QNCameraVideoTrackConfig *cameraVideoTrackConfig = [[QNCameraVideoTrackConfig alloc] initWithSourceTag:@"camera"
                                                                                                   config:videoConfig
                                                                                         multiStreamEnable:NO];
    
    if (cameraVideoTrackConfig) {
        // 使用自定义配置创建相机视频 Track
        self.cameraVideoTrack = [QNRTC createCameraVideoTrackWithConfig:cameraVideoTrackConfig];
    } else {
        // 也可以使用默认配置
        self.cameraVideoTrack = [QNRTC createCameraVideoTrack];
    }
    
    // 设置采集分辨率（要保证预览分辨率 sessionPreset 不小于 QNCameraVideoTrackConfig 的编码分辨率 videoEncodeSize）
    self.cameraVideoTrack.videoFormat = AVCaptureSessionPreset640x480;
    
    // 配置美颜参数
    [self.cameraVideoTrack setBeautifyModeOn:YES];
    [self.cameraVideoTrack setSmoothLevel:0.5];
    [self.cameraVideoTrack setRedden:0.5];
    [self.cameraVideoTrack setWhiten:0.5];
    
    // 设置回调代理
    self.cameraVideoTrack.delegate = self;
    
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
    __weak CameraVideoExample *weakSelf = self;
    [self.client publish:@[self.cameraVideoTrack, self.microphoneAudioTrack] completeCallback:^(BOOL onPublished, NSError *error) {
        if (onPublished) {
            [weakSelf showAlertWithTitle:@"房间状态" message:@"发布成功"];
        } else {
            [weakSelf showAlertWithTitle:@"房间状态" message:[NSString stringWithFormat:@"发布失败: %@", error.localizedDescription]];
        }
    }];
}

#pragma mark - 美颜设置相关
/*!
 * @abstract 美颜开关
 */
- (void)beautySwitchAction:(UISwitch *)beautyModeOn {
    [self.cameraVideoTrack setBeautifyModeOn:beautyModeOn.isOn];
    if (beautyModeOn.isOn) {
        [self.cameraVideoTrack setSmoothLevel:self.controlView.beautyStrengthSlider.value];
        [self.cameraVideoTrack setRedden:self.controlView.beautyReddenSlider.value];
        [self.cameraVideoTrack setWhiten:self.controlView.beautyWhitenSlider.value];
    }
}

/*!
 * @abstract 美颜强度
 */
- (void)beautyStrengthSliderAction:(UISlider *)slider {
    [self.cameraVideoTrack setSmoothLevel:slider.value];
}

/*!
 * @abstract 红润
 */
- (void)beautyReddenSliderAction:(UISlider *)slider {
    [self.cameraVideoTrack setRedden:slider.value];
}

/*!
 * @abstract 白皙
 */
- (void)beautyWhitenSliderAction:(UISlider *)slider {
    [self.cameraVideoTrack setWhiten:slider.value];
}

#pragma mark - QNLocalVideoTrackDelegate
/*!
 * @abstract 本地相机视频 Track 数据回调。
 */
- (void)localVideoTrack:(QNLocalVideoTrack *)localVideoTrack didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    // 可以在此回调给本地预览画面添加三方美颜滤镜效果
}

#pragma mark - QNRemoteVideoTrackDelegate
/*!
 * @abstract 远端视频 Track 数据回调。
 */
- (void)remoteVideoTrack:(QNRemoteVideoTrack *)remoteVideoTrack didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    // 可以在此回调给远端渲染画面添加三方美颜滤镜效果
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
    videoTrack.delegate = self;
    [videoTrack play:self.remoteRenderView];
    self.remoteRenderView.hidden = NO;
}

/*!
 * @abstract 远端用户视频取消渲染到 renderView 上的回调。
 */
- (void)RTCClient:(QNRTCClient *)client didDetachRenderTrack:(QNRemoteVideoTrack *)videoTrack remoteUserID:(NSString *)userID {
    videoTrack.delegate = nil;
    [videoTrack play:nil];
    self.remoteRenderView.hidden = YES;
}

@end
