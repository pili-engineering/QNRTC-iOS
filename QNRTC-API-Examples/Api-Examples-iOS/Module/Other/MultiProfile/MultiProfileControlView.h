//
//  MultiProfileControlView.h
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/12/6.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultiProfileControlView : UIView
@property (weak, nonatomic) IBOutlet UILabel *currentProfileTF;
@property (weak, nonatomic) IBOutlet UIButton *switchProfileButton;
@property (weak, nonatomic) IBOutlet RadioButton *lowButton;
@property (weak, nonatomic) IBOutlet RadioButton *mediumButton;
@property (weak, nonatomic) IBOutlet RadioButton *highButton;
@end

NS_ASSUME_NONNULL_END
