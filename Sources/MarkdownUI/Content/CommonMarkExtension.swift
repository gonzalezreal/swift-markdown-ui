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
  static let table = Self(rawValue: "table")
  static let tagfilter = Self(rawValue: "tagfilter")
  static let tasklist = Self(rawValue: "tasklist")
}

extension Set where Element == CommonMarkExtension {
  static let all: Self = [.autolink, .strikethrough, .table, .tagfilter, .tasklist]
}
