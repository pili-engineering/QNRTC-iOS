//
//  QNTrackSubConfiguration.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2020/7/21.
//  Copyright © 2020 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QNTrackSubProfile){
    QNTrackSubProfileLow = 0,
    QNTrackSubProfileMedium = 1,
    QNTrackSubProfileHigh = 2
};

@interface QNTrackSubConfiguration : NSObject
<
NSCopying
>

/**
 @brief 当前 trackLayer 的质量，默认 QNTrackSubProfileLow
 */
@property (nonatomic, assign) QNTrackSubProfile profile;

/**
@brief 是否订阅当前 profile 下的 track，默认为 NO 不订阅，初始化默认在 QNTrackSubProfileLow 会订阅
*/
@property (nonatomic, assign) BOOL chooseSub;

/**
@brief 是否固定，默认为 NO 不固定

@warning 目前版本仅支持不固定，暂未支持固定
*/
@property (nonatomic, assign) BOOL isMaintain;

/**
 @brief 当前 profile 是否订阅生效
*/
@property (nonatomic, assign, readonly) BOOL profileSubscribed;
@end

NS_ASSUME_NONNULL_END
