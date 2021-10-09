import CommonMark

#if os(macOS)
  import AppKit
#elseif canImport(UIKit)
  import UIKit
#endif

extension NSAttributedString {
  #if !os(watchOS)
    /// Create an attributed string from a CommonMark document.
    public convenience init(
      document: Document,
      attachments: [String: NSTextAttachment] = [:],
      writingDirection: NSWritingDirection = .natural,
      alignment: NSTextAlignment = .natural,
      style: MarkdownStyle
    ) {
      let renderer = AttributedStringRenderer(
        writingDirection: writingDirection,
        alignment: alignment,
        style: style
      )
      self.init(
        attributedString: renderer.attributedString(
          for: document,
          attachments: attachments
        )
      )
    }
  #else
    /// Create an attributed string from a CommonMark document.
    public convenience init(
      document: Document,
      writingDirection: NSWritingDirection = .natural,
      alignment: NSTextAlignment = .natural,
      style: MarkdownStyle
    ) {
      let renderer = AttributedStringRenderer(
        writingDirection: writingDirection,
        alignment: alignment,
        style: style
      )
      self.init(attributedString: renderer.attributedString(for: document))
    }
  #endif
}
