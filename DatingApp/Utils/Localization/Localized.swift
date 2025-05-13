//
//  Localized.swift
//  SwiftUIBase
//
//  Created by LongNH8 on 12/5/25.
//

import UIKit

extension String {
    var localized: String {
        languageHelper.getValue(forKey: self)
    }
}

func localized(key: ErrorLocalizationKey) -> String {
    return key.rawValue.localized
}

func localized(key: LanguageLocalizationKey) -> String {
    return key.rawValue.localized
}

func localized(key: GeneralLocalizationKey) -> String {
    return key.rawValue.localized
}

func localizedBy(key: String) -> String {
    return key.localized
}
