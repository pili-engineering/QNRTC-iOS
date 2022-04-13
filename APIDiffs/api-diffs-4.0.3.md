# QNRTCKit 4.0.2 to 4.0.3 API Differences

## General Headers

```
QNLocalAudioTrack
```
- *Added*  method `- (float)getVolumeLevel;`

```
QNRoomMediaRelayInfo.h
```
- *Deprecated*  method `- (instancetype _Nonnull)initWithToken:(NSString *_Nullable)token;`

- *Added*  method `- (instancetype _Nonnull)initWithRoomName:(NSString *__nonnull)roomName token:(NSString *__nonnull)token;`
