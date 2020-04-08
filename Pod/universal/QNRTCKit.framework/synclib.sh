#!/bin/bash
#假设 pili-webrtc 和 pili-rtc-ios-kit 处于同一目录下
cp ../../../../../pili-webrtc/out_ios_libs/librtc_sdk_objc.a  .
cp ../../../../../pili-webrtc/sdk/objc/Framework/Headers/WebRTC/*  .
rm RTCCameraVideoCapturer.h
