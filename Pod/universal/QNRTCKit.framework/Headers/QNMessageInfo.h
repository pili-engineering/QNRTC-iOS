//
//  QNMessageInfo.h
//  QNRTCKit
//
//  Created by lawder on 2019/1/18.
//  Copyright © 2019年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNMessageInfo : NSObject

/*!
 * @abstract 发送消息时传入的消息 id
 *
 * @since v2.3.0
 */
@property (nonatomic, strong) NSString *identifier;

/*!
 * @abstract 发送消息的用户的 userId
 *
 * @since v2.3.0
 */
@property (nonatomic, strong) NSString *userId;

/*!
 * @abstract 发送的消息内容
 *
 * @since v2.3.0
 */
@property (nonatomic, strong) NSString *content;

/*!
 * @abstract 服务器收到消息的时间戳
 *
 * @since v2.3.0
 */
@property (nonatomic, strong) NSNumber *timestamp;

@end

NS_ASSUME_NONNULL_END
