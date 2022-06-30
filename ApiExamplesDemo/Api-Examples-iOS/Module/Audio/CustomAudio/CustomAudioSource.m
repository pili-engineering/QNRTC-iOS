//
//  CustomAudioSource.m
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/30.
//

#import "CustomAudioSource.h"

@interface CustomAudioSource ()
@property (nonatomic, assign) AudioStreamBasicDescription origASDB;
@property (nonatomic, strong) dispatch_queue_t audioOperationQueue;
@property (nonatomic, assign) AUGraph graph;
@property (nonatomic, assign) AudioUnit audioUnit;
@end

@implementation CustomAudioSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.audioOperationQueue = dispatch_queue_create("com.audio.operation.queue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(self.audioOperationQueue, ^{
            [self setupAudioSession];
            [self setupASDB];
            [self initAudioSourceEngine];
        });
    }
    return self;
}

- (void)startCaptureSession {
    dispatch_async(self.audioOperationQueue, ^{
        OSStatus status;
        status = AUGraphInitialize(self.graph);
        if (noErr != status) {
            NSLog(@"AUGraphInitialize error, status = %d", (int)status);
            return;
        }
        
        status = AUGraphStart(self.graph);
        if (noErr != status) {
            NSLog(@"AUGraphStart error, status = %d", (int)status);
            return;
        }
    });
}

- (void)stopCaptureSession {
    dispatch_async(self.audioOperationQueue, ^{
        OSStatus status;
        status = AUGraphStop(self.graph);
        if (noErr != status) {
            NSLog(@"AUGraphStop error, status = %d", (int)status);
            return;
        }
    });
}

- (void)initAudioSourceEngine {
    // 设置 AudioComponentDescription
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    
    // 获取 Audio Unit 实例
    OSStatus status = NewAUGraph(&_graph);
    if (noErr != status) {
        NSLog(@"NewAUGraph error, status = %d", (int)status);
        return;
    }
    
    AUNode ioNode;
    status = AUGraphAddNode(_graph, &acd, &ioNode);
    if (noErr != status) {
        NSLog(@"AUGraphAddNode error, status = %d", (int)status);
        return;
    }
    
    status = AUGraphOpen(_graph);
    if (noErr != status) {
        NSLog(@"AUGraphOpen error, status = %d", (int)status);
        return;
    }
    
    status = AUGraphNodeInfo(_graph, ioNode, NULL, &_audioUnit);
    if (noErr != status) {
        NSLog(@"AUGraphNodeInfo error, status = %d", (int)status);
        return;
    }
    
    // 设置 Audio Unit 属性  Bus 0 is used for the output side, bus 1 is used to get audio input
    // 开启输入 bus1 的 input
    UInt32 enableInput = 1;
    status = AudioUnitSetProperty(_audioUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Input,
                                  1,
                                  &enableInput,
                                  sizeof(enableInput));
    if (noErr != status) {
        NSLog(@"enable i/o input error, status = %d", (int)status);
        return;
    }
    
    // 关闭音频输出 bus0 的 output
    UInt32 disableOutput = 0;
    status = AudioUnitSetProperty(_audioUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Output,
                                  0,
                                  &disableOutput,
                                  sizeof(disableOutput));
    if (noErr != status) {
        NSLog(@"disable i/o output error, status = %d", (int)status);
        return;
    }
    
    // 设置输出 asdb  bus1 的 output
    UInt32 asdbSize = sizeof(AudioStreamBasicDescription);
    status = AudioUnitSetProperty(_audioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  1,
                                  &_origASDB,
                                  asdbSize);
    if (noErr != status) {
        NSLog(@"set asbd error, status = %d", (int)status);
        return;
    }
    
    // 检查 asdb 设置是否生效
    AudioStreamBasicDescription tempAsdb;
    status = AudioUnitGetProperty(_audioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  1,
                                  &tempAsdb,
                                  &asdbSize);
    if (noErr != status) {
        NSLog(@"get asbd error, status = %d", (int)status);
        return;
    }
    
    // 设置最大采集帧数
    UInt32 maxFramesPerSlice = 4096;
    UInt32 maxFramesPerSliceSize = sizeof(maxFramesPerSlice);
    status = AudioUnitSetProperty(_audioUnit,
                                  kAudioUnitProperty_MaximumFramesPerSlice,
                                  kAudioUnitScope_Global,
                                  0,
                                  &maxFramesPerSlice,
                                  maxFramesPerSliceSize);
    if (noErr != status) {
        NSLog(@"set max frames per slice error, status = %d", (int)status);
        return;
    }
    
    // 检查最大帧数设置是否生效
    status = AudioUnitGetProperty(_audioUnit,
                             kAudioUnitProperty_MaximumFramesPerSlice,
                             kAudioUnitScope_Global,
                             0,
                             &maxFramesPerSlice,
                             &maxFramesPerSliceSize);
    if (noErr != status) {
        NSLog(@"get max frames per slice error, status = %d", (int)status);
        return;
    }
    
    // 给 bus0 的 input 设置音频回调监听
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = &inputCallback;
    callbackStruct.inputProcRefCon = (__bridge void *_Nullable)(self);
    status = AudioUnitSetProperty(_audioUnit,
                                  kAudioOutputUnitProperty_SetInputCallback,
                                  kAudioUnitScope_Input,
                                  0,
                                  &callbackStruct
                                  , sizeof(callbackStruct));
    if (noErr != status) {
        NSLog(@"set bus0 input callback error, status = %d", (int)status);
        return;
    }
}

- (void)setupAudioSession {
    NSError *error;

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setPreferredSampleRate:48000 error:&error];
    if (error) {
        NSLog(@"set preferred sample rate failed, error: %@", error.localizedDescription);
    }
    
    [audioSession setPreferredIOBufferDuration:0.002 error:&error];
    if (error) {
        NSLog(@"set preferred io buffer duration failed, error: %@", error.localizedDescription);
    }
    
    AVAudioSessionCategoryOptions option = AVAudioSessionCategoryOptionDefaultToSpeaker |
    AVAudioSessionCategoryOptionAllowBluetooth |
    AVAudioSessionCategoryOptionMixWithOthers;
    
    BOOL success;
    success = [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:option error:&error];
    if (!success) {
        NSLog(@"set category failed error: %@", error.localizedDescription);
        return;
    }
    
    success = [audioSession setActive:YES error:&error];
    if (!success) {
        NSLog(@"set active failed error: %@", error.localizedDescription);
    }
}

- (void)setupASDB {
    // PCM 格式，48000 采样率，16 位宽，单声道
    AudioStreamBasicDescription origASDB;
    origASDB.mFormatID = kAudioFormatLinearPCM;
    origASDB.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsNonInterleaved;
    origASDB.mChannelsPerFrame = 1;
    origASDB.mBitsPerChannel = 8 * sizeof(SInt16);
    origASDB.mBytesPerFrame = sizeof(SInt16);
    origASDB.mFramesPerPacket = 1;
    origASDB.mBytesPerPacket = sizeof(SInt16);
    origASDB.mSampleRate = 48000;
    origASDB.mReserved = 0;
    
    self.origASDB = origASDB;
}

- (AudioStreamBasicDescription)getASDB {
    return self.origASDB;
}

#pragma mark - Audio Unit 监听回调
OSStatus inputCallback(void *                           inRefCon,
                       AudioUnitRenderActionFlags *    ioActionFlags,
                       const AudioTimeStamp *            inTimeStamp,
                       UInt32                            inBusNumber,
                       UInt32                            inNumberFrames,
                       AudioBufferList * __nullable    ioData) {
    
    CustomAudioSource *This = (__bridge CustomAudioSource *)inRefCon;
    
    AudioBuffer buffer;
    buffer.mDataByteSize = inNumberFrames * This.origASDB.mBytesPerFrame;
    buffer.mNumberChannels = This.origASDB.mChannelsPerFrame;
    buffer.mData = malloc(buffer.mDataByteSize);
    
    AudioBufferList bufferList;
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers[0] = buffer;
    
    OSStatus status = AudioUnitRender(This.audioUnit,
                                      ioActionFlags,
                                      inTimeStamp,
                                      1, // bus1
                                      inNumberFrames,
                                      &bufferList);
    
    if (noErr != status) {
        NSLog(@"AudioUnitRender error, status = %d", (int)status);
        return status;
    } else {
        if (This.delegate && [This.delegate respondsToSelector:@selector(customAudioSource:didOutputAudioBufferList:)]) {
            [This.delegate customAudioSource:This didOutputAudioBufferList:&bufferList];
        }
    }

    free(buffer.mData);
    return status;
}

@end
