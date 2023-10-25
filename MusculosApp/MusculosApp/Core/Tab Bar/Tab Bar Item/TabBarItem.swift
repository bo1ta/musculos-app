//
//  TabBarItem.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.08.2023.
//

import Foundation

enum TabBarItem: String {
    case dashboard
    case workout
    case add

    var label: String {
        switch self {
        case .add:
            return "Add"
        case .dashboard:
            return "Dashboard"
        case .workout:
            return "Workout"
        }
    }

    var imageName: String {
        switch self {
        case .add:
            return "plus"
        case .dashboard:
            return "rectangle.grid.2x2"
        case .workout:
            return "dumbbell"
        }
    }
}

extension TabBarItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.label)
    }

    static func ==(lhs: TabBarItem, rhs: TabBarItem) -> Bool {
        return lhs.label == rhs.label
    }
}
