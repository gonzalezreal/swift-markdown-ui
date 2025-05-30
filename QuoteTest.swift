import SwiftUI
import MarkdownUI

struct QuoteTestView: View {
    let markdownText = """
    这是一个测试文档。

    这里有一些\u{201C}引号内的文字\u{201D}应该显示为黄色。

    还有一些"英文引号内的文字"也应该显示为黄色。

    德文引号\u{201E}这些文字\u{201D}和法文引号\u{00AB}这些文字\u{00BB}也应该显示为黄色。

    中文引号\u{300C}这些文字\u{300D}和\u{300E}这些文字\u{300F}也应该显示为黄色。

    普通文字应该保持默认颜色。

    **粗体文字**和*斜体文字*应该正常工作。

    混合使用：\u{201C}这是引号内的**粗体文字**\u{201D}应该既是黄色又是粗体。
    """
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("引号高亮测试")
                    .font(.title)
                    .fontWeight(.bold)
                
                Markdown(markdownText)
                    .markdownTheme(.basic)
                    .padding()
            }
            .padding()
        }
    }
}

struct ContentView: View {
    var body: some View {
        QuoteTestView()
    }
}

#Preview {
    ContentView()
} 