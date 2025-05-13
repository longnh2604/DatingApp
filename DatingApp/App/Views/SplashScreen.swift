//
//  SplashScreen.swift
//  SwiftUIBase
//
//  Created by LongNH8 on 12/5/25.
//

import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject var viewModel: DatingAppContentViewModel
    
    // MARK: - State Properties
    @State var isActive = false
    
    var body: some View {
        if isActive {
            DatingAppContentView()
                .preferredColorScheme(.light)
        } else {
            ZStack {
                VStack {
                    Image(AppAssets.appIcon)
                        .resizable()
                        .scaledToFit()
                }
            }
            .onAppear {
                // For demo
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}
