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
    
    @State private var contentHeight: CGFloat = 0
    @State private var selectedOptions: [String: Bool] = [:]
    
    init(question: String, options: [String]) {
        self.question = question
        self.options = options
    }
    
    var body: some View {
        TransparentContainer {
                VStack {
                    Text(self.question)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedOptions[option]?.toggle()
                            for (key, _) in selectedOptions {
                                if key != option {
                                    selectedOptions[key] = false
                                }
                            }
                        }, label: {
                            Text(option)
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(SelectedButton(option: option, selectedOptions: selectedOptions))
                        .listRowSeparator(.hidden)
                    }
                    .padding(.bottom, 4)
                    Spacer()
                }
                .onAppear(perform: {
                    self.selectedOptions = Dictionary(uniqueKeysWithValues: options.map { ($0, false) })
                })
                .background(
                    GeometryReader { scrollViewGeometry in
                        Color.clear
                            .onAppear(perform: {
                                contentHeight += 40 + scrollViewGeometry.size.height + 80
                            })
                    }
                )
            }
        .padding([.leading, .trailing], 20)
        .frame(height: contentHeight)
    }
}

struct SelectPill_Preview: PreviewProvider {
    static var previews: some View {
        SelectPill(question: "Set your goal", options: ["Lose weight", "Build muscle", "Get toned", "Plan nutrition"])
    }
}
