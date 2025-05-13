//
//  LoginView.swift
//  DatingApp
//
//  Created by LongNH8 on 13/5/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(AppAssets.appIcon) // Replace with your asset
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(20)

            Text("Dating App")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button(action: {
                viewModel.signInWithGoogle()
            }) {
                HStack {
                    Image(AppAssets.googleIcon)
                        .resizable()
                        .frame(width: 34, height: 34)
                    
                    Text("Sign in with Google")
                        .fontWeight(.semibold)
                }
                .frame(width: 280, height: 50)
                .foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
