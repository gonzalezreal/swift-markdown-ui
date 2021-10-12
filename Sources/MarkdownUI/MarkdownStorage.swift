import CommonMark
import Foundation

extension Markdown {
  enum Storage {
    case markdown(String)
    case document(Document)

    var document: Document {
      switch self {
      case .markdown(let string):
        return (try? Document(markdown: string)) ?? Document(blocks: [])
      case .document(let document):
        return document
      }
    }
  }
}
