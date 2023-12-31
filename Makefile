test-macos:
	xcodebuild test \
			-scheme MarkdownUI \
			-destination platform="macOS"

test-macos-maccatalyst:
	xcodebuild test \
			-scheme MarkdownUI \
			-destination platform="macOS,variant=Mac Catalyst"
			
test-ios:
	xcodebuild test \
			-scheme MarkdownUI \
			-destination platform="iOS Simulator,name=iPhone SE (3rd generation)"

test-tvos:
	xcodebuild test \
			-scheme MarkdownUI \
			-destination platform="tvOS Simulator,name=Apple TV"

test-watchos:
	xcodebuild test \
			-scheme MarkdownUI \
			-destination platform="watchOS Simulator,name=Apple Watch SE (40mm) (2nd generation)"

test: test-macos test-macos-maccatalyst test-ios test-tvos test-watchos

format:
	swift format --in-place --recursive .

.PHONY: format
