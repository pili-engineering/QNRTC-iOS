//
//  QRDMergeSettingView.h
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2020/4/26.
//  Copyright © 2020 PILI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "QRDMergeInfo.h"
#import <QNRTCKit/QNRTCKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QRDMergeSettingView;
@protocol QRDMergeSettingViewDelegate <NSObject>

@optional
- (void)mergeSettingView:(QRDMergeSettingView *)settingView didGetMessage:(NSString *)message;

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didSetMergeLayouts:(NSArray <QNMergeStreamLayout *> *)layouts jobId:(NSString *)jobId;

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didRemoveMergeLayouts:(NSArray <QNMergeStreamLayout *> *)layouts jobId:(NSString *)jobId;

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didUpdateTotalHeight:(CGFloat)totalHeight;

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didUpdateMergeConfiguration:(QNMergeStreamConfiguration *)streamConfiguration layouts:(NSArray <QNMergeStreamLayout *> *)layouts jobId:(NSString *)jobId;

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didCloseMerge:(nullable NSString *)jobId;

- (void)mergeSettingView:(QRDMergeSettingView *)settingView didUseDefaultMerge:(BOOL)isDefault;

@end

@interface QRDMergeSettingView : UIView

@property (nonatomic, assign) id<QRDMergeSettingViewDelegate> delegate;

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

@property (nonatomic, strong) NSMutableArray *mergeUserArray;
@property (nonatomic, strong) NSMutableArray *mergeInfoArray;
@property (nonatomic, strong) NSString *selectedUserId;
@property (nonatomic, assign) CGSize mergeStreamSize;

@property (nonatomic, weak) QRDMergeInfo *firstTrackMergeInfo;
@property (nonatomic, weak) QRDMergeInfo *secondTrackMergeInfo;
@property (nonatomic, weak) QRDMergeInfo *audioTrackMergeInfo;

@property (nonatomic, strong) UILabel *mergeOpenLabel;
@property (nonatomic, strong) UISwitch *mergeSwitch;

@property (nonatomic, strong) UILabel *warnningLabel;

@property (nonatomic, strong) UILabel *customMergeOpenLabel;
@property (nonatomic, strong) UISwitch *customMergeSwitch;
@property (nonatomic, strong) UILabel *streamInfoLabel;
@property (nonatomic, strong) UILabel *streamURLLabel;
@property (nonatomic, strong) UITextField *widthTextField;
@property (nonatomic, strong) UITextField *heightTextField;
@property (nonatomic, strong) UITextField *fpsTextField;
@property (nonatomic, strong) UITextField *bitrateTextField;
@property (nonatomic, strong) UITextField *mergeIdTextField;
@property (nonatomic, strong) UITextField *minbitrateTextField;
@property (nonatomic, strong) UITextField *maxbitrateTextField;

@property (nonatomic, strong) UILabel *fillModeLabel;
@property (nonatomic, strong) UIButton *aspectFillButton;
@property (nonatomic, strong) UIButton *aspectFitButton;
@property (nonatomic, strong) UIButton *scaleFitButton;

@property (nonatomic, assign, readonly) CGFloat totalHeight;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, assign) BOOL saveEnable;


- (id)initWithFrame:(CGRect)frame userId:(NSString *)userId roomName:(NSString *)roomName;

- (void)addMergeInfoWithTracks:(NSArray *)tracks userId:(NSString *)userId;

- (void)removeMergeInfoWithTracks:(NSArray *)tracks userId:(NSString *)userId;

- (void)removeMergeInfoWithUserId:(NSString *)userId;

- (void)resetMergeFrame;

- (void)resetUserList;

- (void)updateSwitch;

@end

NS_ASSUME_NONNULL_END
