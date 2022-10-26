# QNRTCKit 5.1.1 to 5.2.0 API Differences

## General Headers

```
QNRTCConfiguration
```
- *Added*  property `@property (nonatomic, assign, readonly) BOOL maintainResolutionEnabled;
`
- *Added*  property `@property (nonatomic, assign, readonly) BOOL communicationModeOn;`
- *Added*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy maintainResolutionEnabled:(BOOL)maintainResolutionEnabled;`
- *Added*  method `- (instancetype)initWithPolicy:(QNRTCPolicy)policy maintainResolutionEnabled:(BOOL)maintainResolutionEnabled communicationModeOn:(BOOL)communicationModeOn;`

```
QNMicrophoneAudioTrack
```
- *Added*  method `- (void)destroyAudioMusicMixer;`
- *Added*  method `- (void)destroyAudioEffectMixer;`
- *Added*  method `- (QNAudioSourceMixer *)createAudioSourceMixer:(id<QNAudioSourceMixerDelegate>)sourceMixerDelegate;`
- *Added*  method `- (void)destroyAudioSourceMixer;`
- *Added*  method `- (void)destroyAudioMusicMixer;`

```
QNAudioMusicMixer
```
- *Added*  method `- (void)setPublishEnabled:(BOOL)publishEnabled;`
- *Added*  method `- (BOOL)isPublishEnabled;`
- *Deprecated* method `- (void)setMixingVolume:(float)volume;`
- *Deprecated* method `- (float)getMixingVolume;`
- *Added* method `- (void)setMusicVolume:(float)volume;`
- *Added* method `- (float)getMusicVolume;`

```
QNAudioEffecMixer
```
- *Added*  method `- (void)destroyAudioEffectWithEffectID:(int)effectID;`
- *Added*  method `- (void)setPublishEnabled:(BOOL)publishEnabled effectID:(int)effectID;`
- *Added*  method `- (BOOL)isPublishEnabled:(int)effectID;`
- *Deprecated*  method `- (void)setEffectID:(int)effectID volume:(float)volume`
- *Added*  method `- (void)setVolume:(float)volume effectID:(int)effectID;`

```
QNAudioSourceMixer
```
- *Added*  method `- (QNAudioSource *)createAudioSourceWithSourceID:(int)sourceID;`
- *Added*  method `- (QNAudioSource *)createAudioSourceWithSourceID:(int)sourceID blockingMode:(BOOL)blockingMode;`
- *Added*  method `- (void)destroyAudioSourceWithSourceID:(int)sourceID;`
- *Added*  method `- (void)setPublishEnabled:(BOOL)publishEnabled sourceID:(int)sourceID;`
- *Added*  method `- (BOOL)isPublishEnabled:(int)sourceID;`
- *Added*  method `- (void)setVolume:(float)volume sourceID:(int)sourceID;`
- *Added*  method `- (float)getVolume:(int)sourceID;`
- *Added*  method `- (void)setAllSourcesVolume:(float)volume;`
- *Added*  method `- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer asbd:(AudioStreamBasicDescription *)asbd sourceID:(int)sourceID;`

```
QNAudioSourceMixerDelegate
```
- *Added*  method `- (void)audioSourceMixer:(QNAudioSourceMixer *)audioSourceMixer didFailWithError:(NSError *)error;`

```
QNAudioSource
```
- *Added*  method `- (int)getID;`

```
QNAudioMixErrorDomain
```
- *Added*  enum `QNAudioMixErrorInvalidID`
