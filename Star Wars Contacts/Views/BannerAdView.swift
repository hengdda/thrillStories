//
//  BannerAdView.swift
//  Star Wars Contacts
//
//  Created by Mac22N on 2024-07-17.
//  Copyright © 2024 Michael Holt. All rights reserved.
//
import SwiftUI
import GoogleMobileAds
import GoogleAnalytics
struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
          let bannerView =  GADBannerView()
           //bannerView.adUnitID   = "ca-app-pub-7921041501220320/4720774093"
        //for test purpose: ca-app-pub-3940256099942544/2435281174
          bannerView.adUnitID   = "ca-app-pub-8031803597671655/7625921807"
           bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
           bannerView.backgroundColor = .secondarySystemBackground
           bannerView.load(GADRequest())
        AnalyticsManager.shared.logEventFirebase()
           return bannerView
     }
       func updateUIView(_ uiView: GADBannerView, context: Context) {}
}
