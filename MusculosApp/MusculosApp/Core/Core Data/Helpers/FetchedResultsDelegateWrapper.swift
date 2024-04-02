//
//  FetchedResultsObserver.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.03.2024.
//

import Foundation
import CoreData

/// Acts as a wrapper over `NSFetchedResultsControllerDelegate`
/// so we can use our callbacks
///
class FetchedResultsDelegateWrapper: NSObject {
  
  /// Forwards FRC's Delegate: `controllerWillChangeContent`
  ///
  var onWillChangeContent: (() -> Void)?
  
  /// Forwards FRC's Delegate: `controllerDidChangeContent`
  ///
  var onDidChangeContent: (() -> Void)?
  
  /// Forwards FRC's Delegate: `didChange anObject`
  ///
  var onDidChangeObject: ((_ object: Any, _ indexPath: IndexPath?, _ type: NSFetchedResultsChangeType, _ newIndexPath: IndexPath?) -> Void)?
  
  /// Forwards FRC's Delegate: `didChange sectionInfo`
  ///
  var onDidChangeSection: ((_ sectionInfo: NSFetchedResultsSectionInfo, _ sectionIndex: Int, _ type: NSFetchedResultsChangeType) -> Void)?
}

// MARK: - NSFetchedResultsControllerDelegate

extension FetchedResultsDelegateWrapper: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
    onWillChangeContent?()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
    onDidChangeContent?()
  }
  
  func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    onDidChangeObject?(anObject, indexPath, type, newIndexPath)
  }
  
  func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange sectionInfo: any NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    onDidChangeSection?(sectionInfo, sectionIndex, type)
  }
}
