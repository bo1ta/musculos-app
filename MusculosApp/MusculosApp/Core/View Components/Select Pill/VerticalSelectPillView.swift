//
//  VerticalSelectPillView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import SwiftUI

struct VerticalSelectPillView: View {
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
        TransparentContainerView {
            VStack {
                Text(self.question)
                    .font(.largeTitle)
                    .foregroundColor(.white)

                self.answersButtons

                Button(action: self.onContinue, label: {
                    Text("Next")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                })
                .buttonStyle(PrimaryButton())
                .padding(.top, 18)
            }
        }
        .padding([.leading, .trailing], 20)
    }

    @ViewBuilder private var answersButtons: some View {
        ForEach(answers, id: \.id) { answer in
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
    }
}

struct VerticalSelectPillView_Preview: PreviewProvider {
    static var previews: some View {
        VerticalSelectPillView(
            question: "Choose a lifestyle",
            answers: [
                Answer(id: 1, content: "One", questionId: 1),
                Answer(id: 2, content: "Two", questionId: 1),
                Answer(id: 3, content: "Three", questionId: 1)
            ]
        )
    }
}
