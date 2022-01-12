//
//  QNLiveStreamingErrorInfo.h
//  QNRTCKit
//
//  Created by tony.jing on 2021/8/17.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"

typedef NS_ENUM(NSUInteger, QNLiveStreamingType){
    QNLiveStreamingTypeStart = 0,
    QNLiveStreamingTypeStop = 1,
    QNLiveStreamingTypeUpdate = 2
};

@interface QNLiveStreamingErrorInfo : NSObject

/*!
 * @abstract error
 *
 * @since v4.0.0
 */
@property (nonatomic, strong) NSError * error;

/*!
 * @abstract 触发错误归属类型
 *
 * @since v4.0.0
 */
@property (nonatomic, assign) QNLiveStreamingType type;

@end


