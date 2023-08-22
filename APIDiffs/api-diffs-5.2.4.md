# QNRTCKit 5.2.3 to 5.2.4 API Differences

## General Headers

```
QNRTCConfiguration.h
```
- *Added*  property `@property (nonatomic, assign, readonly) int reconnectionTimeout;`
- *Added*  property `@property (nonatomic, assign, readonly) QNVideoEncoderType encoderType;`
- *Added*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy audioScene:(QNAudioScene)audioScene reconnectionTimeout:(int)reconnectionTimeout;`
- *Added*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy audioScene:(QNAudioScene)audioScene reconnectionTimeout:(int)reconnectionTimeout encoderType:(QNVideoEncoderType)encoderType;`

```
QNVideoEncoderConfig.h
```
- *Added*  property `@property (nonatomic, assign, readonly) QNVideoFormatPreset formatPreset;`
- *Added*  method `- (instancetype)initWithPreference:(QNDegradationPreference)preference
                      formatPreset:(QNVideoFormatPreset)formatPreset;`      
                      
```
QNLocalVideoTrackStats.h
```
- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger uplinkFrameWidth;`
- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger uplinkFrameHeight;`
- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger captureFrameRate;`
- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger captureFrameWidth;`
- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger captureFrameHeight;`
- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger targetFrameRate;`
- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger targetFrameWidth;`
- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger targetFrameHeight;`

```
QNRemoteVideoTrackStats.h
```
- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger uplinkFrameWidth;`
- *Added*  property `@property (nonatomic, assign, readonly) NSUInteger uplinkFrameHeight;`

```
QNAudioEffectMixer.h
```
- *Deprecated*  method `- (void)audioEffectMixer:(QNAudioEffectMixer *)audioEffectMixer didFailWithError:(NSError *)error;`
- *Added*  method `- (void)audioEffect:(QNAudioEffect *)audioEffect didFailed:(int)effectID error:(NSError *)error;`
- *Added*  nethod `- (void)audioEffect:(QNAudioEffect *)audioEffect didFinished:(int)effectID;`

```
QNTypeDefines
```
- *Added*  `QNDegradationDefault`
- *Added*  `QNVideoEncoderType`
- *Added*  `QNVideoFormatPreset`
- *Added*  `QNRTCErrorStreamNotExistError`
- *Added*  `QNRTCErrorServerUnavailable`
- *Added*  `QNRTCErrorOperationTimeoutError`
- *Added*  `QNRTCErrorLiveStreamingClosedError`