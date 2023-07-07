//
//  TranscodingLiveCustomControlView.h
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/12/10.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface TranscodingLiveCustomControlView : UIView
@property (weak, nonatomic) IBOutlet UITextField *publishUrlTF;
@property (weak, nonatomic) IBOutlet UITextField *streamWidthTF;
@property (weak, nonatomic) IBOutlet UITextField *streamHeightTF;
@property (weak, nonatomic) IBOutlet UITextField *streamFpsTF;
@property (weak, nonatomic) IBOutlet UITextField *streamBpsTF;
@property (weak, nonatomic) IBOutlet RadioButton *aspectFillButton;
@property (weak, nonatomic) IBOutlet RadioButton *aspectFitButton;
@property (weak, nonatomic) IBOutlet RadioButton *scaleFitButton;
@property (weak, nonatomic) IBOutlet UISwitch *watermarkSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *bgImageSwitch;
@property (weak, nonatomic) IBOutlet UIButton *startStreamingButton;
@property (weak, nonatomic) IBOutlet UIButton *stopStreamingButton;

@property (weak, nonatomic) IBOutlet RadioButton *localUserButton;
@property (weak, nonatomic) IBOutlet RadioButton *remoteUserButton;
@property (weak, nonatomic) IBOutlet UITextField *layoutXTF;
@property (weak, nonatomic) IBOutlet UITextField *layoutYTF;
@property (weak, nonatomic) IBOutlet UITextField *layoutWidthTF;
@property (weak, nonatomic) IBOutlet UITextField *layoutHeightTF;
@property (weak, nonatomic) IBOutlet UITextField *layoutZTF;
@property (weak, nonatomic) IBOutlet UIButton *addLayoutButton;
@property (weak, nonatomic) IBOutlet UIButton *removeLayoutButton;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@end

NS_ASSUME_NONNULL_END
