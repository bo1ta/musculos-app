//
//  SelectPill.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import SwiftUI

struct SelectPill: View {
    private let question: String
    private let onContinue: () -> Void
    
    @State private var contentHeight: CGFloat = 0
    
    @Binding var selectedAnswer: Answer?
    var answers: [Answer]
    
    init(question: String, answers: [Answer], selectedAnswer: Binding<Answer?> = .constant(nil), onContinue: @escaping () -> Void = {}) {
        self.question = question
        self.answers = answers
        self._selectedAnswer = selectedAnswer
        self.onContinue = onContinue
    }
    
    var body: some View {
        TransparentContainer {
                VStack {
                    Text(self.question)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    ForEach(answers, id: \.self) { answer in
                        Button(action: {
                            selectedAnswer = answer
                        }, label: {
                            Text(answer.content)
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(SelectedButton(isSelected: selectedAnswer == answer))
                        .listRowSeparator(.hidden)
                    }
                    .padding(.bottom, 4)
                    Button(action: self.onContinue, label: {
                        Text("Next")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    })
                    .buttonStyle(PrimaryButton())
                    .padding(.top, 18)
                }
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
        SelectPill(question: "Choose a lifestyle", answers: [Answer(id: 1, content: "One", questionId: 1), Answer(id: 2, content: "Two", questionId: 1), Answer(id: 3, content: "Three", questionId: 1)])
    }
}
