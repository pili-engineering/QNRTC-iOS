//
//  MediaRecordControlView.h
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2024/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaRecordControlView : UIView
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

NS_ASSUME_NONNULL_END
