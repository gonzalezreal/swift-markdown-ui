import SwiftUI
import LaTeXSwiftUI

struct LatexView: View {
  var content: String

  var body: some View {
    LaTeX(content)
  }
}
