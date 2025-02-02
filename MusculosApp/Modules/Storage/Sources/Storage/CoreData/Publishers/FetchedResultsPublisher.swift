//
//  FetchedResultsPublisher.swift
//  Storage
//
//  Created by Solomon Alexandru on 18.01.2025.
//

import Combine
import CoreData
import Utility

/// `NSFetchedResultsController` wrapper that publishes events when changes occur
///
public class FetchedResultsPublisher<T: EntityType>: NSObject, NSFetchedResultsControllerDelegate {
  public enum Event {
    case didUpdateContent([T.ReadOnlyType])
    case didInsertModel(T.ReadOnlyType)
    case didDeleteModel(T.ReadOnlyType)
    case didUpdateModel(T.ReadOnlyType)
  }

  private let storage: StorageType
  private let subject = PassthroughSubject<Event, Never>()
  private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>

  public var sortDescriptors: [NSSortDescriptor]
  public var fetchLimit: Int?

  public var predicate: NSPredicate? {
    didSet {
      if let predicate, fetchedResultsController.delegate != nil {
        fetchedResultsController.fetchRequest.predicate = predicate
        performFetch()
      }
    }
  }

  public var fetchedObjects: [T.ReadOnlyType] {
    guard let fetchedObjects = fetchedResultsController.fetchedObjects as? [T] else {
      return []
    }
    return fetchedObjects.map { $0.toReadOnly() }
  }

  public var publisher: AnyPublisher<Event, Never> {
    subject.eraseToAnyPublisher()
  }

  public init(
    storage: StorageType,
    sortDescriptors: [NSSortDescriptor],
    predicate: NSPredicate? = nil,
    fetchLimit: Int? = nil)
  {
    self.storage = storage
    self.predicate = predicate
    self.sortDescriptors = sortDescriptors
    self.fetchLimit = fetchLimit

    fetchedResultsController = storage.createFetchedResultsController(
      for: T.self,
      predicate: predicate,
      sortDescriptors: sortDescriptors,
      fetchLimit: fetchLimit,
      sectionNameKeyPath: nil,
      cacheName: nil)

    super.init()

    setupObserver()

    fetchedResultsController.delegate = self
    performFetch()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  private func setupObserver() {
    // Hack: Workaround for FRC throwing an exception when linked to a context backed by in-memory store
    // More info: https://stackoverflow.com/q/49052482/1161723
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didReceiveCoreDataWillResetNotification),
      name: .willResetCoreData,
      object: nil)
  }

  @objc
  private func didReceiveCoreDataWillResetNotification() {
    fetchedResultsController.delegate = nil
  }

  public func performFetch() {
    do {
      try fetchedResultsController.performFetch()
      sendFetchedObjects(fetchedResultsController.fetchedObjects)
    } catch {
      Logger.error(error, message: "Failed to load objects")
    }
  }

  private func sendFetchedObjects(_ fetchedObjects: [any NSFetchRequestResult]?) {
    guard let fetchedObjects = fetchedObjects as? [T] else {
      return
    }

    let readOnlyObjects = fetchedObjects.map { $0.toReadOnly() }
    subject.send(.didUpdateContent(readOnlyObjects))
  }

  // MARK: NSFetchedResultsControllerDelegate methods

  public func controller(
    _: NSFetchedResultsController<any NSFetchRequestResult>,
    didChange anObject: Any,
    at _: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath _: IndexPath?)
  {
    guard let entityObject = anObject as? T else {
      return
    }

    switch type {
    case .insert:
      subject.send(.didInsertModel(entityObject.toReadOnly()))
      Logger.info(message: "Did insert object \(T.entityName): \(entityObject.objectID)")

    case .update:
      subject.send(.didUpdateModel(entityObject.toReadOnly()))
      Logger.info(message: "Did update object \(T.entityName): \(entityObject.objectID)")

    case .delete:
      subject.send(.didDeleteModel(entityObject.toReadOnly()))
      Logger.info(message: "Did delete object \(T.entityName): \(entityObject.objectID)")

    default:
      return
    }
  }
}
