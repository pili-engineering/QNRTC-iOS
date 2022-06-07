//
//  QNRTCConfiguration.h
//  QNRTCKit
//
//  Created by lawder on 2019/4/10.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract 用来配置 RTC 的相关信息
 *
 * @since v4.0.0
 */
@interface QNRTCConfiguration : NSObject <NSCopying>

/*!
 * @abstract 媒体流的连接方式，默认为 QNRTCPolicyForceUDP
 *
 * @since v4.0.0
 */
@property (nonatomic, assign, readonly) QNRTCPolicy policy;

/*!
 * @abstract 用默认参数生成一个对象
 *
 * @since v4.0.0
 */
+ (instancetype)defaultConfiguration;

/*!
 * @abstract 用给定的 policy 生成一个对象
 *
 * @since v4.0.0
 */
- (instancetype)initWithPolicy:(QNRTCPolicy)policy;

@end

NS_ASSUME_NONNULL_END
