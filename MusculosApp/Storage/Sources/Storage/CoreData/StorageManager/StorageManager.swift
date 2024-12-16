//
//  StorageManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation
import Combine
import Utility
import Models
import Factory
@preconcurrency import CoreData

public class StorageManager: StorageManagerType, @unchecked Sendable {
  public static let shared = StorageManager()

  private var cancellables = Set<AnyCancellable>()

  public init() {
    setupNotificationPublisher()
  }

  private func setupNotificationPublisher() {
    NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: writerDerivedStorage as? NSManagedObjectContext)
      .debounce(for: .seconds(coalesceSaveInterval), scheduler: DispatchQueue.global())
      .sink { [weak self] _ in
        self?.saveChanges(completion: {})
      }
      .store(in: &cancellables)
  }

  public var coalesceSaveInterval: Double {
    return 0.5
  }

  // MARK: - Migration

  private let dataModelVersion = "0.005"

  private func shouldRecreateDataStore() -> Bool {
    guard let version = UserDefaults.standard.string(forKey: UserDefaultsKey.coreDataModelVersion) else {
      return false
    }
    return version != dataModelVersion
  }

  private func updateDataModelVersion() {
    UserDefaults.standard.setValue(dataModelVersion, forKey: UserDefaultsKey.coreDataModelVersion)
  }

  // MARK: - Core Data Stack
  
  lazy var persistentContainer: NSPersistentContainer = {
    guard
      let modelURL = Bundle.module.url(forResource: "MusculosDataModel", withExtension: ".momd"),
      let model = NSManagedObjectModel(contentsOf: modelURL)
    else {
      fatalError("Could not load Core Data model")
    }

    let container = NSPersistentContainer(name: "MusculosDataStore", managedObjectModel: model)
    defer { updateDataModelVersion() }

    let description = container.persistentStoreDescriptions.first
    description?.type = NSSQLiteStoreType
    description?.shouldMigrateStoreAutomatically = true
    description?.shouldInferMappingModelAutomatically = true

    if shouldRecreateDataStore(), let storeURL = description?.url {
      do {
        try container.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, type: .sqlite)
        Logger.info(message: "Deleted persistent store for forced migration")
      } catch {
        Logger.error(error, message: "Failed to delete persistent store")
      }
    }

    container.loadPersistentStores { _, error in
      if let error = error {
        Logger.error(error, message: "Failed to load persistent store")
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
    try? await writerDerivedStorage.perform {
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
      Logger.info(message: "CoreDataStack DESTROYED ! 💣")
    }
  }
  
  func deleteSql() {
    let url = FileManager.default
      .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("MusculosDataModel.sqlite")

    guard FileManager.default.fileExists(atPath: url.path) else {
      Logger.error(MusculosError.notFound, message: "Could not find sqlite db")
      return
    }
    
    do {
      try self.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, type: .sqlite)
    } catch {
      Logger.error(error, message: "Could not destroy persistent store")
    }
  }
  
  func deleteAllStoredObjects() {
    let viewContext = persistentContainer.viewContext
    
    for e in persistentContainer.persistentStoreCoordinator.managedObjectModel.entities {
      let r = NSBatchDeleteRequest(
        fetchRequest: NSFetchRequest(entityName: e.name ?? "")
      )
      do {
        try viewContext.execute(r)
      } catch {
        Logger.error(error, message: "Could not delete stored objects")
      }
    }
    viewContext.saveIfNeeded()
  }
}
