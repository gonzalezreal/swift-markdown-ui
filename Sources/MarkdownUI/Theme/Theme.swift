import Foundation

public struct Theme {
  // MARK: - Text styles

  public var text: TextStyle
  public var code: TextStyle
  public var emphasis: TextStyle
  public var strong: TextStyle
  public var strikethrough: TextStyle
  public var link: TextStyle

  public init(
    text: TextStyle = .init(EmptyTextStyle()),
    code: TextStyle = .init(FontFamilyVariant(.monospaced)),
    emphasis: TextStyle = .init(FontStyle(.italic)),
    strong: TextStyle = .init(FontWeight(.bold)),
    strikethrough: TextStyle = .init(StrikethroughStyle(.single)),
    link: TextStyle = .init(EmptyTextStyle())
  ) {
    self.text = text
    self.code = code
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link
  }
}
