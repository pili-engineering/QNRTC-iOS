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
 * @abstract 固定分辨率，默认为 NO
 *
 * @since v5.2.0
 */
@property (nonatomic, assign, readonly) BOOL maintainResolutionEnabled __deprecated_msg("Method deprecated in v5.2.3. Use `QNDegradationPreference`");

/*!
 * @abstract 是否使用通话模式，默认为 YES
 *
 * @warning 使用声卡并配戴耳机的情况下，建议关闭该配置，可解决声卡模式不匹配带来的音频异常无效等问题
 *          关闭该模式将直接关闭硬件回声消除，不佩戴耳机的情况下连麦，可能出现回声
 *
 * @since v5.2.0
 */
@property (nonatomic, assign, readonly) BOOL communicationModeOn __deprecated_msg("Method deprecated in v5.2.3. Use `initWithPolicy:`");

/*!
 * @abstract 音频场景，默认为 QNAudioSceneDefault
 *
 * @warning 可通过 QNRTC 调用 setAudioScene 动态设置
 *
 * @since v5.2.3
 */
@property (nonatomic, assign, readonly) QNAudioScene audioScene;

/*!
 * @abstract SDK 与七牛服务器由于网络原因断开后，内部尝试重连的超时时间，单位： ms，默认 30s
 *
 * @warning 建议在重连超时收到 QNRTCErrorNetworkTimeout 后做新的业务处理
 *
 * @since v5.2.4
 */
@property (nonatomic, assign, readonly) int reconnectionTimeout;
/*!
 * @abstract 设置编码器类型，默认使用 QNVideoEncoderToolboxH264
 *
 *
 * @since v5.2.4
 */
@property (nonatomic, assign, readonly) QNVideoEncoderType encoderType;

/*!
 * @abstract 预设登录服务器域名
 *
 * @warning 当设置 mcuDomain 自定义域名，默认优先访问自定义域名，自定义域名访问异常时，内部会自动会切到默认域名进行访问
 *
 * @since v5.2.5
 */
@property (nonatomic, strong) NSArray* mcuDomains;


/*!
 * @abstract 用默认参数生成一个对象
 *
 * @since v4.0.0
 */
+ (instancetype)defaultConfiguration;

/*!
 * @abstract 用指定的 policy 生成一个对象
 *
 * @since v4.0.0
 */
- (instancetype)initWithPolicy:(QNRTCPolicy)policy;

/*!
 * @abstract 用指定的 policy 、maintainResolutionEnabled 生成一个对象
 *
 * @since v5.2.0
 */
- (instancetype)initWithPolicy:(QNRTCPolicy)policy maintainResolutionEnabled:(BOOL)maintainResolutionEnabled __deprecated_msg("Method deprecated in v5.2.3. Use `initWithPolicy:`");

/*!
 * @abstract 用指定的 policy 、maintainResolutionEnabled、communicationModeOn 生成一个对象
 *
 * @since v5.2.0
 */
- (instancetype)initWithPolicy:(QNRTCPolicy)policy maintainResolutionEnabled:(BOOL)maintainResolutionEnabled
           communicationModeOn:(BOOL)communicationModeOn __deprecated_msg("Method deprecated in v5.2.3. Use `initWithPolicy:`");

/*!
 * @abstract 用指定的 policy 、audioScene 生成一个对象
 *
 * @since v5.2.3
 */
- (instancetype)initWithPolicy:(QNRTCPolicy)policy audioScene:(QNAudioScene)audioScene;


/*!
 * @abstract 用指定的 policy 、audioScene 、reconnectionTimeout 生成一个对象
 *
 * @param policy 用指定的连接方式
 * @param audioScene 场景
 * @param reconnectionTimeout 重连超时间单位（ms）
 * @since v5.2.4
 */
- (instancetype)initWithPolicy:(QNRTCPolicy)policy audioScene:(QNAudioScene)audioScene reconnectionTimeout:(int)reconnectionTimeout;

/*!
 * @abstract 用指定的 policy 、audioScene 、reconnectionTimeout 、encoderType生成一个对象
 *
 * @param policy 用指定的连接方式
 * @param audioScene 场景
 * @param reconnectionTimeout 重连超时间单位（ms）
 * @param encoderType 视频编码类型
 * @since v5.2.4
 */
- (instancetype)initWithPolicy:(QNRTCPolicy)policy audioScene:(QNAudioScene)audioScene reconnectionTimeout:(int)reconnectionTimeout encoderType:(QNVideoEncoderType)encoderType;


@end

NS_ASSUME_NONNULL_END
