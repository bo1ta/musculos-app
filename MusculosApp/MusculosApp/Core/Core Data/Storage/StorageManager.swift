//
//  StorageManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation
import Combine
import UIKit
import CoreData

class StorageManager: StorageManagerType {
  private var cancellables = Set<AnyCancellable>()
  private let coalesceInterval: Double = 2.0 // coalesce interval for Core Data saving
  
  init() {
    setupNotificationPublisher()
  }
  
  /// Setup `onChange` notification for `writerDerivedStorage`
  /// Debounces for 2 seconds then saves changes in a background task
  ///
  func setupNotificationPublisher() {
    NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: writerDerivedStorage as? NSManagedObjectContext)
      .debounce(for: .seconds(coalesceInterval), scheduler: DispatchQueue.global())
      .sink { [weak self] _ in
        self?.performBackgroundSave()
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
    let app = UIApplication.shared
    var bgTask: UIBackgroundTaskIdentifier = .invalid
    
    bgTask = app.beginBackgroundTask(withName: "CoreDataSave", expirationHandler: {
      app.endBackgroundTask(bgTask)
      bgTask = .invalid
    })
    
    self.saveChanges {
      app.endBackgroundTask(bgTask)
      bgTask = .invalid
    }
  }
  
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
  
  func saveChanges() async {
    await writerDerivedStorage.perform {
      self.writerDerivedStorage.saveIfNeeded()
      
      self.viewStorage.performSync {
        self.viewStorage.saveIfNeeded()
      }
    }
  }
  
  // MARK: - Queue Operations
  
  private lazy var writeQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
  private lazy var readQueue: OperationQueue = {
    let queue = OperationQueue()
    return queue
  }()
  
  func performWriteOperation(_ task: @escaping (StorageType) throws -> Void) async throws {
    return try await withCheckedThrowingContinuation { continuation in
      let operation = CoreDataWriteOperation(task: task, storage: self.writerDerivedStorage, continuation: continuation)
      self.writeQueue.addOperation(operation)
    }
  }
  
  func performReadOperation<ResultType>(_ task: @escaping (StorageType) -> ResultType) async -> ResultType {
    return await withCheckedContinuation { continuation in
      let operation = CoreDataReadOperation(task: task, storage: self.viewStorage, continuation: continuation)
      self.readQueue.addOperation(operation)
    }
  }
  
  // MARK: - Reset/Delete methods
  
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
