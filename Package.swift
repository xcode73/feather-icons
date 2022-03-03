// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "feather-icons",
    platforms: [
       .macOS(.v10_15),
    ],
    products: [
        .library(name: "FeatherIcons", targets: ["FeatherIcons"]),
    ],
    dependencies: [
        .package(url: "https://github.com/binarybirds/swift-html", from: "1.6.0"),
    ],
    targets: [
        .target(name: "FeatherIcons", dependencies: [
            .product(name: "SwiftSvg", package: "swift-html"),
        ]),

        .testTarget(name: "FeatherIconsTests", dependencies: [
            .target(name: "FeatherIcons"),
        ]),
    ]
)

