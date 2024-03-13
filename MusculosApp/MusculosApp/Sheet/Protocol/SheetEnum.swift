//
//  SheetEnum.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import Foundation
import SwiftUI

protocol SheetEnum: Identifiable {
  associatedtype Body: View

  @ViewBuilder
  func view(coordinator: SheetCoordinator<Self>) -> Body
}
