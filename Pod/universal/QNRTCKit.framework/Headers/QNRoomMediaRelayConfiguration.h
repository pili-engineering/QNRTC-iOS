//
//  QNRoomMediaRelayConfiguration.h
//  QNRTCKit
//
//  Created by tony.jing on 2021/11/3.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNRoomMediaRelayInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNRoomMediaRelayConfiguration : NSObject

///源房间信息 QNRoomMediaRelayInfo
@property (strong, nonatomic) QNRoomMediaRelayInfo *sourceInfo;

///目标房间信息 QNRoomMediaRelayInfo 列表
@property (strong, nonatomic, readonly) NSMutableDictionary *destinationInfos;

///设置目标房间信息。
- (BOOL)setDestinationInfo:(QNRoomMediaRelayInfo *_Nonnull)destinationInfo forRoomName:(NSString *_Nonnull)roomName;

///删除目标频道。
- (BOOL)removeDestinationInfoForRoomName:(NSString *_Nonnull)roomName;

@end

NS_ASSUME_NONNULL_END
