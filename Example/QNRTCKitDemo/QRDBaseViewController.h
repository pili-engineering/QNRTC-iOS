//
//  UIViewController+QNRTCInnerTestDemo.h
//  QNRTCTestDemo
//
//  Created by hxiongan on 2018/8/21.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QNRTCKit/QNRTCKit.h>
#import <Masonry.h>
#import "QRDPublicHeader.h"
#import "QRDUserView.h"
#import "QRDNetworkUtil.h"


@interface LogTableView : UITableView

@property (nonatomic, assign) NSUInteger lastCount;
@property (nonatomic, assign) BOOL isScrolling;
@property (nonatomic, assign) BOOL isBottom;

@end

@interface QRDBaseViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
QNRTCEngineDelegate,
QRDUserViewDelegate
>
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, readonly) LogTableView *tableView;
@property (nonatomic, readonly) NSMutableArray *logStringArray;
@property (nonatomic, readonly) UIView *renderBackgroundView;//上面只添加 renderView
@property (nonatomic, readonly) NSMutableArray *userViewArray;

@property (nonatomic, strong) QNRTCEngine *engine;
@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) NSString *appId;
@property (nonatomic, readonly) NSString *roomName;
@property (nonatomic, readonly) BOOL isAdmin;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

- (void)resetRenderViews;
- (QRDUserView *)createUserViewWithTrackId:(NSString *)trackId userId:(NSString *)userId;
- (QRDUserView *)userViewWithUserId:(NSString *)userId;
- (void)addRenderViewToSuperView:(QRDUserView *)renderView;
- (void)removeRenderViewFromSuperView:(QRDUserView *)renderView;

// 用户退出房间的时候，清除掉用户的所有信息
- (void)clearUserInfo:(NSString *)userId;

- (void)clearAllRemoteUserInfo;

- (void)addLogString:(NSString *)logString;
- (void)clearLogString;

- (BOOL)isAdminUser:(NSString *)userId;

// 大小窗口切换
- (void)exchangeWindowSize;

- (void)checkSelfPreviewGesture;

@end
