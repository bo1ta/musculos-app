//
//  IntroductionViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.06.2023.
//

import Foundation
import Combine

final class IntroductionViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
        
    private var cancellables = Set<AnyCancellable>()
    private var module: IntroductionModule = IntroductionModule()
    
    init(module: IntroductionModule = IntroductionModule()) {
        self.module = module
    }
    
    var currentQuestion: Question? {
        guard currentIndex >= 0 && currentIndex < questions.count else {
            return nil
        }
        return questions[currentIndex]
    }
    
    func nextQuestion() {
        guard currentIndex < questions.count - 1 else {
            return
        }
        currentIndex += 1
    }
    
    func previousQuestion() {
        guard currentIndex > 0 else {
            return
        }
        currentIndex -= 1
    }
}

// MARK: - Networking

extension IntroductionViewModel {
    func getQuestions() {
        self.isLoading = true
        self.module.getQuestions()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let networkError):
                    self?.errorMessage = networkError.description
                case .finished:
                    print("Finished fetching questions!")
                }
                self?.isLoading = false
            } receiveValue: { [weak self] response in
                DispatchQueue.main.async {
                    self?.questions = response.questions
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
}
