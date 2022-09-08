//
//  CustomVideoSource.h
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/29.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomVideoSource;

@protocol CustomVideoSourceDelegate <NSObject>

- (void)customVideoSource:(CustomVideoSource *)videoSource didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

@interface CustomVideoSource : NSObject

@property (nonatomic, weak) id<CustomVideoSourceDelegate> delegate;

- (void)startCaptureSession;
- (void)stopCaptureSession;

@end

NS_ASSUME_NONNULL_END
