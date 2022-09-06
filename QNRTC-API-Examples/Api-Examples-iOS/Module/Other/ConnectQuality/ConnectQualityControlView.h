//
//  ConnectQualityControlView.h
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConnectQualityControlView : UIView
@property (weak, nonatomic) IBOutlet UILabel *localUplinkNetworkGradeL;
@property (weak, nonatomic) IBOutlet UILabel *localDownlinkNetworkGradeL;
@property (weak, nonatomic) IBOutlet UILabel *localAudioUplinkBitrateL;
@property (weak, nonatomic) IBOutlet UILabel *localAudioUplinkRttL;
@property (weak, nonatomic) IBOutlet UILabel *localAudioUplinkLostRateL;
@property (weak, nonatomic) IBOutlet UILabel *localVideoProfileL;
@property (weak, nonatomic) IBOutlet UILabel *localVideoUplinkFpsL;
@property (weak, nonatomic) IBOutlet UILabel *localVideoUplinkBitrateL;
@property (weak, nonatomic) IBOutlet UILabel *localVideoUplinkRttL;
@property (weak, nonatomic) IBOutlet UILabel *localVideoUplinkLostRateL;

@property (weak, nonatomic) IBOutlet UILabel *remoteUplinkNetworkGradeL;
@property (weak, nonatomic) IBOutlet UILabel *remoteDownlinkNetworkGradeL;
@property (weak, nonatomic) IBOutlet UILabel *remoteAudioDownlinkBitrateL;
@property (weak, nonatomic) IBOutlet UILabel *remoteAudioDownloadLostRateL;
@property (weak, nonatomic) IBOutlet UILabel *remoteAudioUplinkRttL;
@property (weak, nonatomic) IBOutlet UILabel *remoteAudioUplinkLostRateL;

@property (weak, nonatomic) IBOutlet UILabel *remoteVideoProfileL;
@property (weak, nonatomic) IBOutlet UILabel *remoteVideoDownloadFpsL;
@property (weak, nonatomic) IBOutlet UILabel *remoteVideoDownloadBitrateL;
@property (weak, nonatomic) IBOutlet UILabel *remoteVideoDownloadLostRateL;
@property (weak, nonatomic) IBOutlet UILabel *remoteVideoUplinkRttL;
@property (weak, nonatomic) IBOutlet UILabel *remoteVideoUplinkLostRateL;

- (void)resetLocal;
- (void)resetRemote;

@end

NS_ASSUME_NONNULL_END
