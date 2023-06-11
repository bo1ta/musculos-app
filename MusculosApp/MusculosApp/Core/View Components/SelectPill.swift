//
//  SelectPill.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import SwiftUI

struct SelectPill: View {
    private let question: String
    private let options: [String]
    
    init(question: String, options: [String]) {
        self.question = question
        self.options = options
    }
    
    var body: some View {
        TransparentContainer {
            VStack {
                Text(self.question)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

struct SelectPill_Preview: PreviewProvider {
    static var previews: some View {
        SelectPill(question: "Set your goal", options: ["Lose weight", "Build muscle", "Get toned", "Plan nutrition"])
    }
}
