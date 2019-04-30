# QNRTCKit 2.1.1 to 2.2.0 API Differences

```
QNAudioEngine.h
```
- *Added*  class `QNAudioEngine`

```
QNRTCConfiguration.h
```
- *Added*  class `QNRTCConfiguration`

```
QNRTCEngine.h
```
- *Added*  property `@property (nonatomic, strong, readonly) QNAudioEngine *audioEngine;`
- *Added*  method `- (instancetype)initWithConfiguration:(QNRTCConfiguration *)configuration;`

```
QNTypeDefines.h
```
   
- *Added* `NS_ERROR_ENUM(QNAudioMixErrorDomain)`
- *Added* `NS_ERROR_ENUM(QNAudioFileErrorDomain)`
- *Added* `typedef NS_ENUM(NSUInteger, QNRTCPolicy)`
- *Added* `typedef NS_ENUM(NSUInteger, QNAudioPlayState)`

