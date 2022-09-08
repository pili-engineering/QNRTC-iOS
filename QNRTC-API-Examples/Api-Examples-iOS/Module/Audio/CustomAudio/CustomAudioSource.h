//
//  CustomAudioSource.h
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomAudioSource;

@protocol CustomAudioSourceDelegate <NSObject>

- (void)customAudioSource:(CustomAudioSource *)audioSource didOutputAudioBufferList:(AudioBufferList *)audioBufferList;

@end

@interface CustomAudioSource : NSObject

@property (nonatomic, weak) id<CustomAudioSourceDelegate> delegate;

- (void)startCaptureSession;
- (void)stopCaptureSession;
- (AudioStreamBasicDescription)getASDB;

@end

NS_ASSUME_NONNULL_END
