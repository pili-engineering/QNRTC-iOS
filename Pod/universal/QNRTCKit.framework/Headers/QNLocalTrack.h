//
//  QNLocalTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/7/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNLocalTrack : QNTrack
/*!
 * @abstract 将本地音/视频 Track 置为 muted 状态。
 *
 * @discussion 需要发布成功后才可以执行 mute 操作。
 *
 * @since v4.0.0
 */
- (void)updateMute:(BOOL)mute;

@end

NS_ASSUME_NONNULL_END
