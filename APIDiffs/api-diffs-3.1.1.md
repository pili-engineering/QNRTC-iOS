# QNRTCKit 3.1.0 to 3.1.1 API Differences

## General Headers

```
QNRoomMediaRelayInfo.h
```
- *Deprecated*  method `- (instancetype _Nonnull)initWithToken:(NSString *_Nullable)token;`

- *Added*  method `- (instancetype _Nonnull)initWithRoomName:(NSString *__nonnull)roomName token:(NSString *__nonnull)token;`
