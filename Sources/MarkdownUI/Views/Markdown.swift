import SwiftUI

public struct Markdown: View {
  private enum Storage {
    case text(String)
    case document(Document)

    var document: Document {
      switch self {
      case .text(let markdown):
        return Document(markdown: markdown)
      case .document(let document):
        return document
      }
    }
  }

  @Environment(\.theme.baseFont) private var baseFont
  @State private var blocks: [AnyBlock] = []

  private let storage: Storage
  private let baseURL: URL?

  private init(storage: Storage, baseURL: URL?) {
    self.storage = storage
    self.baseURL = baseURL
  }

  public var body: some View {
    BlockSequence(blocks)
      .onAppear {
        // Delay markdown parsing until the view appears for the first time
        if blocks.isEmpty {
          blocks = storage.document.blocks
        }
      }
      .environment(\.font, baseFont)
      .environment(\.markdownBaseURL, baseURL)
  }
}

extension Markdown {
  public init(_ markdown: String, baseURL: URL? = nil) {
    self.init(storage: .text(markdown), baseURL: baseURL)
  }

  public init(baseURL: URL? = nil, @BlockContentBuilder blocks: () -> [AnyBlock]) {
    self.init(storage: .document(.init(blocks: blocks)), baseURL: baseURL)
  }
}
