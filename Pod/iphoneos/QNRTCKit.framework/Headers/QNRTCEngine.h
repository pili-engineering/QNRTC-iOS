//
//  QNRTCEngine.h
//  QNRTCKit
//
//  Created by lawder on 2017/12/3.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QNTypeDefines.h"
#import "QNVideoRender.h"
#import "QNTrackInfo.h"
#import "QNMergeStreamConfiguration.h"
#import "QNMergeStreamLayout.h"
#import "QNAudioEngine.h"
#import "QNMessageInfo.h"
#import "QNForwardStreamConfiguration.h"
#import <HappyDNS/HappyDNS.h>

@class QNRTCEngine;
@class QNRTCConfiguration;

NS_ASSUME_NONNULL_BEGIN

/*!
 * @protocol QNRTCEngineDelegate
 *
 * @discussion QNRTCEngine 在运行过程中的状态和事件回调。
 *
 * @since v2.0.0
 */
@protocol QNRTCEngineDelegate <NSObject>

@optional

/*!
 * @abstract SDK 运行过程中发生错误会通过该方法回调。
 *
 * @discussion 具体错误码的含义可以见 QNTypeDefines.h 文件。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didFailWithError:(NSError *)error;

/*!
 * @abstract 房间状态变更的回调。
 *
 * @discussion 当状态变为 QNRoomStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leaveRoom 即可。
 * 重连成功后的状态为 QNRoomStateReconnected。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine roomStateDidChange:(QNRoomState)roomState;

/*!
 * @abstract 本地音/视频 Track 成功发布的回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didPublishLocalTracks:(NSArray<QNTrackInfo *> *)tracks;

/*!
 * @abstract 远端用户加入房间的回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didJoinOfRemoteUserId:(NSString *)userId userData:(NSString *)userData;

/*!
 * @abstract 远端用户离开房间的回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didLeaveOfRemoteUserId:(NSString *)userId;

/*!
 * @abstract 订阅远端用户成功的回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didSubscribeTracks:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId;

/*!
 * @abstract 订阅远端用户 profile 发生改变的回调
 *
 * @since v2.5.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didSubscribeProfileChanged:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId;

/*!
 * @abstract 远端用户发布音/视频的回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didPublishTracks:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId;

/*!
 * @abstract 远端用户取消发布音/视频的回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didUnPublishTracks:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId;

/*!
 * @abstract 被 userId 踢出的回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didKickoutByUserId:(NSString *)userId;

/*!
 * @abstract 远端用户音频状态变更为 muted 的回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didAudioMuted:(BOOL)muted ofTrackId:(NSString *)trackId byRemoteUserId:(NSString *)userId;

/*!
 * @abstract 远端用户视频状态变更为 muted 的回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didVideoMuted:(BOOL)muted ofTrackId:(NSString *)trackId byRemoteUserId:(NSString *)userId;

/*!
 * @abstract 远端用户视频首帧解码后的回调。
 *
 * @discussion 如果需要渲染，则需要返回一个带 renderView 的 QNVideoRender 对象。
 *
 * @since v2.0.0
 */
- (QNVideoRender *)RTCEngine:(QNRTCEngine *)engine firstVideoDidDecodeOfTrackId:(NSString *)trackId remoteUserId:(NSString *)userId;

/*!
 * @abstract 远端用户视频取消渲染到 renderView 上的回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didDetachRenderView:(UIView *)renderView ofTrackId:(NSString *)trackId remoteUserId:(NSString *)userId;

/*!
 * @abstract 远端用户视频数据的回调。
 *
 * @discussion 注意：回调远端用户视频数据会带来一定的性能消耗，如果没有相关需求，不要实现该回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer ofTrackId:(NSString *)trackId remoteUserId:(NSString *)userId;

/*!
 * @abstract 远端用户音频数据的回调。
 *
 * @discussion 注意：回调远端用户音频数据会带来一定的性能消耗，如果没有相关需求，请不要实现该回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine
didGetAudioBuffer:(AudioBuffer *)audioBuffer
    bitsPerSample:(NSUInteger)bitsPerSample
       sampleRate:(NSUInteger)sampleRate
        ofTrackId:(NSString *)trackId
     remoteUserId:(NSString *)userId;

/*!
 * @abstract 摄像头原数据时的回调。
 *
 * @discussion 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致编码帧率下降。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine cameraSourceDidGetSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/*!
 * @abstract 麦克风原数据时的回调。
 *
 * @discussion 需要注意的是这个回调在 AU Remote IO 线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine microphoneSourceDidGetAudioBuffer:(AudioBuffer *)audioBuffer;

/*!
 * @abstract 麦克风原数据时的回调。
 *
 * @discussion 需要注意的是这个回调在 AU Remote IO 线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题。
 *
 * @warning 注意，当接入蓝牙耳机等外置设备时，采样率可能发生改变，具体值可从 asbd 中获取。
 *
 * @since v2.1.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine microphoneSourceDidGetAudioBuffer:(AudioBuffer *)audioBuffer asbd:(const AudioStreamBasicDescription *)asbd;

/*!
 * @abstract 统计信息回调。
 *
 * @discussion 回调的时间间隔由 statisticInterval 参数决定，statisticInterval 默认为 0，即不回调统计信息。
 *
 * @see statisticInterval
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine
  didGetStatistic:(NSDictionary *)statistic
        ofTrackId:(NSString *)trackId
           userId:(NSString *)userId;

/*!
 * @abstract 用户音量回调，包括本地和远端，volume 值在 [0, 1] 之间。
 *
 * @discussion 注意：回调用户音量会带来一定的性能消耗，如果没有相关需求，请不要实现该回调。
 *
 * @since v2.3.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine volume:(float)volume ofTrackId:(NSString *)trackId userId:(NSString *)userId;

/*!
 * @abstract 成功创建合流任务的回调。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didCreateMergeStreamWithJobId:(NSString *)jobId;

/*!
 * @abstract 音频输出设备变更的回调。主动调用的 `- (void)setSpeakerOn:(BOOL)speakerOn;` 不会有该回调。
 *
 * @since v2.1.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didChangeAudioOutputToDevice:(QNAudioDeviceType)deviceType;

/*!
 * @abstract 收到消息的回调。
 *
 * @since v2.3.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didReceiveMessage:(QNMessageInfo *)message;

/*!
 * @abstract 本地用户离开房间成功的回调。
 *
 * @discussion 调用 leaveRoom 离开房间成功的回调
 *
 * @since v2.4.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didLeaveOfLocalSuccess:(BOOL)success;

/*!
 * @abstract 成功创建单路转推任务的回调。
 *
 * @since v2.5.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine didCreateForwardJobWithJobId:(NSString *)jobId;

/*!
* @abstract 远端用户发生重连的回调。
*
* @since v3.0.0
*/
- (void)RTCEngine:(QNRTCEngine *)engine didReconnectingRemoteUserId:(NSString *)userId;

/*!
* @abstract 远端用户重连成功的回调。
*
* @since v3.0.0
*/
- (void)RTCEngine:(QNRTCEngine *)engine didReconnectedRemoteUserId:(NSString *)userId;

@end

@protocol QNRTCEngineEncodeDataDelegate <NSObject>

@optional

/*!
* @abstract 编码数据自定义加密的回调（目前只支持音频）
*
* @discussion 调用此函数，需要把对应的加密数据设置给 encryptedData，并且返回     encryptedData 的实际对应长度
*
* @since v3.0.0
*/
- (size_t)RTCEngine:(QNRTCEngine *)engine
   didSendFrameData:(uint8_t *)frameData
    frameDataLength:(size_t)frameDataLength
      encryptedData:(uint8_t*)encryptedData
          ofTrackId:(NSString *)trackId;

/*!
* @abstract 编码数据自定义拓展的回调 （目前只支持音频）
*
* @warning 最多 1000 个字节
*
* @since v3.0.0
*/
- (size_t)RTCEngine:(QNRTCEngine *)engine
     didSendExtData:(uint8_t *)extData
   extMaxDataLength:(size_t)extMaxDataLength
          ofTrackId:(NSString *)trackId;

/*!
* @abstract 本地编码数据自定义加密最大长度的回调 （目前只支持音频）
*
* @discussion 评估加密数据的最大值，必须设置
*
* @see - (size_t)RTCEngine:(QNRTCEngine *)engine
*         didSendFrameData:(uint8_t *)frameData
*          frameDataLength:(size_t)frameDataLength
*            encryptedData:(uint8_t*)encryptedData
*                ofTrackId:(NSString *)trackId;
*
* @since v3.0.0
*/
- (size_t)RTCEngine:(QNRTCEngine *)engine
  didSendDataLength:(size_t)frameDataLength
          oftrackId:(NSString *)trackId;

/*!
* @abstract 远端加密自定义数据解密的回调 （目前只支持音频）
*
* @discussion 调用此函数，需要把对应的解密数据设置给 decryptedData，并且返回     decryptedData 的实际对应长度
*
* @since v3.0.0
*/
- (size_t)RTCEngine:(QNRTCEngine *)engine
    didGetFrameData:(uint8_t *)frameData
    frameDataLength:(size_t)frameDataLength
      decryptedData:(uint8_t*)decryptedData
          ofTrackId:(NSString *)trackId
           ofUserId:(NSString *)userId;

/*!
* @abstract 远端用户自定义拓展数据的回调 （目前只支持音频）
*
* @since v3.0.0
*/
- (void)RTCEngine:(QNRTCEngine *)engine
    didGetExtData:(uint8_t *)extData
    extDataLength:(size_t)extDataLength
        ofTrackId:(NSString *)trackId
         ofUserId:(NSString *)userId;

/*!
* @abstract 远端数据自定义解密最大长度的回调 （目前只支持音频）
*
* @discussion 评估解密数据的最大值，必须设置
*
* @see - (size_t)RTCEngine:(QNRTCEngine *)engine
*         didGetFrameData:(uint8_t *)frameData
*          frameDataLength:(size_t)frameDataLength
*            decryptedData:(uint8_t*)decryptedData
*                ofTrackId:(NSString *)trackId;
*                 ofUserId:(NSString *)userId;
*
* @since v3.0.0
*/
- (size_t)RTCEngine:(QNRTCEngine *)engine
   didGetDataLength:(size_t)frameDataLength
          oftrackId:(NSString *)trackId
           ofUserId:(NSString *)userId;

@end


@interface QNRTCEngine : NSObject

/*!
 * @abstract 房间状态。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign, readonly) QNRoomState roomState;

/*!
 * @abstract 状态回调的 delegate。
 *
 * @since v2.0.0
 */
@property (nonatomic, weak) id<QNRTCEngineDelegate> delegate;

/*!
* @abstract 编码数据回调的 delegate。
*
* @since v3.0.0
*/
@property (nonatomic, weak) id<QNRTCEngineEncodeDataDelegate> encodeDataDelegate;

/*!
 * @abstract 是否自动订阅远端的流，默认为 YES。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) BOOL autoSubscribe;

/*!
 * @abstract 是否静音远端的声音，设置为 YES 后，本地不会输出远端用户的声音。
 *
 * @discussion 默认为 NO。该值跟房间状态无关，在离开房间后 SDK 并不会重置该值，即会保持您上次设置的值。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign, getter=isMuteSpeaker) BOOL muteSpeaker;

/*!
 * @abstract 统计信息回调的时间间隔。
 *
 * @discussion 单位为秒。默认为 0，即默认不会回调统计信息。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) NSUInteger statisticInterval;

/*!
 * @abstract 连麦房间中的用户的列表。
 *
 * @discussion 该列表不包含自己。当房间状态为 QNRoomStateConnected/QNRoomStateReconnected 才可获取。
 *
 * @see roomState
 *
 * @since v2.0.0
 */
@property (nonatomic, strong, readonly) NSArray<NSString *> *userList;

/*!
 * @abstract 连麦房间中的音频管理类实例。
 *
 * @warning 该值为 QNRTCEngine 的属性，使用方式如下：
 *          self.engine.audioEngine.audioURL = [NSURL URLWithString:@"http://www.xxx.com/test.mp3"];
 *          self.engine.audioEngine.delegate = self;
 *
 * @discussion 需要配置 audioURL 传入音频地址，调用 startAudioMixing 开始混音，调用 stopAudioMixing 停止混音。
 *
 * @since v2.2.0
 */
@property (nonatomic, strong, readonly) QNAudioEngine *audioEngine;
/*!
 * @abstract 用一个 configuration 来初始化 engine。
 *
 * @param
 *    configuration 用于初始化 engine 的配置。
 *
 * @since v2.2.0
 */
- (instancetype)initWithConfiguration:(QNRTCConfiguration *)configuration;

/*!
 * @abstract 用一个 configuration 来初始化 engine。
 *
 * @param configuration 用于初始化 engine 的配置。
 *
 * @param dnsManager 自定义 DNS 解析
 *
 * @since v2.5.0
 */
- (instancetype)initWithConfiguration:(QNRTCConfiguration *)configuration dnsManager:(nullable QNDnsManager *)dnsManager;

/*!
 * @abstract 加入房间。
 *
 * @param
 *    token 此处 token 需要 App 从 App Server 中获取，token 中已经包含 appId、roomToken、userId 等信息。
 *
 * @since v2.0.0
 */
- (void)joinRoomWithToken:(NSString *)token;

/*!
 * @abstract 加入房间。
 *
 * @param
 *    token 此处 token 需要 App 从 App Server 中获取，token 中已经包含 appId、roomToken、userId 等信息。
 *
 * @param
 *    userData SDK 可将 userData 传给房间中的其它用户，如无需求可置为 nil。
 *
 * @see - (void)RTCEngine:(QNRTCEngine *)engine didJoinOfRemoteUserId:(NSString *)userId userData:(NSString *)userData;
 *
 * @since v2.0.0
 */
- (void)joinRoomWithToken:(NSString *)token
                 userData:(nullable NSString *)userData;

/*!
 * @abstract 退出房间。
 *
 * @since v2.0.0
 */
- (void)leaveRoom;

/*!
 * @abstract 是否使用外部导入的音频数据。
 *
 * @discussion 默认为 NO，需要在加入房间之前设置。
 *
 * @see - (void)pushAudioBuffer:(AudioBuffer *)audioBuffer;
 *
 * @since v2.0.0
 */
- (void)setExternalAudioSourceEnabled:(BOOL)enabled;

/*!
 * @abstract 发布本地的音视频到服务器。
 *
 * @discussion 需要加入房间成功后且不处于重连状态才可以发布音视频。调用该接口后，SDK 会默认创建一个音频 QNTrackInfo 和一个视频 QNTrackInfo
 * 并发布，其中 master 属性均被置为 YES，master 属性含义可查阅 QNTrackInfo.h 头文件。
 *
 * @since v2.0.0
 */
- (void)publish;

/*!
 * @abstract 发布本地的音频到服务器。
 *
 * @discussion 需要加入房间成功后且不处于重连状态才可以发布音频。调用该接口后，SDK 会默认创建一个音频 QNTrackInfo 并发布，其中 master 属性会置为 YES，
 * master 属性含义可查阅 QNTrackInfo.h 头文件。
 *
 *
 * @since v2.0.0
 */
- (void)publishAudio;

/*!
 * @abstract 发布本地的视频到服务器。
 *
 * @discussion 需要加入房间成功后且不处于重连状态才可以发布视频。调用该接口后，SDK 会默认创建一个视频 QNTrackInfo 并发布，其中 master 属性会置为 YES，
 * master 属性含义可查阅 QNTrackInfo.h 头文件。
 *
 * @since v2.0.0
 */
- (void)publishVideo;

/*!
 * @abstract 发布由 tracks 定义的音/视频到服务器。
 *
 * @discussion 需要加入房间成功后且不处于重连状态才可以发布音/视频。
 *
 * @since v2.0.0
 */
- (void)publishTracks:(NSArray<QNTrackInfo *> *)tracks;

/*!
 * @abstract 取消发布本地的音视频。
 *
 * @discussion 该接口会取消发布 master 属性为 YES 的 Track，master 属性含义可查阅 QNTrackInfo.h 头文件。
 *
 * @since v2.0.0
 */
- (void)unpublish;

/*!
 * @abstract 取消发布本地的音频。
 *
 * @discussion 该接口会取消发布 master 属性为 YES 的音频 Track，master 属性含义可查阅 QNTrackInfo.h 头文件。
 *
 * @since v2.0.0
 */
- (void)unpublishAudio;

/*!
 * @abstract 取消发布本地的视频。
 *
 * @discussion 该接口会取消发布 master 属性为 YES 的视频 Track，master 属性含义可查阅 QNTrackInfo.h 头文件。
 *
 * @since v2.0.0
 */
- (void)unpublishVideo;

/*!
 * @abstract 取消发布由 tracks 定义的音/视频。
 * @discussion QNTrackInfo 中只需要设置需要取消发布的 trackId 即可，其它参数可忽略。
 *
 * @since v2.0.0
 */
- (void)unpublishTracks:(NSArray<QNTrackInfo *> *)tracks;

/*!
 * @abstract 将本地音频置为 muted 状态。
 *
 * @discussion 需要发布成功后才可以执行 mute 操作。该接口只会操作标识为 master 的音频 Track，master 属性含义可查阅 QNTrackInfo.h 头文件。
 *
 * @since v2.0.0
 */
- (void)muteAudio:(BOOL)muted;

/*!
 * @abstract 将本地视频置为 muted 状态。
 *
 * @discussion 需要发布成功后才可以执行 mute 操作。该接口只会操作标识为 master 的视频 Track，master 属性含义可查阅 QNTrackInfo.h 头文件。
 *
 * @since v2.0.0
 */
- (void)muteVideo:(BOOL)muted;

/*!
 * @abstract 将本地音/视频 Track 置为 muted 状态。
 *
 * @discussion 需要发布成功后才可以执行 mute 操作。将需要操作的 trackId 及 muted 状态设置到 QNTrackInfo 中，QNTrackInfo 其它参数可忽略。
 *
 * @since v2.0.0
 */
- (void)muteTracks:(NSArray<QNTrackInfo *> *)tracks;

/*!
* @abstract 设置远端音频 Track 播放音量。范围从 0 ~ 10，10 为最大
*
* @discussion 需要发布成功后才可以执行 setRemote 操作。本次操作仅对远端音频播放音量做调整，远端音量回调为远端音频数据的原始音量，不会基于本设置做相应调整。
*
* @warning 部分机型调整音量放大会出现低频噪音
*
* @since v3.0.0
*/
- (void)setRemoteTrackId:(NSString *)trackId outputVolume:(double)volume;

/*!
 * @abstract 导入视频数据。
 *
 * @discussion 调用此接口将把数据导入给所有 sourceType 为 QNRTCSourceTypeExternalVideo 的视频 Track。
 * 支持导入的视频数据格式为：kCVPixelFormatType_32BGRA、kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 * 和 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange。
 *
 * @since v2.0.0
 */
- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/*!
 * @abstract 导入视频数据。
 *
 * @discussion 调用此接口将把数据导入给指定 trackId 的视频 Track，
 * 若 trackId 为 nil，则将把数据导入给所有 sourceType 为 QNRTCSourceTypeExternalVideo 的视频 Track。
 * 支持导入的视频数据格式为：kCVPixelFormatType_32BGRA、kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 * 和 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange。
 *
 * @since v2.0.0
 */
- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer trackId:(nullable NSString *)trackId;

/*!
 * @abstract 导入视频数据。
 *
 * @discussion 调用此接口将把数据导入给所有 sourceType 为 QNRTCSourceTypeExternalVideo 的视频 Track。
 * 支持导入的视频数据格式为：kCVPixelFormatType_32BGRA、kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 * 和 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange。
 *
 * @since v2.0.0
 */
- (void)pushPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/*!
 * @abstract 导入视频数据。
 *
 * @discussion 调用此接口将把数据导入给指定 trackId 的视频 Track，
 * 若 trackId 为 nil，则将把数据导入给所有 sourceType 为 QNRTCSourceTypeExternalVideo 的视频 Track。
 * 支持导入的视频数据格式为：kCVPixelFormatType_32BGRA、kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 * 和 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange。
 *
 * @since v2.0.0
 */
- (void)pushPixelBuffer:(CVPixelBufferRef)pixelBuffer trackId:(nullable NSString *)trackId;

/*!
 * @abstract 导入音频数据
 *
 * @discussion 仅在调用 - (void)setExternalAudioSourceEnabled:(BOOL)enabled; 并传入 YES 后才有效。
 * 支持的音频数据格式为：PCM 格式，48000 采样率，16 位宽，单声道
 *
 * @since v2.0.0
 */
- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer;

/*!
 * @abstract 导入音频数据
 *
 * @discussion 仅在调用 - (void)setExternalAudioSourceEnabled:(BOOL)enabled; 并传入 YES 后才有效。
 * 支持的音频数据格式为：PCM 格式
 *
 * @since v2.3.0
 */
- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer asbd:(AudioStreamBasicDescription *)asbd;

/*!
 * @abstract 订阅由 QNTrackInfo 中的 trackId 指定的一组 Track。
 *
 * @discussion 此处 QNTrackInfo 只须设置 trackId，其它参数可忽略。
 *
 * @since v2.0.0
 */
- (void)subscribeTracks:(NSArray<QNTrackInfo *> *)tracks;

/*!
 * @abstract 取消订阅由 QNTrackInfo 中的 trackId 指定的一组 Track。
 *
 * @discussion 此处 QNTrackInfo 只须设置 trackId，其它参数可忽略。
 *
 * @since v2.0.0
 */
- (void)unsubscribeTracks:(NSArray<QNTrackInfo *> *)tracks;

/*!
* @abstract 更新订阅由 QNTrackInfo 中的 trackId 指定的一组 Track。
*
* @discussion 用于订阅大小流。
*
* @since v2.5.0
*/
- (void)updateSubscribeTracks:(NSArray<QNTrackInfo *> *)tracks;

/*!
 * @abstract 将 userId 的踢出房间。
 *
 * @since v2.0.0
 */
- (void)kickoutUser:(NSString *)userId;

/*!
 * @abstract 发送消息给 users 数组中的所有 userId。若需要给房间中的所有人发消息，数组传入 nil 即可。
 *
 * @since v2.3.0
 */
- (void)sendMessage:(NSString *)messsage toUsers:(nullable NSArray<NSString *> *)users messageId:(nullable NSString *)messageId;

/*!
 * @abstract 获取本地发布的视频 Track 的渲染 View。
 *
 * @discussion 供外部导入视频数据的 Track 使用。如果 Track 使用的是 SDK 采集的摄像头数据，推荐使用 previewView 属性获取本地摄像头的渲染 View。
 *
 * @see '@property (nonatomic, strong, readonly) UIView *previewView;'
 *
 * @since v2.0.0
 */
- (QNVideoView *)renderViewOfLocalTrackWithTrackId:(NSString *)trackId;

/*!
 * @abstract 是否将音频默认输出设备设为 Speaker。
 *
 * @discussion 默认为 YES，即如果不调用该接口，则声音会默认从扬声器输出，设为 NO 时，声音会从听筒输出。
 * 无论设置何值，当连接上外置音频设备时，声音会优先从外置音频设备输出。当外置音频设备移除时，会使用默认输出设备。
 *
 * @warning 需要在加入房间前调用，否则无效。
 *
 * @see '- (void)setSpeakerOn:(BOOL)speakOn;'
 *
 * @since v2.1.0
 */
- (void)setDefaultOutputAudioPortToSpeaker:(BOOL)defaultToSpeaker;

/*!
 * @abstract 是否将声音从扬声器输出。
 *
 * @discussion 传入 YES 时，强制声音从扬声器输出。
 *
 * @warning 由于系统原因，在某些设备（如 iPhone XS Max、iPhone 8 Plus）上，连接 AirPods 后无法通过
 * 该接口将声音强制设为扬声器输出。如有需求，可以通过使用 AVRoutePickerView 来切换。
 *
 * @see '- (void)setDefaultOutputAudioPortToSpeaker:(BOOL)defaultToSpeaker;'
 *
 * @since v2.1.0
 */
- (void)setSpeakerOn:(BOOL)speakerOn;

/*!
 * @abstract 创建合流任务。
 *
 * @discussion 创建合流任务不是必需的。合流时，如果未提前创建合流任务，那么会使用对应的应用的合流参数创建一个默认的合流任务。
 * 异步接口，创建成功后，会通过 - (void)RTCEngine:(QNRTCEngine *)engine didCreateMergeStreamWithJobId:(NSString *)jobId; 接口回调通知。
 *
 * @warning 当有合流及单路转推切换需求时，合流必须使用自定义合流，流地址一样切换会有抢流现象，故流地址尾部需要拼接 "?serialnum=xxx" 决定流的优先级，serialnum 值越大，优先级越高，切换成功后务必关闭之前的任务，否则会出现一路任务持续计费的情况。
 *
 * @since v2.0.0
 */
- (void)createMergeStreamJobWithConfiguration:(QNMergeStreamConfiguration *)configuration;

/*!
 * @abstract 将对应的音视频 Track 加入合流。
 *
 * @discussion 需要更新合流布局时，重新调用该接口即可。若使用默认的合流任务，则 jobId 传入 nil 即可。
 *
 * @since v2.0.0
 */
- (void)setMergeStreamLayouts:(NSArray <QNMergeStreamLayout *> *)layouts
                        jobId:(nullable NSString *)jobId;

/*!
 * @abstract 将对应的音视频 Track 从合流中移除。
 *
 * @discussion 此处 QNMergeStreamLayout 中只需要设置 trackId 即可，其它参数可忽略。若使用默认的合流任务，则 jobId 传入 nil 即可。
 *
 * @since v2.0.0
 */
- (void)removeMergeStreamLayouts:(NSArray <QNMergeStreamLayout *> *)layouts
                           jobId:(nullable NSString *)jobId;

/*!
 * @abstract 停止合流任务。
 *
 * @param
 *    jobId 合流任务 id，如果使用的是默认的合流任务，则传入 nil 即可。
 *
 * @since v2.0.0
 */
- (void)stopMergeStreamWithJobId:(nullable NSString *)jobId;

/*!
 * @abstract 停止合流任务。
 *
 * @param
 *    jobId 合流任务 id，如果使用的是默认的合流任务，则传入 nil 即可。
 *
 * @param
 *    delayMillisecond 延迟时间，单位毫秒
 *
 * @since v3.0.1
 */
- (void)stopMergeStreamWithJobId:(nullable NSString *)jobId delayMillisecond:(NSUInteger)delayMillisecond;

/*!
* @abstract 创建单路转推任务。
*
* @discussion 创建单路转推任务时，只支持一路音频以及一路视频。创建成功后，会通过 - (void)RTCEngine:(QNRTCEngine *)engine didCreateForwardJobWithJobId:(NSString *)jobId; 接口回调通知。
*
* @warning 当有合流及单路转推切换需求时，合流必须使用自定义合流，流地址一样切换会有抢流现象，故流地址尾部需要拼接 "?serialnum=xxx" 决定流的优先级，serialnum 值越大，优先级越高，切换成功后务必关闭之前的任务，否则会出现一路任务持续计费的情况。另外，使用的视频 Track 是保持固定分辨率的，即 setMaintainResolutionEnabled 为 YES，且仅支持一路视频、一路音频。
*
* @since v2.5.0
*/
- (void)createForwardJobWithConfiguration:(QNForwardStreamConfiguration *)configuration;

/*!
* @abstract 停止单路转推任务。
*
* @param jobId 单路转推任务 id
*
* @since v2.5.0
*/
- (void)stopForwardJobWithJobId:(NSString *)jobId;

/*!
* @abstract 停止单路转推任务。
*
* @param jobId 单路转推任务 id
*
* @param delayMillisecond 延迟时间，单位毫秒
*
* @since v3.0.1
*/
- (void)stopForwardJobWithJobId:(NSString *)jobId delayMillisecond:(NSUInteger)delayMillisecond;

/*!
 * @abstract 麦克风输入音量
 *
 * @discussion 设置范围为 0~10，默认为 1
 *
 * @warning 当麦克风输入音量增益调大之后，部分机型会出现噪音
 *
 * @since v3.0.1
 */
- (void)setMicrophoneInputGain:(float) inputGain;

/*!
 * @abstract 本地视频 Track 添加 SEI
 *
 * @param videoSEI SEI 内容
 *
 * @param repeatNumber SEI 重复发送次数，-1 为永久发送
 *
 * @param tracks 需要添加 SEI 的视频 track
 *
 * @discussion 需要停止发送 SEI，可以设置 videoSEI 为 nil，repeatNumber 为 0 即可
 *
 * @since v3.0.1
 */
- (void)setLocalVideoSEI:(NSString *)videoSEI repeatNmuber:(NSNumber *)repeatNumber withTracks:(NSArray<QNTrackInfo *> *)tracks;

@end


#pragma mark - Category (CameraSource)

/*!
 * @category PLCameraStreamingSession(CameraSource)
 *
 * @discussion 与摄像头相关的接口
 *
 * @since v2.0.0
 *
 */
@interface QNRTCEngine (CameraSource)

/*!
 * @abstract 视频采集 session，只读变量，给有特殊需求的开发者使用，最好不要修改。
 *
 * @since v2.0.0
 */
@property (nonatomic, readonly) AVCaptureSession * _Nullable captureSession;

/*!
 * @abstract 视频采集输入源，只读变量，给有特殊需求的开发者使用，最好不要修改。
 *
 * @since v2.0.0
 */
@property (nonatomic, readonly) AVCaptureDeviceInput * _Nullable videoCaptureDeviceInput;

/*!
 * @abstract 摄像头的预览视图，调用 startCapture 后才会有画面。
 *
 * @since v2.0.0
 */
@property (nonatomic, strong, readonly) UIView *previewView;

/*!
 * @abstract previewView 中视频的填充方式，默认使用 QNVideoFillModePreserveAspectRatioAndFill。
 *
 * @since v2.0.0
 */
@property(readwrite, nonatomic) QNVideoFillModeType fillMode;

/*!
 * @abstract 摄像头的位置，默认为 AVCaptureDevicePositionFront。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) AVCaptureDevicePosition   captureDevicePosition;

/*!
 * @abstract 开启 camera 时的采集摄像头的旋转方向，默认为 AVCaptureVideoOrientationPortrait。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

/*!
 * @abstract 是否开启手电筒，默认为 NO。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign, getter=isTorchOn) BOOL    torchOn;

/*!
 * @abstract 连续自动对焦。默认为 YES。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign, getter=isContinuousAutofocusEnable) BOOL  continuousAutofocusEnable;

/*!
 * @abstract 手动点击屏幕进行对焦。默认为 YES。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign, getter=isTouchToFocusEnable) BOOL touchToFocusEnable;

/*!
 * @abstract 该属性适用于视频拍摄过程中用来减缓因自动对焦产生的镜头伸缩，使画面不因快速的对焦而产生抖动感。默认为 YES。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign, getter=isSmoothAutoFocusEnabled) BOOL  smoothAutoFocusEnabled;

/*!
 * @abstract 聚焦的位置，(0,0) 代表左上, (1,1) 代表右下。默认为 (0.5, 0.5)，即中间位置。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) CGPoint   focusPointOfInterest;

/*!
 * @abstract 控制摄像头的缩放，默认为 1.0。
 *
 * @discussion 设置的数值需要小于等于 videoActiveForat.videoMaxZoomFactor，如果大于会设置失败。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) CGFloat videoZoomFactor;

/*!
 * @abstract 设备支持的 formats。
 *
 * @since v2.0.0
 */
@property (nonatomic, strong, readonly) NSArray<AVCaptureDeviceFormat *> *videoFormats;

/*!
 * @abstract 设备当前的 format。
 *
 * @since v2.0.0
 */
@property (nonatomic, strong) AVCaptureDeviceFormat *videoActiveFormat;

/*!
 * @abstract 采集的视频的 sessionPreset，默认为 AVCaptureSessionPreset640x480。
 *
 * @since v2.0.0
 */
@property (nonatomic, copy) NSString *sessionPreset;

/*!
 * @abstract 采集的视频数据的帧率，默认为 24。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) NSUInteger videoFrameRate;

/*!
 * @abstract 前置摄像头预览是否开启镜像，默认为 YES。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) BOOL previewMirrorFrontFacing;

/*!
 * @abstract 后置摄像头预览是否开启镜像，默认为 NO。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) BOOL previewMirrorRearFacing;

/*!
 * @abstract 前置摄像头，对方观看时是否开启镜像，默认 NO。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) BOOL encodeMirrorFrontFacing;

/*!
 * @abstract 后置摄像头，对方观看时是否开启镜像，默认 NO。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) BOOL encodeMirrorRearFacing;

/*!
 * @abstract 切换前后摄像头。
 *
 * @since v2.0.0
 */
- (void)toggleCamera;

/*!
 * @abstract 是否开启美颜。
 *
 * @since v2.0.0
 */
-(void)setBeautifyModeOn:(BOOL)beautifyModeOn;

/*!
 * @abstract 设置对应 Beauty 的程度参数，范围从 0 ~ 1，0 为不美颜。
 *
 * @discussion 如果美颜不开启，设置该参数无效。
 *
 * @since v2.0.0
 */
-(void)setBeautify:(CGFloat)beautify;

/*!
 * @abstract 设置美白程度。
 *
 * @discussion 如果美颜不开启，设置该参数无效。
 *
 * @since v2.0.0
 */
-(void)setWhiten:(CGFloat)whiten;

/*!
 * @abstract 设置红润的程度。范围是从 0 ~ 1，0 为不红润。
 *
 * @discussion 如果美颜不开启，设置该参数无效。
 *
 * @since v2.0.0
 */
-(void)setRedden:(CGFloat)redden;

/*!
 * @abstract 设置水印。
 *
 * @since v2.0.0
 */
-(void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position;

/*!
 * @abstract 移除水印。
 *
 * @since v2.0.0
 */
-(void)clearWaterMark;

/*!
 * @abstract 设置摄像头 track 发送图片数据
 *
 * @param image 推流的图片
 *
 * @discussion 由于某些特殊原因不想使用摄像头采集的数据作为发送视频数据时，可以使用该接口设置一张图片来替代。传入 nil 则关闭该功能。

 * @warning    请确保传入的 image 的宽和高是 16 的整数倍。请勿在 applicationState 为 UIApplicationStateBackground 时调用该接口，否则将出错。
 *
 * @since v3.0.1
 */
- (void)pushCameraTrackWithImage:(nullable UIImage *)image;

/*!
 * @abstract 开启摄像头采集。
 *
 * @since v2.0.0
 */
- (void)startCapture;

/*!
 * @abstract 关闭摄像头采集。
 *
 * @since v2.0.0
 */
- (void)stopCapture;

@end

#pragma mark - Category (Authorization)

/*!
 * @category QNRTCEngine(Authorization)
 *
 * @discussion 与设备授权相关的接口
 *
 * @since v2.0.0
 *
 */
@interface QNRTCEngine (Authorization)

/*!
 * @abstract 摄像头的授权状态。
 *
 * @since v2.0.0
 */
+ (QNAuthorizationStatus)cameraAuthorizationStatus;

/*!
 * @abstract 获取摄像头权限。
 *
 * @discussion handler 该 block 将会在主线程中回调。
 *
 * @since v2.0.0
 */
+ (void)requestCameraAccessWithCompletionHandler:(void (^)(BOOL granted))handler;

/*!
 * @abstract 麦克风的授权状态。
 *
 * @since v2.0.0
 */
+ (QNAuthorizationStatus)microphoneAuthorizationStatus;

/*!
 * @abstract 获取麦克风权限。
 *
 * @discussion handler 该 block 将会在主线程中回调。
 *
 * @since v2.0.0
 */
+ (void)requestMicrophoneAccessWithCompletionHandler:(void (^)(BOOL granted))handler;

@end

#pragma mark - Category (ScreenRecorder)

/*!
 * @category QNRTCEngine(ScreenRecorder)
 *
 * @discussion 与录屏相关的接口
 *
 * @since v2.0.0
 */
@interface QNRTCEngine (ScreenRecorder)

/*!
 * @abstract 判断屏幕录制功能是否可用
 *
 * @discussion 屏幕录制功能仅在 iOS 11 及以上版本可用
 *
 * @since v2.0.0
 */
+ (BOOL)isScreenRecorderAvailable;

/*!
 * @abstract 屏幕录制的帧率，默认值为 20，可设置 [10, 60] 之间的值，超出范围则不变更
 *
 * @discussion 该值仅为期望值，受 ReplayKit 的限制，在特定情况（比如画面保持不动）下，ReplayKit 可能隔几秒才会回调一帧数据。
 *
 * @since v2.0.0
 */
@property (nonatomic, assign) NSUInteger screenRecorderFrameRate;

@end

#pragma mark - Category (Logging)

/*!
 * @category QNRTCEngine(Logging)
 *
 * @discussion 与日志相关的接口。
 *
 * @since v2.0.0
 */
@interface QNRTCEngine (Logging)

/*!
* @abstract 开启文件日志
*
* @discussion 为了不错过日志，建议在 App 启动时即开启，日志文件位于 App Container/Library/Caches/Pili/Logs 目录下以 QNRTC+当前时间命名的目录内
* 注意：文件日志功能主要用于排查问题，打开文件日志功能会对性能有一定影响，上线前请记得关闭文件日志功能！
*
* @since v2.0.0
*/
+ (void)enableFileLogging;

@end

#pragma mark - Category (Info)

/*!
 * @category QNRTCEngine(Info)
 *
 * @discussion SDK 相关信息的接口。
 *
 * @since v2.0.0
 */
@interface QNRTCEngine (Info)

/*!
 * @abstract 获取 SDK 的版本信息。
 *
 * @since v2.0.0
 */
+ (NSString *)versionInfo;

@end

NS_ASSUME_NONNULL_END


