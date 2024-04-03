//
//  VATextureKitMacroTests+DecodableDefaultCase.swift
//  
//
//  Created by VAndrJ on 03.04.2024.
//

#if canImport(VATextureKitMacroMacros)
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import VATextureKitMacroMacros

extension VATextureKitMacroTests {

    func test_DecodableDefaultCase_expansion() throws {
        assertMacroExpansion(
            """
            @DecodableDefaultCase
            public enum SomeEnum: String, Codable {
                case undefined
                case first
            }
            """,
            expandedSource: """
            public enum SomeEnum: String, Codable {
                case undefined
                case first
            }

            extension SomeEnum {
                public init(from decoder: Decoder) throws {
                    self = try SomeEnum(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .undefined
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_DecodableDefaultCase_shadowed_expansion() throws {
        assertMacroExpansion(
            """
            @DecodableDefaultCase
            enum SomeEnum: String, Codable {
                case `default`
                case first
            }
            """,
            expandedSource: """
            enum SomeEnum: String, Codable {
                case `default`
                case first
            }

            extension SomeEnum {
                init(from decoder: Decoder) throws {
                    self = try SomeEnum(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .default
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_DecodableDefaultCase_withRawValue_expansion() throws {
        assertMacroExpansion(
            """
            @DecodableDefaultCase
            fileprivate enum SomeEnum: Int, Codable {
                case undefined = -1
                case first = 0
            }
            """,
            expandedSource: """
            fileprivate enum SomeEnum: Int, Codable {
                case undefined = -1
                case first = 0
            }

            extension SomeEnum {
                fileprivate init(from decoder: Decoder) throws {
                    self = try SomeEnum(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .undefined
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_DecodableDefaultCase_expansionWithAssociatedValue_failure() throws {
        assertMacroExpansion(
            """
            @DecodableDefaultCase
            enum SomeEnum: Codable {
                case withAssociated(number: Int)
                case first
            }
            """,
            expandedSource: """
            enum SomeEnum: Codable {
                case withAssociated(number: Int)
                case first
            }
            """,
            diagnostics: [DiagnosticSpec(message: VATextureKitMacroError.associatedValue.description, line: 1, column: 1)],
            macros: testMacros
        )
    }

    func test_DecodableDefaultCase_notEnum_failure() throws {
        assertMacroExpansion(
            """
            @DecodableDefaultCase
            class SomeEnum: Codable {
                case withAssociated(number: Int)
                case first
            }
            """,
            expandedSource: """
            class SomeEnum: Codable {
                case withAssociated(number: Int)
                case first
            }
            """,
            diagnostics: [DiagnosticSpec(message: VATextureKitMacroError.notEnum.description, line: 1, column: 1)],
            macros: testMacros
        )
    }
}
#endif
