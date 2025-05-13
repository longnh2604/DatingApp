//
//  LoginViewModel.swift
//  DatingApp
//
//  Created by LongNH8 on 13/5/25.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

class LoginViewModel: ObservableObject {
    @Published var isLoggedIn = false
    
    func signInWithGoogle() {
        AppFirebaseConfig.shared.signInWithGoogle()
    }
}
