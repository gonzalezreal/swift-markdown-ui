#if canImport(UIKit) && !os(watchOS)

    import UIKit

    @available(iOS 13.0, tvOS 13.0, *)
    public extension UIColor {
        static var primary: UIColor { label }
        static var secondary: UIColor { secondaryLabel }
    }

#endif
