import SwiftUI
import GoogleMobileAds
import Photos

struct IndividualDetailView3: View {
    @State private var isFlipped = false
    @EnvironmentObject var viewModel: IndividualDetailViewModel
    
    var birthDate: String {
        self.viewModel.birthdate
    }
    @State private var interstitial: GADInterstitialAd?
    @State private var showingSettings = false
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImageName: String = "f8"
    @State private var tapped = false
    @State private var rotation: Double = 0
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    @State private var fontSizeinView: CGFloat = 16
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
                            }
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
                    Spacer()
                    BannerAdView()
                          .frame(width: UIScreen.main.bounds.size.width, height: 50)
                }
                .padding(.bottom, -1)
                .navigationBarHidden(true)
                .onAppear {
                    self.selectedImageName = pickRandomImage()
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        fontSizeinView = 33 // Set fontSize to 27 if running on an iPad
                     }
                    loadInterstitialAd()
                }
            }
            //.background(isFlipped ? Color.customChineseBlack : Color.customChineseRose.opacity(0.7))
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
            .background(Color.customChineseRose.opacity(0.7))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var frontView: some View {
        ZStack {
            //  Spacer(minLength: 1)
            // Title at the top
          
          
            VStack{
                //Spacer(minLength: 6)
                Text("     ")
                ScrollView {
                Text(viewModel.fullName)
                    .font(.system(size: fontSizeinView * 2 - 4, weight: .bold))
                    .padding(.horizontal, 5)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                Spacer(minLength: 3)
                
                Image("7")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.3)
                                .clipped()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 10) // White border with 10 points width
                                )
                                .cornerRadius(20)
                    HStack(spacing: 16) {
                        Button("A") {
                            fontSizeinView = 16  // Set to default size
                        }.foregroundColor(.white)    // Set the text color to white
                                .font(.system(size: 16))
                                .frame(height: 40) // Set the same fixed height
                        Button("A") {
                            fontSizeinView = 21  // Set to a bigger size
                        }.foregroundColor(.white)    // Set the text color to white
                            .font(.system(size: 21))
                            .frame(height: 40) // Set the same fixed height
                        Button("A") {
                            fontSizeinView = 27 // Set to an extra bigger size
                        }.foregroundColor(.white)    // Set the text color to white
                            .font(.system(size: 27))
                            .frame(height: 40) // Set the same fixed height
                        Button("A") {
                            fontSizeinView = 33 // Set to an extra bigger size
                        }.foregroundColor(.white)    // Set the text color to white
                            .font(.system(size: 33))
                            .frame(height: 40) // Set the same fixed height
                        Button("A") {
                            fontSizeinView = 38 // Set to an extra bigger size
                        }.foregroundColor(.white)    // Set the text color to white
                            .font(.system(size: 38))
                            .frame(height: 40) // Set the same fixed height
                    }
                    VStack(alignment: .leading) {
                        LabelDetailRowLineByLine(value: storyContent,
                                                 leafColor: .white, // Custom color for leaf icon
                                                 textColor: .white, // Default text color
                                                  textHighlightColor: .customChineseBlack ,
                                                 fontSize:fontSizeinView )
                    }
                    .padding(.horizontal, 7)
                }
                .frame(height: UIScreen.main.bounds.height * 0.86)
                Spacer(minLength: 5)
                // Button to go back
                HStack(spacing: 0) {
                    Spacer()
                    Button(action: {
                        showInterstitialAd()
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
                            
                            Text(" Return ")
                                .foregroundColor(Color.white)
                                .font(.system(size: fontSizeinView))
                               Spacer()
                        }
                        //.background(Color.customGold)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.customChineseGao, lineWidth: 2)
                        )
                        .padding(.horizontal, 4)
                        .shadow(radius: 10)
                    }
                    Spacer()
                    Button(action: {
                                // Trigger animation
                                withAnimation(.easeOut(duration: 0.5)) {
                                    tapped.toggle()
                                    offsetX = -UIScreen.main.bounds.width * 0.4 // Move left
                                    offsetY = -UIScreen.main.bounds.height * 0.4 // Move up
                                   // rotation = 360 // Rotate the heart
                                }
                                // Sequence to return the heart to its original position and reset state
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeIn(duration: 0.5)) {
                                        offsetX = UIScreen.main.bounds.width * 0.3 // Move right
                                        offsetY = UIScreen.main.bounds.height * 0.3 // Move down
                                       // rotation = 0 // Reset rotation
                                        tapped = true // Reset tapped state
                                    }
                                    
                                    // Reset offset and rotation to original values
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                                        offsetX = 0
                                        offsetY = 0
                                    }
                                }
                            }) {
                                Image(systemName: "heart.fill") // Use heart icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 33, height: 33)
                                    .foregroundColor(tapped ? .customChineseRose : .customChineseGao) // Change color to gold when tapped
                                    .offset(x: offsetX, y: offsetY) // Move heart up and then back down
                                  //  .rotationEffect(.degrees(rotation)) // Rotate the heart
                                    .scaleEffect(tapped ? 1.2 : 1) // Optional scale effect
                                    .animation(.easeIn(duration: 0.5)) // Animate the color change
                            }
                    Spacer()
                }
                .padding(.horizontal,7)
            }
           
            // Scroll view in the middle at the bottom
            // Image taking 40% of the screen
            Spacer(minLength: 3)

        }.background(Color.customPinkBackground) // Hides the navigation bar completely
        //.frame(height: UIScreen.main.bounds.height * 0.9)
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
        }
    }
    // Function to load the interstitial ad
    func loadInterstitialAd() {
        let request = GADRequest()
        // Replace with your actual ad unit ID
        let adUnitID = "ca-app-pub-7921041501220320/5924447033"
        // my adid: ca-app-pub-7921041501220320/5924447033
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) {  ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            print("Interstitial ad loaded")
            interstitial = ad
        }
    }
    func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
        // Function to show the interstitial ad
    func showInterstitialAd() {
        if let interstitial = interstitial {
            if let topController = topViewController() {
                interstitial.present(fromRootViewController: topController)
                print("interstitial ad show")
            }
        } else {
            print("interstitial Ad wasn't ready")
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
