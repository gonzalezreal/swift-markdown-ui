import SwiftUI
import Combine
import LaTeXSwiftUI

struct InlineText: View {
  @Environment(\.inlineImageProvider) private var inlineImageProvider
  @Environment(\.baseURL) private var baseURL
  @Environment(\.imageBaseURL) private var imageBaseURL
  @Environment(\.softBreakMode) private var softBreakMode
  @Environment(\.theme) private var theme

  @State private var inlineImages: [String: Image] = [:]
  @State private var latexImages: [String: Image] = [:]

  private let inlines: [InlineNode]

  init(_ inlines: [InlineNode]) {
    self.inlines = inlines
  }

  var body: some View {
    TextStyleAttributesReader { attributes in
      self.inlines.renderText(
        baseURL: self.baseURL,
        textStyles: .init(
          code: self.theme.code,
          emphasis: self.theme.emphasis,
          strong: self.theme.strong,
          strikethrough: self.theme.strikethrough,
          link: self.theme.link
        ),
        images: self.latexImages.merging(self.inlineImages, uniquingKeysWith: { $1 }),
        softBreakMode: self.softBreakMode,
        attributes: attributes
      )
    }
    .task(id: self.inlines) { @MainActor in
      self.inlineImages = (try? await self.loadInlineImages()) ?? [:]
    }
    .onAppear {
      updateLatexInsertions(inlines: inlines)
    }
    .onChange(of: inlines, perform: updateLatexInsertions)
  }

  private func setLatexImage(content: String) {
    let renderer = ImageRenderer(content: LaTeX("$" + content + "$"))
    renderer.scale = UIScreen.main.scale
    renderer.render { size, renderHandler in
      latexImages[content] = Image(uiImage: UIGraphicsImageRenderer(size: size).image(actions: { ctx in
        ctx.cgContext.translateBy(x: size.width, y: size.height)
        ctx.cgContext.scaleBy(x: -1, y: -1)
        renderHandler(ctx.cgContext)
      }).withHorizontallyFlippedOrientation())
    }
  }

  private func updateLatexInsertions(inlines: [InlineNode]) {
    let oldContents = Set(latexImages.keys)
    let newContents = Set(inlines.compactMap {
      if case let .latex(content) = $0 {
        content
      } else {
        nil
      }
    })

    oldContents.subtracting(newContents).forEach {
      latexImages[$0] = nil
    }
    newContents.subtracting(oldContents).forEach(setLatexImage)
  }

  @MainActor
  private func loadInlineImages() async throws -> [String: Image] {
    let images = Set(self.inlines.compactMap(\.imageData))
    guard !images.isEmpty else { return [:] }

    return try await withThrowingTaskGroup(of: (String, Image).self) { @MainActor taskGroup in
      for image in images {
        guard let url = URL(string: image.source, relativeTo: self.imageBaseURL) else {
          continue
        }

        taskGroup.addTask { @MainActor in
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
