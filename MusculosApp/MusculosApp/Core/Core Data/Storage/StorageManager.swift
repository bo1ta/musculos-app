//
//  StorageManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation
import Combine
import UIKit
@preconcurrency import CoreData

typealias CoreDataWriteClosure = (StorageType) throws -> Void
typealias CoreDataReadClosure<ResultType> = (StorageType) -> ResultType

class StorageManager: StorageManagerType, @unchecked Sendable {
  private var cancellables = Set<AnyCancellable>()
  private let coalesceInterval: Double = 2.0 // coalesce interval for Core Data saving
  
  private var backgroundSaveTask: Task<Void, Never>?
  
  init() {
    setupNotificationPublisher()
  }
  
  /// Setup `onChange` notification for `writerDerivedStorage`
  /// Debounces for 2 seconds then saves changes in a background task
  ///
  func setupNotificationPublisher() {
    NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: writerDerivedStorage as? NSManagedObjectContext)
      .debounce(for: .seconds(coalesceInterval), scheduler: DispatchQueue.global())
      .sink { [performBackgroundSave] _ in
        performBackgroundSave()
      }
      .store(in: &cancellables)
  }
  
  // MARK: - Core Data Stack
  
  public lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MusculosDataStore")
    
    let description = container.persistentStoreDescriptions.first
    description?.type = NSSQLiteStoreType
    description?.shouldMigrateStoreAutomatically = true
    description?.shouldInferMappingModelAutomatically = true
    
    container.loadPersistentStores { _, error in
      if let error = error {
        MusculosLogger.logError(error, message: "Failed to load persistent store", category: .coreData)
      }
    }
    
    return container
  }()
  
  public var viewStorage: StorageType {
    return persistentContainer.viewContext
  }
  
  public lazy var writerDerivedStorage: StorageType = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    managedObjectContext.parent = persistentContainer.viewContext
    managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    return managedObjectContext
  }()
  
  // MARK: - Save methods
  
  /// Starts a background task to save the changes
  /// This ensures data is saved even if the app goes from foreground to background
  ///
  private func performBackgroundSave() {
    backgroundSaveTask = Task { @MainActor [weak self] in
      let app = UIApplication.shared
      var bgTask: UIBackgroundTaskIdentifier = .invalid
      
      bgTask = app.beginBackgroundTask(withName: "CoreDataSave", expirationHandler: {
        app.endBackgroundTask(bgTask)
        bgTask = .invalid
      })
      
      self?.saveChanges {
        app.endBackgroundTask(bgTask)
        bgTask = .invalid
      }
    }
  }
  
  /// Saves changes from `writerDerivedStorage`, followed by `viewStorage`
  /// Escapes a void completion block
  ///
  func saveChanges(completion: @escaping () -> Void) {
    writerDerivedStorage.performSync { [ weak self] in
      guard let self else { return }
      
      self.writerDerivedStorage.saveIfNeeded()
      
      self.viewStorage.performSync {
        self.viewStorage.saveIfNeeded()
        completion()
      }
    }
  }
  
  /// Saves changes from `writerDerivedStorage`, followed by `viewStorage`
  /// With `async` flavour
  ///
  func saveChanges() async {
    await writerDerivedStorage.perform {
      self.writerDerivedStorage.saveIfNeeded()
      
      self.viewStorage.performSync {
        self.viewStorage.saveIfNeeded()
      }
    }
  }
  
  // MARK: - Operation Queues
  
  /// The write operation queue
  /// To enforce safety, the max concurrent operations is 1
  ///
  private lazy var writeQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
  /// The read operation queue
  /// Should be used only for reading operations
  ///
  private lazy var readQueue: OperationQueue = {
    let queue = OperationQueue()
    return queue
  }()
  
  /// Performs the task in the `writeQueue`
  /// Escapes the `writerDerivedStorage` to perform safe core data writing tasks
  /// `CoreDataWriteClosure` = `(StorageType) throws -> Void`
  ///
  func performWriteOperation(_ writeClosure: @escaping CoreDataWriteClosure) async throws {
    return try await withCheckedThrowingContinuation { continuation in
      let operation = CoreDataWriteOperation(storage: self.writerDerivedStorage, closure: writeClosure, continuation: continuation)
      self.writeQueue.addOperation(operation)
    }
  }
  
  /// Performs the task in the `readQueue`
  /// Escapes the `viewStorage` to perform safe core data reading tasks
  /// `CoreDataReadClosure` = `(StorageType) -> ResultType`
  ///
  func performReadOperation<ResultType>(_ readClosure: @escaping CoreDataReadClosure<ResultType>) async -> ResultType {
    return await withCheckedContinuation { continuation in
      let operation = CoreDataReadOperation(storage: self.viewStorage, closure: readClosure, continuation: continuation)
      self.readQueue.addOperation(operation)
    }
  }
  
  // MARK: - Reset/Delete methods
  
  /// Resets the core data store
  ///
  func reset() {
    let viewContext = persistentContainer.viewContext
    viewContext.performAndWait {
      viewContext.reset()
      self.deleteAllStoredObjects()
      MusculosLogger.logInfo(message: "CoreDataStack DESTROYED ! 💣", category: .coreData)
    }
  }
  
  func deleteSql() {
    let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("MusculosDataStore.sqlite")
    
    guard FileManager.default.fileExists(atPath: url.path) else {
      MusculosLogger.logError(MusculosError.notFound, message: "Could not find sqlite db", category: .coreData)
      return
    }
    
    do {
      try self.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, type: .sqlite)
    } catch {
      MusculosLogger.logError(error, message: "Could not destroy persistent store", category: .coreData)
    }
  }
  
  func deleteAllStoredObjects() {
    let viewContext = persistentContainer.viewContext
    
    for e in persistentContainer.persistentStoreCoordinator.managedObjectModel.entities {
      let r = NSBatchDeleteRequest(
        fetchRequest: NSFetchRequest(entityName: e.name ?? "")
      )
      _ = try? viewContext.execute(r)
    }
    viewContext.saveIfNeeded()
  }
}
