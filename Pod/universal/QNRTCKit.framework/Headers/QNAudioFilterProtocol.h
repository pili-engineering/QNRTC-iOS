//
//  QNAudioFilterProtocol.h
//  QNRTCKit
//
//  Created by ShengQiang'Liu on 2023/8/22.
//  Copyright © 2023 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNAudioFrame.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QNAudioFilterProtocol <NSObject>

/**
 * Audio frame 处理.
 * @param inAudioFrame 需要处理的 audio frame.
 * @param adaptedFrame 处理完的 audio frame.
 * @return
 * - `true`: Success.
 * - `false`: Failure. 丢弃 audio frame.
 */
- (BOOL)adaptAudioFrame:(const QNAudioFrame *)inAudioFrame adaptedFrame:(QNAudioFrame *)adaptedFrame;

/**
 * 获取 QNAudioFilter 类的标识名称
 *
 * @return
 * - 标识名称
 */
- (const NSString *)getName;

/**
 * 开启或者关闭当前 filter.
 * @param enable 是否开启 filter:
 * - `true`: 开启.
 * - `false`: 关闭.
 */
- (void)setEnabled:(BOOL)enable;

/**
 * 检查当前 Filter 是否开启.
 * @return
 * - `true`: 已开启.
 * - `false`: 已关闭.
 */
- (BOOL)isEnabled;

@end

NS_ASSUME_NONNULL_END
