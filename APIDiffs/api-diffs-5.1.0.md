# QNRTCKit 5.0.0 to 5.1.0 API Differences

## General Headers

```
QNMicrophoneAudioTrack.h
```
- *Added*  method `- (QNAudioMusicMixer *)createAudioMusicMixer:(NSString *)musicPath musicMixerDelegate:(id<QNAudioMusicMixerDelegate>)musicMixerDelegate;`
- *Added*  method `- (QNAudioEffectMixer *)createAudioEffectMixer:(id<QNAudioEffectMixerDelegate>)effectMixerDelegate;`
- *Added*  method `- (void)setEarMonitorEnabled:(BOOL)enabled;`
- *Added*  method `- (BOOL)getEarMonitorEnabled;`
- *Added*  method `- (void)setPlayingVolume:(float)volume;`
- *Added*  method `- (float)getPlayingVolume;`


```
class added
```	
- *Added* class QNAudioMusicMixer
	- *Added* method `+ (int64_t)getDuration:(NSString *)filePath;`
	- *Added* method `- (void)setMixingVolume:(float)volume;`
	- *Added* method `- (float)getMixingVolume;`
	- *Added* method `- (void)setStartPosition:(int64_t)position;`
	- *Added* method `- (int64_t)getStartPosition;`
	- *Added* method `- (int64_t)getCurrentPosition;`
	- *Added* method `- (BOOL)start;`
	- *Added* method `- (BOOL)start:(int)loopCount;`
	- *Added* method `- (BOOL)stop;`
	- *Added* method `- (BOOL)pause;`
	- *Added* method `- (BOOL)resume;`
	- *Added* method `- (BOOL)seekTo:(int64_t)position;`
	- *Added* delegate `- (void)audioMusicMixer:(QNAudioMusicMixer *)audioMusicMixer didFailWithError:(NSError *)error;`
	- *Added* delegate `- (void)audioMusicMixer:(QNAudioMusicMixer *)audioMusicMixer didStateChanged:(QNMusicMixerState)musicMixerState;`
	- *Added* delegate `- (void)audioMusicMixer:(QNAudioMusicMixer *)audioMusicMixer didMixing:(int64_t)currentPosition;`

- *Added* class QNAudioEffect
	- *Added* method `+ (int64_t)getDuration:(NSString *)filePath;`
	- *Added* method `- (int)getID;`
	- *Added* method `- (NSString *)getFilePath;`
	- *Added* method `- (void)setStartPosition:(int64_t)position;`
	- *Added* method `- (int64_t)getStartPosition;`
	- *Added* method `- (void)setLoopCount:(int)loopCount;`
	- *Added* method `- (int)getLoopCount;`
	
- *Added* class QNAudioEffectMixer
	- *Added* method `- (QNAudioEffect *)createAudioEffectWithEffectID:(int)effectID filePath:(NSString *)filePath;`
	- *Added* method `- (BOOL)start:(int)effectID;`
	- *Added* method `- (BOOL)stop:(int)effectID;`
	- *Added* method `- (BOOL)pause:(int)effectID;`
	- *Added* method `- (BOOL)resume:(int)effectID;`
	- *Added* method `- (int64_t)getCurrentPosition:(int)effectID;`
	- *Added* method `- (void)setEffectID:(int)effectID volume:(float)volume;`
	- *Added* method `- (float)getVolume:(int)effectID;`
	- *Added* method `- (void)setAllEffectsVolume:(float)volume;`
	- *Added* method `- (BOOL)stopAll;`
	- *Added* method `- (BOOL)pauseAll;`
	- *Added* method `- (BOOL)resumeAll;`
	- *Added* delegate `- (void)audioEffectMixer:(QNAudioEffectMixer *)audioEffectMixer didFailWithError:(NSError *)error;`
	- *Added* delegate `- (void)audioEffectMixer:(QNAudioEffectMixer *)audioEffectMixer didFinished:(int)effectID;`
