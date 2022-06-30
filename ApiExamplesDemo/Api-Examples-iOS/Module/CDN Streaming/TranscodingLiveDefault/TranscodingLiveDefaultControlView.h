//
//  TranscodingLiveDefaultControlView.h
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/12/10.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface TranscodingLiveDefaultControlView : UIView
@property (weak, nonatomic) IBOutlet RadioButton *localUserButton;
@property (weak, nonatomic) IBOutlet RadioButton *remoteUserButton;
@property (weak, nonatomic) IBOutlet UITextField *layoutXTF;
@property (weak, nonatomic) IBOutlet UITextField *layoutYTF;
@property (weak, nonatomic) IBOutlet UITextField *layoutWidthTF;
@property (weak, nonatomic) IBOutlet UITextField *layoutHeightTF;
@property (weak, nonatomic) IBOutlet UITextField *layoutZTF;
@property (weak, nonatomic) IBOutlet UIButton *addLayoutButton;
@property (weak, nonatomic) IBOutlet UIButton *removeLayoutButton;

@end

NS_ASSUME_NONNULL_END
