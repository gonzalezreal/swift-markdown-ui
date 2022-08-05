import SwiftUI

public struct DefaultMarkdownInlineStyle: MarkdownInlineStyle {
  public init() {}
}

extension MarkdownInlineStyle where Self == DefaultMarkdownInlineStyle {
  public static var `default`: Self {
    .init()
  }
}
