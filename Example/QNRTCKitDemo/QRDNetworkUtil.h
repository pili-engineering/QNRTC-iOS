//
//  QRDNetworkUtil.h
//  QNRTCTestDemo
//
//  Created by hxiongan on 2018/8/16.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRDNetworkUtil : NSObject

+ (void)requestTokenWithRoomName:(NSString *)roomName
                           appId:(NSString *)appId
                          userId:(NSString *)userId
               completionHandler:(void (^)(NSError *error, NSString *token))completionHandler;

+ (void)requestRoomUserListWithRoomName:(NSString *)roomName
                                  appId:(NSString *)appId
                      completionHandler:(void (^)(NSError *error, NSDictionary *userListDic))completionHandler;

@end
