//
//  TabBarItem.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.08.2023.
//

import Foundation

enum TabBarItem: Hashable {
  case home
  case explore
  case overview
  case workout
  
  var label: String {
    String(describing: self).capitalized
  }

  var imageName: String {
    switch self {
    case .home: return "house-icon"
    case .explore: return "newspaper-icon"
    case .overview: return "graph-icon"
    case .workout: return "settings-icon"
    }
  }
}
