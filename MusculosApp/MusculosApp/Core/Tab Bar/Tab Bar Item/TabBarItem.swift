//
//  TabBarItem.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.08.2023.
//

import Foundation
import SwiftUI

enum TabBarItem: String {
  case explore
  case overview
//  case workout
//  case dashboard
  
  var label: String {
    return self.rawValue.capitalized
  }
  
  var imageName: String {
    switch self {
    case .explore:
      "dumbbell"
    case .overview:
      "chart.bar.xaxis.ascending"
//    case .dashboard:
//      "rectangle.grid.2x2"
//    case .workout:
//      "list.bullet.rectangle"
    }
  }
  
  @ViewBuilder
  var view: some View {
    switch self {
    case .explore:
      ExploreExerciseView()
    case .overview:
      OverviewView()
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
