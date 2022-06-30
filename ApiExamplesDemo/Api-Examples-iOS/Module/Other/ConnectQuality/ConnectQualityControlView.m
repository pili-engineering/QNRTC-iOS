//
//  ConnectQualityControlView.m
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/12/8.
//

#import "ConnectQualityControlView.h"

@implementation ConnectQualityControlView

- (void)resetLocal {
    self.localUplinkNetworkGradeL.text = @"None";
    self.localDownlinkNetworkGradeL.text = @"None";
    
    self.localAudioUplinkBitrateL.text = @"0 kbps";
    self.localAudioUplinkRttL.text = @"0 ms";
    self.localAudioUplinkLostRateL.text = @"0.0 %";
    
    self.localVideoProfileL.text = @"None";
    self.localVideoUplinkFpsL.text = @"0 fps";
    self.localVideoUplinkBitrateL.text = @"0 kbps";
    self.localVideoUplinkRttL.text = @"0 ms";
    self.localVideoUplinkLostRateL.text = @"0.0 %";
}

- (void)resetRemote {
    self.remoteUplinkNetworkGradeL.text = @"None";
    self.remoteDownlinkNetworkGradeL.text = @"None";
    
    self.remoteAudioDownlinkBitrateL.text = @"0 kbps";
    self.remoteAudioDownloadLostRateL.text = @"0.0 %";
    self.remoteAudioUplinkRttL.text = @"0 ms";
    self.remoteAudioUplinkLostRateL.text = @"0.0 %";
    
    self.remoteVideoProfileL.text = @"None";
    self.remoteVideoDownloadFpsL.text = @"0 fps";
    self.remoteVideoDownloadBitrateL.text = @"0 kbps";
    self.remoteVideoDownloadLostRateL.text = @"0.0 %";
    self.remoteVideoUplinkRttL.text = @"0 ms";
    self.remoteVideoUplinkLostRateL.text = @"0.0 %";
}

@end
