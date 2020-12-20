#if os(macOS)

    import AppKit

    public extension NSColor {
        static var primary: NSColor { labelColor }
        static var secondary: NSColor { secondaryLabelColor }
    }

#endif
