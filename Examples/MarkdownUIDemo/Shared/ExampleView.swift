import MarkdownUI
import SwiftUI

struct ExampleView: View {
    let example: Example

    private var content: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Text(example.content)
                    Spacer()
                }
                .font(.system(.callout, design: .monospaced))
                .padding()
                .background(Color.secondary.opacity(0.2))

                Divider()

                Markdown(example.content)
                    .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(Color.primary.opacity(0.25), lineWidth: 0.5)
            )
            .padding()
        }
        .navigationTitle(example.title)
        .documentStyle(example.useDefaultStyle ? DocumentStyle(font: .system(.body)) : .alternative)
    }

    var body: some View {
        #if os(iOS)
            content.navigationBarTitleDisplayMode(.inline)
        #else
            content
        #endif
    }
}

extension DocumentStyle {
    static var alternative: DocumentStyle {
        DocumentStyle(font: .system(.body, design: .serif), codeFontName: "Menlo")
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView(example: .text)
    }
}
