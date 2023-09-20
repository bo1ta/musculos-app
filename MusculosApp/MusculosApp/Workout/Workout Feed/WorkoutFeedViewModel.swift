//
//  WorkoutFeedViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.09.2023.
//

import Foundation
import Combine

@MainActor
final class WorkoutFeedViewModel: ObservableObject {
    @Published var selectedFilter: String = ""
    @Published var errorMessage = ""
    @Published var currentExercises: [Exercise] = []
    @Published var isFiltersPresented = false
    @Published var searchResults: [SearchExerciseResponse.PreviewExercise]?
    
    @Published var searchQuery: String = "" {
        didSet {
            if searchQuery == "" {
                searchResults = nil
            }
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var workoutManager: WorkoutManager {
        return WorkoutManager()
    }
    
    private var exerciseModule: ExerciseModule {
        return ExerciseModule()
    }
    
    init() {
        $searchQuery.debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.searchExercise(with: query)
            }
            .store(in: &cancellables)
    }
    
    func loadExercises() async {
        do {
            let exercises = try await self.workoutManager.fetchAllExercises()
            self.currentExercises.append(contentsOf: exercises)
        } catch {
            MusculosLogger.log(.error, message: "Error loading exercises", category: .ui)
            self.errorMessage = error.localizedDescription
        }
    }
    
    func searchExercise(with query: String) {
        let publisher = self.exerciseModule.searchExercise(with: query)
        publisher.sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] results in
            self?.searchResults = results.suggestions.map{ $0.data }
        }
        .store(in: &cancellables)

    }
}
