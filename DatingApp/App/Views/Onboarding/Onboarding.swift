//
//  Onboarding.swift
//  DatingApp
//
//  Created by LongNH8 on 13/5/25.
//

import SwiftUI

// Model for onboarding data
struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}

// Main Onboarding View
struct OnboardingView: View {
    @EnvironmentObject var viewModel: DatingAppContentViewModel
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(imageName: AppAssets.appIcon, title: "Welcome", description: "This is the first onboarding screen."),
        OnboardingPage(imageName: AppAssets.appIcon, title: "Discover", description: "Explore features of the app."),
        OnboardingPage(imageName: AppAssets.appIcon, title: "Get Started", description: "Let’s get you set up!")
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .animation(.easeInOut, value: currentPage)
            
            Button(action: {
                if currentPage < pages.count - 1 {
                    currentPage += 1
                } else {
                    // TODO: Handle when onboarding is done
                    print("Onboarding Finished")
                    viewModel.completeOnboarding()
                }
            }) {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top)
        }
    }
}

// View for each onboarding page
struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 250)

            Text(page.title)
                .font(.title)
                .bold()

            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
    }
}

// Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
