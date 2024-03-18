import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct NodeLayoutMacro {}

func diagnose<Context>(
    node: AttributeSyntax,
    context: Context,
    message: DiagnosticProblemMessage
) where Context: MacroExpansionContext {
    let errorDiagnose = Diagnostic(
        node: Syntax(node),
        message: message
    )
    context.diagnose(errorDiagnose)
}

extension NodeLayoutMacro: AccessorMacro {
    public static func expansion<Context, Declaration>(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: Declaration,
        in context: Context
    ) throws -> [AccessorDeclSyntax] where Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol {
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            diagnose(node: node, context: context, message: .noDeclaration)

            return []
        }
        guard varDecl.isVar else {
            diagnose(node: node, context: context, message: .notVariable)

            return []
        }
        guard varDecl.isInstance else {
            diagnose(node: node, context: context, message: .notInstance)

            return []
        }
        guard let binding = varDecl.bindings.first, binding.pattern.as(IdentifierPatternSyntax.self)?.identifier != nil else {
            diagnose(node: node, context: context, message: .other)

            return []
        }

        return [
      """
      didSet {
          setNeedsLayout()
      }
      """,
        ]
    }
}

public struct NodeDistinctLayoutMacro {}

extension NodeDistinctLayoutMacro: AccessorMacro {
    public static func expansion<Context, Declaration>(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: Declaration,
        in context: Context
    ) throws -> [AccessorDeclSyntax] where Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol {
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            diagnose(node: node, context: context, message: .noDeclaration)

            return []
        }
        guard varDecl.isVar else {
            diagnose(node: node, context: context, message: .notVariable)

            return []
        }
        guard varDecl.isInstance else {
            diagnose(node: node, context: context, message: .notInstance)

            return []
        }
        guard let binding = varDecl.bindings.first, let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.trimmed else {
            diagnose(node: node, context: context, message: .other)

            return []
        }

        return [
      """
      didSet {
          guard oldValue != \(identifier) else { 
              return
          }

          setNeedsLayout()
      }
      """,
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

enum DiagnosticProblemMessage: String, DiagnosticMessage {
    case noDeclaration = "No declaration"
    case notVariable = "Must be `var` declaration"
    case notInstance = "Must be instance variable"
    case other = "Binding error"

    var message: String { rawValue }
    var diagnosticID: SwiftDiagnostics.MessageID { .init(domain: "VATextureKitMacro", id: rawValue) }
    var severity: SwiftDiagnostics.DiagnosticSeverity { .error }
}

@main
struct VATextureKitMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        NodeLayoutMacro.self,
        NodeDistinctLayoutMacro.self,
    ]
}
