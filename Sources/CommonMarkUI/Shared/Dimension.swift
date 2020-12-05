import CoreGraphics
import Foundation

public enum Dimension: Equatable {
    case points(CGFloat)
    case em(CGFloat)

    var points: CGFloat? {
        guard case let .points(value) = self else { return nil }
        return value
    }

    var em: CGFloat? {
        guard case let .em(value) = self else { return nil }
        return value
    }

    func resolve(_ parentSize: CGFloat) -> CGFloat {
        switch self {
        case let .points(value):
            return value
        case let .em(value):
            return value * parentSize
        }
    }
}
