# QNRTCKit 2.0.0 to 2.1.0 API Differences

```
QNUtil.h
```
- *Added*  class `QNUtil`

```
QNRTCEngine.h
```
- *Added*  `- (void)RTCEngine:(QNRTCEngine *)engine microphoneSourceDidGetAudioBuffer:(AudioBuffer *)audioBuffer asbd:(const AudioStreamBasicDescription *)asbd;`
- *Added* `- (void)RTCEngine:(QNRTCEngine *)engine didChangeAudioOutputToDevice:(QNAudioDeviceType)deviceType;`
- *Added* `- (void)setDefaultOutputAudioPortToSpeaker:(BOOL)defaultToSpeaker;`
- *Added* `- (void)setSpeakerOn:(BOOL)speakerOn;`

```
QNTypeDefines.h
```
 
- *Added* `NS_ENUM(NSUInteger, QNAudioDeviceType)`




