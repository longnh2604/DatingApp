//
//  LanguageHelper.swift
//  SwiftUIBase
//
//  Created by LongNH8 on 12/5/25.
//

import UIKit

enum LanguageLocalizationKey: String {
    case lgTitle
    case lgEnglish
    case lgJapanese
}

enum Language: String {
    case english = "en"
    case japanese = "ja"

    var title: String {
        switch self {
        case .english:
            return localized(key: .lgEnglish)
        case .japanese:
            return localized(key: .lgJapanese)
        }
    }
}

let languageHelper = LanguageHelper.shared

class LanguageHelper {

    static let shared = LanguageHelper()
    fileprivate var info: [String: String]?

    func setLanguage(forLanguage language: Language) {
        UserShared.shared.currentLanguage = language
        NotificationCenter.default.post(name: .changeLanguageNoti, object: nil)
    }

    func currentLanguage() -> Language {
        return UserShared.shared.currentLanguage
    }

    func getValue(forKey key: String) -> String {
        let source = UserShared.shared.currentLanguage
        if let path = Bundle.main.path(forResource: source.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(
                key,
                tableName: "Localizable",
                bundle: bundle,
                value: "\(key)", comment: ""
            )
        } else {
            return NSLocalizedString(
                key,
                tableName: "Localizable",
                bundle: .main,
                value: "\(key)", comment: ""
            )
        }
    }
}
