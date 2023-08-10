//
//  ContentView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selection: String = "workout"
    @State private var tabSelection: TabBarItem = .workout
    
    var body: some View {
        CustomTabBarContainer(selection: $tabSelection) {
            WorkoutFeedView()
                .tabBarItem(tab: .workout , selection: $tabSelection)
            
            AuthenticationView()
                .tabBarItem(tab: .add, selection: $tabSelection)
            
            IntroductionView()
                .tabBarItem(tab: .dashboard, selection: $tabSelection)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
