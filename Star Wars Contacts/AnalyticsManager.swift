//
//  AnalyticsManager.swift
//  Star Wars Contacts
//
//  Created by Mac22N on 2024-07-18.
//  Copyright © 2024 Michael Holt. All rights reserved.

import SwiftUI
import FirebaseAnalytics
final class AnalyticsManager {
   
    private init(){}
    static let shared = AnalyticsManager()
    
    public func logEventFirebase(){
        let machineID = getMachineID()
        Analytics.logEvent("MyAd_click", parameters: [
              AnalyticsParameterItemID: "ad_id", // Replace with your ad ID
              AnalyticsParameterItemName: machineID, // Replace with your ad name
              AnalyticsParameterContentType: "ad_shown_\(machineID)",
          ])
      
        print("logevent is up!")
    }
    func getMachineID() -> String {
        // Example machine ID (UUID) for demonstration
        let machineID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        
        // Get the last 6 characters of the machineID followed by '-'
        let lastCharacters = String(machineID.suffix(6)) + "-"
        
        return lastCharacters
    }
  
}
