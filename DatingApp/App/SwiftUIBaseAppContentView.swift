//
//  DatingAppContentView.swift
//  DatingApp
//
//  Created by LongNH8 on 12/5/25.
//

import SwiftUI

struct DatingAppContentView: View {
    @ObservedObject var viewModel: DatingAppContentViewModel
    
    init(viewModel: DatingAppContentViewModel = DatingAppContentViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            switch viewModel.userState {
            case .loggedIn:
                Text("Base View \(AppConfig.App.appName)")
            case .onboarded:
                Text("Login View")
            case .notOnboarded:
                Text("Onboarding View")
                    .onAppear {
                        viewModel.completeOnboarding()
                    }
            }
        }
    }
}
