import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(VATextureKitMacroMacros)
import VATextureKitMacroMacros

let testMacros: [String: Macro.Type] = [
    "Layout": NodeLayoutMacro.self,
    "DistinctLayout": NodeDistinctLayoutMacro.self,
]
#endif

final class VATextureKitMacroTests: XCTestCase {

    func testMacro() throws {
        #if canImport(VATextureKitMacroMacros)
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
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithStringLiteral() throws {
        #if canImport(VATextureKitMacroMacros)
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
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
