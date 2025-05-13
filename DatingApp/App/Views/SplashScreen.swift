//
//  SplashScreen.swift
//  SwiftUIBase
//
//  Created by LongNH8 on 12/5/25.
//

import SwiftUI

struct SplashScreen: View {
    // MARK: - State Properties
    @State var isActive = false

    // MARK: - ObservedObject
    @ObservedObject var viewModel: DatingAppContentViewModel

    // MARK: - Init
    init(viewModel: DatingAppContentViewModel) {
        self.viewModel = viewModel
    }
    
    // Customise your SplashScreen here
    var body: some View {
        if isActive {
            DatingAppContentView(viewModel: viewModel)
                .preferredColorScheme(.light)
        } else {
            ZStack {
                VStack {
                    Image(AppAssets.splash)
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
