# QNRTCKit 2.4.0 to 2.5.0 API Differences

## General Headers

```
QNRTCEngine.h
```
- *Added*  delegate `- (void)RTCEngine:(QNRTCEngine *)engine didSubscribeProfileChanged:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId;`

- *Added*  delegate `- (void)RTCEngine:(QNRTCEngine *)engine didCreateForwardJobWithJobId:(NSString *)jobId;`

- *Added*  method `- (void)updateSubscribeTracks:(NSArray<QNTrackInfo *> *)tracks;`

- *Added*  method `- (instancetype)initWithConfiguration:(QNRTCConfiguration *)configuration dnsManager:(nullable QNDnsManager *)dnsManager;`

- *Added*  method `- (void)createForwardJobWithConfiguration:(QNForwardStreamConfiguration *)configuration;`

- *Added*  method `- (void)stopForwardJobWithJobId:(NSString *)jobId;`

```
QNTrackInfo.h
```
- *Added*  property `@property (nonatomic, strong) NSMutableArray<QNTrackSubConfiguration *> *subConfigurations;
`
- *Added*  property `@property (nonatomic, assign) BOOL multiStreamEnable;
`

```
QNTypeDefines.h
```
- *Added*   `extern NSString *QNStatisticProfileKey;`

```
QNForwardStreamConfiguration.h
```
- *Added*  class `QNForwardStreamConfiguration`

```
QNTrackSubConfiguration.h
```
- *Added*  class `QNTrackSubConfiguration`