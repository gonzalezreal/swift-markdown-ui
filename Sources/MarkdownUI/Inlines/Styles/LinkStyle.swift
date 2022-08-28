import SwiftUI

public struct LinkStyle {
  public struct Configuration {
    public var content: String
    public var url: URL
    public var font: Font?
  }

  var makeBody: (Configuration) -> Text

  public init(makeBody: @escaping (Configuration) -> Text) {
    self.makeBody = makeBody
  }
}

extension LinkStyle {
  public static var `default`: Self {
    .init { configuration in
      Text(
        AttributedString(
          configuration.content,
          attributes: .init().link(configuration.url)
        )
      )
    }
  }
}

extension View {
  public func markdownLinkStyle(
    makeBody: @escaping (LinkStyle.Configuration) -> Text
  ) -> some View {
    markdownLinkStyle(.init(makeBody: makeBody))
  }

  public func markdownLinkStyle(_ linkStyle: LinkStyle) -> some View {
    environment(\.linkStyle, linkStyle)
  }
}

extension EnvironmentValues {
  var linkStyle: LinkStyle {
    get { self[LinkStyleKey.self] }
    set { self[LinkStyleKey.self] = newValue }
  }
}

private struct LinkStyleKey: EnvironmentKey {
  static var defaultValue: LinkStyle = .default
}
