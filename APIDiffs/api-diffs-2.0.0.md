# QNRTCKit 1.2.0 to 2.0.0 API Differences

```
QNRTCSession.h
```
- *Deprecated*  class `QNRTCSession`

```
QNRTCEngine.h
```
- *Added*  class `QNRTCEngine`

```
QNTrackInfo.h
```
- *Added*  class `QNTrackInfo`

```
QNMergeStreamConfiguration.h
```
- *Added*  class `QNMergeStreamConfiguration`

```
QNMergeStreamLayout.h
```
- *Added*  class `QNMergeStreamLayout`

```
QNWatermarkInfo.h
```
- *Added*  class `QNWatermarkInfo`

```
QNTypeDefines.h
```
- *Modified* `NS_ERROR_ENUM(QNRTCErrorDomain)`
    - *Added* `QNRTCErrorUpdateMergeFailed`
   
- *Added* `typedef NS_ENUM(NSUInteger, QNTrackKind)`
- *Added* `typedef NS_ENUM(NSUInteger, QNRTCSourceType)`

- *Modified* `typedef NS_ENUM(NSUInteger, QNRoomState)`
    - *Added* `QNRoomStateReconnected`



