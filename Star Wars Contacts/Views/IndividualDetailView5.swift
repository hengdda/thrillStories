//
//  IndividualDetailView5.swift
//  Star Wars Contacts
//
//  Created by Mac22N on 2024-08-03.
//  Copyright © 2024 Michael Holt. All rights reserved.
//
import SwiftUI
import GoogleMobileAds
import Photos

struct IndividualDetailView5: View {
    @State private var isFlipped = false
    @EnvironmentObject var viewModel: IndividualDetailViewModel
    
    var birthDate: String {
        self.viewModel.birthdate
    }
    
    @State private var showingSettings = false
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImageName: String = "f8"
    @State private var tapped = false
        @State private var offset: CGFloat = 0
    var storyContent: String {
        self.viewModel.birthdate
    }
    
    var isForceSensitive: String {
        self.viewModel.isForceSensitive ? "YES" : "NO"
    }
    
    var affiliation: String {
        self.viewModel.affiliation.rawValue
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 0) {
                    ZStack {
                        if isFlipped {
                            backView
                        } else {
                            frontView
                        }
                    }
                    .rotation3DEffect(
                        Angle(degrees: isFlipped ? 180 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isFlipped.toggle()
                        }
                    }
              
                    
                    Spacer()
                    
                    BannerAdView()
                        .frame(width: UIScreen.main.bounds.size.width, height: 50)
                        .background(Color.gray.opacity(0.1))
                }
                .padding(.bottom, -1)
                .navigationBarHidden(true)
                .onAppear {
                    self.selectedImageName = pickRandomImage()
                }
            }
            .background(Color.customLetterBackground)
        }
    }
    
    var frontView: some View {
        
        GeometryReader { geometry in
                  let width = geometry.size.width
                  let height = geometry.size.height

                  VStack {
                      Spacer().frame(height: height * 0.05) // Top 5% space
                      
                      HStack {
                          Spacer().frame(width: width * 0.05) // Left 5% space

                          VStack {
                              Text("U")
                                  .font(.system(size: 80))
                                 .frame(width: 85, height: nil)
                                 //.background(Color.yellow) // To visualize the frame
                                  .position(x: width * 0.275, y: height * 0.275)
                                  //.frame(width: width * 0.55, height: height * 0.55, alignment: .topLeading) // 0.55 * 0.55 of the screen size
                              
                          }
                          
                          Spacer()
                      }
                      
                      HStack {
                          Spacer().frame(width: width * 0.2) // 20% space

                          VStack {
                              Spacer().frame(height: height * 0.5) // Top 50% space
                              
                              Text("Second Text Space")
                                  .frame(width: width * 0.4, height: height * 0.4, alignment: .topLeading) // 0.4 * 0.4 of the screen size

                              Spacer()
                          }
                          
                          Spacer()
                      }

                      HStack {
                          Spacer().frame(width: width * 0.7) // Left 70% space

                          VStack {
                              Spacer().frame(height: height * 0.6) // Top 60% space

                              Image("lotus")
                                  .resizable()
                                  .aspectRatio(contentMode: .fit)
                                  .frame(width: width * 0.3, height: height * 0.4, alignment: .bottomTrailing) // 0.3 * 0.4 of the screen size
                              
                              Spacer()
                          }
                          
                          Spacer()
                      }
                  }
              }
        /*
        GeometryReader { geometry in
                    ZStack {
                        // Vertical line at 10% of the screen width
                        Path { path in
                            let x = geometry.size.width * 0.1
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                        }
                        .stroke(Color.gray, lineWidth: 1)
                        
                        // Vertical line at 90% of the screen width
                        Path { path in
                            let x = geometry.size.width * 0.9
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                        }
                        .stroke(Color.gray, lineWidth: 1)
                        
                        // Horizontal line at 15% of the screen height
                        Path { path in
                            let y = geometry.size.height * 0.15
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }
                        .stroke(Color.gray, lineWidth: 1)
                        
                        // Horizontal line at 76% of the screen height
                        /*
                        Path { path in
                            let y = geometry.size.height * 0.9
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }
                        .stroke(Color.gray, lineWidth: 1)*/
                        
                        // Centered content
                        VStack {
                            Spacer().frame(height: geometry.size.height * 0.05)
                            
                            Text(viewModel.fullName)
                                .font(.system(size: 24, weight: .bold))
                                //.padding(.horizontal, 34)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .padding(.bottom, 2)
                            
                            Image("30")
                                .resizable()
                                //.aspectRatio(contentMode: .fit)
                                .frame(height: geometry.size.height * 0.3)
                                .padding(.horizontal, 36)
                            
                            ScrollView {
                                VStack(alignment: .leading) {
                                    LabelDetailRowLineByLine(value: storyContent,
                                                             leafColor: .white, // Custom color for leaf icon
                                                             textColor: .blue, // Default text color
                                                             textHighlightColor: .white )
                                    .padding()
                                }
                                .padding(.horizontal, 32)
                            }
                            Spacer()
                            // Button to go back
                            HStack(spacing: 0) {
                                Spacer()
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    HStack {
                                     
                                        Image(decorative: viewModel.getImage(for: String(viewModel.id)), scale: 1)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 20, height: 30)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                            .shadow(radius: 1)
                                            .padding(.top, 1)
                                        
                                        Text(" Go Back ")
                                            .foregroundColor(Color.white)
                                           Spacer()
                                    }
                                    //.background(Color.customGold)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.customGold, lineWidth: 2)
                                    )
                                    .shadow(radius: 10)
                                }
                                Button(action: {
                                    // Trigger animation
                                    withAnimation(.easeOut(duration: 1.0)) {
                                        tapped.toggle()
                                        offset = tapped ? -UIScreen.main.bounds.height * 0.3 : 0
                                    }

                                    // Roll left and then return to the original position
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        withAnimation(.easeIn(duration: 1.0)) {
                                            offset = 0
                                        }

                                        // Reset tapped state after the return animation completes
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            tapped = false
                                        }
                                    }
                                }) {
                                    Image(systemName: "heart.fill") // Use heart icon
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(tapped ? .customGold : .white) // Change color to gold when tapped
                                        .offset(y: offset) // Move heart up and then back down
                                        .rotationEffect(.degrees(tapped ? -30 : 0)) // Roll left effect
                                        .scaleEffect(tapped ? 1.2 : 1)
                                }
                                Spacer()
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                }*/
        .edgesIgnoringSafeArea(.all)
        //.background(Color.customOrange)
    }
    
    var backView: some View {
        ZStack {
            GeometryReader { geometry in
                Image("eightface")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .scaleEffect(x: -1, y: 1) // Optional: Flip the image horizontally
            }
            
            VStack {
                Button(action: {
                    saveImageToPhotoLibrary(imageName: "eightface")
                }) {
                    Text("Save to Photo Library")
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom, 2)
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    func saveImageToPhotoLibrary(imageName: String) {
        guard let uiImage = UIImage(named: imageName) else {
            print("Image not found")
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                print("Image saved to photo library")
            } else {
                print("Permission denied to access photo library")
            }
        }
    }
    
    func pickRandomImage() -> String {
        let imageNames = ["f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9"]
        guard let randomImage = imageNames.randomElement() else {
            return "f1"
        }
        return randomImage
    }
}
