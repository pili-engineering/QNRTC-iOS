//
//  QNTranscodingLiveStreamingImage.h
//  QNRTCKit
//
//  Created by tony.jing on 2021/8/17.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNTranscodingLiveStreamingImage : NSObject
/*!
 * @abstract 设置图片在合流画布中所在位置
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) CGRect frame;

/*!
 * @abstract 设置图片地址，仅支持 HTTP
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) NSString *imageUrl;

@end

NS_ASSUME_NONNULL_END
