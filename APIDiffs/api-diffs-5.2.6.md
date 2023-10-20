# QNRTCKit 5.2.5 to 5.2.6 API Differences

## General Headers

```
QNMicrophoneAudioTrack
```

- *Deleted*  method `- (QNAudioMusicMixer *)createAudioMusicMixer:(NSString *)musicPath musicMixerDelegate:(id<QNAudioMusicMixerDelegate>)musicMixerDelegate;`
- *Deleted*  method `- (void)destroyAudioMusicMixer;`
- *Deleted*  method `- (QNAudioEffectMixer *)createAudioEffectMixer:(id<QNAudioEffectMixerDelegate>)effectMixerDelegate;`
- *Deleted*  method `- (void)destroyAudioEffectMixer;`
- *Deleted*  method `- (QNAudioSourceMixer *)createAudioSourceMixer:(id<QNAudioSourceMixerDelegate>)sourceMixerDelegate;`
- *Deleted*  method `- (void)destroyAudioSourceMixer;`
- *Deleted*  method `- (void)setEarMonitorEnabled:(BOOL)enabled;`
- *Deleted*  method `- (BOOL)getEarMonitorEnabled;`
- *Deleted*  method `- (void)setPlayingVolume:(float)volume;`
- *Deleted*  method `- (float)getPlayingVolume;`


```
QNLocalAudioTrack
```

- *Added*  method `- (void)setEarMonitorEnabled:(BOOL)enabled;`
- *Added*  method `- (BOOL)getEarMonitorEnabled;`
- *Added*  method `- (void)setPlayingVolume:(float)volume;`
- *Added*  method `- (float)getPlayingVolume;`
- *Added*  method `- (BOOL)addAudioFilter:(id<QNAudioFilterProtocol>)filter;`
- *Added*  method `- (BOOL)removeAudioFilter:(id<QNAudioFilterProtocol>)filter;`

```
QNRTC
```

- *Added*  method `+ (QNAudioMusicMixer *)createAudioMusicMixer:(NSString *)musicPath musicMixerDelegate:(id<QNAudioMusicMixerDelegate>)musicMixerDelegate;`
- *Added*  method `+ (void)destroyAudioMusicMixer:(QNAudioMusicMixer*)mixer;`
- *Added*  method `+ (QNAudioEffectMixer *)createAudioEffectMixer:(id<QNAudioEffectMixerDelegate>)effectMixerDelegate;`
- *Added*  method `+ (void)destroyAudioEffectMixer:(QNAudioEffectMixer*)mixer;`
- *Added*  method `+ (QNAudioSourceMixer *)createAudioSourceMixer:(id<QNAudioSourceMixerDelegate>)sourceMixerDelegate;`
- *Added*  method `+ (void)destroyAudioSourceMixer:(QNAudioSourceMixer*)mixer;`

```
QNRTCClient
```
- *Added*  method `- (void)RTCClient:(QNRTCClient *)client didUserVolumeIndication:(NSArray<QNAudioVolumeInfo *>*)userVolumeList;`
- *Added*  method `- (void)enableAudioVolumeIndication:(int)interval;`
