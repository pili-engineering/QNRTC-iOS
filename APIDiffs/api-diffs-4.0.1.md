# QNRTCKit 4.0.0 to 4.0.1 API Differences

## General Headers

```
QNRTC.h
```
- *Added*  method `+ (QNRTCClient *)createRTCClient:(QNClientConfig *)clientConfig;`


```
QNRTCClient.h
```

- *Added*  method `- (void)setClientRole:(QNClientRole)role completeCallback:(nullable QNClientRoleResultCallback)callback;`

- *Added*  method `- (void)startRoomMediaRelay:(nullable QNRoomMediaRelayConfiguration *_Nonnull)config completeCallback:(QNMediaRelayResultCallback)callback;`

- *Added*  method `- (void)updateRoomMediaRelay:(nullable QNRoomMediaRelayConfiguration *_Nonnull)config completeCallback:(QNMediaRelayResultCallback)callback;`

- *Added*  method `- (void)stopRoomMediaRelay:(nullable QNMediaRelayResultCallback)callback;`

- *Added*  delegate `- (void)RTCClient:(QNRTCClient *)client didMediaRelayStateChanged:(NSString *)relayRoom state:(QNMediaRelayState)state;`



```
QNClientConfig.h
```
- *Added*  class `QNClientConfig`


```
QNRoomMediaRelayInfo.h
```
- *Added*  class `QNRoomMediaRelayInfo`


```
QNRoomMediaRelayConfiguration.h
```
- *Added*  class `QNRoomMediaRelayConfiguration`

```
QNTypeDefines.h
```
- *Added*   `typedef NS_ENUM(NSUInteger, QNClientMode)`

- *Added*   `typedef NS_ENUM(NSUInteger, QNClientRole)`

- *Added*   `NS_ERROR_ENUM(QNMediaRelayErrorDomain)`

- *Added*   `typedef void (^QNClientRoleResultCallback)(QNClientRole newRole, NSError *error)`

- *Added*   `typedef void (^QNMediaRelayResultCallback)(NSDictionary *state, NSError *error)`

