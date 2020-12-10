import Foundation

struct ParagraphOptions: OptionSet {
    let rawValue: Int

    static let tightSpacing = ParagraphOptions(rawValue: 1 << 0)
    static let hanging = ParagraphOptions(rawValue: 1 << 1)
}
