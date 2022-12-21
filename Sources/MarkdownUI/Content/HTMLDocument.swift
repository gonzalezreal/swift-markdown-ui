import Foundation
@_implementationOnly import libxml2

final class HTMLDocument {
  struct ParsingOptions: OptionSet {
    var rawValue: Int32

    init(rawValue: Int32) {
      self.rawValue = rawValue
    }

    init(_ htmlParserOption: htmlParserOption) {
      self.init(rawValue: Int32(htmlParserOption.rawValue))
    }

    static let recover = ParsingOptions(HTML_PARSE_RECOVER)
    static let noError = ParsingOptions(HTML_PARSE_NOERROR)
    static let noWarning = ParsingOptions(HTML_PARSE_NOWARNING)
    static let noBlanks = ParsingOptions(HTML_PARSE_NOBLANKS)
    static let noNetwork = ParsingOptions(HTML_PARSE_NONET)
    static let noImplied = ParsingOptions(HTML_PARSE_NOIMPLIED)
    static let compact = ParsingOptions(HTML_PARSE_COMPACT)

    static let `default`: ParsingOptions = [
      .recover, .noError, .noWarning, .noBlanks, .noNetwork, .compact,
    ]
  }

  struct Node {
    let document: HTMLDocument
    private let nodePtr: htmlNodePtr

    var type: xmlElementType {
      nodePtr.pointee.type
    }

    var name: String? {
      String(cString: nodePtr.pointee.name)
    }

    subscript(attribute: String) -> String? {
      guard let value = xmlGetProp(nodePtr, attribute) else {
        return nil
      }
      defer { xmlFree(value) }
      return String(cString: value)
    }

    var content: String? {
      guard let value = xmlNodeGetContent(nodePtr) else {
        return nil
      }
      defer { xmlFree(value) }
      return String(cString: value)
    }

    var children: [Node] {
      guard let first = nodePtr.pointee.children else {
        return []
      }
      return sequence(first: first, next: { $0.pointee.next })
        .compactMap { Node(document: document, nodePtr: $0) }
    }

    init(document: HTMLDocument, nodePtr: htmlNodePtr) {
      self.document = document
      self.nodePtr = nodePtr
    }
  }

  var root: Node? {
    guard let rootPtr = xmlDocGetRootElement(docPtr) else {
      return nil
    }
    return Node(document: self, nodePtr: rootPtr)
  }

  var body: Node? {
    root?.children.first(where: { $0.type == XML_ELEMENT_NODE && $0.name == "body" })
  }

  private let docPtr: htmlDocPtr

  init?(string: String, baseURL: URL? = nil, options: ParsingOptions = .default) {
    guard
      let docPtr = string.cString(using: .utf8)?
        .withUnsafeBufferPointer({ buffer in
          htmlReadMemory(
            buffer.baseAddress,
            Int32(buffer.count),
            baseURL?.absoluteString,
            nil,
            options.rawValue
          )
        })
    else {
      return nil
    }

    self.docPtr = docPtr
  }

  deinit {
    xmlFreeDoc(docPtr)
  }
}
