#!/bin/bash

xcodebuild -version | grep "Xcode 7" > /dev/null || { echo 'Not running Xcode 7' ; exit 1; }

cd `git rev-parse --show-toplevel`

xctool -project SwiftUtilities.xcodeproj -scheme All build test || exit $!
