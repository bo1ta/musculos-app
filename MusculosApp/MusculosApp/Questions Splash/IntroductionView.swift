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
    @State private var selectedOption: String =  "12"
    
    init(viewModel: IntroductionViewModel = IntroductionViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        backgroundView {
            VStack(alignment: .leading, content: {
                    CustomNavigationBar(onBack: {
                        viewModel.previousQuestion()
                    }, onContinue: {
                        viewModel.nextQuestion(with: nil)
                    })
                        .padding([.leading, .trailing], 20)
                    
                   answerQuestion
            })
            .overlay(loadingOverlay)
            .onAppear(perform: {
                self.viewModel.getQuestions()
            })
        }
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    private func backgroundView(@ViewBuilder content: () -> some View) -> some View {
        ZStack {
            Image("deadlift-background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            content()
        }
    }
    
    @ViewBuilder private var loadingOverlay: some View {
        if self.viewModel.isLoading {
            ZStack {
                Color(white: 0, opacity: 0.75)
                ProgressView().tint(.white)
            }
        }
    }
    
    @ViewBuilder private var answerQuestion: some View {
        if let currentQuestion = viewModel.currentQuestion {
            SelectPill(question: currentQuestion.content, answers: currentQuestion.answers, selectedAnswer: $selectedAnswer) {
                withAnimation(Animation.snappy(duration: 0.7)) {
                    self.viewModel.nextQuestion(with: selectedAnswer)
                }
            }
            ProgressBar(progressCount: viewModel.questions.count, currentProgress: viewModel.currentIndex)
                .padding([.leading, .trailing], 20)
        } else {
          mockQuestion
        }
    }
    
    @ViewBuilder private var mockQuestion: some View {
        SelectPill(question: "Choose a lifestyle", answers: [Answer(id: 1, content: "One", questionId: 1), Answer(id: 2, content: "Two", questionId: 1), Answer(id: 3, content: "Three", questionId: 1)])
        ProgressBar(progressCount: 5, currentProgress: 0)
            .padding([.leading, .trailing], 20)
    }

}


struct IntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
