//
//  QNMediaRecordInfo.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2024/4/7.
//  Copyright © 2024 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNMediaRecordInfo : NSObject

/*!
 * @abstract 录制文件的存储路径
 *
 * @discussion 支持 wav、aac、mp4 格式
 *
 * @since v6.2.0
 */
@property(nonatomic, copy, readonly) NSString * _Nullable filePath;
 
/*!
 * @abstract 录制文件的大小，单位为字节
 *
 * @since v6.2.0
 */
@property(nonatomic, assign, readonly) int32_t fileSize;

/*!
 * @abstract 录制文件的时长，单位毫秒
 *
 * @since v6.2.0
 */
@property(nonatomic, assign, readonly) int64_t duration;
 
@end

NS_ASSUME_NONNULL_END
