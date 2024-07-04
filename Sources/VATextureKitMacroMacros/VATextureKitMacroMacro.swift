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

private let varKeyword: TokenKind = .keyword(.var)
private let staticKeyword: TokenKind = .keyword(.static)
private let classKeyword: TokenKind = .keyword(.class)

extension VariableDeclSyntax {
    public var isVar: Bool { bindingSpecifier.tokenKind == varKeyword }
    public var isStatic: Bool { modifiers.contains { $0.name.tokenKind == staticKeyword } }
    public var isClass: Bool { modifiers.contains { $0.name.tokenKind == classKeyword } }
    public var isInstance: Bool { !(isClass || isStatic) }
}

public enum VATextureKitMacroError: Error, CustomStringConvertible {
    case notVariable
    case notEnum
    case associatedValue

    public var description: String {
        switch self {
        case .notVariable: "Must be `var` declaration"
        case .notEnum: "Must be `enum`"
        case .associatedValue: "Must not have associated values"
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
        DecodableDefaultCase.self,
    ]
}
