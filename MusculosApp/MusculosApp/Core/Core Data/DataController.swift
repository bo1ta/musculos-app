//
//  DataController.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    static let shared = DataController()

    let container: NSPersistentContainer
    
    public init() {
        
        self.container = NSPersistentContainer(name: "MusculosDataStore")
        self.container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error)")
            }
        }
    }
    
    func save() {
        let context = self.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core data failed to save: \(error.localizedDescription)")
            }
        }
    }
}
