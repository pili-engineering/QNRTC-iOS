//
//  QNCDNStreamingClient.h
//  QNRTCKit
//
//  Created by ShengQiang'Liu on 2023/11/6.
//  Copyright © 2023 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNCDNStreamingConfig.h"
#import "QNCDNStreamingStats.h"

NS_ASSUME_NONNULL_BEGIN

@class QNCDNStreamingClient;

@protocol QNCDNStreamingDelegate <NSObject>

/*!
 * @abstract 推流状态回调
 *
 * @param client 推流实例
 * @param state 推流状态
 * @param code 错误码，请参考 QNErrorCode
 * @param message 描述信息
 *
 * @since v6.0.0
 */
- (void)cdnStreamingClient:(QNCDNStreamingClient *)client didCDNStreamingConnectionStateChanged:(QNConnectionState)state
                 errorCode:(int)code
                   message:(NSString *)message;

/*!
 * @abstract 推流统计信息回调
 *
 * @param stats 统计信息
 * @see QNCDNStreamingStats.
 *
 * @since v6.0.0
 */
- (void)cdnStreamingClient:(QNCDNStreamingClient *)client didCDNStreamingStats:(QNCDNStreamingStats *)stats;

@end

@interface QNCDNStreamingClient : NSObject

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 设置推流回调的监听
 *
 * @see QNCDNStreamingDelegate.
 *
 * @since v6.0.0
 */
@property (nonatomic, weak) id<QNCDNStreamingDelegate> delegate;

/*!
 * @abstract 开始推流到 CDN
 *
 * @param config 推流参数配置。
 * @see QNCDNStreamingConfig.
 * @return 请参考 QNErrorCode
 *
 * @since v6.0.0
 */
- (int)startWithConfig:(QNCDNStreamingConfig *)config;

/*!
 * @abstract 停止推流到 CDN
 *
 * @since v6.0.0
 * @return 请参考 QNErrorCode
 */
- (int)stop;

@end

NS_ASSUME_NONNULL_END
