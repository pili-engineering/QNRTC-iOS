//
//  AudioMusicMixControlView.h
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioMusicMixControlView : UIView

@property (weak, nonatomic) IBOutlet UITextField *musicUrlTF;
@property (weak, nonatomic) IBOutlet UITextField *loopTimeTF;

@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UISlider *micInputVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *musicInputVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *musicPlayVolumeSlider;

@property (weak, nonatomic) IBOutlet UIButton *playStopButton;
@property (weak, nonatomic) IBOutlet UIButton *resumePauseButton;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *playbackSwitch;

@end

NS_ASSUME_NONNULL_END
