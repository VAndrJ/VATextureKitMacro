#if canImport(VATextureKitMacroMacros)
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import VATextureKitMacroMacros

let testMacros: [String: Macro.Type] = [
    "Layout": NodeLayoutMacro.self,
    "DistinctLayout": NodeDistinctLayoutMacro.self,
    "ScrollLayout": ScrollNodeLayoutMacro.self,
    "DistinctScrollLayout": ScrollNodeDistinctLayoutMacro.self,
    "DecodableDefaultCase": DecodableDefaultCase.self,
]

final class VATextureKitMacroTests: XCTestCase {

    func test_layoutMacro() throws {
        let variableName = "someVariable"
        assertMacroExpansion(
            """
            @Layout var \(variableName) = false
            """,
            expandedSource: """
            var \(variableName) = false {
                didSet {
                    setNeedsLayout()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_layoutMacro_faulure() throws {
        let variableName = "someVariable"
        assertMacroExpansion(
            """
            @Layout let \(variableName) = false
            """,
            expandedSource: """
            let \(variableName) = false
            """,
            diagnostics: [DiagnosticSpec(message: VATextureKitMacroError.notVariable.description, line: 1, column: 1)],
            macros: testMacros
        )
    }

    func test_layoutScrollMacro() throws {
        let variableName = "someVariable"
        assertMacroExpansion(
            """
            @ScrollLayout var \(variableName) = false
            """,
            expandedSource: """
            var \(variableName) = false {
                didSet {
                    scrollNode.setNeedsLayout()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_layoutScrollMacro_failure() throws {
        let variableName = "someVariable"
        assertMacroExpansion(
            """
            @ScrollLayout let \(variableName) = false
            """,
            expandedSource: """
            let \(variableName) = false
            """,
            diagnostics: [DiagnosticSpec(message: VATextureKitMacroError.notVariable.description, line: 1, column: 1)],
            macros: testMacros
        )
    }

    func test_distinctLayoutMacro() throws {
        let variableName = "someVariable"
        assertMacroExpansion(
            """
            @DistinctLayout var \(variableName) = false
            """,
            expandedSource: """
            var \(variableName) = false {
                didSet {
                    guard oldValue != \(variableName) else {
                        return
                    }

                    setNeedsLayout()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_distinctLayoutMacro_failure() throws {
        let variableName = "someVariable"
        assertMacroExpansion(
            """
            @DistinctLayout let \(variableName) = false
            """,
            expandedSource: """
            let \(variableName) = false
            """,
            diagnostics: [DiagnosticSpec(message: VATextureKitMacroError.notVariable.description, line: 1, column: 1)],
            macros: testMacros
        )
    }

    func test_distinctScrollLayout() throws {
        let variableName = "someVariable"
        assertMacroExpansion(
            """
            @DistinctScrollLayout var \(variableName) = false
            """,
            expandedSource: """
            var \(variableName) = false {
                didSet {
                    guard oldValue != \(variableName) else {
                        return
                    }

                    scrollNode.setNeedsLayout()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_distinctScrollLayout_failure() throws {
        let variableName = "someVariable"
        assertMacroExpansion(
            """
            @DistinctScrollLayout let \(variableName) = false
            """,
            expandedSource: """
            let \(variableName) = false
            """,
            diagnostics: [DiagnosticSpec(message: VATextureKitMacroError.notVariable.description, line: 1, column: 1)],
            macros: testMacros
        )
    }
}
#endif
