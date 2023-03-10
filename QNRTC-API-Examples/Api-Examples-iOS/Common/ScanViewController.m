//
//  ScanViewController.m
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/26.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController ()<
 AVCaptureMetadataOutputObjectsDelegate
>
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) NSString *scanResult;
@end

@implementation ScanViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self stopReading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self startReading];
    
}

#pragma mark - 开始扫描
- (BOOL)startReading {
    NSError *error;
    
    // 初始化捕捉设备（AVCaptureDevice），类型为 AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 用 captureDevice 创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // 创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    // 实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    // 将添加输入流和媒体输出流到会话
    [_captureSession addInput:input];
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    // 设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // 实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    // 设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.bgView.bounds];
    [self.bgView.layer addSublayer:_videoPreviewLayer];
    
    // 设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    // 扫描框
    _boxView = [[UIView alloc] init];
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    [self.bgView addSubview:_boxView];
    [_boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(22);
    }];
    
    // 开始扫描
    [_captureSession startRunning];
    return YES;
}

#pragma mark - 停止扫描
- (void)stopReading {
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 判断是否有数据
        if (metadataObjects != nil && [metadataObjects count] > 0) {
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            // 判断回传的数据类型
            if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                NSLog(@"input QR: %@", [metadataObj stringValue]);
                self.scanResult = [metadataObj stringValue];
                [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:self.scanResult preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self startReading];
                    });
                }];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self.delegate respondsToSelector:@selector(scanQRResult:)]) {
                            [self.delegate scanQRResult:self.scanResult];
                        }
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
                [alertVc addAction:cancelAction];
                [alertVc addAction:sureAction];
                [self presentViewController:alertVc animated:YES completion:nil];

            }
        }
    });
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (IBAction)getBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
