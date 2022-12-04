import SwiftUI

public struct ListMarkerStyle<Configuration> {
  var makeBody: (Configuration) -> AnyView

  public init<Body: View>(
    @ViewBuilder makeBody: @escaping (_ configuration: Configuration) -> Body
  ) {
    self.makeBody = { configuration in
      AnyView(makeBody(configuration))
    }
  }
}

public struct ListItemConfiguration {
  public var listLevel: Int
  public var itemNumber: Int
}

extension ListMarkerStyle where Configuration == ListItemConfiguration {
  // MARK: - Numbers

  public static var decimal: ListMarkerStyle {
    ListMarkerStyle { configuration in
      Text("\(configuration.itemNumber).")
        .monospacedDigit()
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var upperRoman: ListMarkerStyle {
    ListMarkerStyle { configuration in
      Text(configuration.itemNumber.roman + ".")
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var lowerRoman: ListMarkerStyle {
    ListMarkerStyle { configuration in
      Text(configuration.itemNumber.roman.lowercased() + ".")
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  // MARK: - Bullets

  public static var disc: ListMarkerStyle {
    ListMarkerStyle { _ in
      Bullet.disc
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var circle: ListMarkerStyle {
    ListMarkerStyle { _ in
      Bullet.circle
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var square: ListMarkerStyle {
    ListMarkerStyle { _ in
      Bullet.square
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }

  public static var discCircleSquare: ListMarkerStyle {
    ListMarkerStyle { configuration in
      let styles: [ListMarkerStyle] = [.disc, .circle, .square]
      styles[min(configuration.listLevel, styles.count) - 1]
        .makeBody(configuration)
    }
  }

  public static var dash: ListMarkerStyle {
    ListMarkerStyle { _ in
      Text("-")
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }
}

private struct Bullet: View {
  @Environment(\.fontStyle.size) private var fontSize
  private let image: SwiftUI.Image

  var body: some View {
    image.font(.system(size: round(fontSize / 3)))
  }

  static var disc: Bullet {
    .init(image: .init(systemName: "circle.fill"))
  }

  static var circle: Bullet {
    .init(image: .init(systemName: "circle"))
  }

  static var square: Bullet {
    .init(image: .init(systemName: "square.fill"))
  }
}

public struct TaskListItemConfiguration {
  public var isCompleted: Bool
}

extension ListMarkerStyle where Configuration == TaskListItemConfiguration {
  // MARK: - Tasks

  public static var checkmarkSquareFill: ListMarkerStyle {
    ListMarkerStyle { configuration in
      SwiftUI.Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
        .symbolRenderingMode(.hierarchical)
        .imageScale(.small)
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }
}
