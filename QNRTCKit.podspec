#
# Be sure to run `pod lib lint QNRTCKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name      = 'QNRTCKit'
    s.version   = '3.0.1'
    s.summary   = 'Qiniu RTC SDK for iOS.'
    s.homepage  = 'https://github.com/pili-engineering/QNRTC-iOS'
    s.license   = 'Apache License, Version 2.0'
    s.author    = { "pili" => "pili-coresdk@qiniu.com" }
    s.source    = { :http => "https://sdk-release.qnsdk.com/QNRTCKit-iphoneos-v3.0.1.zip"}


    s.platform                = :ios
    s.ios.deployment_target   = '9.0'
    s.requires_arc            = true

    s.frameworks = ['UIKit', 'AVFoundation', 'CoreGraphics', 'CFNetwork', 'AudioToolbox', 'CoreMedia', 'VideoToolbox']
    
    s.default_subspec = "Core"

    s.subspec "Core" do |core|
        core.vendored_framework = ['Pod/iphoneos/*.framework']
    end
    
    s.subspec "ex-HappyDNS" do |core|
        core.vendored_framework = ['Pod/iphoneos/QNRTCKit.framework']
    end

end
