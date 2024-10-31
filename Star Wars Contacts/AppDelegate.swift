//
//  AppDelegate.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/4/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit
import Firebase
import SwiftUI
import Firebase

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("AppDelegate didFinishLaunchingWithOptions") // Add this line to debug
        // Override point for customization after application launch.
        FirebaseApp.configure()
        setUserMachineID() // Set user property on app launch
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    public func setUserMachineID() {
        let machineID = getMachineID() // Implement this function to retrieve the machine ID
        Analytics.setUserProperty(machineID, forName: "machine_id")
        print("User machine ID set to : \(machineID)")
    }
    func getMachineID() -> String {
        // Implement your logic to get the machine ID
        // Example for iOS Device UUID (not recommended for App Store due to privacy policies)
        return UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
    }

}

@available(iOS 14.0, *)
@main
struct myApp: App {
    // Register AppDelegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
           WindowGroup {
               // Initially, the SwiftUI `WindowGroup` is not needed if you use `AppCoordinator` to set up the window.
               // Remove or adjust the `WindowGroup` if `AppCoordinator` handles the view hierarchy.
               EmptyView()
           }
       }
   }

