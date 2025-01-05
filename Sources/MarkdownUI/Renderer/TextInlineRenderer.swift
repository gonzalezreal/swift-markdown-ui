import SwiftUI

extension Sequence where Element == InlineNode {
  func renderText(
    baseURL: URL?,
    textStyles: InlineTextStyles,
    images: [String: Image],
    softBreakMode: SoftBreak.Mode,
    attributes: AttributeContainer,
    textReplacer: ((String, String) -> String)?
  ) -> SelectableText {
    var renderer = TextInlineRenderer(
      baseURL: baseURL,
      textStyles: textStyles,
      images: images,
      softBreakMode: softBreakMode,
      attributes: attributes,
      textReplacer: textReplacer
    )
    renderer.render(self)
      return renderer.result
  }
}

private struct TextInlineRenderer {

    var result = SelectableText("")
  private let baseURL: URL?
  private let textStyles: InlineTextStyles
  private let images: [String: Image]
  private let softBreakMode: SoftBreak.Mode
  private let attributes: AttributeContainer
  private var shouldSkipNextWhitespace = false
  private var textReplacer: ((String, String) -> String)?

  init(
    baseURL: URL?,
    textStyles: InlineTextStyles,
    images: [String: Image],
    softBreakMode: SoftBreak.Mode,
    attributes: AttributeContainer,
    textReplacer: ((String, String) -> String)?
  ) {
    self.baseURL = baseURL
    self.textStyles = textStyles
    self.images = images
    self.softBreakMode = softBreakMode
    self.attributes = attributes
    self.textReplacer = textReplacer
  }

  mutating func render<S: Sequence>(_ inlines: S) where S.Element == InlineNode {
    for inline in inlines {
      self.render(inline)
    }
  }

  private mutating func render(_ inline: InlineNode) {
    switch inline {
    case .text(let content):
      self.renderText(content)
    case .softBreak:
      self.renderSoftBreak()
    case .html(let content):
      self.renderHTML(content)
    case .image(let source, _):
      self.renderImage(source)
    default:
      self.defaultRender(inline)
    }
  }

  private mutating func renderText(_ text: String) {
    var text = text

    if self.shouldSkipNextWhitespace {
      self.shouldSkipNextWhitespace = false
      text = text.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression)
    }

    self.defaultRender(.text(text))
  }

  private mutating func renderSoftBreak() {
    switch self.softBreakMode {
    case .space where self.shouldSkipNextWhitespace:
      self.shouldSkipNextWhitespace = false
    case .space:
      self.defaultRender(.softBreak)
    case .lineBreak:
      self.shouldSkipNextWhitespace = true
      self.defaultRender(.lineBreak)
    }
  }

  private mutating func renderHTML(_ html: String) {
    let tag = HTMLTag(html)

    switch tag?.name.lowercased() {
    case "br":
      self.defaultRender(.lineBreak)
      self.shouldSkipNextWhitespace = true
    default:
      self.defaultRender(.html(html))
    }
  }

  private mutating func renderImage(_ source: String) {

  }

  private mutating func defaultRender(_ inline: InlineNode) {
      result.append(
        inline.renderAttributedString(
          baseURL: self.baseURL,
          textStyles: self.textStyles,
          softBreakMode: self.softBreakMode,
          attributes: self.attributes,
          textReplacer: self.textReplacer
        )
        )
  }
}

// 添加可选择文本的TextView
struct SelectableText: UIViewRepresentable {
    var attributedString: AttributedString
    var text: NSAttributedString
    
    init(_ attributedString: AttributedString) {
        self.attributedString = AttributedString() + attributedString
        self.attributedString.foregroundColor = .systemBlue
        text = NSAttributedString("")
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    mutating func append(_ attributedString: AttributedString) {
        self.attributedString += attributedString
        self.text = transfromAttributedText()
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
    }
    
    func transfromAttributedText() -> NSAttributedString {
        let newAttributedString = AttributedString() + attributedString
        let nsAttributedString = NSMutableAttributedString(newAttributedString)
        
        // 遍历所有runs并应用字体
        attributedString.runs.enumerated().forEach { index, run in
            guard let fontPoperties = run.fontProperties else {
                return
            }
            let font = UIFont.withProperties(fontPoperties)
            let range = NSRange(run.range, in: attributedString)
            nsAttributedString.addAttribute(.font, value: font, range: range)
        }
        return nsAttributedString
    }
    
    @available(iOS 16.0, *)
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        guard let width = proposal.width else { return nil }
        let dimensions = text.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil)
        return .init(width: width, height: ceil(dimensions.height))
    }
}

extension SelectableText {
    final class Coordinator: NSObject, UITextViewDelegate {
        private var textView: SelectableText
        init(_ textView: SelectableText) {
            self.textView = textView
            super.init()
        }
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        func textViewDidChange(_ textView: UITextView) {
            self.textView.text = textView.attributedText
        }
    }
}
