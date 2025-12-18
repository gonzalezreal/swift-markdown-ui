#!/bin/bash

# Demo App Build Script
# This script compiles the Demo app to verify code changes

set -e  # Exit on any error

echo "Starting Demo app build..."
echo "Working directory: $(pwd)"

# Check if we're in the correct directory
if [ ! -f "Examples/Demo/Demo.xcodeproj/project.pbxproj" ]; then
    echo "Error: Examples/Demo/Demo.xcodeproj not found in current directory"
    echo "Please run this script from the root of the swift-markdown-diff repository"
    exit 1
fi

# Check if xcodebuild is available
if ! command -v xcodebuild &> /dev/null; then
    echo "Error: xcodebuild not found. Please install Xcode Command Line Tools:"
    echo "xcode-select --install"
    exit 1
fi

# Set build configuration
CONFIGURATION="Debug"

echo "Checking project configuration..."
echo "   Configuration: $CONFIGURATION"

# Check if xcpretty is available
if ! command -v xcpretty &> /dev/null; then
    echo "Warning: xcpretty not found. Install with: gem install xcpretty"
    echo "Falling back to quiet mode..."
    XCPRETTY=""
else
    XCPRETTY="xcpretty"
fi

# Build the Demo app
echo ""
echo "Building Demo app..."
if [ -n "$XCPRETTY" ]; then
    set -o pipefail
    xcodebuild \
        -project Examples/Demo/Demo.xcodeproj \
        -scheme "Demo" \
        -configuration "$CONFIGURATION" \
        -destination "platform=iOS Simulator,name=iPhone 16,OS=18.6" \
        build 2>&1 | xcpretty
else
    xcodebuild \
        -project Examples/Demo/Demo.xcodeproj \
        -scheme "Demo" \
        -configuration "$CONFIGURATION" \
        -destination "platform=iOS Simulator,name=iPhone 16,OS=18.6" \
        -quiet \
        build
fi

if [ $? -eq 0 ]; then
    echo "Demo app build completed successfully!"
else
    echo "Demo app build failed!"
    exit 1
fi

# Show summary
echo ""
echo "Summary:"
echo "   Demo app compilation successful"
echo ""
echo "All changes are ready!"
