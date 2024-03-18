// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "VATextureKitMacro",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "VATextureKitMacro",
            targets: ["VATextureKitMacro"]
        ),
        .executable(
            name: "VATextureKitMacroClient",
            targets: ["VATextureKitMacroClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .macro(
            name: "VATextureKitMacroMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(name: "VATextureKitMacro", dependencies: ["VATextureKitMacroMacros"]),
        .executableTarget(name: "VATextureKitMacroClient", dependencies: ["VATextureKitMacro"]),
        .testTarget(
            name: "VATextureKitMacroTests",
            dependencies: [
                "VATextureKitMacroMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
