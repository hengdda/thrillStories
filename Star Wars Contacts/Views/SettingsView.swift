//
//  SettingsView.swift
//  Star Wars Contacts
//
//  Created by Mac22N on 2024-07-18.
//  Copyright © 2024 Michael Holt. All rights reserved.
//

import SwiftUI
import Network

struct SettingsView: View {

    @State private var isConnected = true
    @State private var showAlert = false
    private let monitor = NWPathMonitor()
    var body: some View {
        ZStack {
            // Full-screen image background
            Image("settingsimg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
               
            VStack{
                Spacer()
                /*
                VStack {
                          if isConnected {
                              Text("You are connected to the network.")
                          } else {
                              Text("No network connection.")
                              Button(action: requestLocalNetworkPermission) {
                                  Text("Allow Local Network Access")
                                      .padding()
                                      .background(Color.blue)
                                      .foregroundColor(.white)
                                      .cornerRadius(8)
                              }
                              .alert(isPresented: $showAlert) {
                                  Alert(
                                      title: Text("Local Network Permission Required"),
                                      message: Text("Please allow access to the local network for better connectivity."),
                                      primaryButton: .default(Text("Settings"), action: openAppSettings),
                                      secondaryButton: .cancel()
                                  )
                              }
                          }
                      }
                      .onAppear {
                          startMonitoring()
                      }
                Button(action: requestLocalNetworkPermission) {
                                    Text("Allow Local Network Access")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Local Network Permission Required"),
                                        message: Text("Please allow access to the local network for better connectivity."),
                                        primaryButton: .default(Text("Settings"), action: openAppSettings),
                                        secondaryButton: .cancel()
                                    )
                                }
                 */
                Text("Your account ID is: \(getMachineID())")
                    .foregroundColor(.customChineseRose)
            }
                       
        }
            .navigationBarTitle("Settings")

    }
    private func startMonitoring() {
          monitor.pathUpdateHandler = { path in
              DispatchQueue.main.async {
                  self.isConnected = (path.status == .satisfied)
                  if !self.isConnected {
                      self.showAlert = true
                  }
              }
          }
          let queue = DispatchQueue(label: "NetworkMonitor")
          monitor.start(queue: queue)
      }
    private func openAppSettings() {
          guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
          if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
      }
    private func requestLocalNetworkPermission() {
           // Attempt to connect to a local network resource (e.g., UDP broadcast)
           // to trigger the local network permission prompt.

           // Note: iOS will automatically prompt the user for local network permission
           // when the app tries to access the local network for the first time.
           showAlert = true
       }
    func getMachineID() -> String {
        // Example machine ID (UUID) for demonstration
        let machineID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        
        // Get the last 6 characters of the machineID followed by '-'
        let lastCharacters = String(machineID.suffix(6)) + "-"
        
        return lastCharacters
    }
}
class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    @Published var isConnected: Bool = false

    init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitor")
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
#Preview {
    SettingsView()
}
