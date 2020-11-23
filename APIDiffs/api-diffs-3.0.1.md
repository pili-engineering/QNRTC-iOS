# QNRTCKit 3.0.0 to 3.0.1 API Differences

## General Headers

```
QNRTCEngine.h
```

- *Added*  method `- (void)stopMergeStreamWithJobId:(nullable NSString *)jobId delayMillisecond:(NSUInteger)delayMillisecond;`

- *Added*  method `- (void)stopForwardJobWithJobId:(NSString *)jobId delayMillisecond:(NSUInteger)delayMillisecond;`

- *Added*  method `- (void)setMicrophoneInputGain:(float) inputGain;`

- *Added*  method `- (void)setLocalVideoSEI:(NSString *)videoSEI repeatNmuber:(NSNumber *)repeatNumber withTracks:(NSArray<QNTrackInfo *> *)tracks;`

- *Added*  method `- (void)pushCameraTrackWithImage:(nullable UIImage *)image;`



```
QNAudioEngine.h
```
- *Added*  property `@property (nonatomic, assign) float musicOutputVolume;`
