//
//  AudioSourceModel.h
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AudioSourceModel;

@protocol AudioSourceModelDelegate <NSObject>

- (void)audioSourceModel:(AudioSourceModel *)audioSourceModel audioBuffer:(AudioBuffer *)audioeBuffer asbd:(AudioStreamBasicDescription *)asbd;

@end

@interface AudioSourceModel : NSObject
@property (nonatomic, weak) id<AudioSourceModelDelegate> delegate;
@property (nonatomic, assign, readonly) int sourceID;
@property (nonatomic, copy, readonly) NSString *fileName;

- (instancetype)initWithFileName:(NSString *)fileName sourceID:(int)sourceID;
- (void)loopRead;
- (void)cancelRead;
@end

NS_ASSUME_NONNULL_END
