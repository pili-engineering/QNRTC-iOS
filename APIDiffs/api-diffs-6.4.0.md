# QNRTCKit 6.3.0 to 6.4.0 API Differences

## General Headers
```
QNRTC.h
```
- *Added*  method `+ (QNMediaPlayer *)createMediaPlayer;`

```
QNMediaPlayer.h
```
- *Added*  property `@property (nonatomic, weak) id<QNMediaPlayerDelegate> delegate;`
- *Added*  method `- (int)play:(QNMediaSource *)source;`
- *Added*  method `- (int)pause;`
- *Added*  method `- (int)stop;`
- *Added*  method `- (int)resume;`
- *Added*  method `- (int)seek:(NSUInteger)positionMs;`
- *Added*  method `- (int)getDuration;`
- *Added*  method `- (int)getCurrentPosition;`
- *Added*  method `- (int)setLoopCount:(NSInteger)loopCount;`
- *Added*  method `- (QNPlayerState)getCurrentPlayerState;`
- *Added*  method `- (void)setView:(QNVideoGLView *)videoView;`
- *Added*  method `- (QNCustomVideoTrack *)getMediaPlayerVideoTrack;`
- *Added*  method `- (QNCustomAudioTrack *)getMediaPlayerAudioTrack;`

```
QNPlayerEventInfo
```
- *Added*  property `@property (nonatomic, strong) NSString *message;`
- *Added*  property `@property (nonatomic, assign) int errorCode;`
```

QNMediaSource
```
- *Added*  property `@property (nonatomic, strong) NSString *url;`

```
QNMediaPlayerDelegate
```
- *Added*  method `- (void)mediaPlayer:(QNMediaPlayer *)player didPlayerStateChanged:(QNPlayerState)state;`
- *Added*  method `- (void)mediaPlayer:(QNMediaPlayer *)player didPlayerEvent:(QNPlayerEvent)event eventInfo:(QNPlayerEventInfo *)info;`
- *Added*  method `- (void)mediaPlayer:(QNMediaPlayer *)player didPlayerPositionChanged:(NSUInteger)position;`
```
QNTypeDefines
```
- *Added*  `QNMediaPlayerReasonCode`
- *Added*  `QNPlayerState`
- *Added*  `QNPlayerEvent`
```