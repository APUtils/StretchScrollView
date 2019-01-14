#!/bin/bash

### Script to install frameworks ###

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

declare -a tests_frameworks=("github \"Quick\/Nimble\"" "github \"Quick\/Quick\"")

disableTestsFramework() {
    previous_cartfile=`cat "Cartfile.resolved"`
    for i in "${tests_frameworks[@]}"; do
        sed -i '' "/$i/d" "Cartfile.resolved"
    done
    trap "enableTestsFramework" ERR
    trap "enableTestsFramework" INT
}

enableTestsFramework() {
    echo "$previous_cartfile" > "Cartfile.resolved"
    trap '' ERR
    trap '' INT
}

# Assume scripts are placed in /Scripts/Carthage dir
base_dir=$(dirname "$0")
cd "$base_dir"
cd ..
cd ..

if [ ! -f Carthage/cartSum.txt ]; then
    prevSum="null";
else
    prevSum=`cat Carthage/cartSum.txt`;
fi

# Get checksum
cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`

if [ "$prevSum" != "$cartSum" ] || [ ! -d "Carthage/Build/iOS" ]; then
    echo "Carthage frameworks are outdated. Updating..."

    # Install main app frameworks. Ignore tests frameworks.
    disableTestsFramework
    carthage bootstrap --platform iOS --cache-builds --use-ssh
    enableTestsFramework
    echo ""

    # Update checksum file
    cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`
    echo $cartSum > Carthage/cartSum.txt
else
    echo "Carthage frameworks up to date"
fi
