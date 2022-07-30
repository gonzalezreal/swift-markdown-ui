import SwiftUI

public struct DefaultMarkdownInlineStyle: MarkdownInlineStyle {
  public init() {}
}

extension MarkdownInlineStyle where Self == DefaultMarkdownInlineStyle {
  public var `default`: Self {
    .init()
  }
}
