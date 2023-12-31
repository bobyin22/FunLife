//
//  AppDelegate.swift
//  FunLife
//
//  Created by 尹周舶 on 2023/6/14.
//

import UIKit
import FirebaseCore
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // swiftlint:disable line_length
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()                         // MARK: 加入第三方套件Firebase
        IQKeyboardManager.shared().isEnabled = true     // MARK: 加入第三方套件IQKeyboard
        
        // MARK: 這是目前存在UserDefaults的資料  然後要取得UUID
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // swiftlint:enable line_length
}
