// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "project8",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/twostraws/SwiftGD.git", .upToNextMinor(from: "2.0.0")),
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Vapor","Leaf","SwiftGD"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

