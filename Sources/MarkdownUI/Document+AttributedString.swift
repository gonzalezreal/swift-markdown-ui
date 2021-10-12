import CommonMark
import SwiftUI

extension Document {
  func renderAttributedString(
    baseURL: URL?,
    baseWritingDirection: NSWritingDirection,
    alignment: NSTextAlignment,
    style: Markdown.Style
  ) -> NSAttributedString {
    // TODO: implement
    NSAttributedString(string: renderCommonMark())
  }
}
