import SwiftUI

final class ResizableImageAttachment: NSTextAttachment {
  #if os(iOS) || os(tvOS)
    typealias NSRect = CGRect
  #endif

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
}
