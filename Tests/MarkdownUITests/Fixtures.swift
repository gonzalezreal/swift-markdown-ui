#if !os(macOS) && !targetEnvironment(macCatalyst)

    import UIKit

    enum Fixtures {
        static let anyImageURL = URL(string: "https://picsum.photos/id/237/200/300")!

        // Photo by André Spieker (https://unsplash.com/@andrespieker)
        static let anyImage = UIImage(
            data: try! Data(contentsOf: fixtureURL("puppy.jpg"))
        )!
    }

    private func fixtureURL(_ fileName: String, file: StaticString = #file) -> URL {
        URL(fileURLWithPath: "\(file)", isDirectory: false)
            .deletingLastPathComponent()
            .appendingPathComponent("__Fixtures__")
            .appendingPathComponent(fileName)
    }

#endif
