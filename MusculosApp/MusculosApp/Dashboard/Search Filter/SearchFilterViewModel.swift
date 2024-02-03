//
//  SearchFilterViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.02.2024.
//

import Foundation
import SwiftUI
import Combine

class SearchFilterViewModel: ObservableObject {
  @Published var searchQuery: String = ""
  @Published var selectedMuscleFilters: [String] = []
  @Published var selectedWorkoutFilters: [String] = []
  @Published var selectedDifficultyFilters: [String] = []
  @Published var selectedDuration: Float = 0
  
  @Published var showMuscleFilters: Bool = true
  @Published var showWorkoutFilters: Bool = true
  @Published var showDifficultyFilters: Bool = true
  @Published var showDurationFilter: Bool = true
  @Published var showEquipmentFilter: Bool = true
  
  private var cancellables: Set<AnyCancellable> = []
  private(set) var task: Task<Void, Never>?
  
  init() {
    self.setupFiltersPublisher()
  }
  
  private func setupFiltersPublisher() {
    let selectedFilters = Publishers.CombineLatest4($selectedMuscleFilters, $selectedWorkoutFilters, $selectedDifficultyFilters, $selectedDuration)
    selectedFilters.combineLatest($searchQuery)
      .debounce(for: 1, scheduler: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.resetTask()
        self?.maybeHandleSearch()
      }
      .store(in: &cancellables)
  }
  
  func resetFilters() {
    selectedMuscleFilters = []
    selectedWorkoutFilters = []
    selectedDifficultyFilters = []
  }
  
  private func maybeHandleSearch() {
    guard shouldHandleSearch else { return }
    
    task = Task { @MainActor [weak self] in
      guard let self else { return }
      print("ceva se intampla!")
    }
  }
  
  private func resetTask() {
    task?.cancel()
    task = nil
  }
  
  private var shouldHandleSearch: Bool {
    searchQuery.count > 0 &&
    selectedMuscleFilters.count > 0 &&
    selectedWorkoutFilters.count > 0 &&
    selectedDifficultyFilters.count > 0 &&
    selectedDuration > 0
  }
}
