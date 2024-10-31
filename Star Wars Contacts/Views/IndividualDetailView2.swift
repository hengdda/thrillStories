import SwiftUI
import GoogleMobileAds
import Photos

struct IndividualDetailView2: View {
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
                        if !isFlipped {
                            QuestionViewNew(strategyId: String(viewModel.id)) {
                                withAnimation {
                                   isFlipped.toggle()
                                }
                            }.scaleEffect(x: -1, y: 1)
                        } else {
                            frontView.scaleEffect(x: -1, y: 1)
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
                    BannerAdView()
                        .frame(width: UIScreen.main.bounds.size.width, height: 50)
                        //.background(Color.gray.opacity(0.1))
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
        VStack {
            ZStack {
                    Image("lotus")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.main.bounds.height * 0.3)
                        .clipped()
                        .cornerRadius(20)
                        .opacity(0.4) // Set opacity to 20%
                        .padding(.top, 10)
                Spacer(minLength: 1)
                    Image("lotus") // Replace "anotherImage" with the name of your second image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:UIScreen.main.bounds.width * 0.7 , height:  UIScreen.main.bounds.height * 0.37 ) // Make the second image smaller
                        //.offset(y: UIScreen.main.bounds.height * 0.05) // Adjust the position of the second image
                        .clipped()
                        .cornerRadius(15)
                }
            // Title at the top
           
            Spacer(minLength: 1)
            Text(viewModel.fullName)
                .font(.system(size: 24, weight: .bold))
                .padding(.horizontal, 15)
                .foregroundColor(Color.customZanglan)
                .multilineTextAlignment(.center)
                .padding(.vertical, -1)
 
            // Scroll view in the middle at the bottom
            ScrollView {
                VStack(alignment: .leading) {
                    LabelDetailRowLineByLine(value: storyContent,
                                             leafColor: .customZanglan, // Custom color for leaf icon
                                             textColor: .customChineseBlack, // Default text color
                                             textHighlightColor: .customBlue, fontSize: 16)
                        .padding()
                }
                .padding(.horizontal, 2)
            }
            .frame(width: UIScreen.main.bounds.height * 0.6, height: UIScreen.main.bounds.height * 0.3)
            // Image taking 40% of the screen
            Spacer(minLength: 1)
            // Button to go back
            HStack(spacing: 0) {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Spacer()
                        Image(decorative: viewModel.getImage(for: String(viewModel.id)), scale: 1)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 30)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 1)
                            .padding(.top, 1)
                        
                        Text(" Go Back ")
                            .foregroundColor(Color.customZanglan)
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
                Spacer()
                Button(action: {
                               // Trigger animation
                               withAnimation(.easeOut(duration: 1.0)) {
                                   tapped.toggle()
                                   offset = -UIScreen.main.bounds.height * 0.3
                                   //offset = tapped ? -UIScreen.main.bounds.height * 0.3 : 0
                                   // Return heart to original position after 1 second
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                      withAnimation(.easeIn(duration: 1.0)) {
                                                          offset = 0
                                                      }

                                                      // Reset tapped state after the return animation completes
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                          tapped = true
                                                      }
                                                  }
                               }
                           }) {
                               Image(systemName: "heart.fill") // Use heart icon
                                   .resizable()
                                                       .scaledToFit()
                                                       .frame(width: 35, height: 35)
                                                       .foregroundColor(tapped ? .customGold : .customZanglan) // Change color to gold when tapped
                                                       .offset(y: offset) // Move heart up and then back down
                                                       .rotationEffect(.degrees(tapped ? 360 : 0)) // Optional rotation effect
                                                       .scaleEffect(tapped ? 1.2 : 1)
                           }
                Spacer()
            }
            .padding(.horizontal, 15)
            .frame(width: UIScreen.main.bounds.height * 0.6)

        }
        //.background(Color.customChineseGray.opacity(0.7))
    }
    
    var backView: some View {
        ZStack {
            GeometryReader { geometry in
                Image("eightface")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    //.scaleEffect(x: -1, y: 1) // Optional: Flip the image horizontally
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
            return "f1"
        }
        return randomImage
    }
}


