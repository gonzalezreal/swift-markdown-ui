import CommonMark
import Foundation

#if os(macOS)
  import AppKit
#elseif canImport(UIKit)
  import UIKit
#endif

public struct ParagraphState {
  public var baseWritingDirection: NSWritingDirection
  public var alignment: NSTextAlignment
  public var indentLevel: Int
  public var isHanging: Bool
  public var spacing: List.Spacing

  public init(
    baseWritingDirection: NSWritingDirection = .natural,
    alignment: NSTextAlignment = .natural,
    indentLevel: Int = 0,
    isHanging: Bool = false,
    spacing: List.Spacing = .loose
  ) {
    self.baseWritingDirection = baseWritingDirection
    self.alignment = alignment
    self.indentLevel = indentLevel
    self.isHanging = isHanging
    self.spacing = spacing
  }
}
