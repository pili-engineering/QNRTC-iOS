# QNRTCKit 0.2.0 to 1.0.0 API Differences

## General Headers

```
QNRTCSession.h
```

- *Added* method `- (instancetype)initWithCaptureEnabled:(BOOL)captureEnabled;`
- *Added* method `- (void)pushPixelBuffer:(CVPixelBufferRef)pixelBuffer;`
- *Added* method `- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer;` 

- *Added* property `@property (nonatomic, assign, readonly) BOOL captureEnabled;`


