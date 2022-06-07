# QNRTCKit 4.0.4 to 5.0.0 API Differences

## General Headers

```
QNRTCConfiguration.h
```
- *Deleted*  property `@property (nonatomic, assign, readonly) BOOL isStereo;`
- *Deleted*  property `@property (nonatomic, assign, readonly) QNRTCBWEPolicy bwePolicy;`
- *Deleted*  property `@property (nonatomic, assign, readonly) BOOL allowAudioMixWithOthers;`
- *Deleted*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy stereo:(BOOL)isStereo;`
- *Deleted*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy stereo:(BOOL)isStereo bwePolicy:(QNRTCBWEPolicy)bwePolicy;`
- *Deleted*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy stereo:(BOOL)isStereo bwePolicy:(QNRTCBWEPolicy)bwePolicy allowAudioMixWithOthers:(BOOL)allowAudioMixWithOthers;`

```
QNRTC.h
```
- *Deleted*  method `+ (void)configRTC:(QNRTCConfiguration *)configuration;`
- *Added*  method `+ (void)initRTC:(QNRTCConfiguration *)configuration;`
- *Deleted*  method `+ (void)setAudioRouteDelegate:(id <QNRTCDelegate>)delegate;`
- *Added*  method `+ (void)setRTCDelegate:(id <QNRTCDelegate>)delegate;`
- *Deleted*  delegate `- (void)QNRTCDidChangeRTCAudioOutputToDevice:(QNAudioDeviceType)deviceType;`
- *Added*  delegate `- (void)RTCDidAudioRouteChanged:(QNAudioDeviceType)deviceType;`


```
QNRTCClient.h
```
- *Deleted*  method `- (NSArray <QNTrack *> *)getSubscribedTracks:(NSString *)userID;`
- *Deleted*  method `- (QNNetworkQuality *)getUserNetworkQuality:(NSString *)userID;`
- *Added*  method `- (NSDictionary *)getUserNetworkQuality;`
- *Deleted*  delegate `- (void)RTCClient:(QNRTCClient *)client didStartLiveStreamingWith:(NSString *)streamID;`
- *Added*  delegate `- (void)RTCClient:(QNRTCClient *)client didStartLiveStreaming:(NSString *)streamID;`
- *Deleted*  delegate `- (void)RTCClient:(QNRTCClient *)client didStopLiveStreamingWith:(NSString *)streamID;`
- *Added*  delegate `- (void)RTCClient:(QNRTCClient *)client didStopLiveStreaming:(NSString *)streamID;`
- *Deleted*  delegate `- (void)RTCClient:(QNRTCClient *)client didErrorLiveStreamingWith:(NSString *)streamID errorInfo:(QNLiveStreamingErrorInfo *)errorInfo;`
- *Added*  delegate `- (void)RTCClient:(QNRTCClient *)client didErrorLiveStreaming:(NSString *)streamID errorInfo:(QNLiveStreamingErrorInfo *)errorInfo;`
- *Added*  delegate `- (void)RTCClient:(QNRTCClient *)client remoteTrackMixedDidGetAudioBuffer:(AudioBuffer *)audioBuffer;`
- *Added*  delegate `- (void)RTCClient:(QNRTCClient *)client didNetworkQualityNotified:(QNNetworkQuality *)quality;`


```
QNTrack.h
```
- *Added*  property `@property (nonatomic, readonly) NSString *userID;`


```
QNLocalTrack.h
```
- *Added*  method `- (void)destroy;`


```
QNRemoteTrack.h
```
- *Deleted*  property `@property (nonatomic, weak) id<QNRemoteTrackDelegate> remoteDelegate;`


```
QNLocalAudioTrack.h
```
- *Added*  property `@property (nonatomic, weak) id<QNLocalAudioTrackDelegate> delegate;`
- *Added*  method `- (void)setVolume:(double)volume;`
- *Added*  delegate `- (void)localAudioTrack:(QNLocalAudioTrack *)localAudioTrack didGetAudioBuffer:(AudioBuffer *)audioBuffer bitsPerSample:(NSUInteger)bitsPerSample sampleRate:(NSUInteger)sampleRate;`


```
QNLocalVideoTrack.h
```
- *Deleted*  method `- (void)sendSEI:(NSString *)videoSEI repeatNmuber:(NSNumber *)repeatNumber;`
- *Added*  method `- (void)sendSEI:(NSString *)videoSEI uuid:(NSString *)uuid repeatNmuber:(NSNumber *)repeatNumber;`
- *Added*  property `@property (nonatomic, weak) id<QNLocalVideoTrackDelegate> delegate;`
- *Added*  method `- (void)play:(QNVideoGLView *)videoView;`
- *Added*  delegate `- (void)localVideoTrack:(QNLocalVideoTrack *)localVideoTrack didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer;`


```
QNMicrophoneAudioTrack.h
```
- *Deleted*  property `@property (nonatomic, strong, readonly) QNAudioMixer *audioMixer;`
- *Deleted*  property `@property (nonatomic, weak) id<QNMicrophoneAudioTrackDataDelegate> audioDelegate;`
- *Deleted*  delegate `- (void)microphoneAudioTrack:(QNMicrophoneAudioTrack *)microphoneAudioTrack didGetAudioBuffer:(AudioBuffer *)audioBuffer bitsPerSample:(NSUInteger)bitsPerSample sampleRate:(NSUInteger)sampleRate;`


```
QNCameraVideoTrack.h
```
- *Deleted*  property `@property (nonatomic, weak) id<QNCameraTrackVideoDataDelegate> videoDelegate;`
- *Deleted*  property `@property (nonatomic, readonly) AVCaptureSession * _Nullable captureSession;`
- *Deleted*  property `@property (nonatomic, readonly) AVCaptureDeviceInput * _Nullable videoCaptureDeviceInput;`
- *Deleted*  property `@property(readwrite, nonatomic) QNVideoFillModeType fillMode;`
- *Deleted*  property `@property (nonatomic, assign, getter=isTouchToFocusEnable) BOOL touchToFocusEnable;`
- *Deleted*  property `@property (nonatomic, assign) CGPoint focusPointOfInterest;`
- *Added*  property `@property (nonatomic, assign) CGPoint manualFocus;`
- *Deleted*  property `@property (nonatomic, strong, readonly) NSArray<AVCaptureDeviceFormat *> *videoFormats;`
- *Added*  property `@property (nonatomic, strong, readonly) NSArray<AVCaptureDeviceFormat *> *supportedVideoFormats;`
- *Deleted*  property `@property (nonatomic, copy) NSString *sessionPreset;`
- *Added*  property `@property (nonatomic, copy) NSString *videoFormat;`
- *Deleted*  method `- (void)setBeautify:(CGFloat)beautify;`
- *Added*  method `- (void)setSmoothLevel:(CGFloat)smoothLevel;`
- *Deleted*  method `- (void)pushCameraTrackWithImage:(nullable UIImage *)image;`
- *Added*  method `- (void)pushImage:(nullable UIImage *)image;`
- *Deleted*  method `- (void)play:(QNGLKView *)playView;`
- *Deleted*  delegate `- (void)cameraVideoTrack:(QNCameraVideoTrack *)cameraVideoTrack didGetSampleBuffer:(CMSampleBufferRef)sampleBuffer;`


```
QNCustomAudioTrack.h
```
- *Added*  property `@property (nonatomic, weak) id<QNCustomAudioTrackDelegate> customAudioDelegate;`
- *Added*  delegate `- (void)customAudioTrack:(QNCustomAudioTrack *)customAudioTrack didFailWithError:(NSError *)error;`


```
QNCustomVideoTrack.h
```
- *Deleted*  method `- (void)play:(QNVideoView *)renderView;`
- *Added*  method `- (void)play:(QNVideoGLView *)videoView;`


```
QNScreenVideoTrack.h
```
- *Deleted*  property `@property (nonatomic, assign) NSUInteger screenRecorderFrameRate;`

```
QNRemoteAudioTrack.h
```
- *Deleted*  property `@property (nonatomic, weak) id<QNRemoteTrackAudioDataDelegate> audioDelegate;`
- *Added*  property `@property (nonatomic, weak) id<QNRemoteAudioTrackDelegate> delegate;`
- *Added*  delegate `- (void)remoteAudioTrack:(QNRemoteAudioTrack *)remoteAudioTrack didMuteStateChanged:(BOOL)isMuted;`


```
QNRemoteVideoTrack.h
```
- *Deleted*  property `@property (nonatomic, weak) id<QNRemoteTrackVideoDataDelegate> videoDelegate;`
- *Added*  property `@property (nonatomic, weak) id<QNRemoteVideoTrackDelegate> delegate;`
- *Deleted*  method `- (void)play:(nullable QNVideoView *)renderView;`
- *Added*  method `- (void)play:(QNVideoGLView *)videoView;`
- *Deleted*  delegate `- (void)remoteVideoTrack:(QNRemoteVideoTrack *)remoteVideoTrack didSubscribeProfileChanged:(QNTrackProfile)profile;`
- *Added*  delegate `- (void)remoteVideoTrack:(QNRemoteVideoTrack *)remoteVideoTrack didVideoProfileChanged:(QNTrackProfile)profile;`
- *Added*  method `- (void)remoteVideoTrack:(QNRemoteVideoTrack *)remoteVideoTrack didMuteStateChanged:(BOOL)isMuted;`


```
QNMicrophoneAudioTrackConfig.h
```
- *Deleted*  property `@property (nonatomic, assign, readonly) NSUInteger bitrate;`
- *Added*  property `@property (nonatomic, strong, readonly) QNAudioQuality *audioQuality;`
- *Deleted*  method `- (instancetype)defaultMicrophoneAudioTrackConfig;`
- *Added*  method `+ (instancetype)defaultMicrophoneAudioTrackConfig;`
- *Deleted*  method `- (instancetype)initWithTag:(NSString *)tag bitrate:(NSUInteger)bitrate;`
- *Added*  method `- (instancetype)initWithTag:(NSString *)tag audioQuality:(QNAudioQuality *)audioQuality;`


```
QNCustomAudioTrackConfig.h
```
- *Deleted*  property `@property (nonatomic, assign, readonly) NSUInteger bitrate;`
- *Added*  property `@property (nonatomic, strong, readonly) QNAudioQuality *audioQuality;`
- *Deleted*  method `- (instancetype)defaultCustomAudioTrackConfig;`
- *Added*  method `+ (instancetype)defaultCustomAudioTrackConfig;`
- *Deleted*  method `- (instancetype)initWithTag:(NSString *)tag bitrate:(NSUInteger)bitrate;`
- *Added*  method `- (instancetype)initWithTag:(NSString *)tag audioQuality:(QNAudioQuality *)audioQuality;`


```
QNCameraVideoTrackConfig.h
```
- *Deleted*  property `@property (nonatomic, assign, readonly) NSUInteger bitrate;`
- *Deleted*  property `@property (nonatomic, assign, readonly) CGSize videoEncodeSize;`
- *Added*  property `@property (nonatomic, strong, readonly) QNVideoEncoderConfig *config;`
- *Added*  property `@property (nonatomic, assign) AVCaptureDevicePosition captureDevicePosition;`
- *Deleted*  method `- (instancetype)defaultCameraVideoTrackConfig;`
- *Added*  method `+ (instancetype)defaultCameraVideoTrackConfig;`
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag bitrate:(NSUInteger)bitrate;`                      
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag videoEncodeSize:(CGSize)videoEncodeSize;`
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag bitrate:(NSUInteger)bitrate videoEncodeSize:(CGSize)videoEncodeSize;`
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag bitrate:(NSUInteger)bitrate videoEncodeSize:(CGSize)videoEncodeSize multiStreamEnable:(BOOL)multiStreamEnable;`
- *Added*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag config:(QNVideoEncoderConfig *)config;`
- *Added*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag config:(QNVideoEncoderConfig *)config multiStreamEnable:(BOOL)multiStreamEnable;`


```
QNCustomVideoTrackConfig.h
```

- *Deleted*  property `@property (nonatomic, assign, readonly) NSUInteger bitrate;`
- *Deleted*  property `@property (nonatomic, assign, readonly) CGSize videoEncodeSize;`
- *Added*  property `@property (nonatomic, strong, readonly) QNVideoEncoderConfig *config;`
- *Deleted*  method `- (instancetype)defaultCustomVideoTrackConfig;`
- *Added*  method `+ (instancetype)defaultCustomVideoTrackConfig;`
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag bitrate:(NSUInteger)bitrate;`
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag videoEncodeSize:(CGSize)videoEncodeSize;`
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag bitrate:(NSUInteger)bitrate videoEncodeSize:(CGSize)videoEncodeSize;`
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag bitrate:(NSUInteger)bitrate videoEncodeSize:(CGSize)videoEncodeSize multiStreamEnable:(BOOL)multiStreamEnable;`
- *Added*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag config:(QNVideoEncoderConfig *)config;`
- *Added*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag config:(QNVideoEncoderConfig *)config multiStreamEnable:(BOOL)multiStreamEnable;`


```
QNScreenVideoTrackConfig.h
```
- *Deleted*  property `@property (nonatomic, assign, readonly) NSUInteger bitrate;`
- *Deleted*  property `@property (nonatomic, assign, readonly) CGSize videoEncodeSize;`
- *Added*  property `@property (nonatomic, strong, readonly) QNVideoEncoderConfig *config;`
- *Deleted*  method `- (instancetype)defaultScreenVideoTrackConfig;`
- *Added*  method `+ (instancetype)defaultScreenVideoTrackConfig;`
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag bitrate:(NSUInteger)bitrate;`
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag videoEncodeSize:(CGSize)videoEncodeSize;`
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag bitrate:(NSUInteger)bitrate videoEncodeSize:(CGSize)videoEncodeSize;`
- *Deleted*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag bitrate:(NSUInteger)bitrate videoEncodeSize:(CGSize)videoEncodeSize multiStreamEnable:(BOOL)multiStreamEnable;`
- *Added*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag config:(QNVideoEncoderConfig *)config;`
- *Added*  method `- (instancetype)initWithSourceTag:(nullable NSString *)tag config:(QNVideoEncoderConfig *)config multiStreamEnable:(BOOL)multiStreamEnable;`


```
QNRemoteUser.h
```
- *Added*  property `@property (nonatomic, readonly) NSString *userID;`
- *Added*  property `@property (nonatomic, readonly) NSString *userData;`


```
QNRoomMediaRelayConfiguration.h
```
- *Deleted*  method `- (BOOL)removeDestRoomInfoForRoomName:(NSString *_Nonnull)roomName;`
- *Added*  method `- (BOOL)removeDestRoomInfo:(NSString *_Nonnull)roomName;`


```
QNTranscodingLiveStreamingTrack.h
```
- *Deleted*  property `@property (nonatomic, strong) NSString *trackId;`
- *Added*  property `@property (nonatomic, strong) NSString *trackID;`
- *Deleted*  property `@property (nonatomic, assign) NSUInteger zIndex;`
- *Added*  property `@property (nonatomic, assign) NSUInteger zOrder;`


```
QNVideoGLView.h
```
- *Added*  property`@property(nonatomic, assign) QNVideoFillModeType fillMode;`


```
QNUtil.h
```
- *Deleted*  method  `+ (void)scaleWithSat:(AudioBuffer *)audioBuffer scale:(double)scale max:(float)max min:(float)min;`
- *Deleted*  method `+ (double)volumeWithAudioBuffer:(AudioBuffer *)audioBuffer;`


```
QNTypeDefines.h
```
- *Modified* QNRTCErrorDomain
	- *Deleted*  `QNRTCErrorReconnectTokenError`
	- *Deleted*  `QNRTCErrorKickOutOfRoom`
	- *Deleted*  `QNRTCErrorUserNotExist`
	- *Deleted*  `QNRTCErrorServerUnavailable`
	- *Deleted*  `QNRTCErrorPublishDisconnected`
	- *Deleted*  `QNRTCErrorMultiMasterVideoOrAudio`
	- *Added* `QNRTCErrorNetworkTimeout`
- *Modified* QNConnectionState
	- *Deleted* `QNConnectionStateIdle`
	- *Added* `QNConnectionStateDisconnected`
- *Deleted* QNAudioMixErrorDomain
- *Deleted* QNAudioFileErrorDomain
- *Deleted* QNAudioPlayState
- *Deleted* QNRTCSourceType
- *Deleted* QNRTCBWEPolicy

- *Modified* statistic key define
	- *Deleted* `extern NSString *QNStatisticAudioBitrateKey;`
	- *Deleted* `extern NSString *QNStatisticVideoBitrateKey;`
	- *Deleted* `extern NSString *QNStatisticAudioPacketLossRateKey;`
	- *Deleted* `extern NSString *QNStatisticVideoPacketLossRateKey;`
	- *Deleted* `extern NSString *QNStatisticAudioRemotePacketLossRateKey;`
	- *Deleted* `extern NSString *QNStatisticVideoRemotePacketLossRateKey;`
	- *Deleted* `extern NSString *QNStatisticVideoFrameRateKey;`
	- *Deleted* `extern NSString *QNStatisticProfileKey;`
	- *Deleted* `extern NSString *QNStatisticRttKey;`
	- *Deleted* `extern NSString *QNStatisticNetworkGrade;`


```
class deleted
```	
- *Deleted* class QNAudioMixer 
- *Deleted* class QNGLKView
- *Deleted* class QNRTCUser
- *Deleted* class QNVideoRender


```
class added
```	
- *Added* class QNAudioQuality
	- *Added* property `@property (nonatomic, assign, readonly) NSUInteger bitrate;`
	- *Added* method `+ (instancetype)defaultAudioQuality;`
	- *Added* method `- (instancetype)initWithBitrate:(NSUInteger)bitrate;`

- *Added* class QNVideoEncoderConfig
	- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger bitrate;`
	- *Added*  property `@property (nonatomic, assign, readonly) CGSize videoEncodeSize;`
	- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger videoFrameRate;`
	- *Added*  method `+ (instancetype)defaultVideoEncoderConfig;`
	- *Added*  method `- (instancetype)initWithBitrate:(NSUInteger)bitrate;`
	- *Added*  method `- (instancetype)initWithBitrate:(NSUInteger)bitrate videoEncodeSize:(CGSize)videoEncodeSize;`
	- *Added*  method `- (instancetype)initWithBitrate:(NSUInteger)bitrate videoEncodeSize:(CGSize)videoEncodeSize videoFrameRate:(NSUInteger)videoFrameRate;`
