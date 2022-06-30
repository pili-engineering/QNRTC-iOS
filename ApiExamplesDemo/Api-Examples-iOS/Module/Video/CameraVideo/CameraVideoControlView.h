//
//  CameraVideoControlView.h
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraVideoControlView : UIView

@property (weak, nonatomic) IBOutlet UISwitch *beautySwitch;
@property (weak, nonatomic) IBOutlet UISlider *beautyStrengthSlider;
@property (weak, nonatomic) IBOutlet UISlider *beautyReddenSlider;
@property (weak, nonatomic) IBOutlet UISlider *beautyWhitenSlider;

@end

NS_ASSUME_NONNULL_END
