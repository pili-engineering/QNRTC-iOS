# QNRTCKit 2.3.1 to 2.4.0 API Differences

## General Headers

```
QNRTCEngine.h
```
- *Added*  method `- (void)RTCEngine:(QNRTCEngine *)engine didLeaveOfLocalSuccess:(BOOL)success;`


```
QNTypeDefines.h
```
- *Added*   `extern NSString *QNStatisticRttKey;`
- *Added*   `extern NSString *QNStatisticNetworkGrade`
- *Added*   `extern NSString *QNStatisticAudioRemotePacketLossRateKey`
- *Added*   `extern NSString *QNStatisticVideoRemotePacketLossRateKey`

