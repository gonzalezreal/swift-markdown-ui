import SwiftUI

public struct Theme {
  // MARK: - Text styles

  public var text: TextStyle = EmptyTextStyle()
  public var code: TextStyle = FontFamilyVariant(.monospaced)
  public var emphasis: TextStyle = FontStyle(.italic)
  public var strong: TextStyle = FontWeight(.bold)
  public var strikethrough: TextStyle = StrikethroughStyle(.single)
  public var link: TextStyle = EmptyTextStyle()

  // MARK: - Headings

  var headings: [BlockStyle<BlockConfiguration>] = Array(repeating: .init(), count: 6)

  public var heading1: BlockStyle<BlockConfiguration> {
    get { self.headings[0] }
    set { self.headings[0] = newValue }
  }

  public var heading2: BlockStyle<BlockConfiguration> {
    get { self.headings[1] }
    set { self.headings[1] = newValue }
  }

  public var heading3: BlockStyle<BlockConfiguration> {
    get { self.headings[2] }
    set { self.headings[2] = newValue }
  }

  public var heading4: BlockStyle<BlockConfiguration> {
    get { self.headings[3] }
    set { self.headings[3] = newValue }
  }

  public var heading5: BlockStyle<BlockConfiguration> {
    get { self.headings[4] }
    set { self.headings[4] = newValue }
  }

  public var heading6: BlockStyle<BlockConfiguration> {
    get { self.headings[5] }
    set { self.headings[5] = newValue }
  }

  public init() {}
}

extension Theme {
  public func text<S: TextStyle>(@TextStyleBuilder text: () -> S) -> Theme {
    var theme = self
    theme.text = text()
    return theme
  }

  public func code<S: TextStyle>(@TextStyleBuilder code: () -> S) -> Theme {
    var theme = self
    theme.code = code()
    return theme
  }

  public func emphasis<S: TextStyle>(@TextStyleBuilder emphasis: () -> S) -> Theme {
    var theme = self
    theme.emphasis = emphasis()
    return theme
  }

  public func strong<S: TextStyle>(@TextStyleBuilder strong: () -> S) -> Theme {
    var theme = self
    theme.strong = strong()
    return theme
  }

  public func strikethrough<S: TextStyle>(@TextStyleBuilder strikethrough: () -> S) -> Theme {
    var theme = self
    theme.strikethrough = strikethrough()
    return theme
  }

  public func link<S: TextStyle>(@TextStyleBuilder link: () -> S) -> Theme {
    var theme = self
    theme.link = link()
    return theme
  }

  public func heading1<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.heading1 = .init(body: body)
    return theme
  }

  public func heading2<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.heading2 = .init(body: body)
    return theme
  }

  public func heading3<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.heading3 = .init(body: body)
    return theme
  }

  public func heading4<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.heading4 = .init(body: body)
    return theme
  }

  public func heading5<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.heading5 = .init(body: body)
    return theme
  }

  public func heading6<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.heading6 = .init(body: body)
    return theme
  }
}
