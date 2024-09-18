//
//  StorageManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation
import Combine
import UIKit
import Utility
import Models
@preconcurrency import CoreData

public class StorageManager: StorageManagerType, @unchecked Sendable {
  private var cancellables = Set<AnyCancellable>()
  private let coalesceInterval: Double = 0.3 // coalesce interval for Core Data saving
  
  private var backgroundSaveTask: Task<Void, Never>?
  
  public init() {
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
  
  lazy var persistentContainer: NSPersistentContainer = {
    let bundle = Bundle.module
    let modelURL = bundle.url(forResource: "MusculosDataStore", withExtension: ".momd")!
    let model = NSManagedObjectModel(contentsOf: modelURL)!
    
    let container = NSPersistentContainer(name: "MusculosDataStore", managedObjectModel: model)
    
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
  public func saveChanges(completion: @escaping () -> Void) {
    writerDerivedStorage.performAndWait { [ weak self] in
      guard let self else { return }
      
      self.writerDerivedStorage.saveIfNeeded()
      
      self.viewStorage.performAndWait {
        self.viewStorage.saveIfNeeded()
        completion()
      }
    }
  }
  
  /// Saves changes from `writerDerivedStorage`, followed by `viewStorage`
  /// With `async` flavour
  ///
  public func saveChanges() async {
    await writerDerivedStorage.performAndWait {
      self.writerDerivedStorage.saveIfNeeded()
      
      self.viewStorage.performAndWait {
        self.viewStorage.saveIfNeeded()
      }
    }
  }
  
  // MARK: - Read

  /// Performs the closure in the `viewStorage` context
  ///
  public func performRead<ResultType>(_ readClosure: @escaping ReadStorageClosure<ResultType>) async -> ResultType {
    return await viewStorage.perform {
      return readClosure(self.viewStorage)
    }
  }
  
  // MARK: - Write
  
  /// Performs the closure in the `writerDerivedStorage` context
  ///
  public func performWrite(_ writeClosure: @escaping WriteStorageClosure) async throws {
    try await writerDerivedStorage.perform {
      try writeClosure(self.writerDerivedStorage)
      
      /// need to call proccess changes on the writer storage
      /// otherwise it doesn't trigger the `NSManagedObjectContextObjectsDidChange` notification
      /// which is used for saving
      
      (self.writerDerivedStorage as? NSManagedObjectContext)?.processPendingChanges()
      
    }
  }
  
  // MARK: - Reset/Delete methods
  
  /// Resets the core data store
  ///
  public func reset() {
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
