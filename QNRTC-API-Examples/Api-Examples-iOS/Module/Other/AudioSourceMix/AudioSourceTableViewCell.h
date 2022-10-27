//
//  AudioSourceTableViewCell.h
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioSourceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;

@end

NS_ASSUME_NONNULL_END
