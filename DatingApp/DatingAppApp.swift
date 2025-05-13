//
//  DatingAppApp.swift
//  DatingApp
//
//  Created by LongNH8 on 13/5/25.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import netfox

@main
// MARK: - AppDelegate
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = SceneDelegate.self
        }
        return configuration
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppFirebaseConfig.shared.config(with: application)
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        // If not handled by this app, return false.
        return false
    }
}

// MARK: - SceneDelegate
class SceneDelegate: NSObject, ObservableObject, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // MARK: - Setup Window
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        // Init navigation
        let navigationRoot = Navigation(window: window)
        navigation = navigationRoot
        // Setup rootview
        let viewModel = DatingAppContentViewModel()
        let contentView = SplashScreen().environmentObject(viewModel)
        let rootView = UIHostingController(rootView: contentView.environmentObject(navigationRoot))
        window.rootViewController = rootView
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    
    }
}

