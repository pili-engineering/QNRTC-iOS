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
 * @since v2.2.0
 */
@interface QNRTCConfiguration : NSObject

/*!
 * @abstract 媒体流的连接方式，默认为 QNRTCPolicyForceUDP
 *
 * @since v2.2.0
 */
@property (nonatomic, assign, readonly) QNRTCPolicy policy;

/*!
 * @abstract 是否使用立体声，默认为 NO
 *
 * @since v2.3.0
 */
@property (nonatomic, assign, readonly) BOOL isStereo;

/*!
 * @abstract 带宽估计的策略，默认为 QNRTCBWEPolicyTCC
 *
 * @since v2.3.0
 */
@property (nonatomic, assign, readonly) QNRTCBWEPolicy bwePolicy;

/*!
 * @abstract 是否允许和其它音频一起播放
 *
 * @since v2.3.1
 */
@property (nonatomic, assign, readonly) BOOL allowAudioMixWithOthers;

/*!
 * @abstract 用默认参数生成一个对象
 *
 * @since v2.2.0
 */
+ (instancetype)defaultConfiguration;

/*!
 * @abstract 用给定的 policy 生成一个对象
 *
 * @since v2.2.0
 */
- (instancetype)initWithPolicy:(QNRTCPolicy)policy;

/*!
 * @abstract 用指定的参数生成一个对象
 *
 * @since v2.3.0
 */
- (instancetype)initWithPolicy:(QNRTCPolicy)policy stereo:(BOOL)isStereo;

/*!
 * @abstract 用指定的参数生成一个对象
 *
 * @since v2.3.0
 */
- (instancetype)initWithPolicy:(QNRTCPolicy)policy stereo:(BOOL)isStereo bwePolicy:(QNRTCBWEPolicy)bwePolicy;

/*!
* @abstract 用指定的参数生成一个对象
*
* @since v2.3.1
*/
- (instancetype)initWithPolicy:(QNRTCPolicy)policy
                        stereo:(BOOL)isStereo
                     bwePolicy:(QNRTCBWEPolicy)bwePolicy
       allowAudioMixWithOthers:(BOOL)allowAudioMixWithOthers;


@end

NS_ASSUME_NONNULL_END
