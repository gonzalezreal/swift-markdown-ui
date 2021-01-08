import cmark
import Foundation

/// A CommonMark document.
public struct Document {
    /// A CommonMark document inline.
    public enum Inline: Equatable {
        /// Plain textual content.
        case text(String)

        /// Soft line break.
        case softBreak

        /// Hard line break.
        case lineBreak

        /// Code span.
        case code(String)

        /// Raw HTML.
        case html(String)

        /// Emphasis.
        case emphasis([Inline])

        /// Strong emphasis.
        case strong([Inline])

        /// Link.
        case link([Inline], url: String, title: String = "")

        /// Image.
        case image([Inline], url: String, title: String = "")

        init(node: Node) {
            switch node.type {
            case CMARK_NODE_TEXT:
                self = .text(node.literal!)
            case CMARK_NODE_SOFTBREAK:
                self = .softBreak
            case CMARK_NODE_LINEBREAK:
                self = .lineBreak
            case CMARK_NODE_CODE:
                self = .code(node.literal!)
            case CMARK_NODE_HTML_INLINE:
                self = .html(node.literal!)
            case CMARK_NODE_EMPH:
                self = .emphasis(node.children.map(Inline.init))
            case CMARK_NODE_STRONG:
                self = .strong(node.children.map(Inline.init))
            case CMARK_NODE_LINK:
                self = .link(node.children.map(Inline.init), url: node.url ?? "", title: node.title ?? "")
            case CMARK_NODE_IMAGE:
                self = .image(node.children.map(Inline.init), url: node.url ?? "", title: node.title ?? "")
            default:
                fatalError("Unhandled cmark node '\(node.typeString)'")
            }
        }
    }

    /// A CommonMark list.
    public struct List: Equatable {
        /// List style.
        public enum Style: Equatable {
            case bullet, ordered

            init(_ listType: cmark_list_type) {
                switch listType {
                case CMARK_ORDERED_LIST:
                    self = .ordered
                default:
                    self = .bullet
                }
            }
        }

        /// A single list item.
        public struct Item: Equatable {
            public let blocks: [Block]

            public init(blocks: [Block]) {
                self.blocks = blocks
            }

            init?(node: Node) {
                guard case CMARK_NODE_ITEM = node.type else { return nil }
                blocks = node.children.map(Block.init)
            }
        }

        /// The items in this list.
        public let items: [Item]

        /// The list style.
        public let style: Style

        /// The start index in an ordered list.
        public let start: Int

        /// Whether or not this list has tight or loose spacing between its items.
        public let isTight: Bool

        public init(items: [Item], style: Style, start: Int, isTight: Bool) {
            self.items = items
            self.style = style
            self.start = start
            self.isTight = isTight
        }

        init(node: Node) {
            assert(node.type == CMARK_NODE_LIST)

            items = node.children.compactMap(Item.init)
            style = Style(node.listType)
            start = node.listStart
            isTight = node.listTight
        }
    }

    /// A CommonMark document block.
    public enum Block: Equatable {
        /// A block quote.
        case blockQuote([Block])

        /// A list.
        case list(List)

        /// A code block.
        case code(String, language: String = "")

        /// A group of lines that is treated as raw HTML.
        case html(String)

        /// A paragraph.
        case paragraph([Inline])

        /// A heading.
        case heading([Inline], level: Int)

        /// A thematic break.
        case thematicBreak

        init(node: Node) {
            switch node.type {
            case CMARK_NODE_BLOCK_QUOTE:
                self = .blockQuote(node.children.map(Block.init))
            case CMARK_NODE_LIST:
                self = .list(List(node: node))
            case CMARK_NODE_CODE_BLOCK:
                self = .code(node.literal!, language: node.fenceInfo ?? "")
            case CMARK_NODE_HTML_BLOCK:
                self = .html(node.literal!)
            case CMARK_NODE_PARAGRAPH:
                self = .paragraph(node.children.map(Inline.init))
            case CMARK_NODE_HEADING:
                self = .heading(
                    node.children.map(Inline.init),
                    level: node.headingLevel
                )
            case CMARK_NODE_THEMATIC_BREAK:
                self = .thematicBreak
            default:
                fatalError("Unhandled cmark node '\(node.typeString)'")
            }
        }
    }

    /// The blocks that form this document.
    public var blocks: [Block] {
        node.children.map(Block.init)
    }

    /// A set with all the image locations contained in this document.
    public var imageURLs: Set<String> {
        Set(node.imageURLs)
    }

    private let node: Node

    public init(_ content: String) {
        node = Node(content)!
    }

    public init(contentsOfFile path: String) throws {
        try self.init(String(contentsOfFile: path))
    }

    public init(contentsOfFile path: String, encoding: String.Encoding) throws {
        try self.init(String(contentsOfFile: path, encoding: encoding))
    }
}

extension Document: Equatable {
    public static func == (lhs: Document, rhs: Document) -> Bool {
        if lhs.node === rhs.node {
            return true
        } else {
            return lhs.node.description == rhs.node.description
        }
    }
}

extension Document: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(node.description)
    }
}

extension Document: CustomStringConvertible {
    public var description: String {
        node.description
    }
}

extension Document: ExpressibleByStringInterpolation {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension Document: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let content = try container.decode(String.self)

        guard let node = Node(content) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid document: \(content)"
            )
        }

        self.node = node
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
