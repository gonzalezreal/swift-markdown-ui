import Foundation

struct CommonMarkExtension: Hashable, RawRepresentable {
  let rawValue: String

  init(rawValue: String) {
    self.rawValue = rawValue
  }
}

extension CommonMarkExtension {
  static let autolink = Self(rawValue: "autolink")
  static let strikethrough = Self(rawValue: "strikethrough")
  static let tagfilter = Self(rawValue: "tagfilter")
  static let tasklist = Self(rawValue: "tasklist")
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension CommonMarkExtension {
  static let table = Self(rawValue: "table")
}

extension Set where Element == CommonMarkExtension {
  static let all: Self = {
    if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
      return [.autolink, .strikethrough, .table, .tagfilter, .tasklist]
    } else {
      return [.autolink, .strikethrough, .tagfilter, .tasklist]
    }
  }()
}
