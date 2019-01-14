#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

xcodebuild -workspace "Example/StretchScrollView.xcworkspace" -scheme "StretchScrollView-Example" -configuration "Release"  -sdk iphonesimulator12.1 | xcpretty && exit ${PIPESTATUS[0]}
echo
carthage build --no-skip-current

echo ""
echo "SUCCESS!"
