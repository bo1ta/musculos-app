//
//  HorizontalSelectPill.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct HorizontalSelectPill: View {
    private let title: String
    private let options: [String]
    
    init(title: String, options: [String]) {
        self.title = title
        self.options = options
    }
    
    var body: some View {
        TransparentContainer {
            VStack {
                Text(title)
                    .font(.title)
                    .foregroundColor(.white)
                
                buttonStack
                Spacer()
            }
        }
    }
    
    @ViewBuilder private var buttonStack: some View {
        HStack {
            ForEach(self.options, id: \.self) { option in
                Button(action: {
                    
                }, label: {
                    Text(option)
                })
                .buttonStyle(SecondaryButton())
            }
        }
    }
}

struct HorizontalSelectPill_Preview: PreviewProvider {
    static var previews: some View {
        HorizontalSelectPill(title: "Location", options: ["Home", "Gym", "Mix"])
    }
}
