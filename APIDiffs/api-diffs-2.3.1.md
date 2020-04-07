# QNRTCKit 2.3.0 to 2.3.1 API Differences

## General Headers

```
QNRTCConfiguration.h
```
- *Added*  property `@property (nonatomic, assign, readonly) BOOL allowAudioMixWithOthers;`
- *Added*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy stereo:(BOOL)isStereo bwePolicy:(QNRTCBWEPolicy)bwePolicy allowAudioMixWithOthers:(BOOL)allowAudioMixWithOthers;`


```
QNMergeStreamConfiguration.h
```
- *Added*  property `@property (nonatomic, strong) QNBackgroundInfo *background;`


```
QNWatermarkInfo.h
```
- *Added* class `QNBackgroundInfo`