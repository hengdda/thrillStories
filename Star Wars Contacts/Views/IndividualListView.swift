//
//  IndividualListView.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
struct IndividualListView: View {
   
    @EnvironmentObject var viewModel: IndividualListViewModel
    @State private var showingSettings = false // State variable to control showing settings
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8),count: 5) // Adjust number of columns here
    var body: some View {
           NavigationView {
            GeometryReader { geometry in
                            VStack(spacing: 0) {
                                HStack {
                                    Text("三十六计")
                                        .font(.custom("PingFangTC-Semibold", size: 16))
                                        .foregroundColor(Color.customChineseGray)
                                    Spacer()
                                    Button(action: {
                                        self.showingSettings.toggle()
                                    }) {
                                        Image(systemName: "gearshape")
                                            .imageScale(.large)
                                            .foregroundColor(Color
                                                .customChineseTaohong)
                                    }
                                }
                                .frame(height: geometry.size.height * 0.1)
                                .background(Color.white)
                                .padding(.horizontal)
                                
                                ScrollView(.horizontal) {
                                    LazyHStack(spacing: 1) {
                                        ForEach(viewModel.items, id: \.id) { item in
                                            VStack(spacing: 3) {
                                                IndividualRow(image: self.viewModel.getImage(for: item), name: "")
                                                    .onTapGesture {
                                                        self.viewModel.selectItem(item: item)
                                                    }
                                                    .onAppear {
                                                        self.viewModel.fetchImageIfNeeded(item: item)
                                                    }
                                                    .frame(maxWidth: 40, maxHeight: geometry.size.height * 0.1, alignment: .top)
                                                    .background(Color.blue.opacity(0.1))
                                                
                                                VStack(spacing: 0) {
                                                    ForEach(Array(item.fullName), id: \.self) { character in
                                                        Text(String(character))
                                                            .font(.custom("HYi3gf", size: 15))
                                                            .foregroundColor(Color.black)
                                                            .onTapGesture {
                                                                self.viewModel.selectItem(item: item)
                                                            }
                                                    }
                                                }
                                                .frame(maxWidth: 45, maxHeight: geometry.size.height * 0.7, alignment: .top)
                                                .background(Color.yellow.opacity(0.009))
                                            }
                                            .frame(maxWidth: 45, maxHeight: geometry.size.height * 0.88, alignment: .top)
                                            .padding()
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(8)
                                        }
                                    }
                                    .padding(.vertical)
                                }
                                .frame(height: geometry.size.height * 0.8)
                                
                                BannerAdView()
                                    .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                                    .background(Color.yellow.opacity(0.009))
                            }
                            .background(
                                Image("traditional_pattern")
                                    .resizable()
                                    .scaledToFill()
                                    //.edgesIgnoringSafeArea(.all)
                                    .opacity(0.3)
                            )
                        }
               .navigationBarHidden(true)
               .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
           .navigationViewStyle(.stack) // Add this line to
    }
}



