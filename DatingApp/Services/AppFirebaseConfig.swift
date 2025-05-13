//
//  AppFirebaseConfig.swift
//  DatingApp
//
//  Created by LongNH8 on 13/5/25.
//

import FirebaseCore
import UserNotifications
import Combine
import FirebaseMessaging
import FirebaseCrashlytics
import GoogleSignIn

class AppFirebaseConfig: NSObject, MessagingDelegate {
    static let shared = AppFirebaseConfig()
    var fcmToken: String?
    private override init() {super.init()}
    
    func config(with application: UIApplication) {
        self.configFirebase()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }
    
    private func configFirebase() {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") ?? ""
        guard let firbaseOptions = FirebaseOptions.init(contentsOfFile: filePath) else {
            return
        }
        FirebaseApp.configure(options: firbaseOptions)
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
    }
    
    func registerForRemoteNotification(_ application: UIApplication) {
        DispatchQueue.main.async {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.requestAuthorization( options: [.alert, .badge, .sound], completionHandler: {_, _ in })
            application.registerForRemoteNotifications()
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("================> FCM token: \(fcmToken ?? "")")
        self.fcmToken = fcmToken
    }
    
    func signInWithGoogle() {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("No root view controller")
            return
        }

        let config = GIDConfiguration(clientID: FirebaseApp.app()?.options.clientID ?? "")
        
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { [weak self] result, error in
//            if let error = error {
//                print("Google Sign-In error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let user = result else {
//                print("No Google user")
//                return
//            }
//
//            guard let idToken = user.authentication.idToken else { return }
//            let accessToken = user.authentication.accessToken
//
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//
//            Auth.auth().signIn(with: credential) { authResult, error in
//                if let error = error {
//                    print("Firebase auth error: \(error.localizedDescription)")
//                    return
//                }
//
//                // User successfully signed in
//                DispatchQueue.main.async {
//                    self?.isLoggedIn = true
//                }
//            }
//        }
    }
}

extension AppFirebaseConfig: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent")
        print(notification)
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound])
        } else {
            completionHandler([.alert, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive")
        print(response)
    }
}
