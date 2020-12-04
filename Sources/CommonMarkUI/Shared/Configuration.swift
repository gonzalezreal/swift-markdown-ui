#if os(macOS)
    import AppKit
#elseif os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#endif

extension NSAttributedString {
    struct Configuration {
        var font: Font
        var codeFont: Font?
        var paragraphStyle: NSParagraphStyle
        #if !os(watchOS)
            var attachments: [String: NSTextAttachment] = [:]
        #endif
    }
}
