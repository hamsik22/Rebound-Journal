//
//  AppDelegate.swift
//  Rebound Journal
//
//  Created by hyunho lee on 12/8/24.
//

import UIKit
import Foundation
import UserNotifications
import AppTrackingTransparency

///// App Delegate file in SwiftUI
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        UITextView.appearance().backgroundColor = .clear
//        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
//        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { _ in self.requestIDFA() }
//        return true
//    }
//    
//    /// Display the App Tracking Transparency authorization request for accessing the IDFA
//    func requestIDFA() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            ATTrackingManager.requestTrackingAuthorization { _ in }
//        }
//    }
//}
//
//// MARK: - Handle notification received by application
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.sound, .list, .banner])
//    }
//}
