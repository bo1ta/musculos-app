//
//  IntroductionViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.06.2023.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class IntroductionViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private var selectedAnswers: [Answer] = []
    private var cancellables = Set<AnyCancellable>()
    private var module: IntroductionModule = IntroductionModule()
    
    init(module: IntroductionModule = IntroductionModule()) {
        self.module = module
    }
    
    var currentQuestion: Question? {
        guard self.currentIndex >= 0 && self.currentIndex < questions.count else {
            return nil
        }
        return self.questions[currentIndex]
    }
    
    func nextQuestion(with answer: Answer?) {
        guard
            let answer = answer,
            self.currentIndex < questions.count - 1
        else { return }
        
        self.currentIndex += 1
        self.selectedAnswers.append(answer)
    }
    
    func previousQuestion() {
        guard self.currentIndex > 0 else { return }
        self.currentIndex -= 1
    }
}

extension IntroductionViewModel {
    func getQuestions() {
        self.isLoading = true
        
        Task {
            do {
                self.questions = try await self.module.getQuestions()
                self.isLoading = false
            } catch(let err) {
                self.errorMessage = err.localizedDescription
                self.isLoading = false
            }
        }
    }
}
