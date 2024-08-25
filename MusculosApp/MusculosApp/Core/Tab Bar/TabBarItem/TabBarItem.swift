//
//  TabBarItem.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.08.2023.
//

import Foundation

enum TabBarItem: Hashable {
  case explore
  case overview
  case workout
  
  var label: String {
    String(describing: self).capitalized
  }

  var imageName: String {
    switch self {
    case .explore: return "house-icon"
    case .overview: return "graph-icon"
    case .workout: return "settings-icon"
    }
  }
}
