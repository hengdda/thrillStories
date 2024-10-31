//
//  IndividualDetailView.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

import GoogleMobileAds

import Photos

import GoogleMobileAds

struct IndividualDetailView: View {
    @State private var isFlipped = false
    @EnvironmentObject var viewModel: IndividualDetailViewModel
    @State private var tapped = false
    @State private var offset: CGFloat = 0
    var birthDate: String {
        self.viewModel.birthdate
    }
    @State private var showingSettings = false
    @Environment(\.presentationMode) var presentationMode // Add this line to get the presentation mode
    // State to store the selected image
    @State private var selectedImageName: String = "f8"
    var storyContent: String {
        self.viewModel.birthdate
        //DateFormatters.displayDate.string(from: self.viewModel.birthdate)
    }
    var isForceSensitive: String {
        self.viewModel.isForceSensitive ? "YES" : "NO"
    }
    var affiliation: String {
        self.viewModel.affiliation.rawValue
    }

    var body: some View {
        NavigationView {

            ZStack {
                Image("darkgray")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 0){
                ZStack {
                   
                    
                           if isFlipped {
                                       //backView
                               QuestionViewNew(strategyId: String(viewModel.id)) {
                                   withAnimation {
                                                      isFlipped.toggle()
                                                  }
                               }.scaleEffect(x: -1, y: 1)
                           } else {
                                       frontView
                              }
                           }.rotation3DEffect(
                            Angle(degrees: isFlipped ? 180 : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                isFlipped.toggle()
                            }
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
                           self.selectedImageName = pickRandomImage() // Set the image name when the view appears
                       }
        }//.background(Color.customLetterBackground)
  
    }
    var frontView: some View {
        ZStack {
            GeometryReader { geometry in
               // Clips any part of the image that extends beyond the frame
                // Background image
                Image("Greybackground") // Replace with your image name
                 .resizable()
                  .scaledToFill()
                  .frame(width: geometry.size.width, height: geometry.size.height)
                VStack {
                    Spacer().frame(height: geometry.size.height * 0.15)
                    Text(viewModel.fullName)
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                       // .padding(.bottom, 2)
                    ScrollView {
                        VStack(alignment: .leading) {
                            LabelDetailRowLineByLine(value: storyContent,
                                                     leafColor: .customGold, // Custom color for leaf icon
                                                     textColor: .customGold, // Default text color
                                                       textHighlightColor: .customBlue, fontSize: 16).padding()
                  
                        }
                    }
                    .frame(width: geometry.size.width * 0.89, height: geometry.size.height * 0.5) // Adjust size relative to image
                    .padding(5)
                    //button go back
                    HStack{
                        Spacer()
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss() // Go back to the last page
                        }) {
                                // Image inside the button
                            /*
                            Image(decorative: viewModel.getImage(for: String(viewModel.id)), scale: 1)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 1)
                                .padding(.top, 1)*/
                            
                            Text(" Return ")
                                .foregroundColor(Color.gray)
      
                        }
                       
                        Button(action: {
                            // Trigger animation
                            withAnimation(.easeOut(duration: 1.0)) {
                                tapped.toggle()
                                offset = -UIScreen.main.bounds.height * 0.3

                                // Move the heart up initially
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        offset = -UIScreen.main.bounds.height * 0.2
                                    }
                                    
                                    // Move the heart down a little
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            offset = -UIScreen.main.bounds.height * 0.25
                                        }
                                        
                                        // Move the heart up a little
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                offset = -UIScreen.main.bounds.height * 0.22
                                            }
                                            
                                            // Move the heart back down
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                    offset = 0
                                                }
                                                
                                                // Reset tapped state after the return animation completes
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    tapped = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }) {
                                       Image(systemName: "heart") // Use heart icon
                                           .resizable()
                                                               .scaledToFit()
                                                               .frame(width: 30, height: 30)
                                                               .foregroundColor(tapped ? .customChineseRose: .gray) // Change color to gold when tapped
                                                               .offset(y: offset) // Move heart up and then back down
                                                               .rotationEffect(.degrees(tapped ? 360 : 0)) // Optional rotation effect
                                                               .scaleEffect(tapped ? 1.2 : 1)
                                   }
                        Spacer()
                    }
                    .frame(width: geometry.size.width * 0.8)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.65) // Ensure VStack fits within GeometryReader
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.9) // Adjust size to desired width and height
        }
        .background(Color.customLetterBackground)
      }
    var backView: some View {
        ZStack {
            GeometryReader { geometry in
                Text(viewModel.fullName)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Image("eightface")
                    .resizable() // Make sure the image is resizable
                    .scaledToFill() // Scale the image to fill the entire view
                    .frame(width: geometry.size.width, height: geometry.size.height) // Fit the image to the size of the geometry
                    .clipped() // Ensure the image is clipped to the bounds of the frame
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
        }
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
            return "f1" // Fallback image name if array is empty
        }
        return randomImage
       }

}

#if DEBUG
struct IndividualDetailView_Previews : PreviewProvider {
    static var model = PreviewDatabase.individuals[0]
    static var viewModel = IndividualDetailViewModel(model: model)
    static var previews: some View {
        return IndividualDetailView()
            .environmentObject(viewModel)
    }
}
#endif
