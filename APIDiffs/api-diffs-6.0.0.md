# QNRTCKit 5.2.7 to 6.0.0 API Differences

## General Headers

```
QNCDNStreamingClient.h
```
- *Added*  property `@property (nonatomic, weak) id<QNCDNStreamingDelegate> delegate;`
- *Added*  method `- (int)startWithConfig:(QNCDNStreamingConfig *)config;`
- *Added*  method `- (int)stop;`

```
QNCDNStreamingConfig.h
```

- *Added*  property `@property (nonatomic, copy) NSString *publishUrl;`
- *Added*  property `@property (nonatomic, strong) QNLocalAudioTrack *audioTrack;`
- *Added*  property `@property (nonatomic, strong) QNLocalVideoTrack *videoTrack;`
- *Added*  property `@property (nonatomic, assign) BOOL enableQuic;`
- *Added*  property `@property (nonatomic, assign) uint32_t reconnectCount;`
- *Added*  property `@property (nonatomic, assign) uint32_t bufferingTime;`

```
QNCDNStreamingDelegate
```

- *Added*  method `- (void)cdnStreamingClient:(QNCDNStreamingClient *)client didCDNStreamingConnectionStateChanged:(QNConnectionState)state errorCode:(**int**)code message:(NSString *)message;`
- *Added*  method `- (void)cdnStreamingClient:(QNCDNStreamingClient *)client didCDNStreamingStats:(QNCDNStreamingStats *)stats;`

```
QNLocalAudioTrack.h
```

- *Added*  property `@property (nonatomic, weak) id<QNAudioEncryptDelegate> encryptDelegate;`

```
QNRemoteAudioTrack.h
```

- *Added*  property `@property (nonatomic, weak) id<QNAudioDecryptDelegate> decryptDelegate;`

```
QNAudioEncryptDelegate
```

- *Added*  method `- (void)remoteAudioTrack:(QNRemoteAudioTrack *)remoteAudioTrack onGetExtraData:(uint8_t *)extraData dataSize:(int)dataSize;`
- *Added*  method `- (int)remoteAudioTrack:(QNRemoteAudioTrack *)remoteAudioTrack onSetMaxDecryptSize:(int)frameSize;`

- *Added*  method `- (int)remoteAudioTrack:(QNRemoteAudioTrack *)remoteAudioTrack onDecrypt:(uint8_t *)frame frameSize:(int)frameSize decryptedFrame:(uint8_t *)decryptedFrame;`

```
QNAudioDecryptDelegate
```

- *Added*  method `- (int)remoteAudioTrack:(QNRemoteAudioTrack *)remoteAudioTrack onSetMaxDecryptSize:(int)frameSize;`
- *Added*  method `- (void)cdnStreamingClient:(QNCDNStreamingClient *)client didCDNStreamingStats:(QNCDNStreamingStats *)stats;`
- *Added*  method `- (int)remoteAudioTrack:(QNRemoteAudioTrack *)remoteAudioTrack onDecrypt:(uint8_t *)frame frameSize:(int)frameSize decryptedFrame:(uint8_t *)decryptedFrame;`

