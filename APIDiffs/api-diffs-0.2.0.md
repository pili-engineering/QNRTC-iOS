# QNRTCKit 0.1.0 to 0.2.0 API Differences

## General Headers

```
QNRTCSession.h
```

- *Added* method `- (void)RTCSession:(QNRTCSession *)session didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer ofRemoteUserId:(NSString *)userId;`
- *Added* method `- (void)RTCSession:(QNRTCSession *)session
 didGetAudioBuffer:(AudioBuffer *)audioBuffer
     bitsPerSample:(NSUInteger)bitsPerSample
        sampleRate:(NSUInteger)sampleRate
    ofRemoteUserId:(NSString *)userId;`
- *Added* method `- (void)RTCSession:(QNRTCSession *)session microphoneSourceDidGetAudioBuffer:(AudioBuffer *)audioBuffer;`    
- *Added* method `- (void)setMergeStreamLayoutWithUserId:(NSString *)userId
                                 frame:(CGRect)frame
                                zIndex:(NSUInteger)zIndex;`

- *Added* method `- (void)stopMergeStream;`

- *Added* property `@property (nonatomic, assign) BOOL encodeMirrorFrontFacing;`
- *Added* property `@property (nonatomic, assign) BOOL encodeMirrorRearFacing;`

- *Modified* method `- (CMSampleBufferRef)RTCSession:(QNRTCSession *)session cameraSourceDidGetSmapleBuffer:(CMSampleBufferRef)sampleBuffer;`

|      | Description                                                               |
| ---- | ------------------------------------------------------------------------- |
| From | `- (CMSampleBufferRef)RTCSession:(QNRTCSession *)session cameraSourceDidGetSmapleBuffer:(CMSampleBufferRef)sampleBuffer;`|
| To   | `- (void)RTCSession:(QNRTCSession *)session cameraSourceDidGetSampleBuffer:(CMSampleBufferRef)sampleBuffer;` |
