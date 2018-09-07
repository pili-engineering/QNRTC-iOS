//
//  QRDUserView.h
//  QNRTCKitDemo
//
//  Created by suntongmian on 2018/9/3.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import <QNRTCKit/QNRTCKit.h>

@class QRDUserView;

@protocol QRDUserViewDelegate <NSObject>

- (void)longPressUserView:(QRDUserView *)userView userId:(NSString *)userId;

@end

@interface QRDUserView : QNVideoView

@property (nonatomic, weak) id<QRDUserViewDelegate> delegate;
@property (nonatomic, strong) UIColor *userIdBackgroundColor;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL videoMuted;
@property (nonatomic, assign) BOOL audioMuted;

- (instancetype)initWithFrame:(CGRect)frame;

@end
