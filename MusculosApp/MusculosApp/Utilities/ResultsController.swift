//
//  ResultsController.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.03.2024.
//

import Foundation
import CoreData

typealias ResultsControllerMutableType = NSManagedObject & ReadOnlyConvertible

class ResultsController<T: ResultsControllerMutableType> {
  
  private let viewStorage: StorageType
  
  private let sectionNameKeyPath: String?
  
  public var predicate: NSPredicate? {
    didSet {
      refreshFetchedObjects(predicate: predicate)
    }
  }
  
  public var sortDescriptors: [NSSortDescriptor]? {
    didSet {
      refreshFetchedObjects(sortDescriptors: sortDescriptors)
    }
  }
  
  private lazy var fetchRequest: NSFetchRequest<T> = {
    let request = NSFetchRequest<T>(entityName: T.entityName)
    request.predicate = predicate
    request.sortDescriptors = sortDescriptors
    if let fetchLimit {
      request.fetchLimit = fetchLimit
    }
    return request
  }()
  
  /// Internal NSFetchedResultsController Instance.
  ///
  private lazy var controller: NSFetchedResultsController<T> = {
    viewStorage.createFetchedResultsController(fetchRequest: fetchRequest,
                                   sectionNameKeyPath: sectionNameKeyPath,
                                   cacheName: nil)
  }()
  
  /// Closure to be executed before the results are changed.
  ///
  public var onWillChangeContent: (() -> Void)?
  
  public var onDidChangeContent: (() -> Void)?
  
  /// Closure to be executed whenever an Object is updated.
  ///
  public var onDidChangeObject: ((_ object: T.ReadOnlyType, _ indexPath: IndexPath?, _ type: ChangeType, _ newIndexPath: IndexPath?) -> Void)?

  /// Closure to be executed whenever an entire Section is updated.
  ///
  public var onDidChangeSection: ((_ sectionInfo: SectionInfo, _ sectionIndex: Int, _ type: ChangeType) -> Void)?

  /// Closure to be executed whenever the (entire) content was reset. This happens whenever a `StorageManagerDidResetStorage` notification is
  /// caught
  ///
  public var onDidResetContent: (() -> Void)?
  
  private let fetchLimit: Int?

  init(viewStorage: StorageType,
              sectionNameKeyPath: String? = nil,
              matching predicate: NSPredicate? = nil,
              fetchLimit: Int? = nil,
              sortedBy descriptors: [NSSortDescriptor]) {

      self.viewStorage = viewStorage
      self.sectionNameKeyPath = sectionNameKeyPath
      self.predicate = predicate
      self.fetchLimit = fetchLimit
      self.sortDescriptors = descriptors
  }
  
  /// Convenience Initializer.
  ///
  convenience init(storageManager: StorageManagerType,
                          sectionNameKeyPath: String? = nil,
                          matching predicate: NSPredicate? = nil,
                          fetchLimit: Int? = nil,
                          sortedBy descriptors: [NSSortDescriptor]) {

      self.init(viewStorage: storageManager.viewStorage,
                sectionNameKeyPath: sectionNameKeyPath,
                matching: predicate,
                fetchLimit: fetchLimit,
                sortedBy: descriptors)
  }
  
  /// Executes the fetch request on the store to get objects.
  ///
  public func performFetch() throws {
      try controller.performFetch()
  }
  
  public func object(at indexPath: IndexPath) -> T.ReadOnlyType {
      return controller.object(at: indexPath).toReadOnly()
  }
  
  public func safeObject(at indexPath: IndexPath) -> T.ReadOnlyType? {
      guard !isEmpty else {
          return nil
      }
      guard let sections = controller.sections, sections.count > indexPath.section else {
          return nil
      }

      let section = sections[indexPath.section]

      guard section.numberOfObjects > indexPath.row else {
          return nil
      }

      return controller.object(at: indexPath).toReadOnly()
  }
  
  public func objectIndex(from indexPath: IndexPath) -> Int {
      guard let sections = controller.sections else {
          return indexPath.row
      }

      var output = indexPath.row
      for (index, section) in sections.enumerated() where index < indexPath.section {
          output += section.numberOfObjects
      }

      return output
  }
  
  public var isEmpty: Bool {
      return controller.fetchedObjects?.isEmpty ?? true
  }
  
  public var numberOfObjects: Int {
      return controller.fetchedObjects?.count ?? 0
  }
  
  /// Returns an array of SectionInfo Entitites (read-only)
  ///
  public var sections: [SectionInfo] {
      let readOnlySections = controller.sections?.compactMap { mutableSection in
          SectionInfo(mutableSection: mutableSection)
      }

      return readOnlySections ?? []
  }
  
  public var fetchedObjects: [T.ReadOnlyType] {
      let readOnlyObjects = controller.fetchedObjects?.compactMap { mutableObject in
          mutableObject.toReadOnly()
      }

      return readOnlyObjects ?? []
  }
  
  /// Refreshes all of the Fetched Objects, so that the new criteria is met.
  ///
  private func refreshFetchedObjects(predicate: NSPredicate?) {
    controller.fetchRequest.predicate = predicate
    try? controller.performFetch()
  }
  
  /// Refreshes all of the Fetched Objects, so that the new sort descriptors are applied.
  ///
  private func refreshFetchedObjects(sortDescriptors: [NSSortDescriptor]?) {
      controller.fetchRequest.sortDescriptors = sortDescriptors
      try? controller.performFetch()
  }
  
  /// Returns an optional index path of the first matching object.
  /// - Parameter objectMatching: Specifies the matching criteria.
  /// - Returns: An optional index path of the first object that matches the given criteria.
  public func indexPath(forObjectMatching objectMatching: (T) -> Bool) -> IndexPath? {
      guard let fetchedObjects = controller.fetchedObjects,
            let object = fetchedObjects.first(where: { objectMatching($0) }) else {
          return nil
      }
      return controller.indexPath(forObject: object)
  }
}

extension ResultsController {
  typealias ChangeType = NSFetchedResultsChangeType

  final class SectionInfo {
    private let mutableSectionInfo: NSFetchedResultsSectionInfo
    
    /// Name of the section
    ///
    public var name: String {
      mutableSectionInfo.name
    }
    
    /// Returns the array of (ReadOnly) objects in the section.
    ///
    public lazy var objects: [T.ReadOnlyType] = {
      guard let objects = mutableSectionInfo.objects else {
          return []
      }
      guard let castedObjects = objects as? [T] else {
          assertionFailure("Failed to cast objects into an array of \(T.self)")
          return []
      }

      return castedObjects.map { $0.toReadOnly() }
    }()
    
    init(mutableSection: NSFetchedResultsSectionInfo) {
        mutableSectionInfo = mutableSection
    }
  }
}
