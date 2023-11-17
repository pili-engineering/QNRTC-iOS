# QNRTCKit 5.2.6 to 5.2.7 API Differences

## General Headers

```
QNMicrophoneAudioTrackDelegate
```
- *Added*  method `- (void)microphoneAudioTrack:(QNMicrophoneAudioTrack *)microphoneAudioTrack didFailWithError:(NSError *)error;`


```
QNMicrophoneAudioTrack
```
- *Added*  method `@property (nonatomic, weak) id<QNMicrophoneAudioTrackDelegate> microphoneDelegate;`
- *Added*  method `- (BOOL)startRecording;`
- *Added*  method `- (BOOL)stopRecording;`
- *Added*  method `- (void)pushAudioFrame:(const uint8_t*)data dataSize:(uint32_t)dataSize bitsPerSample:(uint32_t)bitsPerSample sampleRate:(uint32_t)sampleRate channels:(uint32_t)channels bigEndian:(bool)bigEndian planar:(bool)planar;`
