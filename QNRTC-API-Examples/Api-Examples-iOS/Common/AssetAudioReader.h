//
//  AssetAudioReader.h
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/18.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AssetAudioReader : NSObject

@property (nonatomic, readonly) BOOL hasAudio;

- (instancetype)initWithURL:(NSURL *)url;

- (void)seekTo:(CMTime)time;

- (CMSampleBufferRef)readAudioSampleBuffer;;

- (void)cancelReading;

@end
