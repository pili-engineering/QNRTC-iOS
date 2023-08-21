//
//  QNRTCLogConfiguration.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2023/2/19.
//  Copyright © 2023 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNRTCLogConfiguration : NSObject

/*!
 * @abstract log 文件存储路径，默认日志文件位于 App Container/Library/Caches/Pili/Logs 目录内
 */
@property (nonatomic, strong) NSString *dir;

/*!
 * @abstract 唯一标识
 *
 * @discussion 用于区分客户及用户，建议传入用户 userID 等唯一标识符；若用户未设置，则默认使用 deviceID 区分
 */
@property (nonatomic, strong) NSString *tag;

/*!
 * @abstract 文件最大 size
 *
 * @discussion 默认为 3MB，传 0 则代表不需要写日志，自定义文件大小范围为 256kb ~ 10MB
 */
@property (nonatomic, assign) long maxSizeInBytes;

/*!
 * @abstract 日志等级
 */
@property (nonatomic, assign) QNRTCLogLevel level;

/*!
 * @abstract 初始化使用默认存储到 App 沙盒的 Container/Library/Caches/Pili/Logs 目录内
 *
 * @discussion 默认日志等级是 QNRTCLogLevelInfo，最多存储 3 个文件，默认每个文件大小的最大限制为 3MB，文件大小限制最多不可超过 10MB
 */
+ (instancetype)defaultRTCLogConfig;

/*!
 * @abstract 初始化使用自定义日志等级，配置存储到 App 沙盒
 *
 * @discussion 最多存储 3 个文件，默认每个文件大小的最大限制为 3MB，文件大小限制最多不可超过 10MB
 */
- (instancetype)initWithLogLevel:(QNRTCLogLevel)level;

@end

NS_ASSUME_NONNULL_END
