import SwiftUI

struct InlineText: View {
  @Environment(\.inlineImageProvider) private var inlineImageProvider
  @Environment(\.baseURL) private var baseURL
  @Environment(\.imageBaseURL) private var imageBaseURL
  @Environment(\.softBreakMode) private var softBreakMode
  @Environment(\.theme) private var theme

  @State private var inlineImages: [String: Image] = [:]
  @State private var customInlines: [String: Text] = [:]

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
        images: inlineImages,
        customInlines: customInlines,
        softBreakMode: self.softBreakMode,
        attributes: attributes
      )
    }
    .task(id: self.inlines) { @MainActor in
      try? await withThrowingTaskGroup { @MainActor in
        $0.addTask { @MainActor in
          inlineImages = (try? await self.loadInlineImages()) ?? [:]
        }
        $0.addTask { @MainActor in
          let customNodes = self.inlines.compactMap {
            if case let .custom(custom) = $0 { custom } else { nil }
          }
          for customNode in customNodes {
            if let renderAsync = customNode.renderAsync, customInlines[customNode.id] == nil {
              let result = await renderAsync()
              try Task.checkCancellation()
              customInlines[customNode.id] = result
            }
          }
        }
      }
    }
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
          if let existing = inlineImages[image.source] {
            return (image.source, existing)
          } else {
            return (image.source, try await self.inlineImageProvider.image(with: url, label: image.alt))
          }
        }
      }

      var result: [String: Image] = [:]

      for try await pair in taskGroup {
        result[pair.0] = pair.1
      }

      return result
    }
  }
}
