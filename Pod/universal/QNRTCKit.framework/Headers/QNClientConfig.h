//
//  QNClientConfig.h
//  QNRTCKit
//
//  Created by tony.jing on 2021/11/11.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract 用来配置 QNRTCClient 的相关信息
 *
 * @since v4.0.1
 */
@interface QNClientConfig : NSObject

/*!
 * @abstract 使用场景，默认为 QNClientModeRTC
 *
 * @since v4.0.1
 */
@property (nonatomic, assign, readonly) QNClientMode mode;

/*!
 * @abstract 直播场景中（mode 为 "QNClientModeLive" 时）的用户角色。
 *
 * @since v4.0.1
 */
@property (nonatomic, assign, readonly) QNClientRole role;

/*!
 * @abstract 用默认参数生成一个对象
 *
 * @since v4.0.1
 */
+ (instancetype)defaultClientConfig;

/*!
 * @abstract 用指定的 mode 生成一个对象
 *
 * @since v4.0.1
 */
- (instancetype)initWithMode:(QNClientMode)mode;

/*!
 * @abstract 用指定的参数生成一个对象
 *
 * @since v4.0.1
 */
- (instancetype)initWithMode:(QNClientMode)mode role:(QNClientRole)role;

@end

NS_ASSUME_NONNULL_END
