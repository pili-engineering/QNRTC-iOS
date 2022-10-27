//
//  UIViewController+QNRTCInnerTestDemo.m
//  QNRTCTestDemo
//
//  Created by hxiongan on 2018/8/21.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import "QRDBaseViewController.h"
#import "UIView+Alert.h"

@implementation LogTableView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        if (self.numberOfSections && [self numberOfRowsInSection:0]) {
            if (self.isScrolling) return;
            if (!self.isBottom) return;
            if (_lastCount == [self numberOfRowsInSection:0]) return;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self numberOfRowsInSection:0] - 1 inSection:0];
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
            _lastCount = [self numberOfRowsInSection:0];
        }
    }
}

@end


@interface QRDBaseViewController ()

@property (nonatomic, strong) LogTableView *tableView;
@property (nonatomic, strong) NSMutableArray *logStringArray;
@property (nonatomic, strong) UIView *renderBackgroundView;//上面只添加 renderView
@property (nonatomic, strong) NSMutableArray *userViewArray;
@property (nonatomic, strong) NSMutableDictionary *trackInfoDics;

@property (nonatomic, strong) NSTimer *getstatsTimer;
@end

@implementation QRDBaseViewController

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    NSLog(@"[dealloc]==> %@", self.description);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopGetStatsTimer];
}

- (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] stringForKey:QN_USER_ID_KEY];
}

- (NSString *)roomName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:QN_ROOM_NAME_KEY];
}

- (NSString *)appId {
    NSString *appId = [[NSUserDefaults standardUserDefaults] stringForKey:QN_APP_ID_KEY];
    if (0 == appId.length) {
        appId = QN_RTC_DEMO_APPID;
        [[NSUserDefaults standardUserDefaults] setObject:appId forKey:QN_APP_ID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return appId;
}

- (BOOL)isAdmin {
    return [self.userId.lowercaseString isEqualToString:@"admin"];
}

- (BOOL)isAdminUser:(NSString *)userId {
    return [userId.lowercaseString isEqualToString:@"admin"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.logStringArray = [[NSMutableArray alloc] init];
    self.userViewArray = [[NSMutableArray alloc] init];
    self.trackInfoDics = [[NSMutableDictionary alloc] init];
    self.renderBackgroundView = [[UIView alloc] init];
    [self.view insertSubview:self.renderBackgroundView atIndex:0];
    [self.renderBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    [self setupLogUI];
    
    self.preview = [[QNVideoGLView alloc] initWithFrame:self.view.bounds];
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeWindowSize)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [QNRTC deinit];
    [super viewDidDisappear:animated];
}

- (UIView *)colorView {
    if (nil == _colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = [UIColor colorWithRed:69.0/255.0 green:157.0/255.0 blue:251.0/255 alpha:1];
    }
    return _colorView;
}

- (void)setupLogUI {
    
    self.tableView = [[LogTableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.3];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(.33);
    }];
}

- (void)addLogString:(NSString *)logString {
    NSLog(@"%@", logString);
    
    @synchronized(_logStringArray) {
        [self.logStringArray addObject:logString];
    }
    
    dispatch_main_async_safe(^{
        // 只有日志 view 是显示的时候，才去更新 UI
        if (!self.tableView.hidden) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self.tableView selector:@selector(reloadData) object:nil];
            [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:.2];
        }
    });
}


- (void)clearLogString {
    
    @synchronized(_logStringArray) {
        [_logStringArray removeAllObjects];
    }
    
    dispatch_main_async_safe(^{
        [self.tableView reloadData];
    });
}

- (void)clearUserInfo:(NSString *)userId {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSInteger i = self.userViewArray.count - 1; i >= 0; i--) {
            QRDUserView *userView = self.userViewArray[i];
            if ([userView.userId isEqualToString:userId]) {
                [userView removeFromSuperview];
                [self.userViewArray removeObject:userView];
            }
        }

        [self resetRenderViews];
    });
}

- (void)clearAllRemoteUserInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSInteger i = self.userViewArray.count - 1; i >= 0; i--) {
            QRDUserView *userView = self.userViewArray[i];
            [userView removeFromSuperview];
            [self.userViewArray removeObject:userView];
        }

        [self resetRenderViews];
    });
}

#pragma mark - 预览画面设置

- (void)resetRenderViews {
    @synchronized (self) {
        
        NSArray *allRenderView = self.renderBackgroundView.subviews;
        
        if (1 == allRenderView.count) {
            [allRenderView[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.renderBackgroundView);
            }];
        } else if (2 == allRenderView.count) {
            [allRenderView[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.renderBackgroundView);
            }];
            
            [allRenderView[1] mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.renderBackgroundView).offset(-20);
                make.top.equalTo(self.renderBackgroundView).offset(20);
                make.width.equalTo(117);
                make.height.equalTo(208);
            }];
            
            [self.renderBackgroundView bringSubviewToFront:allRenderView[1]];
        }else if (3 == allRenderView.count) {
            
            UIView *view1 = allRenderView[1];
            
            [view1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.renderBackgroundView);
                make.width.equalTo(self.renderBackgroundView).multipliedBy(.5);
                make.height.equalTo(view1.mas_width);
            }];
            
            UIView *view2 = allRenderView[2];
            [view2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.top.equalTo(self.renderBackgroundView);
                make.size.equalTo(view1);
            }];
            
            UIView *view0 = allRenderView[0];
            [view0 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.renderBackgroundView);
                make.top.equalTo(view1.mas_bottom);
                make.size.equalTo(view1);
            }];
        } else {
            
            
            int col = ceil(sqrt(allRenderView.count));
            
            UIView *preView = nil;
            UIView *upView = nil;
            for (int i = 0; i < allRenderView.count; i ++) {
                UIView *view = allRenderView[i];
                [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(preView ? preView.mas_right : self.renderBackgroundView);
                    make.top.equalTo(upView ? upView.mas_bottom : self.renderBackgroundView);
                    make.width.equalTo(self.renderBackgroundView).multipliedBy(1.0/col);
                    //                make.size.equalTo(self.renderBackgroundView).multipliedBy(1.0/col);
                    make.height.equalTo(view.width);
                }];
                
                if ((i + 1) % col == 0) {
                    preView = nil;
                    upView = view;
                } else {
                    preView = view;
                }
            }
        }
        
        [UIView animateWithDuration:.3 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self checkSelfPreviewGesture];
        }];
    }
}

- (void)exchangeWindowSize {
    
    // 只有两个的时候，进行大小窗口切换
    NSArray <UIView *>*allRenderView = self.renderBackgroundView.subviews;
    if (2 != allRenderView.count) return;
    
    
    if (CGRectContainsRect(allRenderView[0].frame, allRenderView[1].frame)) {
        
        [allRenderView[1] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.renderBackgroundView);
        }];
        
        [allRenderView[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.renderBackgroundView).offset(-20);
            make.top.equalTo(self.renderBackgroundView).offset(20);
            make.width.equalTo(117);
            make.height.equalTo(208);
        }];
        [self.renderBackgroundView bringSubviewToFront:allRenderView[0]];
    } else {
        [allRenderView[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.renderBackgroundView);
        }];
        
        [allRenderView[1] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.renderBackgroundView).offset(-20);
            make.top.equalTo(self.renderBackgroundView).offset(20);
            make.width.equalTo(117);
            make.height.equalTo(208);
        }];
        [self.renderBackgroundView bringSubviewToFront:allRenderView[1]];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self checkSelfPreviewGesture];
    }];
}

- (void)checkSelfPreviewGesture {
    
    if ([self.preview.gestureRecognizers containsObject:self.singleTap]) {
        [self.preview removeGestureRecognizer:self.singleTap];
    }
    if ([self.colorView.gestureRecognizers containsObject:self.singleTap]) {
        [self.colorView removeGestureRecognizer:self.singleTap];
    }
    
    UIView *gestureView = self.colorView;
    if (self.preview.superview == self.colorView &&
        NO == self.preview) {
        gestureView = self.preview;
    }
    
    if (2 == self.renderBackgroundView.subviews.count &&
        !CGRectEqualToRect(self.renderBackgroundView.bounds, self.colorView.frame)) {
        if (![gestureView.gestureRecognizers containsObject:self.singleTap]) {
            [gestureView addGestureRecognizer:self.singleTap];
        }
    }
}

- (void)addRenderViewToSuperView:(QRDUserView *)renderView {
    @synchronized(self.renderBackgroundView) {
        if (![[self.renderBackgroundView subviews] containsObject:renderView]) {
            [self.renderBackgroundView addSubview:renderView];
            
            [self resetRenderViews];
        }
    }
}

- (void)removeRenderViewFromSuperView:(QRDUserView *)renderView {
    @synchronized(self.renderBackgroundView) {
        if ([[self.renderBackgroundView subviews] containsObject:renderView]) {
            [renderView removeFromSuperview];
            
            [self resetRenderViews];
        }
    }
}

- (QRDUserView *)createUserViewWithTrackId:(NSString *)trackId userId:(NSString *)userId {
    QRDUserView *userView = [[QRDUserView alloc] init];
    userView.delegate = self;
    userView.userId = userId;
    userView.trackId = trackId;
    userView.fullScreenSuperView = self.view;
    return userView;
}

- (QRDUserView *)userViewWithUserId:(NSString *)userId {
    @synchronized(self.userViewArray) {
        for (QRDUserView *userView in self.userViewArray) {
            if ([userView.userId isEqualToString:userId]) {
                return userView;
            }
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    @synchronized(_logStringArray) {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @synchronized(_logStringArray) {
        return _logStringArray.count;
    }
}

static const int cLabelTag = 10;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reuseIdentifier"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.tag = cLabelTag;
        
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(cell.contentView).offset(5);
            make.right.bottom.equalTo(cell.contentView).offset(-5);
            
        }];
    }
    
    UILabel *label = [cell.contentView viewWithTag:cLabelTag];
    @synchronized(_logStringArray) {
        if (_logStringArray.count > indexPath.row) {
            label.text = _logStringArray[indexPath.row];
        } else {
            label.text = @"Unknown message";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.tableView.isScrolling = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.tableView.isScrolling = decelerate;
    if (!decelerate) {
        CGFloat offset = fabs(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y);
        NSLog(@"value = %f", offset);
        // 这里小于 10 就算到底部了
        self.tableView.isBottom =  offset < 10;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.tableView.isScrolling = NO;
    
    CGFloat offset = fabs(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y);
    NSLog(@"value = %f", offset);
    // 这里小于 10 就算到底部了
    self.tableView.isBottom =  offset < 10;
}

#pragma mark - 统计信息计算

- (void)startGetStatsTimer {
    
    [self stopGetStatsTimer];
    
    self.getstatsTimer = [NSTimer timerWithTimeInterval:3
                                             target:self
                                           selector:@selector(getStatesTimerAction)
                                           userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.getstatsTimer forMode:NSRunLoopCommonModes];
}

- (void)getStatesTimerAction {
    if (QNConnectionStateConnected != self.client.connectionState && QNConnectionStateReconnected != self.client.connectionState) {
        return;
    }
        
    NSDictionary* videoTrackStats =  [[NSDictionary alloc] initWithDictionary:[self.client getLocalVideoTrackStats]];
    for (NSString * trackID in videoTrackStats.allKeys) {
        NSString *str = nil;
        NSArray *videoTracksArray = videoTrackStats[trackID];
        QNLocalVideoTrackStats *videoStats = videoTracksArray[0];
        str = [NSString stringWithFormat:@"统计信息回调:trackID：%@\n\n视频码率：%2fbps\n本地视频丢包率：%f%%\n视频帧率：%d\n本地 rtt：%d\nprofile：%d\n",trackID, videoStats.uplinkBitrate, videoStats.uplinkLostRate, videoStats.uplinkFrameRate, videoStats.uplinkRTT, videoStats.profile];
        [self addLogString:str];
    }
    
    NSDictionary* audioTrackStats =  [self.client getLocalAudioTrackStats];
    for (NSString * trackID in audioTrackStats.allKeys) {
        NSString *str = nil;
        QNLocalAudioTrackStats * audioState = audioTrackStats[trackID];
        str = [NSString stringWithFormat:@"统计信息回调:trackID：%@\n音频码率：%.2fbps\n音频丢包率：%f%%\n本地 rtt：%d\n",trackID, audioState.uplinkBitrate, audioState.uplinkLostRate,audioState.uplinkRTT];
        [self addLogString:str];
    }
    
    NSDictionary* videoRemoteTrackStats =  [self.client getRemoteVideoTrackStats];
    for (NSString * trackID in videoRemoteTrackStats.allKeys) {
        NSString *str = nil;
        QNRemoteVideoTrackStats * videoStats = videoRemoteTrackStats[trackID];
        str = [NSString stringWithFormat:@"统计信息回调:trackID：%@\n视频码率：%2fbps\n远端服务器视频丢包率：%f%%\n视频帧率：%d\n远端user视频丢包率：%f%%\n远端 rtt：%d\n", trackID,videoStats.downlinkBitrate, videoStats.uplinkLostRate, videoStats.downlinkFrameRate, videoStats.downlinkLostRate, videoStats.uplinkRTT];
        [self addLogString:str];
    }
    
    NSDictionary* audioRemoteTrackStats =  [self.client getRemoteAudioTrackStats];
    for (NSString * trackID in audioRemoteTrackStats.allKeys) {
        NSString *str = nil;
        QNRemoteAudioTrackStats * audioState = audioRemoteTrackStats[trackID];
        str = [NSString stringWithFormat:@"统计信息回调:trackID：%@\n音频码率：%2fbps\n远端服务器音频丢包率：%f%%\n远端user音频丢包率：%f%%\n远端 rtt：%d\n", trackID,audioState.downlinkBitrate, audioState.downlinkLostRate,audioState.uplinkLostRate,audioState.uplinkRTT];
        [self addLogString:str];
    }
    
    NSLog(@"aaron localCount:%d localAudioCount:%d remoteVideo:%d remoteAudio:%d",videoTrackStats.count,audioTrackStats.count,videoRemoteTrackStats.count,audioRemoteTrackStats.count);
}

- (void)stopGetStatsTimer {
    if (self.getstatsTimer) {
        [self.getstatsTimer invalidate];
        self.getstatsTimer = nil;
    }
}


#pragma mark - QRDUserViewDelegate

- (BOOL)userViewWantEnterFullScreen:(QRDUserView *)userview {
    
    if (2 == self.renderBackgroundView.subviews.count) {
        [self exchangeWindowSize];
        return NO;
    }
    return YES;
}


- (void)userView:(QRDUserView *)userview longPressWithUserId:(NSString *)userId {
    if (![self isAdmin]) {
        [self.view showFailTip:@"只有管理员可以踢人"];
        return;
    }
    if ([userId isEqualToString:self.userId]) return;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"踢出" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [self.view showFailTip:@"无踢人功能，请转至服务端触发"];
    }];
    
}

/**
 * 房间状态变更的回调。当状态变为 QNRoomStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leaveRoom 即可
 */
- (void)RTCClient:(QNRTCClient *)client didConnectionStateChanged:(QNConnectionState)state disconnectedInfo:(QNConnectionDisconnectedInfo *)info {
    
    NSDictionary *roomStateDictionary =  @{
                                           @(QNConnectionStateDisconnected) : @"Disconnected",
                                           @(QNConnectionStateConnecting) : @"Connecting",
                                           @(QNConnectionStateConnected): @"Connected",
                                           @(QNConnectionStateReconnecting) : @"Reconnecting",
                                           @(QNConnectionStateReconnected) : @"Reconnected"
                                           };
    NSString *str = [NSString stringWithFormat:@"房间状态变更的回调。当状态变为 QNRoomStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leaveRoom 即可:\nroomState: %@\ninfo:%d",  roomStateDictionary[@(state)], info.reason];
    if (QNConnectionStateConnected == state || QNConnectionStateReconnected == state) {
        [self startGetStatsTimer];
    } else {
        [self stopGetStatsTimer];
    }
    [self addLogString:str];
    if (QNConnectionStateDisconnected == state) {
        switch (info.reason) {
            case QNConnectionDisconnectedReasonKickedOut:{
                str =[NSString stringWithFormat:@"被远端服务器踢出的回调"];
                [self addLogString:str];
            }
                break;
            case QNConnectionDisconnectedReasonLeave:{
                str = [NSString stringWithFormat:@"本地用户离开房间"];
                [self addLogString:str];
            }
                break;
                
            default:{
                str = [NSString stringWithFormat:@"SDK 运行过程中发生错误会通过该方法回调，具体错误码的含义可以见 QNTypeDefines.h 文件:\nerror: %@",  info.error];
                [self addLogString:str];
                switch (info.error.code) {
                    case QNRTCErrorAuthFailed:
                        NSLog(@"鉴权失败，请检查鉴权");
                        break;
                    case QNRTCErrorTokenError:
                        //关于 token 签算规则, 详情请参考【服务端开发说明.RoomToken 签发服务】https://doc.qnsdk.com/rtn/docs/server_overview#1
                        NSLog(@"roomToken 错误");
                        break;
                    case QNRTCErrorTokenExpired:
                        NSLog(@"roomToken 过期");
                        break;
                    default:
                        break;
                }
            }
                break;
        }
    }

}

/**
 * 远端用户加入房间的回调
 */
- (void)RTCClient:(QNRTCClient *)client didJoinOfUserID:(NSString *)userID userData:(NSString *)userData {
    NSString *str = [NSString stringWithFormat:@"远端用户加入房间的回调:userID: %@, userData: %@",  userID, userData];
    [self addLogString:str];
}

/**
 * 远端用户离开房间的回调
 */
- (void)RTCClient:(QNRTCClient *)client didLeaveOfUserID:(NSString *)userID {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ 离开房间的回调", userID];
    [self addLogString:str];
    
    [self clearUserInfo:userID];
}

/**
 * 订阅远端用户成功的回调
 */
- (void)RTCClient:(QNRTCClient *)client didSubscribedRemoteVideoTracks:(NSArray<QNRemoteVideoTrack *> *)videoTracks audioTracks:(NSArray<QNRemoteAudioTrack *> *)audioTracks ofUserID:(NSString *)userID {
    NSString *str = [NSString stringWithFormat:@"订阅远端用户: %@ 成功的回调:\nvideoTracks: %@\naudioTracks: %@", userID, videoTracks,audioTracks];
    [self addLogString:str];
}

/**
 * 远端用户发布音/视频的回调
 */
- (void)RTCClient:(QNRTCClient *)client didUserPublishTracks:(NSArray<QNRemoteTrack *> *)tracks ofUserID:(NSString *)userID {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ 发布成功的回调:\nTracks: %@",  userID, tracks];
    [self addLogString:str];
}

/**
 * 远端用户取消发布音/视频的回调
 */
- (void)RTCClient:(QNRTCClient *)client didUserUnpublishTracks:(NSArray<QNRemoteTrack *> *)tracks ofUserID:(NSString *)userID {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ 取消发布的回调:\nTracks: %@",  userID, tracks];
    [self addLogString:str];
}

/**
* 创建转推的回调
*/
- (void)RTCClient:(QNRTCClient *)client didStartLiveStreamingWith:(NSString *)streamID {
    NSString *str = [NSString stringWithFormat:@"创建转推的回调:\nStreamID: %@",  streamID];
    [self addLogString:str];
}

/**
 * 远端用户视频首帧解码后的回调，如果需要渲染，则调用当前 videoTrack.play(QNVideoGLView*) 方法
 */
- (void)RTCClient:(QNRTCClient *)client firstVideoDidDecodeOfTrack:(QNRemoteVideoTrack *)videoTrack remoteUserID:(NSString *)userID {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ trackID: %@ 视频首帧解码后的回调",  userID, videoTrack.trackID];
    [self addLogString:str];
}

/**
 * 远端用户视频取消渲染到 renderView 上的回调
 */
- (void)RTCClient:(QNRTCClient *)client didDetachRenderTrack:(QNRemoteVideoTrack *)videoTrack remoteUserID:(NSString *)userID {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ trackID: %@ 视频取消渲染到 renderView 上的回调",  userID, videoTrack.trackID];
    [self addLogString:str];
}

/**
* 远端用户发生重连
*/
- (void)RTCClient:(QNRTCClient *)client didReconnectingOfUserID:(NSString *)userID {
    NSString *logStr = [NSString stringWithFormat:@"userId 为 %@ 的远端用户发生了重连！", userID];
    [self addLogString:logStr];
}

/**
* 远端用户重连成功
*/
- (void)RTCClient:(QNRTCClient *)client didReconnectedOfUserID:(NSString *)userID {
    NSString *logStr = [NSString stringWithFormat:@"userId 为 %@ 的远端用户重连成功了！", userID];
    [self addLogString:logStr];
}

#pragma mark QNRemoteVideoTrackDelegate

- (void)remoteVideoTrack:(QNRemoteVideoTrack *)remoteVideoTrack didMuteStateChanged:(BOOL)isMuted {
    NSString *str = [NSString stringWithFormat:@"远端视频用户: %@ trackId: %@ Track 状态变更为: %d 的回调",  remoteVideoTrack.userID, remoteVideoTrack.trackID, remoteVideoTrack.muted];
    [self addLogString:str];
}

#pragma mark QNRemoteAudioTrackDelegate

- (void)remoteAudioTrack:(QNRemoteAudioTrack *)remoteAudioTrack didMuteStateChanged:(BOOL)isMuted {
    NSString *str = [NSString stringWithFormat:@"远端音频用户: %@ trackId: %@ Track 状态变更为: %d 的回调",  remoteAudioTrack.userID, remoteAudioTrack.trackID, remoteAudioTrack.muted];
    [self addLogString:str];
}

#pragma mark QNRemoteTrackAudioDataDelegate

/**
 * 远端用户视频数据的回调
 *
 * 注意：回调远端用户视频数据会带来一定的性能消耗，如果没有相关需求，请不要实现该回调
 */
- (void)remoteVideoTrack:(QNRemoteVideoTrack *)remoteVideoTrack didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer; {
    static int i = 0;
    if (i % 300 == 0) {
        NSString *str = [NSString stringWithFormat:@"远端用户视频数据的回调:\ntrackID: %@ size: %zux%zu",remoteVideoTrack.trackID, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer)];
//                [self addLogString:str];
    }
    i ++;
    
}

#pragma mark QNRemoteTrackAudioDataDelegate

/**
 * 远端用户音频数据的回调
 *
 * 注意：回调远端用户音频数据会带来一定的性能消耗，如果没有相关需求，请不要实现该回调
 */
- (void)remoteAudioTrack:(QNRemoteAudioTrack *)remoteAudioTrack didGetAudioBuffer:(AudioBuffer *)audioBuffer bitsPerSample:(NSUInteger)bitsPerSample sampleRate:(NSUInteger)sampleRate {
    static int i = 0;
    if (i % 500 == 0) {
        NSString *str = [NSString stringWithFormat:@"远端用户音频数据的回调:\ntrackID: %@\NbufferCount: %d\nbitsPerSample:%lu\nsampleRate:%lu,dataLen = %u",remoteAudioTrack.trackID, i, (unsigned long)bitsPerSample, (unsigned long)sampleRate, (unsigned int)audioBuffer->mDataByteSize];
//                [self addLogString:str];
    }
    i ++;
}

#pragma mark QNLocalVideoTrackDelegate

/**
 * 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致编码帧率下降
 */
- (void)localVideoTrack:(QNLocalVideoTrack *)localVideoTrack didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    static int i = 0;
    if (i % 300 == 0) {
        NSString *str = [NSString stringWithFormat:@"获取到本地track: %@ 的原数据时的回调:\nbufferCount: %d, size = %zux%zu",localVideoTrack.trackID,  i, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer)];
        //        [self addLogString:str];
    }
    i ++;
}

#pragma mark QNLocalAudioTrackDelegate

/**
 * 获取到麦克风原数据时的回调，需要注意的是这个回调在 AU Remote IO 线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题
 */
- (void)localAudioTrack:(QNLocalAudioTrack *)localAudioTrack didGetAudioBuffer:(AudioBuffer *)audioBuffer bitsPerSample:(NSUInteger)bitsPerSample sampleRate:(NSUInteger)sampleRate {
    static int i = 0;
    if (i % 500 == 0) {
        NSString *str = [NSString stringWithFormat:@"获取到本地音频 track  ：%@ 的原数据时的回调:\nbufferCount: %d, dataLen = %u", localAudioTrack.trackID,  i, (unsigned int)audioBuffer->mDataByteSize];
        //        [self addLogString:str];
    }
    i ++;
}

@end
