//
//  AudioSourceMixControlView.h
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioSourceMixControlView : UIView
@property (weak, nonatomic) IBOutlet UISwitch *playbackSwitch;
@property (weak, nonatomic) IBOutlet UISlider *microphoneMixVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *audioPlayVolumeSlider;
@property (weak, nonatomic) IBOutlet UITableView *audioSourceTableView;

@end

NS_ASSUME_NONNULL_END
