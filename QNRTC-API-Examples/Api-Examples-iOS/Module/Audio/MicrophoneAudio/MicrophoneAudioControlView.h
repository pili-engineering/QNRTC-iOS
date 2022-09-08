//
//  MicrophoneAudioControlView.h
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MicrophoneAudioControlView : UIView
@property (weak, nonatomic) IBOutlet UISlider *localVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *remoteVolumeSlider;
@end

NS_ASSUME_NONNULL_END
