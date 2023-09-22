# QNRTCKit 5.2.4 to 5.2.5 API Differences

## General Headers

```
QNCameraVideoTrack
```

- *Added*  method `- (**int**)pushImage:(**nullable** UIImage *)image`

```
QNTrack
```

- *Added*  method `- (**void**)cameraVideoTrack:(QNCameraVideoTrack *)cameraVideoTrack didPushImageWithError:(NSError *)error`

```
QNRTCConfiguration
```

- *Added*  property `@property (nonatomic, strong) NSArray* mcuDomains;`

  

