//
//  QNCustomAudioTrackConfig.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/6/21.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNAudioQuality.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNCustomAudioTrackConfig : NSObject

/*!
 * @abstract Track 的 tag，SDK 会将其透传到远端，当发布多路 Track 时可用 tag 来作区分。
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) NSString * tag;

/*!
 * @abstract 音频质量配置。
 *
 * @since v5.0.0
 */
@property (nonatomic, strong, readonly) QNAudioQuality *audioQuality;

/*!
 * @abstract 初始化默认 Track 配置。
 *
 * @discussion 默认 tag 为 ""、码率为 64kbps。
 *
 * @since v5.0.0
 */
+ (instancetype)defaultCustomAudioTrackConfig;

/*!
 * @abstract 初始化指定 tag 参数的 Track 配置。
 *
 * @discussion 默认码率为 64kbps。
 *
 * @param tag 区分多路 Track
 *
 * @since v4.0.0
 */
- (instancetype)initWithTag:(NSString *)tag;

/*!
 * @abstract 初始化指定 tag、bitrate (单位 kbps) 参数的 Track 配置。
 *
 * @param tag 区分多路 Track
 *
 * @param audioQuality 音频编码配置
 *
 * @since v5.0.0
 */
- (instancetype)initWithTag:(NSString *)tag
               audioQuality:(QNAudioQuality *)audioQuality;

@end

NS_ASSUME_NONNULL_END
