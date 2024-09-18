//
//  StoreProvider.swift
//
//
//  Created by Solomon Alexandru on 21.07.2024.
//

import SwiftUI
import CoreData
import Combine
import Utility
import Factory

public typealias ResultsControllerMutableType = NSManagedObject & ReadOnlyConvertible

@Observable
@MainActor
public class StorageStore<T: ResultsControllerMutableType>: NSObject, @preconcurrency NSFetchedResultsControllerDelegate {

    // MARK: - Private properties -- no need to be observed

    @ObservationIgnored
    private let viewStorage: StorageType

    @ObservationIgnored
    private let sectionNameKeyPath: String?

    @ObservationIgnored
    private(set) var fetchLimit: Int

    @ObservationIgnored
    private(set) var predicate: NSPredicate?

    @ObservationIgnored
    private(set) var sortDescriptors: [NSSortDescriptor]?

    @ObservationIgnored
    private lazy var controller: NSFetchedResultsController<T> = {
        viewStorage.createFetchedResultsController(
            fetchRequest: fetchRequest,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: nil
        )
    }()

    @ObservationIgnored
    private lazy var fetchRequest: NSFetchRequest<T> = {
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors ?? []
        request.fetchLimit = fetchLimit
        return request
    }()

    private var fetchedObjects: [T.ReadOnlyType] {
        let readOnlyObjects = controller.fetchedObjects?.compactMap { $0.toReadOnly() }
        return readOnlyObjects ?? []
    }

    // MARK: - Public properties

    public var results: [T.ReadOnlyType] = []

    public var numberOfSections: Int {
        return controller.sections?.count ?? 0
    }

    // MARK: - Initializer

    public init(
        viewStorage: StorageType = StorageContainer.shared.storageManager().viewStorage,
        sectionNameKeyPath: String? = nil,
        matching predicate: NSPredicate? = nil,
        fetchLimit: Int = 10,
        sortedBy descriptors: [NSSortDescriptor] = []
    ) {
        self.viewStorage = viewStorage
        self.sectionNameKeyPath = sectionNameKeyPath
        self.fetchLimit = fetchLimit
        self.predicate = predicate
        self.sortDescriptors = descriptors

        super.init()
        self.controller.delegate = self
        refreshFetchedObjects()
    }

    // MARK: - Public methods

    public func updateFetchConfiguration(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil) {
        var needsRefresh = false

        if predicate != self.predicate {
            self.predicate = predicate
            needsRefresh = true
        }

        if sortDescriptors != self.sortDescriptors {
            self.sortDescriptors = sortDescriptors
            needsRefresh = true
        }

        if let fetchLimit = fetchLimit, fetchLimit != self.fetchLimit {
            self.fetchLimit = fetchLimit
            needsRefresh = true
        }

        if needsRefresh {
            refreshFetchedObjects()
        }
    }

    public func object(at indexPath: IndexPath) -> T.ReadOnlyType {
        return controller.object(at: indexPath).toReadOnly()
    }

    public func numberOfItemsInSection(_ section: Int) -> Int {
        guard let sections = controller.sections, sections.endIndex > section else { return 0 }
        return sections[section].numberOfObjects
    }

    // MARK: - Private methods

    private func refreshFetchedObjects() {
        controller.fetchRequest.predicate = predicate
        controller.fetchRequest.sortDescriptors = sortDescriptors ?? []
        controller.fetchRequest.fetchLimit = fetchLimit

        do {
            try controller.performFetch()
            results = fetchedObjects
        } catch {
            MusculosLogger.logError(error, message: "Could not fetch results controller", category: .coreData)
        }
    }

    // MARK: - NSFetchedResultsControllerDelegate Methods

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        results = fetchedObjects
    }
}
