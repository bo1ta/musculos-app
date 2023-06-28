//
//  DetailsSplashView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.06.2023.
//

import SwiftUI

struct IntroductionView: View {
    @ObservedObject var viewModel: IntroductionViewModel
    
    @State private var selectedAnswer: Answer? = nil
    
    init(viewModel: IntroductionViewModel = IntroductionViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Image("deadlift-background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, content: {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    CustomNavigationBar(onBack: {}, onContinue: {})
                        .padding([.leading, .trailing], 20)
                    
                    if let currentQuestion = viewModel.currentQuestion {
                        SelectPill(question: currentQuestion.content, answers: currentQuestion.answers, selectedAnswer: $selectedAnswer) {
                            withAnimation(Animation.snappy(duration: 0.7)) {
                                self.viewModel.nextQuestion(with: selectedAnswer)
                            }
                        }
                    } else {
                        SelectPill(question: "Choose a lifestyle", answers: [Answer(id: 1, content: "One", questionId: 1), Answer(id: 2, content: "Two", questionId: 1), Answer(id: 3, content: "Three", questionId: 1)])
                    }
                    ProgressBar(progressCount: 5, currentProgress: 0)
                        .padding([.leading, .trailing], 20)
                }
            })
            .onAppear(perform: {
                self.viewModel.getQuestions()
            })
        }
    }
}

struct IntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
