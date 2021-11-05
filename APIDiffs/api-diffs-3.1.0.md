# QNRTCKit 3.0.2 to 3.1.0 API Differences

## General Headers

```
QNRTCConfiguration.h
```
- *Added*  property `@property (nonatomic, assign) BOOL audioRedundantEnable;`

- *Added*  property `@@property (nonatomic, assign) BOOL videoErrorCorrectionEnable;`


```
QNRTCEngine.h
```
- *Added*  delegate `- (void)RTCEngine:(QNRTCEngine *)engine roomMediaRelayStateDidChange:(NSDictionary *)state;`

- *Added*  delegate `- (void)RTCEngine:(QNRTCEngine *_Nonnull)engine didClientRoleChanged:(QNClientRole)oldRole newRole:(QNClientRole)newRole;`

- *Added*  delegate `- (void)RTCEngine:(QNRTCEngine *)engine remoteTrackMixedDidGetAudioBuffer:(AudioBuffer *)audioBuffer;`

- *Added*  method `- (void)setRoomType:(QNRoomType)type;`

- *Added*  method `- (void)setClientRole:(QNClientRole)role;`

- *Added*  method `- (void)setClientRole:(QNClientRole)role options:(QNClientRoleOptions *_Nullable)options;`

- *Added*  method `- (void)switchRoomWithToken:(NSString *)token;`

- *Added*  method `- (void)startRoomMediaRelay:(QNRoomMediaRelayConfiguration *_Nonnull)config;`

- *Added*  method `- (void)updateRoomMediaRelay:(QNRoomMediaRelayConfiguration *_Nonnull)config;`

- *Added*  method `- (void)stopRoomMediaRelay;`


```
QNObjects.h
```
- *Added*  class `QNClientRoleOptions`

- *Added*  class `QNRoomMediaRelayInfo`

- *Added*  class `QNRoomMediaRelayConfiguration`


```
QNTypeDefines.h
```
- *Added* `typedef NS_ENUM(NSUInteger, QNRoomType)`

- *Added* `typedef NS_ENUM(NSUInteger, QNClientRole)`

- *Added* `typedef NS_ENUM(NSUInteger, QNAudienceLatencyLevelType)`

- *Added* `typedef NS_ENUM(NSUInteger, QNMediaRelayState)`


