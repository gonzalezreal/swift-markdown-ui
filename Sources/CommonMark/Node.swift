import cmark
import Foundation

class Node {
    let cmark_node: OpaquePointer

    var type: cmark_node_type {
        cmark_node_get_type(cmark_node)
    }

    var listType: cmark_list_type {
        cmark_node_get_list_type(cmark_node)
    }

    var listStart: Int {
        Int(cmark_node_get_list_start(cmark_node))
    }

    var listTight: Bool {
        cmark_node_get_list_tight(cmark_node) != 0
    }

    var typeString: String {
        String(cString: cmark_node_get_type_string(cmark_node))
    }

    var literal: String? {
        guard let literal = cmark_node_get_literal(cmark_node) else { return nil }
        return String(cString: literal)
    }

    var headingLevel: Int {
        Int(cmark_node_get_heading_level(cmark_node))
    }

    var fenceInfo: String? {
        guard let fenceInfo = cmark_node_get_fence_info(cmark_node) else { return nil }
        return String(cString: fenceInfo)
    }

    var url: String? {
        guard let url = cmark_node_get_url(cmark_node) else { return nil }
        return String(cString: url)
    }

    var imageURLs: [String] {
        switch type {
        case CMARK_NODE_DOCUMENT, CMARK_NODE_BLOCK_QUOTE, CMARK_NODE_LIST,
             CMARK_NODE_ITEM, CMARK_NODE_PARAGRAPH, CMARK_NODE_HEADING,
             CMARK_NODE_EMPH, CMARK_NODE_STRONG:
            return Array(children.map(\.imageURLs).joined())
        case CMARK_NODE_IMAGE:
            return [url].compactMap { $0 }
        default:
            return []
        }
    }

    var title: String? {
        guard let title = cmark_node_get_title(cmark_node) else { return nil }
        return String(cString: title)
    }

    var children: [Node] {
        var result: [Node] = []

        var child = cmark_node_first_child(cmark_node)
        while let unwrapped = child {
            result.append(Node(unwrapped))
            child = cmark_node_next(child)
        }
        return result
    }

    init(_ cmark_node: OpaquePointer) {
        self.cmark_node = cmark_node
    }

    convenience init?(_ cmark: String) {
        guard let node = cmark_parse_document(cmark, cmark.utf8.count, CMARK_OPT_SMART) else {
            return nil
        }
        self.init(node)
    }

    deinit {
        guard type == CMARK_NODE_DOCUMENT else { return }
        cmark_node_free(cmark_node)
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        String(cString: cmark_render_commonmark(cmark_node, 0, 0))
    }
}
