//
//  QRDNetworkUtil.m
//  QNRTCTestDemo
//
//  Created by hxiongan on 2018/8/16.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import "QRDNetworkUtil.h"

@implementation QRDNetworkUtil

+ (void)requestTokenWithRoomName:(NSString *)roomName
                           appId:(NSString *)appId
                          userId:(NSString *)userId
               completionHandler:(void (^)(NSError *, NSString *))completionHandler {
    
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api-demo.qnsdk.com/v1/rtc/token/admin/app/%@/room/%@/user/%@?bundleId=%@", appId, roomName, userId, [[NSBundle mainBundle] bundleIdentifier]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(error, nil);
            });
            return;
        }
        
        NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, token);
        });
    }];
    [task resume];
}

+ (void)requestRoomUserListWithRoomName:(NSString *)roomName appId:(NSString *)appId completionHandler:(void (^)(NSError *, NSDictionary *))completionHandler {
    
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api-demo.qnsdk.com/v1/rtc/users/app/%@/room/%@", appId, roomName]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(error, nil);
            });
            return;
        }
        
        NSDictionary * userListDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, userListDic);
        });
    }];
    [task resume];
}
@end
