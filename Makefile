test-macos:
	xcodebuild test \
			-scheme MarkdownUI \
			-destination platform="macOS"

test-ios:
	xcodebuild test \
			-scheme MarkdownUI \
			-destination platform="iOS Simulator,name=iPhone 8"

test-tvos:
	xcodebuild test \
			-scheme MarkdownUI \
			-destination platform="tvOS Simulator,name=Apple TV"

test: test-macos test-ios test-tvos

format:
	swift format --in-place --recursive .

.PHONY: format
