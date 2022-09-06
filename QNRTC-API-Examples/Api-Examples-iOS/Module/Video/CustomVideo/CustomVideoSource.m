//
//  CustomVideoSource.m
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/29.
//

#import "CustomVideoSource.h"

@interface CustomVideoSource () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *captureInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *captureOutput;
@property (nonatomic, strong) AVCaptureConnection *captureConnection;
@property (nonatomic, strong) dispatch_queue_t videoOperationQueue;

@end

@implementation CustomVideoSource
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.videoOperationQueue = dispatch_queue_create("com.video.operation.queue", DISPATCH_QUEUE_SERIAL);
        [self initVideoSourceEngine];
    }
    return self;
}

- (void)initVideoSourceEngine {
    NSError *error;
    
    // 初始化视频采集引擎
    self.captureSession = [[AVCaptureSession alloc] init];
    
    // 设置采集分辨率
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    // 配置输入端
    // 获取视频采集设备  查找前置摄像头
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *curDevice in devices) {
        if ([curDevice position] == AVCaptureDevicePositionFront) {
            self.captureDevice = curDevice;
            break;
        }
    }
    
    // 设置帧率
    [self.captureDevice lockForConfiguration:&error];
    if (error) {
        NSLog(@"lockForConfiguration Error: %@", error.localizedDescription);
    }
    [self.captureDevice setActiveVideoMinFrameDuration:CMTimeMake(1, 15)];
    [self.captureDevice setActiveVideoMaxFrameDuration:CMTimeMake(1, 15)];
    [self.captureDevice unlockForConfiguration];
    
    self.captureInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice error:&error];
    if (error) {
        NSLog(@"AVCaptureDeviceInput Init Error: %@", error.localizedDescription);
        return;
    }
    
    // 配置输出端
    self.captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.captureOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)}];
    self.captureOutput.alwaysDiscardsLateVideoFrames = YES;
    [self.captureOutput setSampleBufferDelegate:self queue:self.videoOperationQueue];

    // 添加输入端
    if ([self.captureSession canAddInput:self.captureInput]) {
        [self.captureSession addInput:self.captureInput];
    }
    
    // 添加输出端
    if ([self.captureSession canAddOutput:self.captureOutput]) {
        [self.captureSession addOutput:self.captureOutput];
    }
    
    // 获取当前 captureConnection
    self.captureConnection = [self.captureOutput connectionWithMediaType:AVMediaTypeVideo];
    // 设置摄像头旋转方向
    if (self.captureConnection.supportsVideoOrientation) {
        self.captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    }
    // 设置镜像
    if (self.captureConnection.supportsVideoMirroring) {
        self.captureConnection.videoMirrored = YES;
    }
}

- (void)startCaptureSession {
    if (![self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
}

- (void)stopCaptureSession {
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (connection == self.captureConnection) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(customVideoSource:didOutputSampleBuffer:)]) {
            [self.delegate customVideoSource:self didOutputSampleBuffer:sampleBuffer];
        }
    }
}

@end
