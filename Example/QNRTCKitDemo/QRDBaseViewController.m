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
@end

@implementation QRDBaseViewController

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    NSLog(@"[dealloc]==> %@", self.description);
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
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeWindowSize)];
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
    
    if ([self.engine.previewView.gestureRecognizers containsObject:self.singleTap]) {
        [self.engine.previewView removeGestureRecognizer:self.singleTap];
    }
    if ([self.colorView.gestureRecognizers containsObject:self.singleTap]) {
        [self.colorView removeGestureRecognizer:self.singleTap];
    }
    
    UIView *gestureView = self.colorView;
    if (self.engine.previewView.superview == self.colorView &&
        NO == self.engine.previewView.hidden) {
        gestureView = self.engine.previewView;
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
        return self.logStringArray.count > 0 ? 1 : 0;
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
        [self.engine kickoutUser:userId];
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定要将 %@ 踢出房间?", userId] message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
                                
    [self presentViewController:alert animated:YES completion:nil];
}


/**
 * SDK 运行过程中发生错误会通过该方法回调，具体错误码的含义可以见 QNTypeDefines.h 文件
 */
- (void)RTCEngine:(QNRTCEngine *)engine didFailWithError:(NSError *)error {
    NSString *str = [NSString stringWithFormat:@"SDK 运行过程中发生错误会通过该方法回调，具体错误码的含义可以见 QNTypeDefines.h 文件:\nerror: %@",  error];
    [self addLogString:str];
}

/**
 * 房间状态变更的回调。当状态变为 QNRoomStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leaveRoom 即可
 */
- (void)RTCEngine:(QNRTCEngine *)engine roomStateDidChange:(QNRoomState)roomState {
    
    NSDictionary *roomStateDictionary =  @{
                                           @(QNRoomStateIdle) : @"Idle",
                                           @(QNRoomStateConnecting) : @"Connecting",
                                           @(QNRoomStateConnected): @"Connected",
                                           @(QNRoomStateReconnecting) : @"Reconnecting",
                                           @(QNRoomStateReconnected) : @"Reconnected"
                                           };
    NSString *str = [NSString stringWithFormat:@"房间状态变更的回调。当状态变为 QNRoomStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leaveRoom 即可:\nroomState: %@",  roomStateDictionary[@(roomState)]];
    [self addLogString:str];
}

/**
 * 本地音视频发布到服务器的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didPublishLocalTracks:(NSArray<QNTrackInfo *> *)tracks {
    NSString *str = [NSString stringWithFormat:@"本地 Track 发布到服务器的回调:\n%@", tracks];
    [self addLogString:str];
}

/**
 * 远端用户加入房间的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didJoinOfRemoteUserId:(NSString *)userId userData:(NSString *)userData {
    NSString *str = [NSString stringWithFormat:@"远端用户加入房间的回调:\nuserId: %@, userData: %@",  userId, userData];
    [self addLogString:str];
}

/**
 * 远端用户离开房间的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didLeaveOfRemoteUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ 离开房间的回调", userId];
    [self addLogString:str];
    
    [self clearUserInfo:userId];
}

/**
 * 订阅远端用户成功的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didSubscribeTracks:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"订阅远端用户: %@ 成功的回调:\nTracks: %@", userId, tracks];
    [self addLogString:str];
}

/**
 * 远端用户发布音/视频的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didPublishTracks:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ 发布成功的回调:\nTracks: %@",  userId, tracks];
    [self addLogString:str];
}

/**
 * 远端用户取消发布音/视频的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didUnPublishTracks:(NSArray<QNTrackInfo *> *)tracks ofRemoteUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ 取消发布的回调:\nTracks: %@",  userId, tracks];
    [self addLogString:str];
}

/**
 * 被 userId 踢出的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didKickoutByUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"被远端用户: %@ 踢出的回调",  userId];
    [self addLogString:str];
}

/**
 * 远端用户音频状态变更为 muted 的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didAudioMuted:(BOOL)muted ofTrackId:(NSString *)trackId byRemoteUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ trackId: %@ 音频状态变更为: %d 的回调",  userId, trackId, muted];
    [self addLogString:str];
}

/**
 * 远端用户视频状态变更为 muted 的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didVideoMuted:(BOOL)muted ofTrackId:(NSString *)trackId byRemoteUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ trackId: %@ 视频状态变更为: %d 的回调",  userId, trackId, muted];
    [self addLogString:str];
}

/**
 * 远端用户视频首帧解码后的回调，如果需要渲染，则需要返回一个带 renderView 的 QNVideoRender 对象
 */
- (QNVideoRender *)RTCEngine:(QNRTCEngine *)engine firstVideoDidDecodeOfTrackId:(NSString *)trackId remoteUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ trackId: %@ 视频首帧解码后的回调",  userId, trackId];
    [self addLogString:str];

    return nil;
}

/**
 * 远端用户视频取消渲染到 renderView 上的回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didDetachRenderView:(UIView *)renderView ofTrackId:(NSString *)trackId remoteUserId:(NSString *)userId {
    NSString *str = [NSString stringWithFormat:@"远端用户: %@ trackId: %@ 视频取消渲染到 renderView 上的回调",  userId, trackId];
    [self addLogString:str];
}

/**
 * 远端用户视频数据的回调
 *
 * 注意：回调远端用户视频数据会带来一定的性能消耗，如果没有相关需求，请不要实现该回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer ofTrackId:(NSString *)trackId remoteUserId:(NSString *)userId {
    static int i = 0;
    if (i % 300 == 0) {
        NSString *str = [NSString stringWithFormat:@"远端用户视频数据的回调:\nuserId: %@ size: %zux%zu", userId, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer)];
        //        [self addLogString:str];
    }
    i ++;
    
}

/**
 * 远端用户音频数据的回调
 *
 * 注意：回调远端用户音频数据会带来一定的性能消耗，如果没有相关需求，请不要实现该回调
 */
- (void)RTCEngine:(QNRTCEngine *)engine
didGetAudioBuffer:(AudioBuffer *)audioBuffer
    bitsPerSample:(NSUInteger)bitsPerSample
       sampleRate:(NSUInteger)sampleRate
        ofTrackId:(NSString *)trackId
     remoteUserId:(NSString *)userId {
    static int i = 0;
    if (i % 500 == 0) {
        NSString *str = [NSString stringWithFormat:@"远端用户音频数据的回调:\nuserId: %@\nbufferCount: %d\nbitsPerSample:%lu\nsampleRate:%lu,dataLen = %u",  userId, i, (unsigned long)bitsPerSample, (unsigned long)sampleRate, (unsigned int)audioBuffer->mDataByteSize];
        //        [self addLogString:str];
    }
    i ++;
}

/**
 * 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致编码帧率下降
 */
- (void)RTCEngine:(QNRTCEngine *)engine cameraSourceDidGetSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    static int i = 0;
    if (i % 300 == 0) {
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        NSString *str = [NSString stringWithFormat:@"获取到摄像头原数据时的回调:\nbufferCount: %d, size = %zux%zu",  i, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer)];
        //        [self addLogString:str];
    }
    i ++;
}

/**
 * 获取到麦克风原数据时的回调，需要注意的是这个回调在 AU Remote IO 线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题
 */
- (void)RTCEngine:(QNRTCEngine *)engine microphoneSourceDidGetAudioBuffer:(AudioBuffer *)audioBuffer {
    static int i = 0;
    if (i % 500 == 0) {
        NSString *str = [NSString stringWithFormat:@"获取到麦克风原数据时的回调:\nbufferCount: %d, dataLen = %u",  i, (unsigned int)audioBuffer->mDataByteSize];
        //        [self addLogString:str];
    }
    i ++;
}

/**
 *统计信息回调，回调的时间间隔由 statisticInterval 参数决定，statisticInterval 默认为 0，即不回调统计信息
 */
- (void)RTCEngine:(QNRTCEngine *)engine
  didGetStatistic:(NSDictionary *)statistic
        ofTrackId:(NSString *)trackId
           userId:(NSString *)userId {
    NSString *str = nil;
    if (statistic[QNStatisticAudioBitrateKey] && statistic[QNStatisticAudioPacketLossRateKey]) {
        int audioBitrate = [[statistic objectForKey:QNStatisticAudioBitrateKey] intValue];
        float audioPacketLossRate = [[statistic objectForKey:QNStatisticAudioPacketLossRateKey] floatValue];
        str = [NSString stringWithFormat:@"音频码率: %dbps\n音频丢包率：%3.1f%%\n", audioBitrate, audioPacketLossRate];
    }
    else {
        int videoBitrate = [[statistic objectForKey:QNStatisticVideoBitrateKey] intValue];
        float videoPacketLossRate = [[statistic objectForKey:QNStatisticVideoPacketLossRateKey] floatValue];
        int videoFrameRateKey = [[statistic objectForKey:QNStatisticVideoFrameRateKey] intValue];
        str = [NSString stringWithFormat:@"视频码率：%dbps\n视频丢包率：%3.1f%%\n视频帧率：%d", videoBitrate, videoPacketLossRate, videoFrameRateKey];
    }
    NSString *logStr = [NSString stringWithFormat:@"统计信息回调:userId: %@ trackId: %@\n%@", userId, trackId, str];
    [self addLogString:logStr];
}

@end
