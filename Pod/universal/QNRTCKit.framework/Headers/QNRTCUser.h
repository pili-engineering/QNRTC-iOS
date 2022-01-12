//
//  QNRTCUser.h
//  QNRTCKit
//
//  Created by lawder on 2017/12/5.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNRTCUser : NSObject
/*!
 * @abstract 用户的唯一标识。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) NSString *userID;

/*!
 * @abstract SDK 可将 userData 传给房间中的其它用户，如无需求可置为 nil。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) NSString *userData;

@end

