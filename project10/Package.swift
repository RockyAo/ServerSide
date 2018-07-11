// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "project10",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "3.0.0-rc.4.0.1"),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0-rc.4"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/crossroadlabs/Markdown.git", .exact("1.0.0-alpha.2")),
        .package(url: "https://github.com/twostraws/SwiftSlug.git", .upToNextMinor(from: "0.2.0")),
    ],
    targets: [
        .target(name: "App", dependencies: ["Fluent", "FluentMySQL", "Vapor", "Markdown", "SwiftSlug", "Leaf"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

