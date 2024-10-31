//
//  individualListViewNew.swift
//  Star Wars Contacts
//
//  Created by Mac22N on 2024-08-22.
//  Copyright © 2024 Michael Holt. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct IndividualListViewNew: View {
    //
    //  IndividualListView.swift
    //  Star Wars Contacts
    //
    //  Created by Michael Holt on 6/5/19.
    //  Copyright © 2019 Michael Holt. All rights reserved.
    //
        @EnvironmentObject var viewModel: IndividualListViewModel
        @State private var showingSettings = false // State variable to control showing settings
        @State private var showingSheet = true // Automatically show the sheet when the view appears
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8),
                            count: 5) // Adjust number of columns here
    var body: some View {
                NavigationView {
                    ZStack {
                        // Full-screen image background
                        Image("sunbackground")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)

                        // Sheet that appears over the image
                        VStack {
                            VStack{
                                Spacer()
                                Text("Thrive Stories ")
                                    .font(.system(size: 40, weight: .bold))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                                    .foregroundColor(.white)
                                    .padding(.top, 25)
                                    .padding(.trailing, 15)
                                    .padding(.bottom, -1)
        
                                Button(action: {
                                               // Action to show SettingsView
                                        showingSettings.toggle()
                                           }) {
                                               Text("Settings")
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(-90)) // Rotate text by -90 degrees
                                   .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading) // Center text in the VStack
                                     }.sheet(isPresented: $showingSettings) {
                                           SettingsView().frame(height: UIScreen.main.bounds.height * 0.3) // Custom height for the sheet // Replace with your actual Settings view
                                     }
                                Spacer()
                            }
                            Spacer()
                            
                            if showingSheet {
                                sheetView(viewModel: viewModel)
                                    .frame(maxWidth: .infinity) // Ensure full width
                                     .frame(height: UIScreen.main.bounds.height * 0.6) // Custom height for the sheet
                                     .background(Color.customChineseBlack.opacity(0.9))
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                     .padding(.top, 50) // Padding to position the sheet in the middle
                                     .transition(.move(edge: .bottom))
                                    .animation(.easeInOut(duration: 2), value: showingSheet)
                            }
                            BannerAdView()
                                .frame(height: 50)
                                .background(Color.yellow.opacity(0.009))
                        }
                        .onAppear {
                           //self.viewModel.fetchImageIfNeeded(item: item)
                            // Delay to show the sheet after the image has appeared
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.showingSheet = true
                            }
                        }
                    }
                    .toolbar {
                        // Empty toolbar to hide it
                    }
                    //.navigationBarHidden(true)
                }
                .navigationViewStyle(.stack)
    }
    
    struct sheetView: View {
        @ObservedObject var viewModel: IndividualListViewModel // Use @ObservedObject to get the view model
        var body: some View {
                  VStack(spacing: 0) {
                      Spacer()
                      HStack{
                          Text(" Index").foregroundColor(Color.white)
                          Spacer()
                      }
                      // Add ScrollView to make LazyVGrid scrollable
                      ScrollView {
                          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                              ForEach(viewModel.items, id: \.id) { item in
                                  VStack(spacing: 0) {
                                      // Image placed inside a square frame
                                      IndividualRowNew(image: self.viewModel.getImage(for: item))
                                          .scaledToFit() // Make sure the image scales correctly to fit within the square
                                          .frame(width: 90, height: 90) // Fixed frame to make the image a square
                                          .background(Color.customChineseBlack.opacity(0.68))
                                          .cornerRadius(8)
                                          .onTapGesture {
                                              self.viewModel.selectItem(item: item)
                                          }
                                          .onAppear {
                                              self.viewModel.fetchImageIfNeeded(item: item)
                                          }
                                      
                                      // Display    number below the image
                                      Text("S \(item.id)") // Replace 'item.number' with the appropriate property from your model
                                          .font(.caption)
                                          .foregroundColor(.white)
                                  }
                                  //.padding()
                                  .background(Color.customTreeBlack.opacity(0.089))
                                  .cornerRadius(8)
                              }
                          }
                          .padding()
                      }
                    }
                  .statusBar(hidden: true) // Hides the status bar
                   // .navigationBarTitle("Settings")
    }
        struct CellView: View {
            let index: Int

            var body: some View {
                Text("Cell \(index + 1)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                    //.padding(4)
            }
        }
            func getMachineID() -> String {
                // Example machine ID (UUID) for demonstration
                let machineID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
                
                // Get the last 6 characters of the machineID followed by '-'
                let lastCharacters = String(machineID.suffix(6)) + "-"
                
                return lastCharacters
            }
        }
    

    }
                      

 



