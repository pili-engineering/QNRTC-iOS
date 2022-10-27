//
//  AssetAudioReader.m
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/18.
//

#import "AssetAudioReader.h"

@interface AssetAudioReader ()

@property (strong, nonatomic) AVAsset *inputAsset;
@property (strong, nonatomic) AVAssetReader *assetReader;
@property (strong, nonatomic) AVAssetReaderTrackOutput *audioReaderOutput;
@property (assign, nonatomic) CMTime startTime;
@end

@implementation AssetAudioReader


- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.inputAsset = [AVAsset assetWithURL:url];
        [self setupWithStartTime:kCMTimeZero];
    }
    return self;
}

- (BOOL)hasAudio {
    AVAsset *asset = [self.assetReader asset];
    return [asset tracksWithMediaType:(AVMediaTypeAudio)].count > 0;
}

- (void)seekTo:(CMTime)time {
    if (self.assetReader) {
        [self.assetReader cancelReading];
        self.assetReader = nil;
    }
    
    [self setupWithStartTime:time];
}

- (void)setupWithStartTime:(CMTime)startTime {
    if (CMTimeCompare(self.inputAsset.duration, startTime) <= 0) {
        NSLog(@"error: the start time > duration");
        return;
    }
    self.startTime = startTime;
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *audioCompositionTrack = nil;
    
    NSArray *audioAssetTracks = [self.inputAsset tracksWithMediaType:AVMediaTypeAudio];
    if (audioAssetTracks.count) {
        audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        AVAssetTrack *audioTrack = [audioAssetTracks firstObject];
        CMTimeRange range = CMTimeRangeMake(startTime, CMTimeSubtract(self.inputAsset.duration, startTime));
        [audioCompositionTrack insertTimeRange:range ofTrack:audioTrack atTime:kCMTimeZero error:nil];
    }
    
    [self startWithAsset:composition];
}

- (void)startWithAsset:(AVAsset *)asset {
    NSError *error = nil;
    self.assetReader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    
    if ([asset tracksWithMediaType:AVMediaTypeAudio].count) {
        AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        
        NSDictionary *audioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                       [NSNumber numberWithInteger:1], AVNumberOfChannelsKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                       [NSNumber numberWithInteger:16], AVLinearPCMBitDepthKey,
                                       [NSNumber numberWithFloat:48000], AVSampleRateKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,// why must be NO
                                       nil];
        _audioReaderOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack
                                                                        outputSettings:audioSettings];
        
        [_assetReader addOutput:_audioReaderOutput];
        _audioReaderOutput.supportsRandomAccess = NO;
    }
    
    if (_assetReader.outputs.count) {
        [_assetReader startReading];
    } else {
        NSLog(@"asset reader output count is zero!");
    }
}

- (CMSampleBufferRef)readAudioSampleBuffer {
    if (AVAssetReaderStatusReading != _assetReader.status) {
        NSLog(@"asset reader status is not reading!");
        return NULL;
    }
    CMSampleBufferRef audioSample = [_audioReaderOutput copyNextSampleBuffer];
    return audioSample;
}

- (void)cancelReading {
    [_assetReader cancelReading];
    _assetReader = nil;
}

@end
