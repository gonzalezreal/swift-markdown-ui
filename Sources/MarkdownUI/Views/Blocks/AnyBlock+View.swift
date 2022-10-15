import SwiftUI

extension AnyBlock: View {
  public var body: some View {
    switch self {
    case .paragraph(let inlines):
      ParagraphView(inlines)
    }
  }
}
