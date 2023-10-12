//
//  MusculosApp.swift
//  Musculos
//
//  Created by Solomon Alexandru on 10.09.2023.
//

import SwiftUI

@main
struct MusculosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
