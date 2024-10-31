//
//  LabelDetailRow.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/18/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

struct LabelDetailRow: View {
    @State var title: String
    @State var value: String

    var body: some View {
        VStack() {
            //Text(title)
              //  .font(.subheadline)
            //Spacer()
            Text(value)
                //.font(.subheadline)
                .font(.system(size: 18))
        }
      
    }
}
