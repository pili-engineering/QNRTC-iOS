//
//  QRDTranscodingStreamingSettingView.h
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2020/4/26.
//  Copyright © 2020 PILI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "QRDTranscodingStreamingInfo.h"
#import <QNRTCKit/QNRTCKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QRDTranscodingStreamingSettingView;
@protocol QRDTranscodingStreamingSettingViewDelegate <NSObject>

@optional
- (void)transcodingStreamingSettingView:(QRDTranscodingStreamingSettingView *)settingView didGetMessage:(NSString *)message;

- (void)transcodingStreamingSettingView:(QRDTranscodingStreamingSettingView *)settingView didSetTranscodingStreamingLayouts:(NSArray <QNTranscodingLiveStreamingTrack *> *)layouts streamID:(NSString *)streamID;

- (void)transcodingStreamingSettingView:(QRDTranscodingStreamingSettingView *)settingView didRemoveTranscodingLiveStreamingTracks:(NSArray <QNTranscodingLiveStreamingTrack *> *)streamingTracks streamID:(NSString *)streamID;

- (void)transcodingStreamingSettingView:(QRDTranscodingStreamingSettingView *)settingView didUpdateTotalHeight:(CGFloat)totalHeight;

- (void)transcodingStreamingSettingView:(QRDTranscodingStreamingSettingView *)settingView didUpdateTranscodingStreamingConfiguration:(QNTranscodingLiveStreamingConfig *)streamConfiguration layouts:(NSArray <QNTranscodingLiveStreamingTrack *> *)layouts streamID:(NSString *)streamID;

- (void)transcodingStreamingSettingView:(QRDTranscodingStreamingSettingView *)settingView didCloseTranscodingLiveStreaming:(nullable QNTranscodingLiveStreamingConfig *)transcodingStreamingConfiguration;

- (void)transcodingStreamingSettingView:(QRDTranscodingStreamingSettingView *)settingView didUseDefaultTranscodingStreaming:(BOOL)isDefault;

@end

@interface QRDTranscodingStreamingSettingView : UIView

@property (nonatomic, assign) id<QRDTranscodingStreamingSettingViewDelegate> delegate;

@property (nonatomic, strong) UITextField *firstTrackXTextField;
@property (nonatomic, strong) UITextField *firstTrackYTextField;
@property (nonatomic, strong) UITextField *firstTrackZTextField;
@property (nonatomic, strong) UITextField *firstTrackWidthTextField;
@property (nonatomic, strong) UITextField *firstTrackHeightTextField;

@property (nonatomic, strong) UITextField *secondTrackXTextField;
@property (nonatomic, strong) UITextField *secondTrackYTextField;
@property (nonatomic, strong) UITextField *secondTrackZTextField;
@property (nonatomic, strong) UITextField *secondTrackWidthTextField;
@property (nonatomic, strong) UITextField *secondTrackHeightTextField;

@property (nonatomic, strong) UILabel *firstTrackTagLabel;
@property (nonatomic, strong) UILabel *secondTrackTagLabel;
@property (nonatomic, strong) UISwitch *firstTrackSwitch;
@property (nonatomic, strong) UISwitch *secondTrackSwitch;
@property (nonatomic, strong) UISwitch *audioTrackSwitch;

@property (nonatomic, strong) UIScrollView *userScorllView;

@property (nonatomic, strong) NSMutableArray *transcodingStreamingUserArray;
@property (nonatomic, strong) NSMutableArray *transcodingStreamingInfoArray;
@property (nonatomic, strong) NSString *selectedUserId;
@property (nonatomic, assign) CGSize transcodingStreamingStreamSize;

@property (nonatomic, weak) QRDTranscodingStreamingInfo *firstTrackTranscodingStreamingInfo;
@property (nonatomic, weak) QRDTranscodingStreamingInfo *secondTrackTranscodingStreamingInfo;
@property (nonatomic, weak) QRDTranscodingStreamingInfo *audioTrackTranscodingStreamingInfo;
@property (nonatomic, strong) QNTranscodingLiveStreamingConfig *customConfiguration;

@property (nonatomic, strong) UILabel *transcodingStreamingOpenLabel;
@property (nonatomic, strong) UISwitch *transcodingStreamingSwitch;

@property (nonatomic, strong) UILabel *warnningLabel;

@property (nonatomic, strong) UILabel *customTranscodingStreamingOpenLabel;
@property (nonatomic, strong) UISwitch *customTranscodingStreamingSwitch;
@property (nonatomic, strong) UILabel *streamInfoLabel;
@property (nonatomic, strong) UILabel *streamURLLabel;
@property (nonatomic, strong) UITextField *widthTextField;
@property (nonatomic, strong) UITextField *heightTextField;
@property (nonatomic, strong) UITextField *fpsTextField;
@property (nonatomic, strong) UITextField *bitrateTextField;
@property (nonatomic, strong) UITextField *transcodingStreamingIdTextField;
@property (nonatomic, strong) UITextField *minbitrateTextField;
@property (nonatomic, strong) UITextField *maxbitrateTextField;

@property (nonatomic, strong) UILabel *fillModeLabel;
@property (nonatomic, strong) UIButton *aspectFillButton;
@property (nonatomic, strong) UIButton *aspectFitButton;
@property (nonatomic, strong) UIButton *scaleFitButton;

@property (nonatomic, assign, readonly) CGFloat totalHeight;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, assign) BOOL saveEnable;
@property (nonatomic, strong) UIButton *cancelButton;


- (id)initWithFrame:(CGRect)frame userId:(NSString *)userId roomName:(NSString *)roomName;

- (void)addTranscodingStreamingInfoWithTracks:(NSArray *)tracks userId:(NSString *)userId;

- (void)removeTranscodingStreamingInfoWithTracks:(NSArray *)tracks userId:(NSString *)userId;

- (void)removeTranscodingStreamingInfoWithUserId:(NSString *)userId;

- (void)resetTranscodingStreamingFrame;

- (void)resetUserList;

- (void)updateSwitch;

@end

NS_ASSUME_NONNULL_END
