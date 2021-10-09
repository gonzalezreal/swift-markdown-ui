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

test-watchos:
	xcodebuild test \
			-scheme MarkdownUI \
			-destination platform="watchOS Simulator,name=Apple Watch Series 5 - 40mm"

test: test-macos test-ios test-tvos test-watchos

format:
	swiftformat .

.PHONY: format
