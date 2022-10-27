//
//  AudioSourceModel.m
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/19.
//

#import "AudioSourceModel.h"
#import "AssetAudioReader.h"

@interface AudioSourceModel()
{
    CFAbsoluteTime startActualFrameTime;
}

@property (nonatomic, assign, readwrite) int sourceID;
@property (nonatomic, copy, readwrite) NSString *fileName;
@property (nonatomic, strong) AssetAudioReader *reader;
@property (nonatomic, assign, getter=isRunning) BOOL running;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation AudioSourceModel

- (instancetype)initWithFileName:(NSString *)fileName sourceID:(int)sourceID{
    if (self = [super init]) {
        _fileName = fileName;
        _sourceID = sourceID;
        
        NSArray *strArray = [fileName componentsSeparatedByString:@"."];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:strArray[0] ofType:strArray[1]];
        _reader = [[AssetAudioReader alloc] initWithURL:[NSURL fileURLWithPath:filePath]];
    }
    return self;
}

- (void)loopRead {
    [self.lock lock];
    if (self.isRunning) {
        [self.lock unlock];
        return;
    }
    self.running = YES;
    [self.reader seekTo:kCMTimeZero];
    [self resetTime];
    if ([self.reader hasAudio]) {
        [NSThread detachNewThreadSelector:@selector(audioPushProc) toTarget:self withObject:nil];
    }
    [self.lock unlock];
}

- (void)cancelRead {
    self.running = NO;
    [self.reader cancelReading];
}

- (void)audioPushProc {
    @autoreleasepool {
        AudioBufferList audioBufferList;

        while (self.isRunning) {
            [self.lock lock];
            CMSampleBufferRef sample = [_reader readAudioSampleBuffer];
            if (!sample) {
                [_reader seekTo:kCMTimeZero];
                [self resetTime];
            }
            [self.lock unlock];
            
            if (sample) {
                CMBlockBufferRef blockBuffer;
                CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sample, NULL, &audioBufferList, sizeof(audioBufferList), NULL, NULL, 0, &blockBuffer);
                AudioStreamBasicDescription asbd = [self getPushASBD];
                if (self.delegate && [self.delegate respondsToSelector:@selector(audioSourceModel:audioBuffer:asbd:)]) {
                    [self.delegate audioSourceModel:self audioBuffer:&audioBufferList.mBuffers[0] asbd:&asbd];
                }
                CMTime currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(sample);
                CFAbsoluteTime currentActualTime = CFAbsoluteTimeGetCurrent();
                CFAbsoluteTime duration = CMTimeGetSeconds(currentSampleTime);
                if (duration > currentActualTime - startActualFrameTime) {
                    [NSThread sleepForTimeInterval:duration - (currentActualTime - startActualFrameTime)];
                }

                CFRelease(blockBuffer);
                CFRelease(sample);
            }
        }
    }
}

-(void)resetTime {
    startActualFrameTime = CFAbsoluteTimeGetCurrent();
}

- (AudioStreamBasicDescription)getPushASBD {
    AudioStreamBasicDescription asbd = {0};
    asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
    asbd.mSampleRate = 48000;
    asbd.mChannelsPerFrame = 1;

    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFramesPerPacket = 1;
    asbd.mBitsPerChannel = 16;
    asbd.mBytesPerFrame = asbd.mBitsPerChannel / 8 * asbd.mChannelsPerFrame;
    asbd.mBytesPerPacket = asbd.mBytesPerFrame * asbd.mFramesPerPacket;
    asbd.mReserved = 0;
    return asbd;
}
@end
