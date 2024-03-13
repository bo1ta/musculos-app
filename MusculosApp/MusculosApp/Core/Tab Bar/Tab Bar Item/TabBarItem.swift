//
//  TabBarItem.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.08.2023.
//

import Foundation

enum TabBarItem: String {
  case dashboard
  case explore
  case overview
  case workout
  
  var label: String {
    return self.rawValue.capitalized
  }
  
  var imageName: String {
    switch self {
    case .explore:
      "dumbbell"
    case .dashboard:
      "rectangle.grid.2x2"
    case .overview:
      "chart.bar.xaxis.ascending"
    case .workout:
      "list.bullet.rectangle"
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
