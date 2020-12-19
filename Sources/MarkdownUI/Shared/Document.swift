import cmark
import Foundation

public struct Document {
    public enum Inline: Equatable {
        case text(String)
        case softBreak
        case lineBreak
        case code(String)
        case html(String)
        case custom(String)
        case emphasis([Inline])
        case strong([Inline])
        case link([Inline], url: String, title: String = "")
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
            case CMARK_NODE_CUSTOM_INLINE:
                self = .custom(node.literal!)
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

    public struct List: Equatable {
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

        public let items: [Item]
        public let style: Style
        public let start: Int
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

    public enum Block: Equatable {
        case blockQuote([Block])
        case list(List)
        case code(String, language: String = "")
        case html(String)
        case custom(String)
        case paragraph([Inline])
        case heading([Inline], level: Int)
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
            case CMARK_NODE_CUSTOM_BLOCK:
                self = .custom(node.literal!)
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

    public var blocks: [Block] {
        node.children.map(Block.init)
    }

    public var imageURLs: Set<String> {
        Set(node.imageURLs)
    }

    private let node: Node
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

extension Document: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let node = Node(description) else {
            return nil
        }
        self.node = node
    }

    public var description: String {
        node.description
    }
}

extension Document: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let description = try container.decode(String.self)

        guard let node = Node(description) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid document: \(description)"
            )
        }

        self.node = node
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
