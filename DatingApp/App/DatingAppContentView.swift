//
//  DatingAppContentView.swift
//  DatingApp
//
//  Created by LongNH8 on 12/5/25.
//

import SwiftUI

struct DatingAppContentView: View {
    @EnvironmentObject var viewModel: DatingAppContentViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.userState {
            case .loggedIn:
                Text("Base View \(AppConfig.App.appName)")
            case .onboarded:
                LoginView()
            case .notOnboarded:
                OnboardingView()
            }
        }
    }
}
