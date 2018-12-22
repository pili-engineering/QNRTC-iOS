//
//  QNMergeStreamLayout.h
//  QNRTCKit
//
//  Created by lawder on 2018/10/31.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNMergeStreamLayout : NSObject

/**
 @brief 当前要操作的 Track 的 id。
 */
@property (nonatomic, strong) NSString *trackId;

/**
 @brief 该 Track 在合流画面中的大小和位置，该属性仅对视频 Track 有效。
 */
@property (nonatomic, assign) CGRect frame;

/**
 @brief 该 Track 在合流画面中的层次，0 为最底层。该属性仅对视频 Track 有效。
 */
@property (nonatomic, assign) NSUInteger zIndex;

@end

NS_ASSUME_NONNULL_END
