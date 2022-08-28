import SwiftUI

public struct InlineCodeStyle {
  public struct Configuration {
    public var content: String
    public var font: Font?
  }

  var makeBody: (Configuration) -> Text

  public init(makeBody: @escaping (Configuration) -> Text) {
    self.makeBody = makeBody
  }
}

extension InlineCodeStyle {
  public static var `default`: Self {
    .init { configuration in
      Text(configuration.content)
        .font((configuration.font ?? .body).monospaced())
    }
  }
}

extension View {
  public func markdownInlineCodeStyle(
    makeBody: @escaping (InlineCodeStyle.Configuration) -> Text
  ) -> some View {
    markdownInlineCodeStyle(.init(makeBody: makeBody))
  }

  public func markdownInlineCodeStyle(_ inlineCodeStyle: InlineCodeStyle) -> some View {
    environment(\.inlineCodeStyle, inlineCodeStyle)
  }
}

extension EnvironmentValues {
  var inlineCodeStyle: InlineCodeStyle {
    get { self[InlineCodeStyleKey.self] }
    set { self[InlineCodeStyleKey.self] = newValue }
  }
}

private struct InlineCodeStyleKey: EnvironmentKey {
  static var defaultValue: InlineCodeStyle = .default
}
