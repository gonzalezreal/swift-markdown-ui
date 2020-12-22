import CoreGraphics
import Foundation

/// A quantity that can be expressed in points or relative to the font size.
public enum Dimension: Equatable {
    /// Absolute points.
    case points(CGFloat)

    /// Relative to the font-size (.em(2) means 2 times the size of the current font)
    case em(CGFloat)

    public var points: CGFloat? {
        guard case let .points(value) = self else { return nil }
        return value
    }

    public var em: CGFloat? {
        guard case let .em(value) = self else { return nil }
        return value
    }

    public func resolve(_ parentSize: CGFloat) -> CGFloat {
        switch self {
        case let .points(value):
            return value
        case let .em(value):
            return value * parentSize
        }
    }
}
