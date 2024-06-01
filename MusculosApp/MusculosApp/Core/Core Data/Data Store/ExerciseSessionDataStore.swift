//
//  ExerciseSessionDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.06.2024.
//

import Foundation
import CoreData

protocol ExerciseSessionDataStoreProtocol {
  func getAll() -> [ExerciseSession]
  func getCompletedToday() throws -> [ExerciseSession]
  func add(from exercise: Exercise, date: Date) async
}

struct ExerciseSessionDataStore: BaseDataStore, ExerciseSessionDataStoreProtocol {
  func getAll() -> [ExerciseSession] {
    return self.viewStorage
      .allObjects(
        ofType: ExerciseSessionEntity.self,
        matching: nil,
        sortedBy: nil
      )
      .map { $0.toReadOnly() }
  }
  
  func getCompletedToday() throws -> [ExerciseSession] {
    guard
      let currentPerson = UserEntity.currentUser(with: self.viewStorage)?.toReadOnly(),
      let (startOfDay, endOfDay) = getCurrentDay() as? (Date, Date)
    else { throw MusculosError.notFound }
        
    let userPredicate = NSPredicate(
      format: "user.email == %@",
      currentPerson.email
    )
    let todayPredicate = NSPredicate(
      format: "date >= %@ AND date <= %@",
      argumentArray: [startOfDay, endOfDay]
    )
    let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, todayPredicate])
    
    return self.viewStorage
      .allObjects(
        ofType: ExerciseSessionEntity.self,
        matching: compundPredicate,
        sortedBy: nil)
      .map { $0.toReadOnly() }
  }
  
  func add(from exercise: Exercise, date: Date) async {
    await writerDerivedStorage.performAndSave {
      guard
        let exerciseEntity = writerDerivedStorage.firstObject(
          of: ExerciseEntity.self,
          matching: ExerciseEntity.CommonPredicate.byId(exercise.id).nsPredicate
        ),
        let userEntity = UserEntity.currentUser(with: writerDerivedStorage)
      else { return }
      
      
      let entity = writerDerivedStorage.insertNewObject(ofType: ExerciseSessionEntity.self)
      entity.sessionId = UUID()
      entity.date = date
      entity.exercise = exerciseEntity
      entity.user = userEntity
    }
    
    await viewStorage.performAndSave { }
  }
}

// MARK: - Private helpers

extension ExerciseSessionDataStore {
  private func getCurrentDay() -> (Date, Date?) {
    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: Date())
    
    var dateComponents = DateComponents()
    dateComponents.day = 1
    
    let endOfDay = calendar.date(byAdding: dateComponents, to: startOfDay)
    return (startOfDay, endOfDay)
  }
}
