//
//  Font+Extensions.swift
//  SwiftUIBase
//
//  Created by LongNH8 on 12/5/25.
//

import Foundation
import SwiftUI

internal struct FontConvertible {
    internal let name: String
    internal let family: String
    internal let path: String

#if os(macOS)
    internal typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
    internal typealias Font = UIFont
#endif

    internal func font(size: CGFloat) -> Font {
        guard let font = Font(font: self, size: size) else {
            fatalError("Unable to initialize font '\(name)' (\(family))")
        }
        return font
    }

    internal func register() {
        // swiftlint:disable:next conditional_returns_on_newline
        guard let url = url else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }

    fileprivate var url: URL? {
        // swiftlint:disable:next implicit_return
        return Bundle.main.url(forResource: path, withExtension: nil)
    }
}

internal extension FontConvertible.Font {
    convenience init?(font: FontConvertible, size: CGFloat) {
#if os(iOS) || os(tvOS) || os(watchOS)
        if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
            font.register()
        }
#elseif os(macOS)
        if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
            font.register()
        }
#endif

        self.init(name: font.name, size: size)
    }
}

struct NotoSansFont {
    static let regular = FontConvertible(name: "NotoSansJP-Regular", family: "NotoSansJP", path: "NotoSansJP-Regular.otf")
    static let medium = FontConvertible(name: "NotoSansJP-Medium", family: "NotoSansJP", path: "NotoSansJP-Medium.otf")
    static let thin = FontConvertible(name: "NotoSansJP-Thin", family: "NotoSansJP", path: "NotoSansJP-Thin.otf")
    static let bold = FontConvertible(name: "NotoSansJP-Bold", family: "NotoSansJP", path: "NotoSansJP-Bold.otf")
    static let heavy = FontConvertible(name: "NotoSansJP-Heavy", family: "NotoSansJP", path: "NotoSansJP-Heavy.otf")
    static let black = FontConvertible(name: "NotoSansJP-Black", family: "NotoSansJP", path: "NotoSansJP-Black.otf")
    static let light = FontConvertible(name: "NotoSansJP-Light", family: "NotoSansJP", path: "NotoSansJP-Light.otf")
}

enum FontType: String {
    case nsBlack, nsBold, nsHeavy, nsLight, nsMedium, nsRegular, nsThin

    var fontName: String {
        switch self {
        case .nsBlack:
            return NotoSansFont.black.name
        case .nsBold:
            return NotoSansFont.bold.name
        case .nsHeavy:
            return NotoSansFont.heavy.name
        case .nsLight:
            return NotoSansFont.light.name
        case .nsMedium:
            return NotoSansFont.medium.name
        case .nsRegular:
            return NotoSansFont.regular.name
        case .nsThin:
            return NotoSansFont.thin.name
        }
    }
}

enum TextStyle: String {
    case title1, title2, title3, subheadline, body, footnote, caption2
}

extension Font {
    static func setFont(_ type: FontType, _ size: CGFloat) -> Font {
        return .custom(type.fontName, fixedSize: size)
    }
}
