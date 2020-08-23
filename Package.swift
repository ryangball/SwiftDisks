// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SwiftDisks",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "SwiftDisks", targets: ["SwiftDisks"])
    ],
    targets: [
        .target(name: "SwiftDisks",
                path: "SwiftDisks",
                dependencies: [])
    ],
    swiftLanguageVersions: [.v5]
)
