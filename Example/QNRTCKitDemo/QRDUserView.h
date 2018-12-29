//
//  QRDUserView.h
//  QNRTCTestDemo
//
//  Created by hxiongan on 2018/8/21.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import <QNRTCKit/QNRTCKit.h>


@class QRDUserView;
@protocol QRDUserViewDelegate <NSObject>
- (BOOL)userViewWantEnterFullScreen:(QRDUserView *)userview;
- (void)userView:(QRDUserView *)userview longPressWithUserId:(NSString *)userId;
@end

@interface QRDUserView : UIView

@property (nonatomic, weak) id<QRDUserViewDelegate> delegate;

@property (nonatomic, strong) NSString *trackId;
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSMutableArray *traks;

@property (nonatomic, readonly) QNVideoView *cameraView;
@property (nonatomic, readonly) QNVideoView *screenView;

@property (nonatomic, weak) UIView *fullScreenSuperView;

- (QNTrackInfo *)trackInfoWithTrackId:(NSString *)trackId;

- (void)showCameraView;

- (void)hideCameraView;

- (void)showScreenView;

- (void)hideScreenView;

- (void)setAudioMute:(BOOL)isMute;

//- (void)setVideoHidden:(BOOL)isHidden trackId:(NSString *)trackId;

- (void)setMuteViewHidden:(BOOL)isHidden;

- (void)updateBuffer:(short *)buffer withBufferSize:(UInt32)bufferSize;

@end
