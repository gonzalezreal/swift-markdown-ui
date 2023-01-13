import SwiftUI

public struct Theme {
  public var text: TextStyle = EmptyTextStyle()
  public var code: TextStyle = FontFamilyVariant(.monospaced)
  public var emphasis: TextStyle = FontStyle(.italic)
  public var strong: TextStyle = FontWeight(.semibold)
  public var strikethrough: TextStyle = StrikethroughStyle(.single)
  public var link: TextStyle = EmptyTextStyle()

  var headings = Array(repeating: BlockStyle(), count: 6)

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

  public var paragraph = BlockStyle()
  public var blockquote = BlockStyle()
  public var codeBlock = BlockStyle()
  public var image = BlockStyle()
  public var list = BlockStyle()
  public var listItem = BlockStyle()
  public var taskListMarker = BlockStyle.checkmarkSquare
  public var bulletedListMarker = BlockStyle.discCircleSquare
  public var numberedListMarker = BlockStyle.decimal
  public var table = BlockStyle()
  public var tableCell: BlockStyle<TableCellConfiguration> = BlockStyle { configuration in
    configuration.label
  }
  public var thematicBreak = BlockStyle {
    Divider()
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
}

extension Theme {
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

  public func paragraph<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.paragraph = .init(body: body)
    return theme
  }

  public func blockquote<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.blockquote = .init(body: body)
    return theme
  }

  public func codeBlock<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.codeBlock = .init(body: body)
    return theme
  }

  public func image<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.image = .init(body: body)
    return theme
  }

  public func list<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.list = .init(body: body)
    return theme
  }

  public func listItem<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.listItem = .init(body: body)
    return theme
  }

  public func taskListMarker(_ taskListMarker: BlockStyle<TaskListMarkerConfiguration>) -> Theme {
    var theme = self
    theme.taskListMarker = taskListMarker
    return theme
  }

  public func taskListMarker<Body: View>(
    @ViewBuilder body: @escaping (_ configuration: TaskListMarkerConfiguration) -> Body
  ) -> Theme {
    var theme = self
    theme.taskListMarker = .init(body: body)
    return theme
  }

  public func bulletedListMarker(
    _ bulletedListMarker: BlockStyle<ListMarkerConfiguration>
  ) -> Theme {
    var theme = self
    theme.bulletedListMarker = bulletedListMarker
    return theme
  }

  public func bulletedListMarker<Body: View>(
    @ViewBuilder body: @escaping (_ configuration: ListMarkerConfiguration) -> Body
  ) -> Theme {
    var theme = self
    theme.bulletedListMarker = .init(body: body)
    return theme
  }

  public func numberedListMarker(
    _ numberedListMarker: BlockStyle<ListMarkerConfiguration>
  ) -> Theme {
    var theme = self
    theme.numberedListMarker = numberedListMarker
    return theme
  }

  public func numberedListMarker<Body: View>(
    @ViewBuilder body: @escaping (_ configuration: ListMarkerConfiguration) -> Body
  ) -> Theme {
    var theme = self
    theme.numberedListMarker = .init(body: body)
    return theme
  }

  public func table<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> Theme {
    var theme = self
    theme.table = .init(body: body)
    return theme
  }

  public func tableCell<Body: View>(
    @ViewBuilder body: @escaping (_ configuration: TableCellConfiguration) -> Body
  ) -> Theme {
    var theme = self
    theme.tableCell = .init(body: body)
    return theme
  }

  public func thematicBreak<Body: View>(@ViewBuilder body: @escaping () -> Body) -> Theme {
    var theme = self
    theme.thematicBreak = .init(body: body)
    return theme
  }
}

extension Theme {
  public var textBackgroundColor: Color? {
    var attributes = AttributeContainer()
    self.text.collectAttributes(in: &attributes)
    return attributes.backgroundColor
  }
}
