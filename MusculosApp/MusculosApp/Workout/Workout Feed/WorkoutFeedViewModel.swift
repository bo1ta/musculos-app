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
    @Published var selectedExercise: Exercise?
    @Published var errorMessage = ""
    @Published var currentExercises: [Exercise] = []
    @Published var isFiltersPresented = false
    @Published var isExerciseDetailPresented = false
    @Published var isLoading = false
    @Published var searchQuery: String = ""
    @Published var selectedMuscles: [MuscleInfo] = []

    private var cancellables: Set<AnyCancellable> = []

    private lazy var workoutManager: WorkoutManager = {
        return WorkoutManager()
    }()

    private lazy var exerciseModule: ExerciseModule = {
        return ExerciseModule()
    }()

    private var initialExercises: [Exercise] = []

    init() {
        $searchQuery
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.searchExercise(with: query)
            }
            .store(in: &cancellables)

        $selectedFilter
            .sink { [weak self] filter in
                self?.filterExercises(by: filter)
            }
            .store(in: &cancellables)
    }

    func filterExercises(by filter: String) {
        switch filter {
        case "Favorites":
            self.filterFavoriteExercises()
            return
        default:
            self.currentExercises = initialExercises
            return
        }
    }

    func loadInitialData() async {
        await self.loadExercises()
    }

    func loadExercises() async {
        do {
            self.isLoading = true
            defer { self.isLoading = false }

            let exercises = try await self.workoutManager.fetchLocalExercises()
            self.currentExercises.append(contentsOf: exercises)
            self.initialExercises = exercises
        } catch {
            MusculosLogger.log(.error, message: "Error loading exercises", category: .ui)
            self.errorMessage = error.localizedDescription
        }
    }

    func filterFavoriteExercises() {
        do {
            self.isLoading = true
            defer { self.isLoading = false }

            let exercises = try self.workoutManager.fetchFavoriteExercises()
            self.currentExercises = exercises
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func getExercisesByMuscleType(muscleInfo: MuscleInfo) async {
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
        guard query.count > 0 else { return }

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
