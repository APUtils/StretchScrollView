#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo ""
echo ""
echo "Building Pods project..."
set -o pipefail && xcodebuild -workspace "Example/StretchScrollView.xcworkspace" -scheme "StretchScrollView-Example" -configuration "Release" -sdk iphonesimulator | xcpretty

echo -e "\nBuilding Carthage projects..."
set -o pipefail && xcodebuild -project "StretchScrollView.xcodeproj" -sdk iphonesimulator -target "StretchScrollView" | xcpretty

echo -e "\nBuilding with Carthage..."
carthage build --no-skip-current --cache-builds

echo -e "\nPerforming tests..."
simulator_id="$(xcrun simctl list devices available | grep "iPhone SE" | tail -1 | sed -e "s/.*iPhone SE (//g" -e "s/).*//g")"
if [ -z "${simulator_id}" ]; then
    echo "error: Please install 'iPhone SE' simulator."
    echo " "
    exit 1
else
    echo "Using iPhone SE simulator with ID: '${simulator_id}'"
fi

set -o pipefail && xcodebuild -workspace "Example/StretchScrollView.xcworkspace" -sdk iphonesimulator -scheme "StretchScrollView-Example" -destination "platform=iOS Simulator,id=${simulator_id}" test | xcpretty

echo -e "\Generating documentation..."
. "updateDocs.command"

echo ""
echo "SUCCESS!"
echo ""
echo ""
