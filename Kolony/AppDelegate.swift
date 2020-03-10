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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //var window: UIWindow? //Maybe needed for FIrebase?; was in FIrebase initialization code given by Google
    static let stripePublishableKey = "pk_test_9PVPskJyQnuh45S4se8Q57ay00SETGm1Xl"
    
    //Base URL of App
    static let baseURLString = "YOUR_BASE_URL_STRING"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure() //Firebase
        
        //Strip test publish key
        Stripe.setDefaultPublishableKey("pk_test_9PVPskJyQnuh45S4se8Q57ay00SETGm1Xl")
        
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

