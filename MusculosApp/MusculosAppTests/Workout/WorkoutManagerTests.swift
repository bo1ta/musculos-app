////
////  WorkoutManagerTests.swift
////  MusculosAppTests
////
////  Created by Solomon Alexandru on 14.09.2023.
////
//
//import Foundation
//import XCTest
//import CoreData
//
//@testable import MusculosApp
//
//class WorkoutManagerTests: XCTestCase {
//  override func tearDown() {
//    MockURLProtocol.clear()
//    super.tearDown()
//  }
//
//  func testFetchEquipment() async throws {
//    let equipmentFetchRequest = NSFetchRequest<EquipmentEntity>(entityName: "EquipmentEntity")
//
//    // Count should be 0 since we start with a clean data store
//    let coreDataStack = CoreDataTestStack()
//    var equipmentEntities = try coreDataStack.mainContext.fetch(equipmentFetchRequest)
//    XCTAssertEqual(equipmentEntities.count, 0)
//
//    // makes a network request in absence of core data models
//    let networkRequestExpectation = self.expectation(description: "should make network request")
//
//    MockURLProtocol.expectation = networkRequestExpectation
//    MockURLProtocol.requestHandler = { request in
//      guard let url = request.url else { throw MusculosError.badRequest }
//      let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
//      let data = try XCTUnwrap(self.readFromFile(name: "getEquipment"))
//      return (response, data)
//    }
//
//    let configuration = URLSessionConfiguration.default
//    configuration.protocolClasses = [MockURLProtocol.self]
//
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//
//    let workoutManager = WorkoutManager(client: client, context: coreDataStack.mainContext)
//    do {
//      let equipments = try await workoutManager.fetchAllEquipments()
//      XCTAssertFalse(equipments.isEmpty)
//
//      // now, the core data store is populated
//      equipmentEntities = try coreDataStack.mainContext.fetch(equipmentFetchRequest)
//      XCTAssertEqual(equipmentEntities.count, equipments.count)
//    } catch {
//      XCTFail("Test failed with error: \(error.localizedDescription)")
//    }
//
//    await fulfillment(of: [networkRequestExpectation], timeout: 1)
//  }
//
//  func testFetchMuscles() async throws {
//    let muscleFetchRequest = NSFetchRequest<MuscleEntity>(entityName: "MuscleEntity")
//
//    let coreDataStack = CoreDataTestStack()
//    var muscleEntities = try coreDataStack.mainContext.fetch(muscleFetchRequest)
//    XCTAssertEqual(muscleEntities.count, 0)
//
//    let networkRequestExpectation = self.expectation(description: "should make network request")
//
//    MockURLProtocol.expectation = networkRequestExpectation
//    MockURLProtocol.requestHandler = { request in
//      guard let url = request.url else { throw MusculosError.badRequest }
//      let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
//      let data = try XCTUnwrap(self.readFromFile(name: "getMuscles"))
//      return (response, data)
//    }
//
//    let configuration = URLSessionConfiguration.default
//    configuration.protocolClasses = [MockURLProtocol.self]
//
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//
//    let workoutManager = WorkoutManager(client: client, context: coreDataStack.mainContext)
//    do {
////      let muscles = try await workoutManager.fetchAllMuscles()
//      XCTAssertFalse(muscles.isEmpty)
//
//      muscleEntities = try coreDataStack.mainContext.fetch(muscleFetchRequest)
//      XCTAssertEqual(muscleEntities.count, muscles.count)
//    } catch {
//      XCTFail("Test failed with error: \(error.localizedDescription)")
//    }
//
//    await fulfillment(of: [networkRequestExpectation], timeout: 1)
//  }
//
//  func testFetchExercises() async throws {
//    let coreDataStack = CoreDataTestStack()
//    let context = coreDataStack.mainContext
//
//    // Set up muscles and equipment so we have the one-to-many relationships
//    let muscleEntities = try await setupMockMuscles(in: context)
//    XCTAssertGreaterThan(muscleEntities.count, 0)
//    let equipmentEntities = try await setupMockEquipment(in: context)
//    XCTAssertGreaterThan(equipmentEntities.count, 0)
//
//    try context.save()
//
//    let fetchRequest = NSFetchRequest<MuscleEntity>(entityName: "MuscleEntity")
//    let fetchrequester = try context.fetch(fetchRequest)
//    XCTAssertGreaterThan(fetchrequester.count, 0)
//
//    let exerciseFetchRequest = NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
//    var exerciseEntities = try coreDataStack.mainContext.fetch(exerciseFetchRequest)
//    XCTAssertEqual(exerciseEntities.count, 0)
//
//    let networkRequestExpectation = self.expectation(description: "should make network request")
//
//    MockURLProtocol.expectation = networkRequestExpectation
//    MockURLProtocol.requestHandler = { request in
//      guard let url = request.url else { throw MusculosError.badRequest }
//      let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
//      let data = try XCTUnwrap(self.readFromFile(name: "getExercises"))
//      return (response, data)
//    }
//
//    let configuration = URLSessionConfiguration.default
//    configuration.protocolClasses = [MockURLProtocol.self]
//
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//
//    let workoutManager = WorkoutManager(client: client, context: context)
//    do {
//      let exercises = try await workoutManager.fetchExercises()
//      XCTAssertFalse(exercises.isEmpty)
//      exerciseEntities = try context.fetch(exerciseFetchRequest)
//      XCTAssertEqual(exerciseEntities.count, exercises.count)
//    } catch {
//      XCTFail("Test failed with error: \(error)")
//    }
//
//    await fulfillment(of: [networkRequestExpectation], timeout: 1)
//  }
//}
//
//extension WorkoutManagerTests {
//  @discardableResult func setupMockMuscles(in context: NSManagedObjectContext) async throws -> [MuscleEntity] {
//    let muscleData = try self.readFromFile(name: "getMuscles")
//    let muscleResponse = try await MuscleResponse.createFrom(muscleData)
//    return muscleResponse.results.map { $0.toEntity(context: context) }
//  }
//
//  @discardableResult func setupMockEquipment(in context: NSManagedObjectContext) async throws -> [EquipmentEntity] {
//    let equipmentData = try self.readFromFile(name: "getEquipment")
//    let equipmentResponse = try await EquipmentResponse.createFrom(equipmentData)
//    return equipmentResponse.results.map { $0.toEntity(context: context) }
//  }
//}
