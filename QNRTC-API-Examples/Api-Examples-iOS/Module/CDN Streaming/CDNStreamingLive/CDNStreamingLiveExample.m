//
//  CDNStreamingLiveExample.m
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/24.
//

#import "CDNStreamingLiveExample.h"
#import "DirectLiveControlView.h"
#import "ScanViewController.h"

@interface CDNStreamingLiveExample () <QNRTCClientDelegate, ScanViewControllerDelegate,QNCDNStreamingDelegate>

@property (nonatomic, strong) QNCameraVideoTrack *cameraVideoTrack;
@property (nonatomic, strong) QNMicrophoneAudioTrack *microphoneAudioTrack;
@property (nonatomic, strong) QNVideoGLView *localRenderView;
@property (nonatomic, strong) QNCDNStreamingClient *cdnStreamingClient;
@property (nonatomic, strong) QNCDNStreamingConfig *streamingConfig;
@property (nonatomic, strong) DirectLiveControlView *controlView;
@property (nonatomic, copy) NSString *remoteUserID;
@property (nonatomic, assign) BOOL isStreaming;

@end

@implementation CDNStreamingLiveExample

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isStreaming = NO;
    [self loadSubviews];
    [self initRTC];
    self.title = @"CDN 直推";
}

/*!
 * @warning 务必主动释放 SDK 资源
 */
- (void)clickBackItem {
    [super clickBackItem];
    // 离开房间  释放 client
    // 清理配置
    [QNRTC deinit];
}

/*!
 * @abstract 初始化视图
 */
- (void)loadSubviews {
    self.localView.text = @"本端视图";
    self.remoteView.text = @"远端视图";
    self.tips = @"Tips：本示例仅展示 RTMP 场景景下本地音视频 Track 的推流功能";
    
    // 添加推流控制视图
    self.controlView = [[[NSBundle mainBundle] loadNibNamed:@"DirectLiveControlView" owner:nil options:nil] lastObject];
    self.controlView.publishUrlTF.text = @"";
    [self.controlView.startButton addTarget:self action:@selector(startLiveStreaming) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.stopButton addTarget:self action:@selector(stopLiveStreaming) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat topMargin = [[UIApplication sharedApplication] statusBarFrame].size.height + 44.0;
    [self.localView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(SCREEN_WIDTH / 4.0);
        make.top.equalTo(self.view).mas_offset(topMargin);
        make.width.mas_equalTo(SCREEN_WIDTH / 2.0);
        make.height.mas_equalTo(SCREEN_WIDTH / 2.0 / 3 * 4);
    }];
    
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
    
    self.remoteView.hidden = YES;
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
    QNRTCConfiguration *configuration = [QNRTCConfiguration defaultConfiguration];
    [QNRTC initRTC:configuration];
    
    // 自定义采集配置
    QNVideoEncoderConfig *videoConfig = [[QNVideoEncoderConfig alloc] initWithBitrate:2000 videoEncodeSize:CGSizeMake(720, 1280)];
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

    // 创建 cdn streaming client
    self.cdnStreamingClient = [QNRTC createCDNStreamingClient];
    self.cdnStreamingClient.delegate = self;
}

#pragma mark - 开始 / 停止推流、QNRTCClientDelegate 中推流相关回调
/*!
 * @abstract 开始推流。
 */
- (void)startLiveStreaming {
    // 校验是否在推流中
    if (self.isStreaming) {
        [self showAlertWithTitle:@"状态提示" message:@"请先停止推流任务"];
        return;
    }
    
    // 校验推流地址
    if ([self.controlView.publishUrlTF.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"参数错误" message:@"请输入推流地址"];
        return;
    }
    
    self.streamingConfig = [[QNCDNStreamingConfig alloc] init];
    self.streamingConfig.publishUrl = self.controlView.publishUrlTF.text;

    self.streamingConfig.audioTrack = self.microphoneAudioTrack;
    self.streamingConfig.videoTrack = self.cameraVideoTrack;
    
    // 开始推流
    [self.cdnStreamingClient startWithConfig:self.streamingConfig];
    
}

/*!
 * @abstract 停止推流。
 */
- (void)stopLiveStreaming {
    // 校验是否在推流中
    if (!self.isStreaming) {
        [self showAlertWithTitle:@"状态提示" message:@"请先开始推流任务"];
        return;
    }

    // 停止单人推流
    [self.cdnStreamingClient stop];
}

#pragma mark - QNCDNStreamingDelegate
- (void)cdnStreamingClient:(QNCDNStreamingClient *)client didCDNStreamingConnectionStateChanged:(QNConnectionState)state
                 errorCode:(int)code
                   message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case QNConnectionStateConnected:
            case QNConnectionStateReconnected: {
                self.isStreaming = YES;
                [self showAlertWithTitle:@"状态提示" message:@"开始推流成功"];;
                break;
            }
            case QNConnectionStateConnecting: {
                [self showAlertWithTitle:@"状态提示" message:@"推流连连中"];
            }
                break;
            case QNConnectionStateReconnecting: {
                [self showAlertWithTitle:@"状态提示" message:@"重连中"];
            }
                break;
            case QNConnectionStateDisconnected: {
                self.isStreaming = NO;
                [self showAlertWithTitle:@"状态提示" message:@"停止推流成功"];
            }
                break;;
            default:
                break;
        }
    });
}

- (void)cdnStreamingClient:(QNCDNStreamingClient *)client didCDNStreamingStats:(QNCDNStreamingStats *)stats {
    NSLog(@"%@",[NSString stringWithFormat:@"视频帧率：%d  视频码率：%d  视频码率：%d  丢包数：%d",stats.sendVideoFps,stats.videoBitrate,stats.audioBitrate,stats.droppedVideoFrames]);
}


@end
