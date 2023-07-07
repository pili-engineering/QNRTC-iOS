# QNRTCKit 5.2.2 to 5.2.3 API Differences

## General Headers

```
QNRTCConfiguration.h
```
- *Deprecated*  property `@property (nonatomic, assign, readonly) BOOL maintainResolutionEnabled;`
- *Deprecated*  property `@property (nonatomic, assign, readonly) BOOL communicationModeOn;`
- *Added*  property `@property (nonatomic, assign, readonly) QNAudioScene audioScene;`
- *Deprecated*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy maintainResolutionEnabled:(BOOL)maintainResolutionEnabled;`
- *Deprecated*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy maintainResolutionEnabled:(BOOL)maintainResolutionEnabled communicationModeOn:(BOOL)communicationModeOn;`
- *Added*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy audioScene:(QNAudioScene)audioScene;`


```
QNRTC.h
```
- *Added*  method `+ (void)setAudioScene:(QNAudioScene)audioScene;`
- *Deprecated*  method `+ (void)enableFileLogging;`
- *Deprecated*  method `+ (void)setLogLevel:(QNRTCLogLevel)level;`
- *Added*  method `+ (void)setLogConfig:(QNRTCLogConfiguration *)configuration;`
- *Added*  method `+ (void)uploadLog:(nullable QNUploadLogResultCallback)callback;`
- *Added*  method `+ (void)uploadLog:(NSString *)token callback:(nullable QNUploadLogResultCallback)callback;`

```
QNRTCLogConfiguration.h
```
- *Added*  property `@property (nonatomic, strong) NSString *dir;`
- *Added*  property `@property (nonatomic, strong) NSString *tag;`
- *Added*  property `@property (nonatomic, assign) long maxSizeInBytes;`
- *Added*  property `@property (nonatomic, assign) QNRTCLogLevel level;`
- *Added*  method `+ (instancetype)defaultRTCLogConfig;`
- *Added*  method `- (instancetype)initWithLogLevel:(QNRTCLogLevel)level;`


```
QNVideoEncoderConfig.h
```
- *Added*  property `@property (nonatomic, assign, readonly) QNDegradationPreference preference;`
- *Added*  method `- (instancetype)initWithBitrate:(NSUInteger)bitrate videoEncodeSize:(CGSize)videoEncodeSize videoFrameRate:(NSUInteger)videoFrameRate preference:(QNDegradationPreference)preference;`


```
QNLocalVideoTrack.h
```
- *Deprecated*  method `- (void)sendSEI:(NSString *)videoSEI uuid:(NSString *)uuid repeatNmuber:(NSNumber *)repeatNumber;`
- *Added*  method `- (void)sendSEIWithData:(NSData *)SEIData uuid:(NSData *)uuid repeatCount:(NSNumber *)repeatCount;`


```
QNCameraVideoTrack.h
```
- *Deprecated*  method `- (void)sendSEI:(NSString *)videoSEI uuid:(NSString *)uuid repeatNmuber:(NSNumber *)repeatNumber;`
- *Added*  method `- (void)sendSEIWithData:(NSData *)SEIData uuid:(NSData *)uuid repeatCount:(NSNumber *)repeatCount;`
- *Deprecated*  method `- (void)switchCamera;`
- *Added*  method `- (void)switchCamera:(nullable QNCameraSwitchResultCallback)callback;`


```
QNCustomVideoTrack.h
```
- *Deprecated*  method `- (void)sendSEI:(NSString *)videoSEI uuid:(NSString *)uuid repeatNmuber:(NSNumber *)repeatNumber;`
- *Added*  method `- (void)sendSEIWithData:(NSData *)SEIData uuid:(NSData *)uuid repeatCount:(NSNumber *)repeatCount;`


```
QNScreenVideoTrack.h
```
- *Deprecated*  method `- (void)sendSEI:(NSString *)videoSEI uuid:(NSString *)uuid repeatNmuber:(NSNumber *)repeatNumber;`
- *Added*  method `- (void)sendSEIWithData:(NSData *)SEIData uuid:(NSData *)uuid repeatCount:(NSNumber *)repeatCount;`


```
QNTypeDefines
```
- *Added*  `QNDegradationPreference`
- *Added*  `QNAudioScene`
- *Added*  `typedef void (^QNUploadLogResultCallback)(NSString *fileName, int code, int remaining);`
- *Added*  `typedef void (^QNCameraSwitchResultCallback)(BOOL isFrontCamera, NSString *errorMessage);`
