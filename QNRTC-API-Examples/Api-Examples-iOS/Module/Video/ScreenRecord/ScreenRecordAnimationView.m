//
//  ScreenRecordAnimationView.m
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/12/2.
//

#import "ScreenRecordAnimationView.h"

@interface ScreenRecordAnimationView ()

@property (nonatomic, strong) UIImageView *animationView;

@end

@implementation ScreenRecordAnimationView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.animationView];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)startAnimation {
    [self.animationView startAnimating];
}

- (void)stopAnimation {
    [self.animationView stopAnimating];
}

- (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _animationView.contentMode = UIViewContentModeScaleAspectFit;
        _animationView.animationImages = @[[UIImage imageNamed:@"img_01"], [UIImage imageNamed:@"img_02"], [UIImage imageNamed:@"img_03"], [UIImage imageNamed:@"img_04"]];
        _animationView.animationDuration = 0.2;
    }
    return _animationView;
}
@end
