//
//  CoreModelNotificationHandler.swift
//
//
//  Created by Solomon Alexandru on 06.09.2024.
//

import CoreData
import Utility
import Combine

/// Class that listens to "core" models that are used accross the app
/// and publishes an event when updates happen
/// `
public final class CoreModelNotificationHandler {
  public enum Event {
    case didUpdateGoal
    case didUpdateExercise
    case didUpdateExerciseSession
  }

  private let eventSubject = PassthroughSubject<Event, Never>()

  public var eventPublisher: AnyPublisher<Event, Never> {
    return eventSubject.eraseToAnyPublisher()
  }

  public init(storageType: StorageType) {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(managedObjectContextDidSave),
      name: .NSManagedObjectContextDidSave,
      object: storageType as? NSManagedObjectContext
    )
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @objc
  private func managedObjectContextDidSave(_ notification: Notification) {
    guard let userInfo = notification.userInfo else { return }

    let insertedObjects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? []
    let updatedObjects = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
    let deletedObjects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> ?? []

    let allChangedObjects = insertedObjects.union(updatedObjects).union(deletedObjects)
    handleChangedObjects(allChangedObjects)
  }

  private func handleChangedObjects(_ objects: Set<NSManagedObject>) {
    if objects.contains(where: { $0 is GoalEntity }) {
      eventSubject.send(.didUpdateGoal)
    }
    if objects.contains(where: { $0 is ExerciseEntity }) {
      eventSubject.send(.didUpdateExercise)
    }
    if objects.contains(where: { $0 is ExerciseSessionEntity }) {
      eventSubject.send(.didUpdateExerciseSession)
    }
  }
}
