import CommonMark
import SwiftUI

struct AttributedStringRenderer {
  struct State {
    var font: MarkdownStyle.Font
    var foregroundColor: SwiftUI.Color
    var paragraphSpacing: CGFloat
    var headIndent: CGFloat = 0
    var tailIndent: CGFloat = 0
    var tabStops: [NSTextTab] = []
    var paragraphEdits: [ParagraphEdit] = []

    mutating func setListMarker(_ listMarker: ListMarker?) {
      // Replace any previous list marker by two indents
      paragraphEdits = paragraphEdits.map { edit in
        guard case .listMarker = edit else { return edit }
        return .firstLineIndent(2)
      }
      guard let listMarker = listMarker else { return }
      paragraphEdits.append(.listMarker(listMarker, font: font))
    }

    mutating func addFirstLineIndent(_ count: Int = 1) {
      paragraphEdits.append(.firstLineIndent(count))
    }
  }

  enum ParagraphEdit {
    case firstLineIndent(Int)
    case listMarker(ListMarker, font: MarkdownStyle.Font)
  }

  enum ListMarker {
    case disc
    case decimal(Int)
  }

  let environment: Environment

  func renderDocument(_ document: Document) -> NSAttributedString {
    return renderBlocks(
      document.blocks,
      state: .init(
        font: environment.style.font,
        foregroundColor: environment.style.foregroundColor,
        paragraphSpacing: environment.style.measurements.paragraphSpacing
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
    let result = NSMutableAttributedString()

    var state = state
    state.font = state.font.italic()
    state.headIndent += environment.style.measurements.headIndentStep
    state.tailIndent += environment.style.measurements.tailIndentStep
    state.tabStops.append(
      .init(textAlignment: .natural, location: state.headIndent)
    )
    state.addFirstLineIndent()

    for (offset, item) in blockQuote.items.enumerated() {
      result.append(
        renderBlock(item, hasSuccessor: offset < blockQuote.items.count - 1, state: state)
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
    let result = NSMutableAttributedString()

    var itemState = state
    itemState.paragraphSpacing =
      bulletList.tight ? 0 : environment.style.measurements.paragraphSpacing
    itemState.headIndent += environment.style.measurements.headIndentStep
    itemState.tabStops.append(
      contentsOf: [
        .init(
          textAlignment: .trailing(environment.baseWritingDirection),
          location: itemState.headIndent - environment.style.measurements.listMarkerSpacing
        ),
        .init(textAlignment: .natural, location: itemState.headIndent),
      ]
    )
    itemState.setListMarker(nil)

    for (offset, item) in bulletList.items.enumerated() {
      result.append(
        renderListItem(
          item,
          listMarker: .disc,
          parentParagraphSpacing: state.paragraphSpacing,
          hasSuccessor: offset < bulletList.items.count - 1,
          state: itemState
        )
      )
    }

    if hasSuccessor {
      result.append(string: .paragraphSeparator)
    }

    return result
  }

  private func renderOrderedList(
    _ orderedList: OrderedList,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    let result = NSMutableAttributedString()

    // Measure the width of the highest list number in em units and use it
    // as the head indent step if higher than the style's head indent step.
    let highestNumber = orderedList.start + orderedList.items.count - 1
    let headIndentStep = max(
      environment.style.measurements.headIndentStep,
      NSAttributedString(
        string: "\(highestNumber).",
        attributes: [
          .font: state.font.monospacedDigit().resolve(sizeCategory: environment.sizeCategory)
        ]
      ).em() + environment.style.measurements.listMarkerSpacing
    )

    var itemState = state
    itemState.paragraphSpacing =
      orderedList.tight ? 0 : environment.style.measurements.paragraphSpacing
    itemState.headIndent += headIndentStep
    itemState.tabStops.append(
      contentsOf: [
        .init(
          textAlignment: .trailing(environment.baseWritingDirection),
          location: itemState.headIndent - environment.style.measurements.listMarkerSpacing
        ),
        .init(textAlignment: .natural, location: itemState.headIndent),
      ]
    )
    itemState.setListMarker(nil)

    for (offset, item) in orderedList.items.enumerated() {
      result.append(
        renderListItem(
          item,
          listMarker: .decimal(offset + orderedList.start),
          parentParagraphSpacing: state.paragraphSpacing,
          hasSuccessor: offset < orderedList.items.count - 1,
          state: itemState
        )
      )
    }

    if hasSuccessor {
      result.append(string: .paragraphSeparator)
    }

    return result
  }

  private func renderListItem(
    _ listItem: ListItem,
    listMarker: ListMarker,
    parentParagraphSpacing: CGFloat,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    let result = NSMutableAttributedString()

    for (offset, block) in listItem.blocks.enumerated() {
      var blockState = state

      if offset == 0 {
        // The first block should have the list marker
        blockState.setListMarker(listMarker)
      } else {
        blockState.addFirstLineIndent(2)
      }

      if !hasSuccessor, offset == listItem.blocks.count - 1 {
        // Use the appropriate paragraph spacing after the list
        blockState.paragraphSpacing = max(parentParagraphSpacing, state.paragraphSpacing)
      }

      result.append(
        renderBlock(
          block,
          hasSuccessor: offset < listItem.blocks.count - 1,
          state: blockState
        )
      )
    }

    if hasSuccessor {
      result.append(string: .paragraphSeparator)
    }

    return result
  }

  private func renderCodeBlock(
    _ codeBlock: CodeBlock,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    var state = state
    state.font = state.font.scale(environment.style.measurements.codeFontScale).monospaced()
    state.headIndent += environment.style.measurements.headIndentStep
    state.tabStops.append(
      .init(textAlignment: .natural, location: state.headIndent)
    )
    state.addFirstLineIndent()

    var code = codeBlock.code.replacingOccurrences(of: "\n", with: String.lineSeparator)
    if !code.isEmpty {
      // Remove the last line separator
      code.removeLast()
    }

    return renderParagraph(.init(text: [.text(code)]), hasSuccessor: hasSuccessor, state: state)
  }

  private func renderHTMLBlock(
    _ htmlBlock: HTMLBlock,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    var html = htmlBlock.html.replacingOccurrences(of: "\n", with: String.lineSeparator)
    // Remove the last line separator
    html.removeLast()

    // Render HTML blocks as plain text paragraphs
    return renderParagraph(.init(text: [.text(html)]), hasSuccessor: hasSuccessor, state: state)
  }

  private func renderParagraph(
    _ paragraph: Paragraph,
    hasSuccessor: Bool,
    state: State
  ) -> NSAttributedString {
    let result = renderParagraphEdits(state: state)
    result.append(renderInlines(paragraph.text, state: state))

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
    let result = renderParagraphEdits(state: state)

    var inlineState = state
    inlineState.font = inlineState.font.bold().scale(
      environment.style.measurements.headingScales[heading.level - 1]
    )

    result.append(renderInlines(heading.text, state: inlineState))

    // The paragraph spacing is relative to the parent font
    var paragraphState = state
    paragraphState.paragraphSpacing = environment.style.measurements.headingSpacing

    result.addAttribute(
      .paragraphStyle,
      value: paragraphStyle(state: paragraphState),
      range: NSRange(0..<result.length)
    )

    if hasSuccessor {
      result.append(string: .paragraphSeparator)
    }

    return result
  }

  private func renderThematicBreak(hasSuccessor: Bool, state: State) -> NSAttributedString {
    let result = renderParagraphEdits(state: state)

    result.append(
      .init(
        string: .nbsp,
        attributes: [
          .font: state.font.resolve(sizeCategory: environment.sizeCategory),
          .strikethroughStyle: NSUnderlineStyle.single.rawValue,
          .strikethroughColor: PlatformColor.separator,
        ]
      )
    )

    result.addAttribute(
      .paragraphStyle,
      value: paragraphStyle(state: state, alignment: .natural),
      range: NSRange(0..<result.length)
    )

    if hasSuccessor {
      result.append(string: .paragraphSeparator)
    }

    return result
  }

  private func renderParagraphEdits(state: State) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()

    for paragraphEdit in state.paragraphEdits {
      switch paragraphEdit {
      case .firstLineIndent(let count):
        result.append(
          renderText(.init(repeating: "\t", count: count), state: state)
        )
      case .listMarker(let listMarker, let font):
        switch listMarker {
        case .disc:
          var state = state
          state.font = font
          result.append(renderText("\t•\t", state: state))
        case .decimal(let value):
          var state = state
          state.font = font.monospacedDigit()
          result.append(renderText("\t\(value).\t", state: state))
        }
      }
    }

    return result
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
        .font: state.font.resolve(sizeCategory: environment.sizeCategory),
        .foregroundColor: PlatformColor(state.foregroundColor),
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
    state.font = state.font.scale(environment.style.measurements.codeFontScale).monospaced()
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
      .flatMap { URL(string: $0, relativeTo: environment.baseURL) }
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
      .flatMap { URL(string: $0, relativeTo: environment.baseURL) }
      .map(\.absoluteURL)
      .map {
        NSAttributedString(markdownImageURL: $0)
      } ?? NSAttributedString()
  }

  private func paragraphStyle(state: State, alignment: NSTextAlignment? = nil) -> NSParagraphStyle {
    let pointSize = state.font.resolve(sizeCategory: environment.sizeCategory).pointSize
    let result = NSMutableParagraphStyle()
    result.setParagraphStyle(.default)
    result.baseWritingDirection = environment.baseWritingDirection
    result.alignment = alignment ?? environment.alignment
    result.lineSpacing = environment.lineSpacing
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
  fileprivate static let nbsp = "\u{00A0}"
}

extension NSMutableAttributedString {
  fileprivate func append(string: String) {
    self.append(
      .init(
        string: string,
        attributes: self.length > 0
          ? self.attributes(at: self.length - 1, effectiveRange: nil)
          : nil
      )
    )
  }
}

extension NSAttributedString {
  /// Returns the width of the string in `em` units.
  fileprivate func em() -> CGFloat {
    guard let font = attribute(.font, at: 0, effectiveRange: nil) as? PlatformFont
    else {
      fatalError("Font attribute not found!")
    }
    return size().width / font.pointSize
  }
}

extension NSTextAlignment {
  fileprivate static func trailing(_ writingDirection: NSWritingDirection) -> NSTextAlignment {
    switch writingDirection {
    case .rightToLeft:
      return .left
    default:
      return .right
    }
  }
}

// MARK: - PlatformColor

#if os(macOS)
  private typealias PlatformColor = NSColor

  extension NSColor {
    fileprivate static var separator: NSColor { .separatorColor }
  }
#elseif os(iOS) || os(tvOS)
  private typealias PlatformColor = UIColor
#endif
