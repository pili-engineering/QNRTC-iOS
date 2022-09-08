//
//  QNMicrophoneSource.h
//  QNRTCKit
//
//  Created by lawder on 16/5/20.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class QRDMicrophoneSource;

@protocol QRDMicrophoneSourceDelegate <NSObject>

- (void)microphoneSource:(QRDMicrophoneSource *)source didGetAudioBuffer:(AudioBuffer *)audioBuffer;

@end

@interface QRDMicrophoneSource : NSObject

@property (nonatomic, weak) id<QRDMicrophoneSourceDelegate> delegate;

@property (nonatomic, assign) BOOL muted;

@property (nonatomic, assign, readonly) BOOL isRunning;

@property (nonatomic, assign) BOOL allowAudioMixWithOthers;

- (void)startRunning;

- (void)stopRunning;

@end
