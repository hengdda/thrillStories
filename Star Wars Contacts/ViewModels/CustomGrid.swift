//
//  CustomGrid.swift
//  Star Wars Contacts
//
//  Created by Mac22N on 2024-07-16.
//  Copyright © 2024 Aurora cAO. All rights reserved.
//
import SwiftUI

struct CustomGrid<Content: View>: View {
    let columns: Int
    let items: [Content]
    let spacing: CGFloat

    init(columns: Int, spacing: CGFloat = 6, items: [Content]) {
        self.columns = columns
        self.spacing = spacing
        self.items = items
    }

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let itemWidth = (totalWidth - CGFloat(columns - 1) * spacing) / CGFloat(columns)

            VStack(spacing: spacing) {
                ForEach(0..<self.rows, id: \.self) { rowIndex in
                    HStack(spacing: self.spacing) {
                        ForEach(0..<self.columns, id: \.self) { columnIndex in
                            if self.itemIndex(row: rowIndex, column: columnIndex) < self.items.count {
                                self.items[self.itemIndex(row: rowIndex, column: columnIndex)]
                                    .frame(width: itemWidth)
                            } else {
                                Spacer()
                                    .frame(width: itemWidth)
                            }
                        }
                    }
                }
            }
        }
    }

    private var rows: Int {
        (items.count + columns - 1) / columns
    }

    private func itemIndex(row: Int, column: Int) -> Int {
        row * columns + column
    }
}
