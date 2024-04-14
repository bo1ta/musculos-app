//
//  NavigationRouter.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.04.2024.
//

import Foundation
import SwiftUI

protocol NavigationRouter {
  associatedtype Content: View
  
  var transition: TransitionStyle { get }
  
  @ViewBuilder
  func view() -> Content
}

enum TransitionStyle {
  case push, presentModal, presentFullScreen
}
