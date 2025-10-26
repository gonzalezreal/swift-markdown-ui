import SwiftUI
import SwiftMath

struct InlineTextWithLaTeX: View {
  @Environment(\.inlineImageProvider) private var inlineImageProvider
  @Environment(\.baseURL) private var baseURL
  @Environment(\.imageBaseURL) private var imageBaseURL
  @Environment(\.softBreakMode) private var softBreakMode
  @Environment(\.theme) private var theme

  @State private var inlineImages: [String: Image] = [:]

  private let inlines: [InlineNode]

  init(_ inlines: [InlineNode]) {
    self.inlines = inlines
  }

  var body: some View {
    TextStyleAttributesReader { attributes in
      VStack(alignment: .leading, spacing: 0) {
        ForEach(Array(self.segments.enumerated()), id: \.offset) { _, segment in
          self.renderSegment(segment, attributes: attributes)
        }
      }
    }
    .task(id: self.inlines) {
      self.inlineImages = (try? await self.loadInlineImages()) ?? [:]
    }
  }

  private var segments: [[InlineNode]] {
    var result: [[InlineNode]] = []
    var currentSegment: [InlineNode] = []

    for inline in self.inlines {
      if case .latex(_, let isDisplay) = inline, isDisplay {
        if !currentSegment.isEmpty {
          result.append(currentSegment)
          currentSegment = []
        }
        result.append([inline])
      } else {
        currentSegment.append(inline)
      }
    }

    if !currentSegment.isEmpty {
      result.append(currentSegment)
    }

    return result
  }

  @ViewBuilder
  private func renderSegment(_ segment: [InlineNode], attributes: AttributeContainer) -> some View {
    if segment.count == 1, case .latex(let latex, let isDisplay) = segment[0], isDisplay {
      MathView(equation: latex, fontSize: attributes.fontProperties?.size ?? 17)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 4)
    } else {
      self.renderInlineSegment(segment, attributes: attributes)
    }
  }

  @ViewBuilder
  private func renderInlineSegment(_ segment: [InlineNode], attributes: AttributeContainer) -> some View {
    HStack(alignment: .firstTextBaseline, spacing: 0) {
      ForEach(Array(segment.enumerated()), id: \.offset) { _, inline in
        switch inline {
        case .latex(let latex, _):
          MathView(equation: latex, fontSize: attributes.fontProperties?.size ?? 17)
            .fixedSize()
        default:
          Text(
            [inline].renderAttributedString(
              baseURL: self.baseURL,
              textStyles: .init(
                code: self.theme.code,
                emphasis: self.theme.emphasis,
                strong: self.theme.strong,
                strikethrough: self.theme.strikethrough,
                link: self.theme.link
              ),
              softBreakMode: self.softBreakMode,
              attributes: attributes
            )
          )
        }
      }
    }
  }

  private func loadInlineImages() async throws -> [String: Image] {
    let images = Set(self.inlines.compactMap(\.imageData))
    guard !images.isEmpty else { return [:] }

    return try await withThrowingTaskGroup(of: (String, Image).self) { taskGroup in
      for image in images {
        guard let url = URL(string: image.source, relativeTo: self.imageBaseURL) else {
          continue
        }

        taskGroup.addTask {
          (image.source, try await self.inlineImageProvider.image(with: url, label: image.alt))
        }
      }

      var inlineImages: [String: Image] = [:]

      for try await result in taskGroup {
        inlineImages[result.0] = result.1
      }

      return inlineImages
    }
  }
}
