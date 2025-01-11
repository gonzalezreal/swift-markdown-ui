import SwiftUI

struct ImageView: View {
  @Environment(\.theme.image) private var image
  @Environment(\.imageProvider) private var imageProvider
  @Environment(\.imageBaseURL) private var baseURL

  private let data: RawImageData
  private let size: MarkdownImageSize?

  init(data: RawImageData, size: MarkdownImageSize? = nil) {
    self.data = data
    self.size = size
  }

  var body: some View {
    self.image.makeBody(
      configuration: .init(
        label: .init(self.label),
        content: .init(block: self.content)
      )
    )
    .frame(size: size)
  }

  private var label: some View {
    self.imageProvider.makeImage(url: self.url)
      .link(destination: self.data.destination)
      .accessibilityLabel(self.data.alt)
  }

  private var content: BlockNode {
    if let destination = self.data.destination {
      return .paragraph(
        content: [
          .link(
            destination: destination,
            children: [.image(source: self.data.source, children: [.text(self.data.alt)])]
          )
        ]
      )
    } else {
      return .paragraph(
        content: [.image(source: self.data.source, children: [.text(self.data.alt)])]
      )
    }
  }

  private var url: URL? {
    URL(string: self.data.source, relativeTo: self.baseURL)
  }
}

extension ImageView {
    init?(_ inlines: [InlineNode]) {
        if inlines.count == 2, let data = inlines.first?.imageData, let size = inlines.last?.size {
            self.init(data: data, size: size)
        }
        else if inlines.count == 1, let data = inlines.first?.imageData {
            self.init(data: data)
        } else {
            return nil
        }
    }
}

extension View {
  fileprivate func link(destination: String?) -> some View {
    self.modifier(LinkModifier(destination: destination))
  }
}

private struct LinkModifier: ViewModifier {
  @Environment(\.baseURL) private var baseURL
  @Environment(\.openURL) private var openURL

  let destination: String?

  var url: URL? {
    self.destination.flatMap {
      URL(string: $0, relativeTo: self.baseURL)
    }
  }

  func body(content: Content) -> some View {
    if let url {
      Button {
        self.openURL(url)
      } label: {
        content
      }
      .buttonStyle(.plain)
    } else {
      content
    }
  }
}

extension View {
    fileprivate func frame(size: MarkdownImageSize?) -> some View {
        self.modifier(ImageViewFrameModifier(size: size))
    }
}

private struct ImageViewFrameModifier: ViewModifier {
    let size: MarkdownImageSize?

    @State private var currentSize: CGSize = .zero

    func body(content: Content) -> some View {
        if let size {
            switch size.value {
                case .fixed(let width, let height):
                    content
                        .frame(width: width, height: height)
                case .relative(let wRatio, _):
                    ZStack(alignment: .leading) {
                        /// Track the full content width.
                        GeometryReader { metrics in
                            content
                                .preference(key: BoundsPreferenceKey.self, value: metrics.frame(in: .global).size)
                        }
                        .opacity(0.0)

                        /// Draw the content applying relative width. Relative height is not handled.
                        content
                            .frame(
                                width: currentSize.width * wRatio
                            )
                    }
                    .onPreferenceChange(BoundsPreferenceKey.self) { newValue in
                        /// Avoid recursive loop that could happens
                        /// https://developer.apple.com/videos/play/wwdc2022/10056/?time=1107
                        if Int(currentSize.width) == Int(newValue.width),
                           Int(currentSize.height) == Int(newValue.height) {
                            return
                        }

                        self.currentSize = newValue
                    }
            }
        } else {
            content
        }
    }
}

private struct BoundsPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
