#if os(macOS)
    import AppKit

    public typealias Font = NSFont

#elseif os(iOS) || os(tvOS) || os(watchOS)
    import UIKit

    public typealias Font = UIFont

#endif
