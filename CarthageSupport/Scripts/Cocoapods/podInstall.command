#!/bin/bash

# Assume scripts are placed in /Scripts/Cocoapods dir
base_dir=$(dirname "$0")
cd "$base_dir"
cd ..
cd ..

pod install
