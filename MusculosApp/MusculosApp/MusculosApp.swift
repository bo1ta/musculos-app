//
//  MusculosAppApp.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI

@main
struct MusculosApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
