//
//  QNNetworkQuality.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/8/24.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNNetworkQuality : NSObject

/*!
 * @abstract 上行网络质量。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) QNNetworkGrade uplinkNetworkGrade;

/*!
 * @abstract 下行网络质量。
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) QNNetworkGrade downlinkNetworkGrade;

@end

NS_ASSUME_NONNULL_END
