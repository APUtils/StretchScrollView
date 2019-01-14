#!/bin/bash

### Script to install frameworks ###

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

# Assume scripts are placed in /Scripts/Carthage dir
base_dir=$(dirname "$0")
cd "$base_dir"
cd ..
cd ..

cart_sum_file="Carthage/cartSumTests.txt"

if [ ! -f $cart_sum_file ]; then
    prevSum="null"
else
    prevSum=`cat $cart_sum_file`
fi

# Get checksum
cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`

if [ "$prevSum" != "$cartSum" ] || [ ! -d "Carthage/Build/iOS" ]; then
    echo "Carthage frameworks are outdated. Updating..."

    # Install needed frameworks.
    carthage bootstrap --platform iOS --cache-builds --use-ssh

    # Update checksum file
    cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`
    echo "$cartSum" > "$cart_sum_file"
else
    echo "Carthage frameworks up to date"
fi
