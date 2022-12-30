import SwiftUI

public struct ListItemConfiguration {
  public var listLevel: Int
  public var itemNumber: Int
}

extension BlockStyle where Configuration == ListItemConfiguration {
  public static var decimal: Self {
    BlockStyle { configuration in
      Text("\(configuration.itemNumber).")
        .monospacedDigit()
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var upperRoman: Self {
    BlockStyle { configuration in
      Text(configuration.itemNumber.roman + ".")
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var lowerRoman: Self {
    BlockStyle { configuration in
      Text(configuration.itemNumber.roman.lowercased() + ".")
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var dash: Self {
    BlockStyle { _ in
      Text("-")
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var disc: Self {
    BlockStyle { _ in
      ListBullet.disc
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var circle: Self {
    BlockStyle { _ in
      ListBullet.circle
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var square: Self {
    BlockStyle { _ in
      ListBullet.square
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var discCircleSquare: Self {
    BlockStyle { configuration in
      let styles: [Self] = [.disc, .circle, .square]
      styles[min(configuration.listLevel, styles.count) - 1]
        .makeBody(configuration: configuration)
    }
  }
}
