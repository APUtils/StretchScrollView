#!/bin/bash

### Script to remove framework ###

# Colors Constants
red_color='\033[0;31m'
green_color='\033[0;32m'
blue_color='\033[0;34m'
no_color='\033[0m'

# Font Constants
bold_text=$(tput bold)
normal_text=$(tput sgr0)

# Assume scripts are placed in /Scripts/Carthage dir
base_dir=$(dirname "$0")
cd "$base_dir"
cd ..
cd ..

getFrameworks() {
	file_name="${1}"
	grep -o -E "^git.*|^binary.*" "${file_name}" | sed -E "s/(github \"|git \"|binary \")//" | sed -e "s/\".*//" | sed -e "s/^.*\///" -e "s/\".*//" -e "s/.json//"
}

# Try one level up if didn't find Cartfile.
if [ ! -f "Cartfile" ]; then
    project_dir="${PWD##*/}"
    cd ..

    if [ ! -f "Cartfile" ]; then
        printf >&2 "\n${red_color}Unable to locate 'Cartfile'${no_color}\n\n"
        exit 1
    fi
fi

scripts_dir="Scripts/Carthage"

# Requires `xcodeproj` installed - https://github.com/CocoaPods/Xcodeproj
# sudo gem install xcodeproj
hash xcodeproj 2>/dev/null || { printf >&2 "\n${red_color}Requires xcodeproj installed - 'sudo gem install xcodeproj'${no_color}\n\n"; exit 1; }

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

echo ""

framework_name=$1

if [ -z $framework_name ]; then
    # Listing available frameworks
    echo ""
    echo "Frameworks list:"

    # Blue color
    printf '\033[0;34m'

    # Frameworks list

    # Frameworks list
    if [ -f "Cartfile" ]; then
        public_frameworks=$(getFrameworks Cartfile)
    fi
    
    if [ -f "Cartfile.private" ]; then
        private_frameworks=$(getFrameworks Cartfile.private)
    fi
    
	frameworks_list=$(echo -e "${public_frameworks}\n${private_frameworks}" | sort -fu | sed '/^$/d')
    printf "$frameworks_list\n"

    # No color
    printf '\033[0m'
    echo ""

    # Asking which one to update
    read -p "Which framework to remove? " framework_name
fi

# Restore working directory
if [ ! -z "${project_dir}" ]; then
    cd "${project_dir}"
fi

if [ -z $framework_name ]; then
    printf >&2 "\n${red_color}Invalid framework name${no_color}\n\n"
    exit 1
elif [[ $frameworks_list = *$framework_name* ]]; then
    echo ""
    echo "Removing $framework_name from project..."

    ruby "$scripts_dir/carthageRemove.rb" $framework_name
else
    printf >&2 "\n${red_color}Invalid framework name${no_color}\n\n"
    exit 1
fi

# Update Carthage files
echo "Removing $framework_name from Carthage..."
sed -i '' "/\/$framework_name\"/d" Cartfile
sed -i '' "/\/$framework_name\"/d" Cartfile.resolved

# Update md5 check sum
cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`
echo $cartSum > Carthage/cartSum.txt

printf >&2 "\n${bold_text}SUCCESSFULLY REMOVED FRAMEWORK${normal_text}\n\n"
