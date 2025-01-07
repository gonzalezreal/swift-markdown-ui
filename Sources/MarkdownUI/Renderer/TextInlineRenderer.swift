import SwiftUI
import YYText

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
    case .link(let destination, let children):
        if destination == "@ref" {
            let text = children.renderPlainText()
            self.renderIndexLink(text)
        } else {
            self.defaultRender(inline)
        }
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
    
    private mutating func renderIndexLink(_ text: String) {
        guard text.count > 0 else { return }
        
        let component = text.components(separatedBy: ",")
        for index in component {
            self.defaultRender(.text(" "))
            addIndexAttributedString(index)
        }
    }
    
    private mutating func addIndexAttributedString(_ index: String) {
        let width = 18
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: width))
        label.backgroundColor = UIColor(hex: "7ABC98").withAlphaComponent(0.4)
        label.textColor = UIColor(hex: "206D48")
        label.text = index
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        
        let tapGr = UITapGestureRecognizer(target: MDEventManager.shared,
                                           action: #selector(MDEventManager.shared.onIndexClicked(_:)))
        label.addGestureRecognizer(tapGr)
        
        let font = UIFont.systemFont(ofSize: 16, weight: .light)
        let switchString = NSMutableAttributedString.yy_attachmentString(withContent: label,
                                                                         contentMode: .center,
                                                                         attachmentSize: label.frame.size,
                                                                         alignTo: font, alignment: .center)
        self.result.appendNSAttributeString(switchString)
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
    @Environment(\.openURL) private var openURL
    var text: NSAttributedString
    var lineSpacing: CGFloat = 12
    
    init(_ attributedString: AttributedString) {
        text = NSAttributedString()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    mutating func append(_ attributedString: AttributedString) {
        let attrt = NSMutableAttributedString(attributedString: self.text)
        let newAttr = transfromAttributedText(attributedString)
        attrt.append(newAttr)
        
        self.text = attrt
    }
    
    mutating func appendNSAttributeString(_ nsAttributedString: NSAttributedString) {
        let attrt = NSMutableAttributedString(attributedString: self.text)
        attrt.append(nsAttributedString)
        
        self.text = attrt
    }
    
    mutating func textViewLineSpacing(_ spacing: CGFloat) {
        self.lineSpacing = spacing
    }
    
    func makeUIView(context: Context) -> YYLabel {
        let textView = YYLabel()
        textView.backgroundColor = .clear
//        textView.isEditable = false
//        textView.isSelectable = true
//        textView.isScrollEnabled = false
//        textView.delegate = context.coordinator
        
//        textView.textContainer.lineBreakMode = .byCharWrapping
//        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.numberOfLines = 0
        
        return textView
    }
    
    func updateUIView(_ uiView: YYLabel, context: Context) {
        uiView.attributedText = text
    }
    
    func transfromAttributedText(_ attributedString: AttributedString) -> NSAttributedString {
        let nsAttributedString = NSMutableAttributedString(attributedString)
        
        // 遍历所有runs并应用字体
        attributedString.runs.enumerated().forEach { index, run in
            guard let fontPoperties = run.fontProperties else {
                return
            }
            let font = UIFont.withProperties(fontPoperties)
            let range = NSRange(run.range, in: attributedString)
            nsAttributedString.addAttribute(.font, value: font, range: range)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byCharWrapping
            paragraphStyle.lineSpacing = self.lineSpacing
            
            nsAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        }
        return nsAttributedString
    }
    
    @available(iOS 16.0, *)
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: YYLabel, context: Context) -> CGSize? {
        guard let width = proposal.width else { return nil }
        let dimensions = text.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil)
        return .init(width: width, height: ceil(dimensions.height))
    }
}

extension SelectableText {
    final class Coordinator: NSObject, YYTextViewDelegate {
        private var textView: SelectableText
        init(_ textView: SelectableText) {
            self.textView = textView
            super.init()
        }
        func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        func textView(_ textView: YYTextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            self.textView.openURL(URL)
            return false
        }
        func textViewDidChange(_ textView: YYTextView) {
            self.textView.text = textView.attributedText ?? .init(string: "")
        }
    }
}
