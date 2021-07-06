DESTINATION_MAC = platform=macOS
DESTINATION_CATALYST = platform=macOS,variant=Mac Catalyst
DESTINATION_IOS = platform=iOS Simulator,name=iPhone 8
DESTINATION_TVOS = platform=tvOS Simulator,name=Apple TV
DESTINATION_WATCHOS = generic/platform=watchOS

default: test watch_os demo_mac demo_ios

test:
	xcodebuild test \
			-workspace MarkdownUI.xcworkspace \
			-scheme MarkdownUI \
			-destination '$(DESTINATION_MAC)'
	xcodebuild test \
			-workspace MarkdownUI.xcworkspace \
			-scheme MarkdownUI \
			-destination '$(DESTINATION_CATALYST)'
	xcodebuild test \
			-workspace MarkdownUI.xcworkspace \
			-scheme MarkdownUI \
			-destination '$(DESTINATION_IOS)'
	xcodebuild test \
			-workspace MarkdownUI.xcworkspace \
			-scheme MarkdownUI \
			-destination '$(DESTINATION_TVOS)'

watch_os:
	xcodebuild \
			-workspace MarkdownUI.xcworkspace \
			-scheme MarkdownUI-watchOS \
			-destination '$(DESTINATION_WATCHOS)'

demo_mac:
	xcodebuild \
			-workspace MarkdownUI.xcworkspace \
			-scheme 'MarkdownUIDemo (macOS)' \
			-destination '$(DESTINATION_MAC)'

demo_ios:
	xcodebuild \
			-workspace MarkdownUI.xcworkspace \
			-scheme 'MarkdownUIDemo (iOS)' \
			-destination '$(DESTINATION_IOS)'

format:
	swiftformat .

.PHONY: format
