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
import FirebaseAuth
import GoogleSignIn
import SwiftUI

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
    
    func signInWithGoogle(view: any View) {
        // Create Google Sign In configuration object.
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: view.getRootViewController()) { signResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
                    
             guard let user = signResult?.user,
                   let idToken = user.idToken else { return }
             
             let accessToken = user.accessToken
                    
             let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)

            // Use the credential to authenticate with Firebase

        }
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
