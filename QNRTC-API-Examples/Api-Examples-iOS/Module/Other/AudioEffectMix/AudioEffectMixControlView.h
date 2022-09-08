//
//  AudioEffectMixControlView.h
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioEffectMixControlView : UIView
@property (weak, nonatomic) IBOutlet UIButton *stopAllButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseAllButton;
@property (weak, nonatomic) IBOutlet UISwitch *playbackSwitch;
@property (weak, nonatomic) IBOutlet UISlider *microphoneMixVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *audioPlayVolumeSlider;
@property (weak, nonatomic) IBOutlet UITableView *audioEffectTableView;

@end

NS_ASSUME_NONNULL_END
