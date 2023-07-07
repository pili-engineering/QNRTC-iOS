//
//  CustomVideoExample.m
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/24.
//

#import "CustomVideoExample.h"
#import "CustomVideoSource.h"
#import "CustomAudioSource.h"

@interface CustomVideoExample () <QNRTCClientDelegate, CustomVideoSourceDelegate, CustomAudioSourceDelegate>

@property (nonatomic, strong) QNRTCClient *client;
@property (nonatomic, strong) QNCustomVideoTrack *customVideoTrack;
@property (nonatomic, strong) QNCustomAudioTrack *customAudioTrack;
@property (nonatomic, strong) QNVideoGLView *localRenderView;
@property (nonatomic, strong) QNVideoGLView *remoteRenderView;
@property (nonatomic, strong) CustomVideoSource *videoSource;
@property (nonatomic, strong) CustomAudioSource *audioSource;
@property (nonatomic, copy) NSString *remoteUserID;

@end

@implementation CustomVideoExample

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubviews];
    [self initVideoSource];
    [self initAudioSource];
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
    
    // 停止视频源采集
    [self.videoSource stopCaptureSession];
    // 停止音频源采集
    [self.audioSource stopCaptureSession];
}

/*!
 * @abstract 初始化视图
 */
- (void)loadSubviews {
    self.localView.text = @"本端视图";
    self.remoteView.text = @"远端视图";
    self.tips = @"Tips：本示例仅展示一对一场景下自定义视频 Track 和 SDK 内置麦克风音频 Track 的发布和订阅功能，视频数据源采集使用 AVCaptureSession 。";
    self.controlScrollView.hidden = YES;
    
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
 * @abstract 初始化自定义采集模块
 */
- (void)initVideoSource {
    self.videoSource = [[CustomVideoSource alloc] init];
    self.videoSource.delegate = self;
    [self.videoSource startCaptureSession];
}

/*!
 * @abstract 初始化自定义采集模块
 */
- (void)initAudioSource {
    self.audioSource = [[CustomAudioSource alloc] init];
    self.audioSource.delegate = self;
    [self.audioSource startCaptureSession];
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
    
    // 创建自定义视频 Track 配置
    QNVideoEncoderConfig *videoConfig = [[QNVideoEncoderConfig alloc] initWithBitrate:600 videoEncodeSize:CGSizeMake(480, 640)];
    QNCustomVideoTrackConfig *customVideoTrackConfig = [[QNCustomVideoTrackConfig alloc] initWithSourceTag:@"custom"
                                                                                                   config:videoConfig
                                                                                         multiStreamEnable:NO];
    
    if (customVideoTrackConfig) {
        // 使用自定义配置创建视频 Track
        self.customVideoTrack = [QNRTC createCustomVideoTrackWithConfig:customVideoTrackConfig];
    } else {
        // 也可以使用默认配置
        self.customVideoTrack = [QNRTC createCustomVideoTrack];
    }
    
    // 创建自定义采集音频配置
    QNAudioQuality *audioQuality = [[QNAudioQuality alloc] initWithBitrate:64];
    QNCustomAudioTrackConfig *customAudioTrackConfig = [[QNCustomAudioTrackConfig alloc] initWithTag:@"custom" audioQuality:audioQuality];
      
    if (customAudioTrackConfig) {
        // 使用自定义配置创建自定义音频 Track
        self.customAudioTrack = [QNRTC createCustomAudioTrackWithConfig:customAudioTrackConfig];
    } else {
        // 也可以使用默认配置
        self.customAudioTrack = [QNRTC createCustomAudioTrack];
    }
    
    // 关闭自动订阅（示例仅针对 1v1 场景，所以此处将自动订阅关闭）
    self.client.autoSubscribe = NO;

    // 加入房间
    [self.client join:self.roomToken];
}

/*!
 * @abstract 发布
 */
- (void)publish {
    __weak CustomVideoExample *weakSelf = self;
    [self.client publish:@[self.customVideoTrack, self.customAudioTrack] completeCallback:^(BOOL onPublished, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (onPublished) {
                [weakSelf showAlertWithTitle:@"房间状态" message:@"发布成功"];
                // 开启本地预览
                [weakSelf.customVideoTrack play:self.localRenderView];
                weakSelf.localRenderView.hidden = NO;
            } else {
                [weakSelf showAlertWithTitle:@"房间状态" message:[NSString stringWithFormat:@"发布失败: %@", error.localizedDescription]];
            }
        });
    }];
}

#pragma mark - CustomVideoSourceDelegate
/*!
 * @abstract 监听自定义视频源数据回调，拿到 sampleBuffer 后调用 pushVideoSampleBuffer 接口。
 */
- (void)customVideoSource:(CustomVideoSource *)videoSource didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (self.client.connectionState == QNConnectionStateConnected || self.client.connectionState == QNConnectionStateReconnected) {
        [self.customVideoTrack pushVideoSampleBuffer:sampleBuffer];
    }
}

#pragma mark - CustomAudioSourceDelegate
/*!
 * @abstract 监听自定义音频源数据回调，拿到 audioBufferList 后调用 pushAudioBuffer 接口。
 */
- (void)customAudioSource:(CustomAudioSource *)audioSource didOutputAudioBufferList:(AudioBufferList *)audioBufferList {
    if (self.client.connectionState == QNConnectionStateConnected || self.client.connectionState == QNConnectionStateReconnected) {
        @autoreleasepool {
            AudioBuffer *buffer = &audioBufferList->mBuffers[0];
            AudioStreamBasicDescription asdb = [self.audioSource getASDB];
            [self.customAudioTrack pushAudioBuffer:buffer asbd:&asdb];
        }
    }
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
