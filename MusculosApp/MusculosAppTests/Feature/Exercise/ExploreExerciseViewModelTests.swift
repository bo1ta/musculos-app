//
//  ExploreExerciseViewModelTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 08.06.2024.
//

import Foundation
import XCTest
import Factory

@testable import MusculosApp
//
//class ExploreExerciseViewModelTests: XCTestCase {
//  func testInitialValues() {
//    let viewModel = ExploreExerciseViewModel()
//    
//    XCTAssertEqual(viewModel.exercisesCompletedToday.count, 0)
//    XCTAssertEqual(viewModel.goals.count, 0)
//    XCTAssertEqual(viewModel.searchQuery, "")
//    XCTAssertEqual(viewModel.contentState, .empty)
//
//    XCTAssertFalse(viewModel.showFilterView)
//    XCTAssertFalse(viewModel.showExerciseDetails)
//    
//    XCTAssertNil(viewModel.selectedExercise)
//  }
//  
//  func testInitialLoad() async {
//    let mockGoalDataStore = MockGoalDataStore()
//    let getGoalExpectation = self.expectation(description: "should get goals expectation")
//    mockGoalDataStore.getAllExpectation = getGoalExpectation
//    Container.shared.goalDataStore.register { mockGoalDataStore }
//    
//    let mockExerciseSessionDataStore = MockExerciseSessionDataStore()
//    let getCompletedTodayExpectation = self.expectation(description: "should get exercise sessions completed today")
//    mockExerciseSessionDataStore.getCompletedTodayExpectation = getCompletedTodayExpectation
//    Container.shared.exerciseSessionDataStore.register { mockExerciseSessionDataStore }
//    
//    defer { Container.shared.reset() }
//    
//    let viewModel = ExploreExerciseViewModel()
//    XCTAssertEqual(viewModel.goals.count, 0)
//    XCTAssertEqual(viewModel.exercisesCompletedToday.count, 0)
//    
//    await viewModel.initialLoad()
//    await fulfillment(of: [getGoalExpectation, getCompletedTodayExpectation])
//    
//    XCTAssertEqual(viewModel.goals.count, 1)
//    XCTAssertEqual(viewModel.exercisesCompletedToday.count, 1)
//  }
//}
//
//extension ExploreExerciseViewModelTests {
//  class MockGoalDataStore: GoalDataStoreProtocol {
//    func incrementCurrentValue(_ goal: Goal) async throws {
//    }
//    
//    func add(_ goal: Goal) async throws {}
//    
//    var getAllExpectation: XCTestExpectation?
//    func getAll() async -> [Goal] {
//      getAllExpectation?.fulfill()
//      return [GoalFactory.createGoal()]
//    }
//  }
//  
//  class MockExerciseSessionDataStore: ExerciseSessionDataStoreProtocol {
//    func getCompletedSinceLastWeek() async -> [ExerciseSession] {
//      return []
//    }
//    
//    var getCompletedTodayExpectation: XCTestExpectation?
//    func getCompletedToday() async -> [ExerciseSession] {
//      getCompletedTodayExpectation?.fulfill()
//      return [ExerciseSessionFactory.createExerciseSession()]
//    }
//    
//    func addSession(_ exercise: Exercise, date: Date) async throws {}
//    
//    func getAll() async -> [ExerciseSession] {
//      return []
//    }
//  }
//}
