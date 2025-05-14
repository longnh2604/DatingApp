//
//  DatingAppContentViewModel.swift
//  DatingApp
//
//  Created by LongNH8 on 12/5/25.
//

import SwiftUI

enum UserState {
    case notOnboarded
    case onboarded
    case loggedIn
}

class DatingAppContentViewModel: ObservableObject {
    @Published var userState: UserState = .notOnboarded
    @Published var loginViewModel: LoginViewModel
    
    init() {
        loginViewModel = LoginViewModel()
        loadUserState()
    }

    private func loadUserState() {
        let hasOnboarded = UserDefaults.standard.bool(forKey: UserDefaultKeys.hasOnboarded)
        let isLoggedIn = UserDefaults.standard.bool(forKey: UserDefaultKeys.isLoggedIn)

        if isLoggedIn {
            userState = .loggedIn
        } else if hasOnboarded {
            userState = .onboarded
        } else {
            userState = .notOnboarded
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.hasOnboarded)
        userState = .onboarded
    }

    func completeLogin() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.isLoggedIn)
        userState = .loggedIn
    }
}
