#!/bin/bash

export PATH=$PATH:/usr/local/bin

xcodebuild -version | grep "Xcode 7" > /dev/null || { echo 'Not running Xcode 7' ; exit 1; }

cd `git rev-parse --show-toplevel`

xctool -project SwiftUtilities.xcodeproj -scheme "SwiftUtilities_OSX" -sdk macosx build test || exit $!
xctool -project SwiftUtilities.xcodeproj -scheme "SwiftUtilities_iOS" -sdk iphonesimulator build test || exit $!
