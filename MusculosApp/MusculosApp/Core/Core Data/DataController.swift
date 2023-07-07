//
//  DataController.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "MusculosDataStore")
    
    public init() {
        self.container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error)")
            }
        }
    }
}
