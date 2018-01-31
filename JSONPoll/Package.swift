// swift-tools-version:4.0
import PackageDescription


let version = Version(stringLiteral: "3.0.0-beta.0")

let package = Package(
    name: "JSONPoll",
    dependencies: [
        // 💧 A server-side Swift web framework.
    
        .package(url: "https://github.com/vapor/vapor.git", from: version),
        .package(url: "https://github.com/vapor/fluent.git", from: version),
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor","FluentSQLite"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)

