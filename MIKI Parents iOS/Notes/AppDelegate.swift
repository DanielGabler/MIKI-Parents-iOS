//
//  AppDelegate.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 06.10.24.
//


import UIKit
import Firebase
import FirebaseMessaging


class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        // Push Notifications registrieren
        registerForPushNotifications(application: application)

        // Messaging Delegate setzen
        Messaging.messaging().delegate = self

        return true
    }

    func registerForPushNotifications(application: UIApplication) {
        // iOS fragt den Benutzer um Erlaubnis, Benachrichtigungen zu empfangen
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted: \(granted)")
        }
        application.registerForRemoteNotifications()
    }

    // FCM Token erhalten
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM token: \(String(describing: fcmToken))")
    }
}

