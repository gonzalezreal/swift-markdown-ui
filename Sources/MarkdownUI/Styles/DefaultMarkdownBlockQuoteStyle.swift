import SwiftUI

public struct DefaultMarkdownBlockQuoteStyle: MarkdownBlockQuoteStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font((configuration.font ?? .body).italic())
      .padding(.leading)
      .padding(.horizontal)
  }
}

extension MarkdownBlockQuoteStyle where Self == DefaultMarkdownBlockQuoteStyle {
  public static var `default`: Self {
    .init()
  }
}
