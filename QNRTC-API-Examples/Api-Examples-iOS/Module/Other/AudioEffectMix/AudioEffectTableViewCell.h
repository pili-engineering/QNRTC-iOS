//
//  AudioEffectTableViewCell.h
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioEffectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@end

NS_ASSUME_NONNULL_END
