//
//  NavigationCoordinator.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.04.2024.
//

import Foundation
import SwiftUI


class NavigationCoordinator<Router: NavigationRouter>: ObservableObject {
  let navigationController: UINavigationController
  let startingRoute: Router?
  
  init(navigationController: UINavigationController, startingRoute: Router?) {
    self.navigationController = navigationController
    self.startingRoute = startingRoute
  }
  
  func start() {
    guard let startingRoute else { return }
    
  }
  
  func show(_ route: Router, animated: Bool = false) {
    let view = route.view()
    let viewWithCoordinator = view.environmentObject(self)
    let viewController = UIHostingController(rootView: viewWithCoordinator)
    
    switch route.transition {
    case .push:
      navigationController.pushViewController(viewController, animated: animated)
    case .presentModal:
      viewController.modalPresentationStyle = .formSheet
      navigationController.present(viewController, animated: animated)
    case .presentFullScreen:
      viewController.modalPresentationStyle = .fullScreen
      navigationController.present(viewController, animated: animated)
    }
  }
  
  func pop(animated: Bool = false) {
    navigationController.popViewController(animated: animated)
  }
}
