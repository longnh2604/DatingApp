//
//  UserShared.swift
//  SwiftUIBase
//
//  Created by LongNH8 on 12/5/25.
//

import SwiftUI

enum LoginState: Int {
    case logined
    case unLogin
}

class UserShared: ObservableObject {
    static let shared = UserShared()
    @Published var loginState: LoginState = .unLogin
    
    var currentLanguage: Language {
        get {
            let result = UserDefaults.standard.string(forKey: UserDefaultKeys.currentLanguage) ?? ""
            return Language(rawValue: result) ?? Language.japanese
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: UserDefaultKeys.currentLanguage)
        }
    }
}
