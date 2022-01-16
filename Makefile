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

readme-images:
	rm -rf Images || true
	xcodebuild test \
			"OTHER_SWIFT_FLAGS=${inherited} -D README_IMAGES" \
			-scheme MarkdownUI \
			-destination platform="iOS Simulator,name=iPhone 8" \
			-only-testing "MarkdownUITests/ReadMeImagesTests" || true
	mv Tests/MarkdownUITests/__Snapshots__/ReadMeImagesTests Images
	sips -Z 400 Images/*.png

test: test-macos test-ios test-tvos

format:
	swift format --in-place --recursive .

.PHONY: format readme-images
