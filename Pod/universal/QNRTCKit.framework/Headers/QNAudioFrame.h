//
//  QNAudioFrame.h
//  QNRTCKit
//
//  Created by ShengQiang'Liu on 2023/9/7.
//  Copyright © 2023 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

enum QNBytesPerSample {
  kTwoBytesPerSample = 2,
};

// Stereo, 32 kHz, 120 ms (2 * 32 * 120)
static const int kQNMaxDataSizeSamples = 7680;
static const int kQNMaxDataSizeBytes = kQNMaxDataSizeSamples * sizeof(int16_t);

@interface QNAudioFrame : NSObject

@property (nonatomic, assign) uint32_t captureTimestamp;
@property (nonatomic, assign) size_t samplesPerChannel;
@property (nonatomic, assign) int sampleRateHz;
@property (nonatomic, assign) size_t numChannels;
@property (nonatomic, assign, readonly) enum QNBytesPerSample bytePerSample;
// 最大 size 为 kQNMaxDataSizeBytes
@property (nonatomic, strong) NSData *data;

@end

NS_ASSUME_NONNULL_END
