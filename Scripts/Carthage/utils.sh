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

getFrameworks() {
	file_name="${1}"
	grep -o -E "^git.*|^binary.*" "${file_name}" | sed -E "s/(github \"|git \"|binary \")//" | sed -e "s/\".*//" | sed -e "s/^.*\///" -e "s/\".*//" -e "s/.json//"
}

getAllFrameworks() {
    echo ""
    echo "Frameworks list:"

    # Blue color
    printf '\033[0;34m'

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
}