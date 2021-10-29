import CommonMark
import SwiftUI

struct AttributedStringRenderer {
  struct State {
    var font: MarkdownStyle.Font
    var foregroundColor: MarkdownStyle.Color
    var paragraphSpacing: CGFloat
    var headIndent: CGFloat = 0
    var tailIndent: CGFloat = 0
    var tabStops: [NSTextTab] = []
  }

  let baseURL: URL?
  let baseWritingDirection: NSWritingDirection
  let alignment: NSTextAlignment
  let style: MarkdownStyle

  func renderDocument(_ document: Document) -> NSAttributedString {
    return renderBlocks(
      document.blocks,
      state: .init(
        font: style.font,
        foregroundColor: style.foregroundColor,
        paragraphSpacing: style.measurements.paragraphSpacing
      )
    )
  }
}

extension AttributedStringRenderer {
  private func renderBlocks(_ blocks: [Block], state: State) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()

    for (offset, block) in blocks.enumerated() {
      result.append(
        renderBlock(block, hasSuccessor: offset < blocks.count - 1, state: state)
      )
    }

    return result
  }

  private func renderBlock(
    _ block: Block,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    switch block {
    case .blockQuote(let blockQuote):
      return renderBlockQuote(blockQuote, hasSuccessor: hasSuccessor, state: state)
    case .bulletList(let bulletList):
      return renderBulletList(bulletList, hasSuccessor: hasSuccessor, state: state)
    case .orderedList(let orderedList):
      return renderOrderedList(orderedList, hasSuccessor: hasSuccessor, state: state)
    case .code(let codeBlock):
      return renderCodeBlock(codeBlock, hasSuccessor: hasSuccessor, state: state)
    case .html(let htmlBlock):
      return renderHTMLBlock(htmlBlock, hasSuccessor: hasSuccessor, state: state)
    case .paragraph(let paragraph):
      return renderParagraph(paragraph, hasSuccessor: hasSuccessor, state: state)
    case .heading(let heading):
      return renderHeading(heading, hasSuccessor: hasSuccessor, state: state)
    case .thematicBreak:
      return renderThematicBreak(hasSuccessor: hasSuccessor, state: state)
    }
  }

  private func renderBlockQuote(
    _ blockQuote: BlockQuote,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    var state = state
    state.font = state.font.italic()
    state.headIndent += style.measurements.headIndentStep
    state.tailIndent += style.measurements.tailIndentStep
    state.tabStops.append(
      .init(textAlignment: .natural, location: state.headIndent)
    )

    let result = NSMutableAttributedString()

    for (offset, item) in blockQuote.items.enumerated() {
      result.append(
        renderBlock(item, hasSuccessor: offset < blockQuote.items.count - 1, state: state)
          .prepending(string: "\t")
      )
    }

    if hasSuccessor {
      result.append(string: .paragraphSeparator)
    }

    return result
  }

  private func renderBulletList(
    _ bulletList: BulletList,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    fatalError("TODO: implement")
  }

  private func renderOrderedList(
    _ orderedList: OrderedList,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    fatalError("TODO: implement")
  }

  private func renderListItem(
    _ listItem: ListItem,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    fatalError("TODO: implement")
  }

  private func renderCodeBlock(
    _ codeBlock: CodeBlock,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    fatalError("TODO: implement")
  }

  private func renderHTMLBlock(
    _ htmlBlock: HTMLBlock,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    fatalError("TODO: implement")
  }

  private func renderParagraph(
    _ paragraph: Paragraph,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    let result = renderInlines(paragraph.text, state: state)
    result.addAttribute(
      .paragraphStyle, value: paragraphStyle(state: state), range: NSRange(0..<result.length)
    )

    if hasSuccessor {
      result.append(string: .paragraphSeparator)
    }

    return result
  }

  private func renderHeading(
    _ heading: Heading,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    fatalError("TODO: implement")
  }

  private func renderThematicBreak(hasSuccessor: Bool, state: State) -> NSAttributedString {
    fatalError("TODO: implement")
  }

  private func renderInlines(_ inlines: [Inline], state: State) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()

    for inline in inlines {
      result.append(renderInline(inline, state: state))
    }

    return result
  }

  private func renderInline(_ inline: Inline, state: State) -> NSAttributedString {
    switch inline {
    case .text(let text):
      return renderText(text, state: state)
    case .softBreak:
      return renderSoftBreak(state: state)
    case .lineBreak:
      return renderLineBreak(state: state)
    case .code(let inlineCode):
      return renderInlineCode(inlineCode, state: state)
    case .html(let inlineHTML):
      return renderInlineHTML(inlineHTML, state: state)
    case .emphasis(let emphasis):
      return renderEmphasis(emphasis, state: state)
    case .strong(let strong):
      return renderStrong(strong, state: state)
    case .link(let link):
      return renderLink(link, state: state)
    case .image(let image):
      return renderImage(image, state: state)
    }
  }

  private func renderText(_ text: String, state: State) -> NSAttributedString {
    NSAttributedString(
      string: text,
      attributes: [
        .font: state.font.resolve(),
        .foregroundColor: state.foregroundColor.resolve()!,
      ]
    )
  }

  private func renderSoftBreak(state: State) -> NSAttributedString {
    renderText(" ", state: state)
  }

  private func renderLineBreak(state: State) -> NSAttributedString {
    renderText(.lineSeparator, state: state)
  }

  private func renderInlineCode(_ inlineCode: InlineCode, state: State) -> NSAttributedString {
    var state = state
    state.font = state.font.scale(style.measurements.codeFontScale).monospaced()
    return renderText(inlineCode.code, state: state)
  }

  private func renderInlineHTML(_ inlineHTML: InlineHTML, state: State) -> NSAttributedString {
    renderText(inlineHTML.html, state: state)
  }

  private func renderEmphasis(_ emphasis: Emphasis, state: State) -> NSAttributedString {
    var state = state
    state.font = state.font.italic()
    return renderInlines(emphasis.children, state: state)
  }

  private func renderStrong(_ strong: Strong, state: State) -> NSAttributedString {
    var state = state
    state.font = state.font.bold()
    return renderInlines(strong.children, state: state)
  }

  private func renderLink(_ link: CommonMark.Link, state: State) -> NSAttributedString {
    let result = renderInlines(link.children, state: state)
    let absoluteURL =
      link.url
      .map(\.relativeString)
      .flatMap { URL(string: $0, relativeTo: baseURL) }
      .map(\.absoluteURL)
    if let url = absoluteURL {
      result.addAttribute(.link, value: url, range: NSRange(0..<result.length))
    }
    #if os(macOS)
      if let title = link.title {
        result.addAttribute(.toolTip, value: title, range: NSRange(0..<result.length))
      }
    #endif

    return result
  }

  private func renderImage(_ image: CommonMark.Image, state: State) -> NSAttributedString {
    image.url
      .map(\.relativeString)
      .flatMap { URL(string: $0, relativeTo: baseURL) }
      .map(\.absoluteURL)
      .map {
        NSAttributedString(markdownImageURL: $0)
      } ?? NSAttributedString()
  }

  private func paragraphStyle(state: State) -> NSParagraphStyle {
    let pointSize = state.font.resolve().pointSize
    let result = NSMutableParagraphStyle()
    result.setParagraphStyle(.default)
    result.baseWritingDirection = baseWritingDirection
    result.alignment = alignment
    result.paragraphSpacing = round(pointSize * state.paragraphSpacing)
    result.headIndent = round(pointSize * state.headIndent)
    result.tailIndent = round(pointSize * state.tailIndent)
    result.tabStops = state.tabStops.map {
      NSTextTab(
        textAlignment: $0.alignment,
        location: round(pointSize * $0.location),
        options: $0.options
      )
    }
    return result
  }
}

extension String {
  fileprivate static let lineSeparator = "\u{2028}"
  fileprivate static let paragraphSeparator = "\u{2029}"
}

extension NSAttributedString {
  func prepending(string: String) -> NSAttributedString {
    let result = NSMutableAttributedString(attributedString: self)
    result.insert(
      .init(string: string, attributes: self.attributes(at: 0, effectiveRange: nil)), at: 0
    )
    return result
  }
}

extension NSMutableAttributedString {
  func append(string: String) {
    self.append(
      .init(string: string, attributes: self.attributes(at: self.length - 1, effectiveRange: nil))
    )
  }
}
