//
//  QNLocalAudioTrack.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/7/29.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNLocalTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNLocalAudioTrack : QNLocalTrack

/*!
 * @abstract 用户音量回调，volume 值在 [0, 1] 之间。
 *
 * @since v4.0.1
 */
- (float)getVolumeLevel;

@end

NS_ASSUME_NONNULL_END
