import SwiftUI

public struct UnorderedListMarkerStyle {
  public struct Configuration {
    public var listLevel: Int
  }
  var makeBody: (Configuration) -> Text

  public init(makeBody: @escaping (Configuration) -> Text) {
    self.makeBody = makeBody
  }
}

extension UnorderedListMarkerStyle {
  public static var disc: Self {
    .init { _ in
      Text("•")
    }
  }

  public static var dash: Self {
    .init { _ in
      Text("-")
    }
  }
}
