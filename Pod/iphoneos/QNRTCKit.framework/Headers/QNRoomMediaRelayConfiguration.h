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

/*!
 * @abstract 源房间信息。
 *
 * @see QNRoomMediaRelayInfo
 *
 * @since v4.0.1
 */
@property (strong, nonatomic) QNRoomMediaRelayInfo *srcRoomInfo;

/*!
 * @abstract 目标房间信息 QNRoomMediaRelayInfo 列表。
 *
 * @see QNRoomMediaRelayInfo
 *
 * @since v4.0.1
 */
@property (strong, nonatomic, readonly) NSMutableDictionary *destRoomInfos;

/*!
 * @abstract 设置目标房间信息。
 *
 * @param destRoomInfo 目标房间信息
 *
 * @param roomName 目标房间名，该参数必填，且需与该方法 destRoomInfo 参数中的 roomName 一致
 *
 * @discussion 如果你想将流转发到多个目标房间，可以多次调用该方法，设置多个房间的 QNRoomMediaRelayInfo。
 *
 * @since v4.0.1
 */
- (BOOL)setDestRoomInfo:(QNRoomMediaRelayInfo *_Nonnull)destRoomInfo forRoomName:(NSString *_Nonnull)roomName;

/*!
 * @abstract 删除目标房间。
 *
 * @param roomName 将要删除的目标房间名
 *
 * @since v4.0.1
 */
- (BOOL)removeDestRoomInfoForRoomName:(NSString *_Nonnull)roomName;

@end

NS_ASSUME_NONNULL_END
