// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(accessor, names: named(didSet))
public macro Layout() = #externalMacro(module: "VATextureKitMacroMacros", type: "NodeLayoutMacro")
@attached(accessor, names: named(didSet))
public macro DistinctLayout() = #externalMacro(module: "VATextureKitMacroMacros", type: "NodeDistinctLayoutMacro")
