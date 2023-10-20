//
//  QNAudioVolumeInfo.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2023/5/18.
//  Copyright © 2023 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNAudioVolumeInfo : NSObject
/*!
 * @abstract 用户 ID
 *
 * @since v5.2.3
 */
@property (nonatomic, readonly) NSString *userID;

/*!
 * @abstract 用户实时音量
 *
 * @since v5.2.3
 */
@property (nonatomic, readonly) float volume;
@end

NS_ASSUME_NONNULL_END
