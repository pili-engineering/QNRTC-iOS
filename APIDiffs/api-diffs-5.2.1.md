# QNRTCKit 5.2.0 to 5.2.1 API Differences

## General Headers

```
QNLocalVideoTrack
```
- *Added*  method `- (void)setVideoEncoderConfig:(QNVideoEncoderConfig *)config;`

```
QNUtil
```
- *Added*  method `+ (BOOL)startAecDump:(NSString *)path durationMs:(int)durationMs;`
- *Added*  method `+ (void)stopAecDump;`

```
QNAudioSourceMixer
```
- *Added*  method `- (QNAudioSource *)createAudioSourceWithSourceID:(int)sourceID bigEndian:(BOOL)bigEndian blockingMode:(BOOL)blockingMode;`