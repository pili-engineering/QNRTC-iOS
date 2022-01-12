//
//  QNRoomMediaRelayInfo.h
//  QNRTCKit
//
//  Created by tony.jing on 2021/11/3.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNRoomMediaRelayInfo : NSObject

/*!
 * @abstract 跨房媒体转发 Token。
 *
 * @since v4.0.1
 */
@property (copy, nonatomic) NSString *token;

/*!
 * @abstract 房间名。
 *
 * @since v4.0.1
 */
@property (copy, nonatomic) NSString *roomName;

/*!
 * @abstract 初始化方法。
 *
 * @since v4.0.1
 */
- (instancetype _Nonnull)initWithToken:(NSString *_Nullable)token;

@end

NS_ASSUME_NONNULL_END
