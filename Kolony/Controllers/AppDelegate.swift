//
//  AppDelegate.swift
//  Book Buddy
//
//  Created by Kedlaya on 1/20/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit
import Firebase
import Stripe
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //For Intelligent Keyboard
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure() //Firebase
        
        //Stripe test publish key
        Stripe.setDefaultPublishableKey("pk_test_9PVPskJyQnuh45S4se8Q57ay00SETGm1Xl")
        
        //Override Stripe's default theme to customize
        //STPTheme.default().primaryBackgroundColor = UIColor(hue: 0.7667, saturation: 0, brightness: 0.25, alpha: 1.0)
        //STPTheme.default().accentColor = UIColor.white
        
        //STPTheme.default().primaryForegroundColor = UIColor.white
        //STPTheme.default().secondaryBackgroundColor = UIColor(hue: 0.8972, saturation: 0, brightness: 0.43, alpha: 1.0)
        
        //STPTheme.default().font = UIFont(name: "Avenir-Next", size: 18)
        //STPTheme.default().emphasisFont = UIFont(name: "Avenir-Next-Medium", size: 18)
        
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
}

