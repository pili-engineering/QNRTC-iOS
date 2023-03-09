//
//  ScanViewController.h
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ScanViewControllerDelegate <NSObject>

- (void)scanQRResult:(NSString *)qrString;

@end

@interface ScanViewController : UIViewController
@property (nonatomic, weak) id<ScanViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
