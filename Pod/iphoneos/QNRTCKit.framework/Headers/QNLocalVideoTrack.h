//
//  QNLocalVideoTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/7/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNLocalTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNLocalVideoTrack : QNLocalTrack
/*!
 * @abstract 本地视频 Track 添加 SEI
 *
 * @param videoSEI SEI 内容
 *
 * @param repeatNumber SEI 重复发送次数，-1 为永久发送
 *
 * @discussion 需要停止发送 SEI，可以设置 videoSEI 为 nil，repeatNumber 为 0 即可
 *
 * @since v4.0.0
 */
- (void)sendSEI:(NSString *)videoSEI repeatNmuber:(NSNumber *)repeatNumber;

@end

NS_ASSUME_NONNULL_END
