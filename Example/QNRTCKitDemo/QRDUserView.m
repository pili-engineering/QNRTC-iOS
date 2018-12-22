//
//  VideoView.m
//  QNRTCTestDemo
//
//  Created by hxiongan on 2018/8/21.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import "QRDUserView.h"
#import "QRDPublicHeader.h"
#import <Masonry.h>

@interface QRDUserView ()

@property (nonatomic, strong) UIImageView *muteView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong, readwrite) QNVideoView *cameraView;
@property (nonatomic, strong, readwrite) QNVideoView *screenView;

@property (nonatomic, strong) UILabel *alertLabel;
//@property (nonatomic, strong) EZAudioPlot *plotView;

@end

@implementation QRDUserView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:random()%200/255.0 green:random()%200/255.0 blue:random()%100/255.0 alpha:1];
        
        _traks = [[NSMutableArray alloc] init];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        
        _muteView = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"un_mute_audio"];
        _muteView.image = img;
        _muteView.hidden = YES;
        [self addSubview:_muteView];
        
        [_muteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.size.equalTo(img.size);
        }];

        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self.muteView.right);
            make.right.equalTo(self);
        }];
        
        _cameraView = [[QNVideoView alloc] init];
        _cameraView.hidden = YES;
        [self insertSubview:_cameraView atIndex:0];
        
        [_cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _screenView = [[QNVideoView alloc] initWithFrame:self.bounds];
        _screenView.hidden = YES;
        [self insertSubview:_screenView atIndex:0];
        [_screenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressViewAction:)];
        longPress.minimumPressDuration = 1;
        [self addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapScreenView:)];
        [singletap requireGestureRecognizerToFail:longPress];
        [_screenView addGestureRecognizer:singletap];
        
        singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapCameraView:)];
        [singletap requireGestureRecognizerToFail:longPress];
        [_cameraView addGestureRecognizer:singletap];
    }
    return self;
}

- (void)longPressViewAction:(UILongPressGestureRecognizer *)longPressGest {
    if (longPressGest.state != UIGestureRecognizerStateBegan) return;
    
    NSLog(@"%s, user: %@", __func__, self.userId);
    
    if (self.delegate) {
        [self.delegate userView:self longPressWithUserId:self.userId];
    }
}

- (void)setAudioMute:(BOOL)isMute {
    dispatch_main_async_safe(^{
        self.muteView.image = [UIImage imageNamed:isMute ? @"microphone-disable" : @"un_mute_audio"];
    });
}

- (void)setVideoHidden:(BOOL)isHidden {
//    dispatch_main_async_safe(^{
//        self.nameLabel.hidden = !isHidden;
//        self.plotView.hidden = !isHidden;
//    });
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;

    dispatch_main_async_safe(^{
        self.nameLabel.text = userId;
    });
}

//- (void)setTrackId:(NSString *)trackId {
//    _trackId = trackId;
//
//    NSString *string = [NSString stringWithFormat:@"%@:%@", _userId, _trackId];
//}

- (void)setMuteViewHidden:(BOOL)isHidden {
    dispatch_main_async_safe(^{
        self.muteView.hidden = isHidden;
    });
}

- (void)updateBuffer:(short *)buffer withBufferSize:(UInt32)bufferSize {
//    [self.plotView updateBuffer:buffer withBufferSize:bufferSize];
}

- (UILabel *)alertLabel {
    if (nil == _alertLabel) {
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.text = @"全屏预览中，轻触屏幕退出";
        _alertLabel.font = [UIFont systemFontOfSize:20];
        _alertLabel.textColor = [UIColor whiteColor];
        [_alertLabel sizeToFit];
        _alertLabel.center = CGPointMake(self.fullScreenSuperView.bounds.size.width/2, self.fullScreenSuperView.bounds.size.height - 30);
    }
    return _alertLabel;
}

- (void)showCameraView {
    dispatch_main_async_safe(^{
        _cameraView.hidden = NO;
        if (_screenView.hidden) {
            [_cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        } else {
            [_cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(self);
                make.width.height.equalTo(self).multipliedBy(.4);
            }];
        }
        
        [UIView animateWithDuration:.25 animations:^{
            [self layoutIfNeeded];
        }];
    });
}

- (void)hideCameraView {
    dispatch_main_async_safe(^{
        _cameraView.hidden = YES;
        
        if (_cameraView.superview != self) {
            [self singleTapCameraView:nil];
        }
    });
}

- (void)showScreenView {
    dispatch_main_async_safe(^{
        
        _screenView.hidden = NO;
        
        [_cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self);
            make.width.height.equalTo(self).multipliedBy(.4);
        }];

        [UIView animateWithDuration:.25 animations:^{
            [self layoutIfNeeded];
        }];
    });
}

- (void)hideScreenView {
    dispatch_main_async_safe(^{
        
        _screenView.hidden = YES;
        
        [_cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        if (_screenView.superview != self) {
            [self singleTapScreenView:nil];
        } else {
            [UIView animateWithDuration:.25 animations:^{
                [self layoutIfNeeded];
            }];
        }
    });
}

- (QNTrackInfo *)trackInfoWithTrackId:(NSString *)trackId {
    for (QNTrackInfo *trackInfo in self.traks) {
        if ([trackInfo.trackId isEqualToString:trackId]) {
            return trackInfo;
        }
    }
    return nil;
}

- (void)singleTapScreenView:(UITapGestureRecognizer *)gesture {
    
    if (self.delegate && NO == [self.delegate userViewWantEnterFullScreen:self]) return;
    
    if (_screenView.superview != self) {
        
        CGRect fromRect = [_fullScreenSuperView convertRect:_screenView.frame toView:self];
        [_screenView removeFromSuperview];
        _screenView.frame = fromRect;
        [self insertSubview:_screenView atIndex:0];
        [_screenView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [UIView animateWithDuration:.25 animations:^{
            [self layoutIfNeeded];
        }];
        [self.alertLabel removeFromSuperview];
    } else {
        
        CGRect fromRect = _screenView.frame;
        fromRect = [self convertRect:fromRect toView:self.fullScreenSuperView];
        [_screenView removeFromSuperview];
        _screenView.frame = fromRect;
        [self.fullScreenSuperView addSubview:_screenView];
        
        
        [_screenView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.fullScreenSuperView);
        }];
        
        [UIView animateWithDuration:.25 animations:^{
            [self.fullScreenSuperView layoutIfNeeded];
        }];
        
        [_screenView addSubview:self.alertLabel];
    }
}

- (void)singleTapCameraView:(UITapGestureRecognizer *)gesture {
    
    if (self.delegate && NO == [self.delegate userViewWantEnterFullScreen:self]) return;
    
    if (_cameraView.superview != self) {
        
        CGRect fromRect = [_fullScreenSuperView convertRect:_cameraView.frame toView:self];
        [_cameraView removeFromSuperview];
        _cameraView.frame = fromRect;
        [self insertSubview:_cameraView aboveSubview:_screenView];
        
        if (_screenView.isHidden) {
            [_cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        } else {
            [_cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(self);
                make.width.height.equalTo(self).multipliedBy(.4);
            }];
        }
        
        [UIView animateWithDuration:.25 animations:^{
            [self layoutIfNeeded];
        }];
        [self.alertLabel removeFromSuperview];
    } else {
        
        CGRect fromRect = _cameraView.frame;
        fromRect = [self convertRect:fromRect toView:self.fullScreenSuperView];
        [_cameraView removeFromSuperview];
        _cameraView.frame = fromRect;
        [self.fullScreenSuperView addSubview:_cameraView];
        
        [_cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.fullScreenSuperView);
        }];
        
        [UIView animateWithDuration:.25 animations:^{
            [self.fullScreenSuperView layoutIfNeeded];
        }];
        
        [_cameraView addSubview:self.alertLabel];

    }
}


@end
