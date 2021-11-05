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

///能加入房间的 Token。
@property (copy, nonatomic) NSString *token;

///房间名。
@property (copy, nonatomic) NSString *roomName;

///用户 ID。
@property (copy, nonatomic) NSString *uid;

///初始化 QNRoomMediaRelayInfo 类
- (instancetype _Nonnull)initWithToken:(NSString *_Nullable)token;

@end

NS_ASSUME_NONNULL_END
