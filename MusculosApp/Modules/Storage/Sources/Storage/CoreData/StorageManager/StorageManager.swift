//
//  StorageManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Combine
@preconcurrency import CoreData
import Foundation
import Utility

// MARK: - StorageManager

public class StorageManager: StorageManagerType, @unchecked Sendable {
  private var cancellables = Set<AnyCancellable>()

  public init() {
    setupNotificationPublisher()
  }

  private func setupNotificationPublisher() {
    NotificationCenter.default.publisher(
      for: .NSManagedObjectContextObjectsDidChange,
      object: writerDerivedStorage as? NSManagedObjectContext)
      .debounce(for: .seconds(coalesceSaveInterval), scheduler: DispatchQueue.global())
      .sink { [weak self] _ in
        self?.saveChanges(completion: { })
      }
      .store(in: &cancellables)
  }

  public var coalesceSaveInterval: Double { 0.3 }

  // MARK: - Migration

  private static let dataModelVersion = "13"

  private func shouldRecreateDataStore() -> Bool {
    guard let version = UserDefaults.standard.string(forKey: UserDefaultsKey.coreDataModelVersion) else {
      return false
    }
    return version != Self.dataModelVersion
  }

  private func updateDataModelVersion() {
    UserDefaults.standard.setValue(Self.dataModelVersion, forKey: UserDefaultsKey.coreDataModelVersion)
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
      if let error {
        Logger.error(error, message: "Failed to load persistent store")
      }
    }

    return container
  }()

  public var viewStorage: StorageType {
    persistentContainer.viewContext
  }

  public func performRead<ResultType>(_ readClosure: @escaping ReadStorageClosure<ResultType>) async -> ResultType {
    await viewStorage.perform {
      readClosure(self.viewStorage)
    }
  }

  public lazy var writerDerivedStorage: StorageType = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    managedObjectContext.parent = persistentContainer.viewContext
    managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    return managedObjectContext
  }()

  public func performWrite(_ writeClosure: @escaping WriteStorageClosure) async throws {
    try await writerDerivedStorage.perform {
      try writeClosure(self.writerDerivedStorage)

      /// need to call proccess changes on the writer storage otherwise it doesn't trigger the `NSManagedObjectContextObjectsDidChange` notification
      ///
      (self.writerDerivedStorage as? NSManagedObjectContext)?.processPendingChanges()
    }
  }

  public func saveChanges(completion: @escaping () -> Void) {
    writerDerivedStorage.perform { [weak self] in
      guard let self else {
        return
      }

      writerDerivedStorage.saveIfNeeded()

      viewStorage.perform {
        self.viewStorage.saveIfNeeded()
        completion()
      }
    }
  }

  public func saveChanges() async {
    try? await writerDerivedStorage.perform { self.writerDerivedStorage.saveIfNeeded() }
    try? await viewStorage.perform { self.viewStorage.saveIfNeeded() }
  }

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
      Logger.error(MusculosError.unexpectedNil, message: "Could not find sqlite db")
      return
    }

    do {
      try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, type: .sqlite)
    } catch {
      Logger.error(error, message: "Could not destroy persistent store")
    }
  }

  func deleteAllStoredObjects() {
    NotificationCenter.default.post(name: .willResetCoreData, object: nil)

    let viewContext = persistentContainer.viewContext

    for entity in persistentContainer.persistentStoreCoordinator.managedObjectModel.entities {
      guard let entityName = entity.name else {
        continue
      }

      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

      do {
        let objects = try viewContext.fetch(fetchRequest)
        for object in objects {
          viewContext.delete(object)
        }
        viewContext.saveIfNeeded()
      } catch {
        Logger.error(error, message: "Failed to fetch objects for entity \(entityName): \(error)")
      }
    }
  }
}

// MARK: - StorageOperations

extension StorageManager {
  public func getObjectCount(_ type: (some Object).Type, predicate: NSPredicate? = nil) async -> Int {
    await performRead { storage in
      storage.countObjects(ofType: type, matching: predicate)
    }
  }

  public func getAllEntities<T: EntityType>(_ type: T.Type, predicate: NSPredicate? = nil) async -> [T.ReadOnlyType] {
    await performRead { storage in
      storage.allObjects(ofType: type, matching: predicate, sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }

  public func getAllEntities<T: EntityType>(
    _ type: T.Type,
    fetchLimit: Int,
    predicate: NSPredicate? = nil)
    async -> [T.ReadOnlyType]
  {
    await performRead { storage in
      storage.allObjects(ofType: type, fetchLimit: fetchLimit, matching: predicate, sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }

  public func getFirstEntity<T: EntityType>(_ type: T.Type, predicate: NSPredicate? = nil) async -> T.ReadOnlyType? {
    await performRead { storage in
      storage.firstObject(of: type, matching: predicate)?.toReadOnly()
    }
  }

  public func createEntityPublisher<T: EntityType>(matching predicate: NSPredicate) -> EntityPublisher<T> {
    EntityPublisher(storage: viewStorage, predicate: predicate)
  }

  public func createFetchedResultsPublisher<T: EntityType>(
    matching predicate: NSPredicate? = nil,
    sortDescriptors: [NSSortDescriptor] = [],
    fetchLimit: Int? = 10)
    -> FetchedResultsPublisher<T>
  {
    FetchedResultsPublisher(
      storage: viewStorage,
      sortDescriptors: sortDescriptors,
      predicate: predicate,
      fetchLimit: fetchLimit)
  }

  public func updateEntity<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) async throws {
    try await performWrite { storage in
      guard let firstObject = storage.firstObject(of: type, matching: model.matchingPredicate()) else {
        return
      }
      firstObject.updateEntityFrom(model, using: storage)
    }
  }

  public func deleteEntity<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) async throws {
    try await performWrite { storage in
      guard let firstObject = storage.firstObject(of: type, matching: model.matchingPredicate()) else {
        return
      }
      storage.deleteObject(firstObject)
    }
  }

  public func importEntity<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) async throws {
    try await performWrite { storage in
      if let firstObject = storage.firstObject(of: type, matching: model.matchingPredicate()) {
        firstObject.updateEntityFrom(model, using: storage)
      } else {
        let newObject = storage.insertNewObject(ofType: type)
        newObject.populateEntityFrom(model, using: storage)
      }
    }
  }

  public func importEntities<T: EntitySyncable>(_ models: [T.ModelType], of type: T.Type) async throws {
    try await performWrite { storage in
      for model in models {
        if let firstObject = storage.firstObject(of: type, matching: model.matchingPredicate()) {
          firstObject.updateEntityFrom(model, using: storage)
        } else {
          let newObject = storage.insertNewObject(ofType: type)
          newObject.populateEntityFrom(model, using: storage)
        }
      }
    }
  }
}
