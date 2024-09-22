//
//  NavigationRouter.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.07.2024.
//

import Observation
import Models
import SwiftUI

@Observable
@MainActor
public final class NavigationRouter {
  private var presentingSheet: Sheet?
  private var presentingFullScreenCover: Sheet?

  var navPath = NavigationPath()

  var currentSheet: Sheet? {
    return presentingSheet ?? presentingFullScreenCover
  }

  func push(_ destination: Destination) {
    navPath.append(destination)
  }

  func pop() {
    navPath.removeLast()
  }

  func popToRoot() {
    navPath.removeLast(navPath.count)
  }

  func present(_ sheet: Sheet, fullScreenCover: Bool = false) {
    if fullScreenCover {
      presentingFullScreenCover = sheet
    } else {
      presentingSheet = sheet
    }
  }

  func isPresentingBinding() -> Binding<Bool> {
    return Binding<Bool>(get: {
      return self.presentingSheet != nil || self.presentingFullScreenCover != nil
    }, set: { value in
      if !value {
        self.presentingSheet = nil
        self.presentingFullScreenCover = nil
      }
    })
  }
}

// MARK: - Internal types

extension NavigationRouter {
  public enum Destination: Hashable {
     case exerciseDetails(Exercise)
     case search
     case notifications
     case filteredByGoal(Goal)
   }

   public enum Sheet: Hashable {
     case addActionSheet
     case workoutFlow(Workout)
   }
}
