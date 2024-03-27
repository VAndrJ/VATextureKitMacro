import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct NodeLayoutMacro: AccessorMacro {

    public static func expansion<Context, Declaration>(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: Declaration,
        in context: Context
    ) throws -> [AccessorDeclSyntax] where Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol {
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              varDecl.isVar,
              varDecl.isInstance,
              let binding = varDecl.bindings.first,
              binding.pattern.as(IdentifierPatternSyntax.self)?.identifier != nil else {
            throw VATextureKitMacroError.notVariable
        }

        return [
            AccessorDeclSyntax(accessorSpecifier: .keyword(.didSet)) {
                "setNeedsLayout()"
            },
        ]
    }
}

public struct ScrollNodeLayoutMacro: AccessorMacro {

    public static func expansion<Context, Declaration>(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: Declaration,
        in context: Context
    ) throws -> [AccessorDeclSyntax] where Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol {
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              varDecl.isVar,
              varDecl.isInstance,
              let binding = varDecl.bindings.first,
              binding.pattern.as(IdentifierPatternSyntax.self)?.identifier != nil else {
            throw VATextureKitMacroError.notVariable
        }

        return [
            AccessorDeclSyntax(accessorSpecifier: .keyword(.didSet)) {
                "scrollNode.setNeedsLayout()"
            },
        ]
    }
}

public struct NodeDistinctLayoutMacro: AccessorMacro {

    public static func expansion<Context, Declaration>(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: Declaration,
        in context: Context
    ) throws -> [AccessorDeclSyntax] where Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol {
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              varDecl.isVar,
              varDecl.isInstance,
              let binding = varDecl.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.trimmed else {
            throw VATextureKitMacroError.notVariable
        }

        return [
            AccessorDeclSyntax(accessorSpecifier: .keyword(.didSet)) {
                """
                    guard oldValue != \(identifier) else {
                        return
                    }

                    setNeedsLayout()
                """
            }
        ]
    }
}

public struct ScrollNodeDistinctLayoutMacro: AccessorMacro {

    public static func expansion<Context, Declaration>(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: Declaration,
        in context: Context
    ) throws -> [AccessorDeclSyntax] where Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol {
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              varDecl.isVar,
              varDecl.isInstance,
              let binding = varDecl.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.trimmed else {
            throw VATextureKitMacroError.notVariable
        }

        return [
            AccessorDeclSyntax(accessorSpecifier: .keyword(.didSet)) {
                """
                    guard oldValue != \(identifier) else {
                        return
                    }

                    scrollNode.setNeedsLayout()
                """
            }
        ]
    }
}

extension VariableDeclSyntax {
    public var isLet: Bool { bindingSpecifier.tokenKind == .keyword(.let) }
    public var isVar: Bool { bindingSpecifier.tokenKind == .keyword(.var) }
    public var isStatic: Bool { modifiers.contains { $0.name.tokenKind == .keyword(.static) } }
    public var isClass: Bool { modifiers.contains { $0.name.tokenKind == .keyword(.class) } }
    public var isInstance: Bool { !isClass && !isStatic }
}

public enum VATextureKitMacroError: Error, CustomStringConvertible {
    case notVariable

    public var description: String {
        switch self {
        case .notVariable: "Must be `var` declaration"
        }
    }
}

@main
struct VATextureKitMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        NodeLayoutMacro.self,
        NodeDistinctLayoutMacro.self,
        ScrollNodeLayoutMacro.self,
        ScrollNodeDistinctLayoutMacro.self,
    ]
}
