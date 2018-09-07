//
//  QRDUserView.m
//  QNRTCKitDemo
//
//  Created by suntongmian on 2018/9/3.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDUserView.h"

@interface QRDUserView ()

@property (nonatomic, strong, readwrite) UILabel *userIdLabel;
@property (nonatomic, strong, readwrite) UIImageView *audioMutedImageView;

@end

@implementation QRDUserView

@synthesize userIdBackgroundColor = _userIdBackgroundColor;
@synthesize userId = _userId;
@synthesize audioMuted = _audioMuted;
@synthesize videoMuted = _videoMuted;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        self.userIdLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.userIdLabel.textColor = [UIColor whiteColor];
        self.userIdLabel.textAlignment = NSTextAlignmentCenter;
        self.userIdLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.userIdLabel];
        
        self.audioMutedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 26, self.bounds.size.height - 34, 20, 26)];
        self.audioMutedImageView.userInteractionEnabled = YES;
        self.audioMutedImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.audioMutedImageView];
        
        UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressViewAction:)];
        longPressGest.minimumPressDuration = 2;
        [self addGestureRecognizer:longPressGest];
    }
    return self;
}

- (void)setUserIdBackgroundColor:(UIColor *)userIdBackgroundColor {
    _userIdBackgroundColor = userIdBackgroundColor;
    self.userIdLabel.backgroundColor = userIdBackgroundColor;
}

- (UIColor *)userIdBackgroundColor {
    return _userIdBackgroundColor;
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    self.userIdLabel.text = userId;
}

- (NSString *)userId {
    return _userId;
}

- (void)setVideoMuted:(BOOL)videoMuted {
    _videoMuted = videoMuted;
    self.userIdLabel.hidden = videoMuted ? NO : YES;
}

- (BOOL)videoMuted {
    return _videoMuted;
}

- (void)setAudioMuted:(BOOL)audioMuted {
    _audioMuted = audioMuted;
    if (audioMuted) {
        self.audioMutedImageView.image = [UIImage imageNamed:@"microphone-disable"];
    } else {
        self.audioMutedImageView.image = [UIImage imageNamed:@"un_mute_audio"];
    }
}

- (void)longPressViewAction:(UILongPressGestureRecognizer *)longPressGest {
    if (longPressGest.state != UIGestureRecognizerStateBegan) return;
    
    NSLog(@"%s, user: %@", __func__, self.userId);

    if (self.delegate && [self.delegate respondsToSelector:@selector(longPressUserView:userId:)]) {
        [self.delegate longPressUserView:self userId:self.userId];
    }
}

- (BOOL)audioMuted {
    return _audioMuted;
}

- (void)dealloc {
    
}

@end
