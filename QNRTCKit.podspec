#
# Be sure to run `pod lib lint QNRTCKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name      = 'QNRTCKit'
    s.version   = '0.1.0'
    s.summary   = 'A short description of QNRTCKit.'
    s.homepage  = 'https://github.com/pili-engineering/QNRTC-iOS'
    s.license   = 'Apache License, Version 2.0'
    s.author    = { "pili" => "pili-coresdk@qiniu.com" }
    s.source    = { :git => 'https://github.com/pili-engineering/QNRTC-iOS.git', :tag => "v#{s.version}" }

    s.platform                = :ios
    s.ios.deployment_target   = '8.0'
    s.requires_arc            = true

    s.subspec "iphoneos" do |ss1|
        ss1.vendored_frameworks = ['Pod/iphoneos/QNRTCKit.framework']
    end

    s.subspec "universal" do |ss2|
        ss2.vendored_frameworks = ['Pod/universal/QNRTCKit.framework']
    end

    s.frameworks = ['UIKit', 'AVFoundation', 'CoreGraphics', 'CFNetwork', 'AudioToolbox', 'CoreMedia', 'VideoToolbox']
    s.libraries = 'z', 'c++', 'icucore', 'sqlite3'
end
