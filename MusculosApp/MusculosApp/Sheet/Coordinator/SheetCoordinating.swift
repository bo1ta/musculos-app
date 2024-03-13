//
//  SheetCoordinating.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import Foundation
import SwiftUI

struct SheetCoordinating<Sheet: SheetEnum>: ViewModifier {
  @StateObject var coordinator: SheetCoordinator<Sheet>
  
  func body(content: Content) -> some View {
    content
      .sheet(item: $coordinator.currentSheet, onDismiss: {
        coordinator.sheetDismissed()
      }, content: { sheet in
        sheet.view(coordinator: coordinator)
      })
  }
}
extension View {
  func sheetCoordinating<Sheet: SheetEnum>(coordinator: SheetCoordinator<Sheet>) -> some View {
    modifier(SheetCoordinating(coordinator: coordinator))
  }
}
