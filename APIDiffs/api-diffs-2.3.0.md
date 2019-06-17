# QNRTCKit 2.2.0 to 2.3.0 API Differences

```
QNMessageInfo.h
```
- *Added*  class `QNMessageInfo`

```
QNRTCConfiguration.h
```
- *Added*  property `@property (nonatomic, assign, readonly) BOOL isStereo;`
- *Added*  property `@property (nonatomic, assign, readonly) QNRTCBWEPolicy bwePolicy;`
- *Added*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy stereo:(BOOL)isStereo;`
- *Added*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy stereo:(BOOL)isStereo bwePolicy:(QNRTCBWEPolicy)bwePolicy;`
```
QNRTCEngine.h
```
- *Added*  `- (void)RTCEngine:(QNRTCEngine *)engine volume:(float)volume ofTrackId:(NSString *)trackId userId:(NSString *)userId;`
- *Added*  `- (void)RTCEngine:(QNRTCEngine *)engine didReceiveMessage:(QNMessageInfo *)message;`
- *Added*  method `- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer asbd:(AudioStreamBasicDescription *)asbd;`
- *Added*  method `- (void)sendMessage:(NSString *)messsage toUsers:(nullable NSArray<NSString *> *)users messageId:(nullable NSString *)messageId;`

```
QNTypeDefines.h
```
   
- *Added* `typedef NS_ENUM(NSUInteger, QNRTCBWEPolicy)`

