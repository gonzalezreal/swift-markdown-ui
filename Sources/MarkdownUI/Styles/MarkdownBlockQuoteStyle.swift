import SwiftUI

public struct MarkdownBlockQuoteConfiguration {
  public struct Label: View {
    init<Content: View>(_ content: Content) {
      body = AnyView(content)
    }
    public var body: AnyView
  }

  public let label: MarkdownBlockQuoteConfiguration.Label
  public let font: Font?
}

public protocol MarkdownBlockQuoteStyle {
  associatedtype Body: View
  typealias Configuration = MarkdownBlockQuoteConfiguration

  @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body
}

extension View {
  public func markdownBlockQuoteStyle<S: MarkdownBlockQuoteStyle>(
    _ markdownBlockQuoteStyle: S
  ) -> some View {
    environment(\.markdownBlockQuoteStyle, AnyMarkdownBlockQuoteStyle(markdownBlockQuoteStyle))
  }
}

struct AnyMarkdownBlockQuoteStyle: MarkdownBlockQuoteStyle {
  private var _makeBody: (Configuration) -> AnyView

  init<S>(_ style: S) where S: MarkdownBlockQuoteStyle {
    _makeBody = { AnyView(style.makeBody(configuration: $0)) }
  }

  func makeBody(configuration: Configuration) -> some View {
    _makeBody(configuration)
  }
}

extension EnvironmentValues {
  var markdownBlockQuoteStyle: AnyMarkdownBlockQuoteStyle {
    get { self[MarkdownBlockQuoteStyleKey.self] }
    set { self[MarkdownBlockQuoteStyleKey.self] = newValue }
  }
}

private struct MarkdownBlockQuoteStyleKey: EnvironmentKey {
  static var defaultValue = AnyMarkdownBlockQuoteStyle(.default)
}
