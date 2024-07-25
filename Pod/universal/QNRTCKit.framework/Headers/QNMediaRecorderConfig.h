//
//  QNMediaRecorderConfig.h
//  QNRTCKit
//
//  Created by 冯文秀 on 2024/4/3.
//  Copyright © 2024 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNTypeDefines.h"
#import "QNTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNMediaRecorderConfig : NSObject
/*!
 * @abstract 文件路径
 *
 * @warning 自定义传入的路径，请确保路径完整精确到文件名和类型，存在有效且可读可写
 *          传空则默认存储在 App Container/Library/Caches/Pili/RecordFile
 *
 * @discussion 支持 aac、wav、mp4
 *
 * @since v6.2.0
 */
@property (nonatomic, copy, readonly) NSString * _Nullable filePath;
 
/*!
 * @abstract 本地音频，支持麦克风或自定义音频
 *
 * @discussion 仅支持一路音频轨的设置，重复设置会被覆盖
 *
 * @since v6.2.0
 */
@property (nonatomic, strong, readonly) QNLocalAudioTrack *localAudioTrack;

/*!
 * @abstract 本地视频，支持摄像头或自定义视频
 *
 * @discussion 仅支持一路视频轨的设置，重复设置会被覆盖
 *
 * @since v6.2.0
 */
@property (nonatomic, strong, readonly) QNLocalVideoTrack *localVideoTrack;

/*!
 * @abstract 初始化指定文件路径、本地音频录制 Track。
 *
 * @param filePath 文件路径，传空默认存储在 App Container/Library/Caches/Pili/RecordFile
 *
 * @param localAudioTrack 本地音频 Track
 *
 * @param localVideoTrack 本地视频 Track
 *
 * @return 音视频录制配置实例
 *
 * @since v6.2.0
 */
- (instancetype)initWithFilePath:(NSString *_Nullable)filePath
                 localAudioTrack:(QNLocalAudioTrack *_Nullable)localAudioTrack
                 localVideoTrack:(QNLocalVideoTrack *_Nullable)localVideoTrack;
@end

NS_ASSUME_NONNULL_END
