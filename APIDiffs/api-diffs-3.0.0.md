# QNRTCKit 2.5.0 to 3.0.0 API Differences

## General Headers

```
QNRTCEngine.h
```
- *Added*  delegate `- (void)RTCEngine:(QNRTCEngine *)engine didReconnectingRemoteUserId:(NSString *)userId;`

- *Added*  delegate `- (void)RTCEngine:(QNRTCEngine *)engine didReconnectedRemoteUserId:(NSString *)userId;`

- *Added*  encodeDataDelegate `- (size_t)RTCEngine:(QNRTCEngine *)engine
didSendFrameData:(uint8_t *)frameData
 frameDataLength:(size_t)frameDataLength
   encryptedData:(uint8_t*)encryptedData
       ofTrackId:(NSString *)trackId;`

- *Added*  encodeDataDelegate `- (size_t)RTCEngine:(QNRTCEngine *)engine didSendExtData:(uint8_t *)extData extMaxDataLength:(size_t)extMaxDataLength ofTrackId:(NSString *)trackId;`

- *Added*  encodeDataDelegate `- (size_t)RTCEngine:(QNRTCEngine *)engine
didSendDataLength:(size_t)frameDataLength
        oftrackId:(NSString *)trackId;`

- *Added*  encodeDataDelegate `- (size_t)RTCEngine:(QNRTCEngine *)engine
didGetFrameData:(uint8_t *)frameData
frameDataLength:(size_t)frameDataLength
  decryptedData:(uint8_t*)decryptedData
      ofTrackId:(NSString *)trackId
       ofUserId:(NSString *)userId;`

- *Added*  encodeDataDelegate `- (void)RTCEngine:(QNRTCEngine *)engine
didGetExtData:(uint8_t *)extData
extDataLength:(size_t)extDataLength
    ofTrackId:(NSString *)trackId
     ofUserId:(NSString *)userId;`

- *Added*  encodeDataDelegate `- (size_t)RTCEngine:(QNRTCEngine *)engine
didGetDataLength:(size_t)frameDataLength
       oftrackId:(NSString *)trackId
        ofUserId:(NSString *)userId;`
        
- *Added*  property `@property (nonatomic, weak) id<QNRTCEngineEncodeDataDelegate> encodeDataDelegate;`

- *Added*  method `- (void)setRemoteTrackId:(NSString *)trackId outputVolume:(double)volume;`
