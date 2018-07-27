//
//  QRDScreenRecorderViewController.m
//  QNRTCKitDemo
//
//  Created by lawder on 2018/6/15.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDScreenRecorderViewController.h"
#import <ReplayKit/ReplayKit.h>
#import <QNRTCKit/QNRTCKit.h>
#import "QRDMicrophoneSource.h"
#import "QRDPublicHeader.h"


@interface QRDScreenRecorderViewController ()
<QNRTCSessionDelegate,
UIScrollViewDelegate,
QRDMicrophoneSourceDelegate>

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) QNRTCSession *session;
@property (nonatomic, strong) RPScreenRecorder *recorder;
@property (nonatomic, strong) QRDMicrophoneSource *microhoneSource;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *renderViewArray;

@end

@implementation QRDScreenRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.renderViewArray = [NSMutableArray new];

    [self setupUI];
    [self setupScreenRecorder];
    [self setupRTCSession];
    [self setupMicrophoneSource];
    [self startRecord];
}

- (void)setupUI {
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    CGPoint center = self.view.center;
    center.y = QRD_SCREEN_HEIGHT / 4;
    self.circleView.center = center;
    self.circleView.backgroundColor = [UIColor blueColor];
    self.circleView.layer.masksToBounds = YES;
    self.circleView.layer.cornerRadius = self.circleView.frame.size.width / 2.0;
    [self.view addSubview:self.circleView];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, QRD_SCREEN_HEIGHT / 2, QRD_SCREEN_WIDTH, QRD_SCREEN_HEIGHT / 2)];
    self.scrollView.contentSize = CGSizeMake(QRD_SCREEN_WIDTH, QRD_SCREEN_HEIGHT / 2);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    UIButton *conferenceButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 32, QRD_SCREEN_HEIGHT - 96, 64, 64)];
    [conferenceButton setImage:[UIImage imageNamed:@"close-phone"] forState:UIControlStateNormal];
    [conferenceButton addTarget:self action:@selector(conferenceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:conferenceButton];
}

- (void)setupScreenRecorder {
    self.recorder = [RPScreenRecorder sharedRecorder];
    if (@available(iOS 10.0, *)) {
        self.recorder.cameraEnabled = YES;
    }
}

- (void)setupRTCSession {
    self.session = [[QNRTCSession alloc] initWithCaptureEnabled:NO];
    self.session.delegate = self;
    self.session.statisticInterval = 3.0;
    self.session.videoEncodeSize = CGSizeFromString(_configDic[@"VideoSize"]);

    [self requestTokenWithCompletionHandler:^(NSError *error, NSString *token) {
        if (error) {
            NSLog(@"requestTokenWithCompletionHandler error: %@", error);
            [self showAlertWithMessage:error.localizedDescription];
            return ;
        }

        [self.session joinRoomWithToken:token];
    }];
}

- (void)setupMicrophoneSource {
    self.microhoneSource = [[QRDMicrophoneSource alloc] init];
    self.microhoneSource.delegate = self;
}

- (void)startRecord {
    if (@available(iOS 11.0, *)) {
        [self.recorder startCaptureWithHandler:^(CMSampleBufferRef  _Nonnull sampleBuffer, RPSampleBufferType bufferType, NSError * _Nullable error) {
            if (bufferType == RPSampleBufferTypeVideo) {
                CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                [self.session pushPixelBuffer:pixelBuffer];
            }
        } completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"startCaptureWithHandler error: %@", error);
                [self showAlertWithMessage:error.localizedDescription];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //如果用户未授权访问摄像头，cameraPreviewView 将为空
                    if (self.recorder.cameraPreviewView) {
                        [self.renderViewArray addObject:self.recorder.cameraPreviewView];
                        [self layoutRenderViews];
                    }
                });
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)stopRecord {
    if (@available(iOS 11.0, *)) {
        [self.recorder stopCaptureWithHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"stopCaptureWithHandler error: %@", error);
                [self showAlertWithMessage:error.localizedDescription];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - Button

- (void)conferenceButtonClick:(id)sender {
    if (self.session.roomState != QNRoomStateIdle) {
        [self.session leaveRoom];
        self.session.delegate = nil;
        self.session = nil;
        [self.microhoneSource stopRunning];
    }

    [self stopRecord];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 拖动

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view != self.circleView) {
        return;
    }

    CGPoint currentPoint = [touch locationInView:self.view];
    CGPoint previousPoint = [touch previousLocationInView:self.view];

    CGPoint center = self.circleView.center;
    center.x += (currentPoint.x - previousPoint.x);
    if (center.x + self.circleView.frame.size.width / 2 > QRD_SCREEN_WIDTH) {
        center.x = QRD_SCREEN_WIDTH - self.circleView.frame.size.width / 2;
    }

    if (center.x - self.circleView.frame.size.width / 2 < 0) {
        center.x = self.circleView.frame.size.width / 2;
    }

    center.y += (currentPoint.y - previousPoint.y);
    if (center.y + self.circleView.frame.size.height / 2 > QRD_SCREEN_HEIGHT / 2) {
        center.y = QRD_SCREEN_HEIGHT / 2  - self.circleView.frame.size.height / 2;
    }

    if (center.y - self.circleView.frame.size.height / 2 < 0) {
        center.y = self.circleView.frame.size.height / 2;
    }

    self.circleView.center = center;
}


#pragma mark - QRDMicrophoneSourceDelegate

- (void)microphoneSource:(QRDMicrophoneSource *)source
       didGetAudioBuffer:(AudioBuffer *)audioBuffer {
    [self.session pushAudioBuffer:audioBuffer];
}

#pragma mark - QNRTCSessionDelegate

- (void)RTCSession:(QNRTCSession *)session didFailWithError:(NSError *)error {
    NSLog(@"QNRTCKitDemo: didFailWithError: %@", error);
    [self showAlertWithMessage:error.localizedDescription];
}

- (void)RTCSession:(QNRTCSession *)session roomStateDidChange:(QNRoomState)roomState {
    static NSDictionary *roomStateDictionary;
    roomStateDictionary = roomStateDictionary ? : @{@(QNRoomStateIdle):       @"Idle",
                                                   @(QNRoomStateConnecting):    @"Connecting",
                                                   @(QNRoomStateConnected):        @"Connected",
                                                   @(QNRoomStateReconnecting):         @"Reconnecting"
                                                   };
    NSLog(@"QNRTCKitDemo: roomStateDidChange: %@", roomStateDictionary[@(roomState)]);

    dispatch_async(dispatch_get_main_queue(), ^{
        if (roomState == QNRoomStateConnected) {
            [self.session publishWithAudioEnabled:YES videoEnabled:YES];
        }
    });
}

- (void)sessionDidPublishLocalMedia:(QNRTCSession *)session {
    NSLog(@"sessionDidPublishLocalMedia");

    [self.microhoneSource startRunning];
}

- (void)RTCSession:(QNRTCSession *)session didGetStatistic:(NSDictionary *)statistic ofUserId:(NSString *)userId {
    NSLog(@"the statistic of userId: %@ is %@", userId, statistic);
}

- (void)RTCSession:(QNRTCSession *)session didPublishOfRemoteUserId:(NSString *)userId {
    [self.session subscribe:userId];
}

- (QNVideoRender *)RTCSession:(QNRTCSession *)session firstVideoDidDecodeOfRemoteUserId:(NSString *)userId {
    QNVideoRender *render = [[QNVideoRender alloc] init];
    render.renderView = [[QNVideoView alloc] initWithFrame:CGRectMake(0, 0, QRD_SCREEN_WIDTH / 2, QRD_SCREEN_HEIGHT / 2)];
    [self.renderViewArray addObject:render.renderView];
    [self layoutRenderViews];
    return render;
}

- (void)RTCSession:(QNRTCSession *)session didDetachRenderView:(nonnull UIView *)renderView ofRemoteUserId:(nonnull NSString *)userId {
    [self.renderViewArray removeObject:renderView];
    [renderView removeFromSuperview];
    [self layoutRenderViews];
}

- (void)layoutRenderViews {
    self.scrollView.contentSize = CGSizeMake(self.renderViewArray.count * QRD_SCREEN_WIDTH / 2, QRD_SCREEN_HEIGHT / 2);
    for (NSInteger i = 0 ; i < self.renderViewArray.count; i++) {
        UIView *view = self.renderViewArray[i];
        view.frame = CGRectMake(i * QRD_SCREEN_WIDTH / 2, 0, QRD_SCREEN_WIDTH / 2, QRD_SCREEN_HEIGHT / 2);
        [self.scrollView addSubview:view];
    }
}

#pragma mark - request data

- (void)requestTokenWithCompletionHandler:(void (^)(NSError *error, NSString *token))completionHandler
{
#warning
    /*
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     */
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api-demo.qnsdk.com/v1/rtc/token/admin/app/%@/room/%@/user/%@?bundleId=%@",self.appId, self.roomName, self.userId, [[NSBundle mainBundle] bundleIdentifier]]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(error, nil);
            });
            return;
        }

        NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, token);
        });
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:controller animated:YES completion:nil];
    });
}


@end
