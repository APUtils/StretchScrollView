#!/bin/bash

### Script to update frameworks ###

# Xcodeproj is required
hash xcodeproj 2>/dev/null || { printf >&2 "\n${red_color}Xcodeproj is required. Run 'sudo gem install xcodeproj'${no_color}\n\n"; exit 1; }

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

# Assume scripts are placed in /Scripts/Carthage dir
base_dir=$(dirname "$0")
cd "$base_dir"

. "utils.sh"

cd ..
cd ..

# Try one level up if didn't find Cartfile.
if [ ! -f "Cartfile" ]; then
    project_dir="${PWD##*/}"
    cd ..

    if [ ! -f "Cartfile" ]; then
        printf >&2 "\n${red_color}Unable to locate 'Cartfile'${no_color}\n\n"
        exit 1
    fi
fi

framework_name=$1

if [ -z $framework_name ]; then
    # Listing available frameworks
	getAllFrameworks

    # Asking which one to update
    read -p "Which framework to update? You can enter several separating with space. Press enter to update all: " framework_name
fi

# Update framework(s)
echo "Synchronizing Carthage dependencies..."
carthage update ${framework_name} --platform iOS --cache-builds --use-ssh
echo ""

# Update md5 check sum
cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`
echo $cartSum > Carthage/cartSum.txt
