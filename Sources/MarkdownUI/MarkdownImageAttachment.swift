import SwiftUI

final class MarkdownImageAttachment: NSTextAttachment {
  #if os(macOS)
    override func attachmentBounds(
      for textContainer: NSTextContainer?,
      proposedLineFragment lineFrag: NSRect,
      glyphPosition position: CGPoint,
      characterIndex charIndex: Int
    ) -> NSRect {
      guard let image = self.image else {
        return super.attachmentBounds(
          for: textContainer,
          proposedLineFragment: lineFrag,
          glyphPosition: position,
          characterIndex: charIndex
        )
      }

      let aspectRatio = image.size.width / image.size.height
      let width = min(lineFrag.width, image.size.width)
      let height = width / aspectRatio

      return NSRect(x: 0, y: 0, width: width, height: height)
    }
  #else
    override func attachmentBounds(
      for textContainer: NSTextContainer?,
      proposedLineFragment lineFrag: CGRect,
      glyphPosition position: CGPoint,
      characterIndex charIndex: Int
    ) -> CGRect {
      guard let image = self.image else {
        return super.attachmentBounds(
          for: textContainer,
          proposedLineFragment: lineFrag,
          glyphPosition: position,
          characterIndex: charIndex
        )
      }

      let aspectRatio = image.size.width / image.size.height
      let width = min(lineFrag.width, image.size.width)
      let height = width / aspectRatio

      return CGRect(x: 0, y: 0, width: width, height: height)
    }
  #endif
}
