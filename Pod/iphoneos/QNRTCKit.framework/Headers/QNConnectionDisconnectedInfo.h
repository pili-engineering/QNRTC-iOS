//
//  QNConnectionDisconnectedInfo.h
//  QNRTCKit
//
//  Created by 何云旗 on 2021/8/30.
//  Copyright © 2021 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNConnectionDisconnectedInfo : NSObject

@property (nonatomic, strong) NSError *error;

@property (nonatomic, assign) QNConnectionDisconnectedReason reason;

@end

NS_ASSUME_NONNULL_END
