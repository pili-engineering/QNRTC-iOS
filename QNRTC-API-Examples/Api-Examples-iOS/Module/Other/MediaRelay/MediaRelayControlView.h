//
//  MediaRelayControlView.h
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaRelayControlView : UIView
@property (weak, nonatomic) IBOutlet UITextField *destRoomTokenTextField;
@property (weak, nonatomic) IBOutlet UIButton *startMediaRelayButton;
@property (weak, nonatomic) IBOutlet UIButton *stopMediaRelayButton;
@property (weak, nonatomic) IBOutlet UILabel *tokenInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;

@end

NS_ASSUME_NONNULL_END
