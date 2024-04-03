//
//  VATextureKitDecodableMacro.swift
//
//
//  Created by VAndrJ on 03.04.2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DecodableDefaultCase: ExtensionMacro {

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self),
              let firstCase = enumDecl.memberBlock.members.first?.decl.as(EnumCaseDeclSyntax.self)?.elements.first else {
            throw VATextureKitMacroError.notEnum
        }
        guard firstCase.parameterClause == nil else {
            throw VATextureKitMacroError.associatedValue
        }

        return [
            ExtensionDeclSyntax(extendedType: type) {
                """
                public init(from decoder: Decoder) throws {
                    self = try \(type)(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .\(raw: firstCase.name.trimmedDescription.notShadowed)
                }
                """
            },
        ]
    }
}

private extension String {
    var notShadowed: String { count > 3 && first == "`" && last == "`" ? String(dropLast().dropFirst()) : self }
}
