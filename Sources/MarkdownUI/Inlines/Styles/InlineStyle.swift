import SwiftUI

public struct InlineStyle {
  public struct Configuration {
    public var label: Text
    public var font: Font?
  }

  var makeBody: (Configuration) -> Text

  public init(makeBody: @escaping (Configuration) -> Text) {
    self.makeBody = makeBody
  }
}

extension InlineStyle {
  public static var italic: Self {
    .init { configuration in
      configuration.label.italic()
    }
  }

  public static var bold: Self {
    .init { configuration in
      configuration.label.bold()
    }
  }

  public static var strikethrough: Self {
    .init { configuration in
      configuration.label.strikethrough()
    }
  }
}

extension View {
  public func markdownEmphasisStyle(
    makeBody: @escaping (InlineStyle.Configuration) -> Text
  ) -> some View {
    markdownEmphasisStyle(.init(makeBody: makeBody))
  }

  public func markdownEmphasisStyle(_ emphasisStyle: InlineStyle) -> some View {
    environment(\.emphasisStyle, emphasisStyle)
  }

  public func markdownStrongStyle(
    makeBody: @escaping (InlineStyle.Configuration) -> Text
  ) -> some View {
    markdownStrongStyle(.init(makeBody: makeBody))
  }

  public func markdownStrongStyle(_ strongStyle: InlineStyle) -> some View {
    environment(\.strongStyle, strongStyle)
  }

  public func markdownStrikethroughStyle(
    makeBody: @escaping (InlineStyle.Configuration) -> Text
  ) -> some View {
    markdownStrikethroughStyle(.init(makeBody: makeBody))
  }

  public func markdownStrikethroughStyle(
    _ strikethroughStyle: InlineStyle
  ) -> some View {
    environment(\.strikethroughStyle, strikethroughStyle)
  }
}

extension EnvironmentValues {
  var emphasisStyle: InlineStyle {
    get { self[EmphasisStyleKey.self] }
    set { self[EmphasisStyleKey.self] = newValue }
  }

  var strongStyle: InlineStyle {
    get { self[StrongStyleKey.self] }
    set { self[StrongStyleKey.self] = newValue }
  }

  var strikethroughStyle: InlineStyle {
    get { self[StrikethroughStyleKey.self] }
    set { self[StrikethroughStyleKey.self] = newValue }
  }
}

private struct EmphasisStyleKey: EnvironmentKey {
  static var defaultValue: InlineStyle = .italic
}

private struct StrongStyleKey: EnvironmentKey {
  static var defaultValue: InlineStyle = .bold
}

private struct StrikethroughStyleKey: EnvironmentKey {
  static var defaultValue: InlineStyle = .strikethrough
}
