// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(accessor, names: named(didSet))
public macro Layout() = #externalMacro(module: "VATextureKitMacroMacros", type: "NodeLayoutMacro")
@attached(accessor, names: named(didSet))
public macro DistinctLayout() = #externalMacro(module: "VATextureKitMacroMacros", type: "NodeDistinctLayoutMacro")
@attached(accessor, names: named(didSet))
public macro ScrollLayout() = #externalMacro(module: "VATextureKitMacroMacros", type: "ScrollNodeLayoutMacro")
@attached(accessor, names: named(didSet))
public macro DistinctScrollLayout() = #externalMacro(module: "VATextureKitMacroMacros", type: "ScrollNodeDistinctLayoutMacro")
