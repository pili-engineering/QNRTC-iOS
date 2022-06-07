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
 * @since v4.0.0
 */
@property (nonatomic, strong, readonly) NSString *identifier;

/*!
 * @abstract 发送消息的用户的 userID
 *
 * @since v4.0.0
 */
@property (nonatomic, strong, readonly) NSString *userID;

/*!
 * @abstract 发送的消息内容
 *
 * @since v4.0.0
 */
@property (nonatomic, strong, readonly) NSString *content;

/*!
 * @abstract 服务器收到消息的时间戳
 *
 * @since v4.0.0
 */
@property (nonatomic, strong, readonly) NSNumber *timestamp;

@end

NS_ASSUME_NONNULL_END
