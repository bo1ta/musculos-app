//
//  AddSheetEnum.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import Foundation
import SwiftUI

enum AddSheetEnum: String, Identifiable, SheetEnum {
  case createItem, createExercise, createWorkout, createGoal, createChallenge
  
  var id: String { rawValue }
  
  @ViewBuilder
  func view(coordinator: SheetCoordinator<AddSheetEnum>) -> some View {
    switch self {
    case .createItem:
      EmptyView()
//      CreateItemSheet()
//        .presentationDetents([.height(300)])
    case .createExercise:
      EmptyView()
    case .createWorkout:
      EmptyView()
    case .createGoal:
      EmptyView()
    case .createChallenge:
      EmptyView()
    }
  }
}
