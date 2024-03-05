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
  case profile

  var label: String {
    switch self {
    case .workout:
      return "Workout"
    case .dashboard:
      return "Dashboard"
    case .profile:
      return "Profile"
    }
  }

  var imageName: String {
    switch self {
    case .workout:
      return "dumbbell"
    case .dashboard:
      return "rectangle.grid.2x2"
    case .profile:
      return "person"
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
