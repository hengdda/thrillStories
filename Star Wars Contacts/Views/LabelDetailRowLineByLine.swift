//
//  LabelDetailRowLineByLine.swift
//  Star Wars Contacts
//
//  Created by Mac22N on 2024-07-23.
//  Copyright © 2024 Michael Holt. All rights reserved.
//

import SwiftUI

struct LabelDetailRowLineByLine: View {
    @State var value: String
    @State private var currentLineIndex: Int = -1
    @State private var contentOffset: CGFloat = 0
    // Parameters for customizable colors
      var leafColor: Color
      var textColor: Color
      var textHighlightColor: Color
      var fontSize: CGFloat // Add fontSize as a parameter
    private var sentences: [String] {
        value.split { $0 == "." || $0 == "。" }
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 7) {
                Divider()
                    .background(Color.customChineseGao)
                
                ForEach(Array(sentences.enumerated()), id: \.element) { index, sentence in
                    HStack(alignment: .top, spacing: 5) {
                        if currentLineIndex == index {
                            Image(systemName: "leaf") // Replace with your custom leaf icon name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 30) // Adjust width and height as needed
                                .foregroundColor(leafColor)
                                //.foregroundColor(.customChineseRose) // Customize icon color if needed
                        }
                        Text(sentence)
                            .font(.system(size: fontSize))
                            .multilineTextAlignment(.leading) // Align text to leading for better alignment
                            .foregroundColor(currentLineIndex == index ? textColor : textHighlightColor)
                    }
                    .background(GeometryReader { geometry in
                        Color.clear.preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).minY)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) { value in
                        if currentLineIndex == index {
                            withAnimation {
                                contentOffset = value
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color.customChineseGao)
                }
            }
            .frame(maxWidth: .infinity) // Expand VStack to full width
            .padding()
        }
        .onAppear {
            animateText()
        }
    }
    
    func animateText() {
        for index in sentences.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 2.8) {
                withAnimation {
                    currentLineIndex = index
                }
            }
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

   

