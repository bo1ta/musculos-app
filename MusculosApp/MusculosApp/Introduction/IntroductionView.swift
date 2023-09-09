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
                    CustomNavigationBarView(onBack: {
                        viewModel.previousQuestion()
                    }, onContinue: {
                        viewModel.nextQuestion(with: nil)
                    })
                        .padding([.leading, .trailing], 20)
                    
                   weightPicker
                Spacer()
            })
            .overlay(loadingOverlay)
            .onAppear(perform: {
//                self.viewModel.getQuestions()
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
            VerticalSelectPillView(question: currentQuestion.content, answers: currentQuestion.answers, selectedAnswer: $selectedAnswer) {
                withAnimation(Animation.easeInOut(duration: 2.0)) {
                    self.viewModel.nextQuestion(with: selectedAnswer)
                }
            }
            ProgressBarView(progressCount: viewModel.questions.count, currentProgress: viewModel.currentIndex)
                .padding([.leading, .trailing], 20)
        } else {
          mockQuestion
        }
    }
    
    @ViewBuilder private var mockQuestion: some View {
        VerticalSelectPillView(question: "Choose a lifestyle", answers: [Answer(id: 1, content: "One", questionId: 1), Answer(id: 2, content: "Two", questionId: 1), Answer(id: 3, content: "Three", questionId: 1)])
        ProgressBarView(progressCount: 5, currentProgress: 0)
            .padding([.leading, .trailing], 20)
    }
        
    @ViewBuilder private var weightPicker: some View {
        TransparentContainerView {
            VStack {
                Text("What's your current weight")
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .lineLimit(2, reservesSpace: true)
                HorizontalPicker(selectedOption: $selectedOption)
                    .padding(25)
                Button(action: {}, label: {
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
}


struct IntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
