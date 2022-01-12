//
//  QNCameraVideoTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/7/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNGLKView.h"
#import "QNLocalVideoTrack.h"

@class QNCameraVideoTrack;
NS_ASSUME_NONNULL_BEGIN
@protocol QNCameraTrackVideoDataDelegate <NSObject>

@optional
/*!
 * @abstract 视频 Track 数据回调。
 *
 * @since v4.0.0
 */
- (void)cameraVideoTrack:(QNCameraVideoTrack *)cameraVideoTrack didGetSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

@interface QNCameraVideoTrack : QNLocalVideoTrack

/*!
 * @abstract 视频 Track 回调代理。
 *
 * @since v4.0.0
 */
@property (nonatomic, weak) id<QNCameraTrackVideoDataDelegate> videoDelegate;

/*!
 * @abstract 视频采集 session，只读变量，给有特殊需求的开发者使用，最好不要修改。
 *
 * @since v4.0.0
 */
@property (nonatomic, readonly) AVCaptureSession * _Nullable captureSession;

/*!
 * @abstract 视频采集输入源，只读变量，给有特殊需求的开发者使用，最好不要修改。
 *
 * @since v4.0.0
 */
@property (nonatomic, readonly) AVCaptureDeviceInput * _Nullable videoCaptureDeviceInput;

/*!
 * @abstract previewView 中视频的填充方式，默认使用 QNVideoFillModePreserveAspectRatioAndFill。
 *
 * @since v4.0.0
 */
@property(readwrite, nonatomic) QNVideoFillModeType fillMode;

/*!
 * @abstract 摄像头的位置，默认为 AVCaptureDevicePositionFront。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) AVCaptureDevicePosition captureDevicePosition;

/*!
 * @abstract 开启 camera 时的采集摄像头的旋转方向，默认为 AVCaptureVideoOrientationPortrait。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

/*!
 * @abstract 是否开启手电筒，默认为 NO。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, getter=isTorchOn) BOOL torchOn;

/*!
 * @abstract 连续自动对焦。默认为 YES。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, getter=isContinuousAutofocusEnable) BOOL continuousAutofocusEnable;

/*!
 * @abstract 手动点击屏幕进行对焦。默认为 YES。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, getter=isTouchToFocusEnable) BOOL touchToFocusEnable;

/*!
 * @abstract 该属性适用于视频拍摄过程中用来减缓因自动对焦产生的镜头伸缩，使画面不因快速的对焦而产生抖动感。默认为 YES。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, getter=isSmoothAutoFocusEnabled) BOOL smoothAutoFocusEnabled;

/*!
 * @abstract 聚焦的位置，(0,0) 代表左上, (1,1) 代表右下。默认为 (0.5, 0.5)，即中间位置。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) CGPoint focusPointOfInterest;

/*!
 * @abstract 控制摄像头的缩放，默认为 1.0。
 *
 * @discussion 设置的数值需要小于等于 videoActiveForat.videoMaxZoomFactor，如果大于会设置失败。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) CGFloat videoZoomFactor;

/*!
 * @abstract 设备支持的 formats。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong, readonly) NSArray<AVCaptureDeviceFormat *> *videoFormats;

/*!
 * @abstract 设备当前的 format。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) AVCaptureDeviceFormat *videoActiveFormat;

/*!
 * @abstract 采集的视频的 sessionPreset，默认为 AVCaptureSessionPreset640x480。
 *
 * @since v4.0.0
 */
@property (nonatomic, copy) NSString *sessionPreset;

/*!
 * @abstract 采集的视频数据的帧率，默认为 24。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) NSUInteger videoFrameRate;

/*!
 * @abstract 前置摄像头预览是否开启镜像，默认为 YES。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) BOOL previewMirrorFrontFacing;

/*!
 * @abstract 后置摄像头预览是否开启镜像，默认为 NO。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) BOOL previewMirrorRearFacing;

/*!
 * @abstract 前置摄像头，对方观看时是否开启镜像，默认 NO。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) BOOL encodeMirrorFrontFacing;

/*!
 * @abstract 后置摄像头，对方观看时是否开启镜像，默认 NO。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) BOOL encodeMirrorRearFacing;

/*!
 * @abstract 切换前后摄像头。
 *
 * @since v4.0.0
 */
- (void)switchCamera;

/*!
 * @abstract 是否开启美颜。
 *
 * @since v4.0.0
 */
- (void)setBeautifyModeOn:(BOOL)beautifyModeOn;

/*!
 * @abstract 设置对应 Beauty 的程度参数，范围从 0 ~ 1，0 为不美颜。
 *
 * @discussion 如果美颜不开启，设置该参数无效。
 *
 * @since v4.0.0
 */
- (void)setBeautify:(CGFloat)beautify;

/*!
 * @abstract 设置美白程度。
 *
 * @discussion 如果美颜不开启，设置该参数无效。
 *
 * @since v4.0.0
 */
- (void)setWhiten:(CGFloat)whiten;

/*!
 * @abstract 设置红润的程度。范围是从 0 ~ 1，0 为不红润。
 *
 * @discussion 如果美颜不开启，设置该参数无效。
 *
 * @since v4.0.0
 */
- (void)setRedden:(CGFloat)redden;

/*!
 * @abstract 设置水印。
 *
 * @since v4.0.0
 */
- (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position;

/*!
 * @abstract 移除水印。
 *
 * @since v4.0.0
 */
- (void)clearWaterMark;

/*!
 * @abstract 设置摄像头 track 发送图片数据
 *
 * @param image 推流的图片
 *
 * @discussion 由于某些特殊原因不想使用摄像头采集的数据作为发送视频数据时，可以使用该接口设置一张图片来替代。传入 nil 则关闭该功能。

 * @warning    请确保传入的 image 的宽和高是 16 的整数倍。请勿在 applicationState 为 UIApplicationStateBackground 时调用该接口，否则将出错。
 *
 * @since v4.0.0
 */
- (void)pushCameraTrackWithImage:(nullable UIImage *)image;

/*!
 * @abstract 开启摄像头采集。
 *
 * @since v4.0.0
 */
- (void)startCapture;

/*!
 * @abstract 关闭摄像头采集。
 *
 * @since v4.0.0
 */
- (void)stopCapture;

/*!
 * @abstract 设置摄像头画面预览。
 *
 * @since v4.0.0
 */
- (void)play:(QNGLKView *)playView;

@end

NS_ASSUME_NONNULL_END
