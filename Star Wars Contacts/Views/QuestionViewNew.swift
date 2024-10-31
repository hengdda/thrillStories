//
//  QuestionViewNew.swift
//  Star Wars Contacts
//
//  Created by Mac22N on 2024-08-23.
//  Copyright © 2024 Michael Holt. All rights reserved.
//

import SwiftUI
import Foundation
import FirebaseStorage
struct QuestionViewNew: View {
    @State private var currentStrategyIndex = 0
    @State private var currentQuestionIndex = 0
    @State private var answeredQuestions = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var showResult = false
    @State private var showTryAgainMessage = false // New state variable to show "Try for another time" message
    @State private var questions: [Question] = []
    @State private var fontSize: CGFloat = 16  // New state variable for font size
    @State private var showEndOfQuestionsMessage: Bool = false
    @State private var showToast = false
    @State private var toastMessage = ""
    var strategyId: String
    var onTapBlankSpace: () -> Void  // Closure to be called on tap

    var body: some View {
        GeometryReader { geometry in  // geometry is now correctly scoped
            VStack {   
               if questions.isEmpty {
                    VStack {
                        Spacer()
                        Image("21")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width * 0.24, height: geometry.size.width * 0.24) // Use same width and height for a circle
                            .clipShape(Circle()) // Clip the image to a circle
                        Spacer()
                        ProgressView() // Displays a default circular spinner
                                        .progressViewStyle(CircularProgressViewStyle()) // Optional: Customize the style
                        Text("Loading questions...")
                           
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .onTapGesture {
                        onTapBlankSpace() // Call the closure when tapped
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.customBlack.opacity(0.85))
                    //.edgesIgnoringSafeArea(.all)
                } else {
                    VStack {
                        Spacer()
                        Image("21")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width * 0.24, height: geometry.size.width * 0.24) // Use same width and height for a circle
                            .clipShape(Circle()) // Clip the image to a circle
                            .padding(.bottom,-1)
                        Spacer()
                        HStack(spacing: 16) {
                            Button("A") {
                                fontSize = 16  // Set to default size
                            }.foregroundColor(.white)    // Set the text color to white
                                .font(.system(size: 16))
                                .frame(height: 40) // Set the same fixed height
                            Button("A") {
                                fontSize = 21  // Set to a bigger size
                            }.foregroundColor(.white)    // Set the text color to white
                                .font(.system(size: 21))
                                .frame(height: 40) // Set the same fixed height
                            Button("A") {
                                fontSize = 27 // Set to an extra bigger size
                            }.foregroundColor(.white)    // Set the text color to white
                                .font(.system(size: 27))
                                .frame(height: 40) // Set the same fixed height
                            Button("A") {
                                fontSize = 33 // Set to an extra bigger size
                            }.foregroundColor(.white)    // Set the text color to white
                                .font(.system(size: 33))
                                .frame(height: 40) // Set the same fixed height
                            Button("A") {
                                fontSize = 38 // Set to an extra bigger size
                            }.foregroundColor(.white)    // Set the text color to white
                                .font(.system(size: 38))
                                .frame(height: 40) // Set the same fixed height
                        }
                        // Status bar showing how many questions are answered
                        Text("Questions answered: \(answeredQuestions)/\(questions.count)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(Color.customClaireYellow)
                        // Display the current question
                        ScrollView {
                            //content of the question
                            Text(questions[currentQuestionIndex].text)
                                .font(.system(size: fontSize)) // Adjust the size as needed
                                .foregroundColor(.customClaireYellow)
                                .padding(.leading, 15)
                                .padding(.trailing, 15)
                            // Same height as index
                            // answered correct or not
                            if showResult {
                                if showTryAgainMessage {
                                    // Show "Try for another time" message when the answer is incorrect
                                    Text("Try for another time")
                                        .font(.system(size: fontSize))
                                        .foregroundColor(.customPink)
                                        .padding()
                                } else {
                                    Text("Great!!")
                                        .font(.system(size: fontSize))
                                        .foregroundColor(.customPink)
                                        .padding()
                                }
                            }else{
                                Text("   ")
                                    .font(.system(size: fontSize))
                                    .foregroundColor(.customPink)
                                    .padding()
                            }
                            Spacer()
                            // Display the 4 answer options
                            ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                                Button(action: {
                                    selectedAnswerIndex = index
                                    showResult = true
                                    checkAnswer(index: index)
                                    // Set toast message and show the //toast
                                    //   toastMessage = "abc!"
                                    toastMessage = questions[currentQuestionIndex].options[index]
                                    showToast = true
                                    
                                    // Hide the toast after 2 seconds
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        showToast = false
                                    }
                                }) {
                                    HStack {
                                        Text("\(index)") // Convert to String if it's not already
                                            .font(.system(size: fontSize ))
                                            .frame(maxWidth: geometry.size.width * 0.1, maxHeight: 40)
                                            .background(answerBackColor(for: index))
                                            .foregroundColor(.customChineseGray)
                                            .clipShape(RoundedCornersShape(radius: 8, corners: [.topLeft, .bottomLeft])) // Apply custom shape
                                        //.padding(.trailing, 3)
                                        // Use ScrollView to allow text scrolling
                                        // Use ScrollView to allow text scrolling
                                        Text(questions[currentQuestionIndex].options[index])
                                            .padding()
                                            .font(.system(size: fontSize))
                                            .frame(maxWidth: geometry.size.width * 0.7,  maxHeight:40) // Fixed width, height not constrained
                                            .background(answerBackgroundColor(for: index))
                                            .foregroundColor(Color.customClaireYellow)
                                            .cornerRadius(8, corners: [.topRight, .bottomRight]) // Rounded corners on the right side
                                            .clipShape(RightHalfRoundedRectangle()) // Clip shape to have a straight left edge
                                            .lineLimit(1) // Allow multiple lines
                                    }
                                }
                                .disabled(showResult)
                            }
                            .padding(5)
                            Spacer()
                            if showResult {
                                Button("Next Question") {
                                    nextQuestion()
                                }
                                .padding()
                                .background(Color.customChineseliulv)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.top)
                            }
                            if showEndOfQuestionsMessage {
                                Text("You have completed all the questions!")
                                    .font(.system(size: fontSize))
                                    .background(Color.customChineseliulv)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .padding(.top)
                            }
                            Spacer()
                        }.overlay(
                            VStack {
                                if showToast {
                                    ToastView(message: toastMessage)
                                        .transition(.opacity)
                                        .animation(.easeInOut(duration: 0.3), value: showToast)
                                }
                                Spacer()
                            }
                        )
                    }
                    //.edgesIgnoringSafeArea([.bottom])
                    // Ensures that the tap gesture area is detectable
                    .onAppear {
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            fontSize = 27 // Set fontSize to 27 if running on an iPad
                        }
                    }
                    .contentShape(Rectangle()) // Allows the tap gesture to detect taps in the entire view
                    .onTapGesture {
                        onTapBlankSpace() // Call the closure when tapped
                    }
               }
               
               
            }
            .onAppear(perform: loadQuestions)
        }
        //.edgesIgnoringSafeArea([.bottom])// Extend the content to fill the entire screen, including th
        .background(Color.customBlack)
        .statusBar(hidden: true)
    }
    func loadQuestionsFromFirebase() {
        let languageCode = Locale.current.languageCode
        let fileName: String
        switch languageCode {
        case "en":
            fileName = "questionsEN.json"
        case "fr":
            fileName = "questionsFR.json"
        default:
            fileName = "questions.json"
        }

        let storage = Storage.storage()
        let storageRef = storage.reference().child("questionsEN.json")
      
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let errorText = error?.localizedDescription {
                print("Error loading questions: \(errorText)")
            } else if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(QuestionData.self, from: data)
                    if let strategy = decodedData.strategies.first(where: { $0.strategyId == strategyId }) {
                        questions = strategy.questions
                    } else {
                        print("Strategy with id \(strategyId) not found.")
                    }
                } catch {
                    print("Error decoding questions: \(error.localizedDescription)")
                }
            }
        }
    }
    func loadQuestions() {
        // Get the current language code of the device
        let languageCode = Locale.current.languageCode
        // Determine the appropriate JSON file based on the language
        let fileName: String
        switch languageCode {
        case "en":
            fileName = "questionsEN"
        case "fr":
            fileName = "questionsFR"
        default:
            fileName = "questions"
        }
        
        // Attempt to load questions from local JSON file
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode(QuestionData.self, from: data)
                if let strategy = decodedData.strategies.first(where: { $0.strategyId == strategyId }) {
                    questions = strategy.questions
                } else {
                    print("Strategy with id \(strategyId) not found.")
                    // If strategy not found, attempt to load from Firebase
                    loadQuestionsFromFirebase()
                }
            } catch {
                print("Error loading questions from local file: \(error)")
                // On error, attempt to load from Firebase
                loadQuestionsFromFirebase()
            }
        } else {
            print("Questions file not found.")
            // If the file is not found, attempt to load from Firebase
            loadQuestionsFromFirebase()
        }
    }
    func answerBackgroundColor(for index: Int) -> Color {
        if let selected = selectedAnswerIndex, selected == index {
            if selected == questions[currentQuestionIndex].correctAnswerIndex {
                return .customChineseliulv
            } else {
                //return .customChineseGao
                return .customChineseGao
            }
        } else {
            //return .customChineseGao
            return .customChineseRose.opacity(0.8)
        }
    }
    func answerBackColor(for index: Int) -> Color {
        if let selected = selectedAnswerIndex, selected == index {
            if selected == questions[currentQuestionIndex].correctAnswerIndex {
                return .customChineseliulv
            } else {
                return .customChineseGao
            }
        } else {
            return .customChineseGao
        }
    }

    func nextQuestion() {
        showResult = false
        showTryAgainMessage = false // Reset the try-again message
        selectedAnswerIndex = nil
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            // Handle end of questions if needed
            showEndOfQuestionsMessage = true
        }
    }

    func checkAnswer(index: Int) {
        if index == questions[currentQuestionIndex].correctAnswerIndex {
            answeredQuestions += 1
            showTryAgainMessage = false // Correct answer; do not show the try-again message
        } else {
            showTryAgainMessage = true // Incorrect answer; show the try-again message
        }
    }
}


struct ToastView: View {
    var message: String
    
    var body: some View {
        Text(message)
            .padding()
            .background(Color.customChineseGao)
            .foregroundColor(Color.red)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}
struct HalfRoundedRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - 8, y: rect.minY)) // Adjust for the corner radius
        path.addArc(center: CGPoint(x: rect.maxX - 8, y: rect.minY + 8), radius: 8, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 8))
        path.addArc(center: CGPoint(x: rect.maxX - 8, y: rect.maxY - 8), radius: 8, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        path.closeSubpath()
        return path
    }
}
struct RightHalfRoundedRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Start at the top-left corner
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        // Draw a line down the left side
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        // Draw a line across the bottom
        path.addLine(to: CGPoint(x: rect.maxX - rect.height / 2, y: rect.maxY))
        // Draw a half-circle on the right side
        path.addArc(
            center: CGPoint(x: rect.maxX - rect.height / 2, y: rect.midY),
            radius: rect.height / 2,
            startAngle: .degrees(90),
            endAngle: .degrees(-90),
            clockwise: true
        )
        
        // Draw a line across the top back to the starting point
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        path.closeSubpath()

        return path
    }
}
// Extension for rounding specific corners
struct RoundedCornersShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = [.topLeft, .bottomLeft] // Only round left corners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornersShape(radius: radius, corners: corners))
    }
}
struct Question: Identifiable, Codable {
    let id: String  // Custom ID based on a strategy
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
}
    // Struct for strategy
    struct Strategy: Codable {
        let strategyId: String
        let questions: [Question]
    }
    // Struct for the entire JSON structure
    struct QuestionData: Codable {
        let strategies: [Strategy]
    }
    // Custom initializer to create an ID based on the question text


