//
//  QNConnectionDisconnectedInfo.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/12/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNConnectionDisconnectedInfo : NSObject

/*!
 * @abstract 用户房间断开的原因。
 *
 * @since v4.0.0
 */
@property (nonatomic, readonly) QNConnectionDisconnectedReason reason;

/*!
 * @abstract 断开房间错误信息。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
