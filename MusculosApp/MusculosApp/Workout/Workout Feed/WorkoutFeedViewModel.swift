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
    @Published var selectedExercise: Exercise? = nil
    @Published var errorMessage = ""
    @Published var currentExercises: [Exercise] = []
    @Published var isFiltersPresented = false
    @Published var isExerciseDetailPresented = false
    @Published var isLoading = false
    @Published var searchQuery: String = ""
    
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
    
    func loadInitialData() {
        Task {
            await self.loadExercises()
        }
    }
    
    func loadExercises() async {
        do {
            self.isLoading = true
            defer { self.isLoading = false }
            
            let exercises = try await self.workoutManager.fetchExercises()
            self.currentExercises.append(contentsOf: exercises)
        } catch {
            MusculosLogger.log(.error, message: "Error loading exercises", category: .ui)
            self.errorMessage = error.localizedDescription
        }
    }
    
    func getExercisesByMuscleType(muscleInfo: MuscleInfo) async throws {
        do {
            self.isLoading = true
            defer { self.isLoading = false }
            
            let exercises = try await self.exerciseModule.getExercises(by: muscleInfo)
            self.currentExercises = exercises
        } catch {
            MusculosLogger.log(.error, message: "Error loading exercises", category: .ui)
            self.errorMessage = error.localizedDescription
        }
    }
    
    func searchExercise(with query: String) {
        self.isLoading = true
        defer { self.isLoading = false }
        
        let publisher = self.exerciseModule.searchExercise(by: query)
        publisher.sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] results in
            self?.currentExercises = results
        }
        .store(in: &cancellables)
    }
}
