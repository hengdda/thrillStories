//
//  QuestionView.swift
//  Star Wars Contacts
//
//  Created by Mac22N on 2024-08-10.
//  Copyright © 2024 Michael Holt. All rights reserved.
//

import SwiftUI
import Foundation
/*
struct QuestionView: View {
    @State private var currentStrategyIndex = 0
    @State private var currentQuestionIndex = 0
    @State private var answeredQuestions = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var showResult = false
     // @State private var strategies: [Strategy] = []
     @State private var questions: [Question] = []
     var strategyId: String
    var onTapBlankSpace: () -> Void  // Closure to be called on tap
     var body: some View {
         GeometryReader { geometry in  // geometry is now correctly scoped
             VStack {
                 if questions.isEmpty {
                     VStack{
                         Image("titleImg")
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(maxWidth: geometry.size.width * 0.66, maxHeight: geometry.size.height * 0.19, alignment: .leading)
                             .clipped()
                             .cornerRadius(20)
                         Spacer()
                         Text("Loading questions...Contact system admin for further assistance")
                             .onAppear(perform: loadQuestions)
                             .font(.headline)
                         Spacer()
                         
                     }.onTapGesture {
                         onTapBlankSpace() // Call the closure when tapped}
                     }
                     .frame(width: geometry.size.width, height: geometry.size.height)
                     .edgesIgnoringSafeArea(.all)
                 } else {
                     VStack {
                         Spacer()
                         Image("titleImg")
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(maxWidth: geometry.size.width * 0.66, maxHeight: geometry.size.height * 0.19, alignment: .leading)
                             .clipped()
                             .cornerRadius(20)
                         // Status bar showing how many questions are answered
                         Text("Questions answered: \(answeredQuestions)/\(questions.count)")
                             .font(.title)
                             .fontWeight(.bold)
                             .padding()
                         
                         // Display the current question
                         Text(questions[currentQuestionIndex].text)
                             .font(.title)
                             .foregroundColor(.customChineseliulv)
                             .padding()
                         
                         // Display the 4 answer options
                         ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                             Button(action: {
                                 selectedAnswerIndex = index
                                 showResult = true
                                 checkAnswer(index: index)
                             }) {
                                 Text(questions[currentQuestionIndex].options[index])
                                     .padding()
                                     .frame(maxWidth: .infinity)
                                     .background(answerBackgroundColor(for: index))
                                     .foregroundColor(.white)
                                     .cornerRadius(8)
                             }
                             .disabled(showResult)
                             .padding(.horizontal)
                         }
                         
                         
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
                         Spacer()
                     }
                     .edgesIgnoringSafeArea(.all)
                     //.padding()
                     .background(Color.white) // Ensures that the tap gesture area is detectable
                     .contentShape(Rectangle()) // Allows the tap gesture to detect taps in the entire view
                     .onTapGesture {
                         onTapBlankSpace() // Call the closure when tapped
                     }
                 }
             }
             .background(Color.yellow.opacity(0.009))
       }.edgesIgnoringSafeArea(.all) // Extend the content to fill the entire screen, including th
    }
    func loadQuestions() {
            if let url = Bundle.main.url(forResource: "questions", withExtension: "json") {
                print("File URL: \(url)")
                do {
                    let data = try Data(contentsOf: url)
                    let decodedData = try JSONDecoder().decode(QuestionData.self, from: data)
                    if let strategy = decodedData.strategies.first(where: { $0.strategyId == strategyId }) {
                        questions = strategy.questions
                    } else {
                        print("Strategy with id \(strategyId) not found.")
                    }
                } catch {
                    print("Error loading questions: \(error)")
                }
            } else {
                print("Questions file not found.")
            }
        }
    func answerBackgroundColor(for index: Int) -> Color {
           if let selected = selectedAnswerIndex, selected == index {
               if selected == questions[currentQuestionIndex].correctAnswerIndex {
                   return .customChineseliulv
               } else {
                   return .customChineseRose
               }
           } else {
               return .customChineseGray.opacity(0.8)
           }
       }
    func nextQuestion() {
           showResult = false
           selectedAnswerIndex = nil
           if currentQuestionIndex < questions.count - 1 {
               currentQuestionIndex += 1
           } else {
               // Handle end of questions if needed
           }
       }
    func checkAnswer(index: Int) {
           if index == questions[currentQuestionIndex].correctAnswerIndex {
               answeredQuestions += 1
           }
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


*/
