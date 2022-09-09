import SwiftUI

public struct OrderedListMarkerStyleConfiguration {
  public var listLevel: Int
  public var number: Int
}

public typealias OrderedListMarkerStyle = ListMarkerStyle<OrderedListMarkerStyleConfiguration>

extension OrderedListMarkerStyle {
  public static var decimal: Self {
    .init { configuration in
      Text("\(configuration.number).")
        .monospacedDigit()
    }
  }

  public static var upperRoman: Self {
    .init { configuration in
      Text(configuration.number.roman + ".")
    }
  }

  public static var lowerRoman: Self {
    .init { configuration in
      Text(configuration.number.roman.lowercased() + ".")
    }
  }
}

extension Int {
  fileprivate var roman: String {
    guard self > 0, self < 4000 else {
      return "\(self)"
    }

    let decimals = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    let numerals = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]

    var number = self
    var result = ""

    for (decimal, numeral) in zip(decimals, numerals) {
      let repeats = number / decimal
      if repeats > 0 {
        result += String(repeating: numeral, count: repeats)
      }
      number = number % decimal
    }

    return result
  }
}
