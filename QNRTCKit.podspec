#
# Be sure to run `pod lib lint QNRTCKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name      = 'QNRTCKit'
    s.version   = '2.3.0'
    s.summary   = 'Qiniu RTC SDK for iOS.'
    s.homepage  = 'https://github.com/pili-engineering/QNRTC-iOS'
    s.license   = 'Apache License, Version 2.0'
    s.author    = { "pili" => "pili-coresdk@qiniu.com" }
    s.source    = { :http => "https://sdk-release.qnsdk.com/QNRTCKit-iphoneos-v2.3.0.zip"}


    s.platform                = :ios
    s.ios.deployment_target   = '8.0'
    s.requires_arc            = true

    s.vendored_frameworks = ['Pod/iphoneos/QNRTCKit.framework']

    s.frameworks = ['UIKit', 'AVFoundation', 'CoreGraphics', 'CFNetwork', 'AudioToolbox', 'CoreMedia', 'VideoToolbox']
end
