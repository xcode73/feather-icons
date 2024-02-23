// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-icons",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "FeatherIcons", targets: ["FeatherIcons"])
    ],
    dependencies: [
        .package(url: "https://github.com/binarybirds/swift-html", from: "1.7.0"),
        .package(url: "https://github.com/cezheng/Fuzi", from: "3.1.3")
    ],
    targets: [
        .executableTarget(name: "Converter", dependencies: [
            .product(name: "Fuzi", package: "Fuzi")
        ]),
        .target(name: "FeatherIcons", dependencies: [
            .product(name: "SwiftSvg", package: "swift-html")
        ]),
        .testTarget(name: "FeatherIconsTests", dependencies: [
            .target(name: "FeatherIcons")
        ]),
    ],
    swiftLanguageVersions: [.v5]
)

