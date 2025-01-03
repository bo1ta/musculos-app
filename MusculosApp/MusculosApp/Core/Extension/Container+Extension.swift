//
//  Container+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.01.2025.
//

import Components
import Factory

extension Container {
  var toastManager: Factory<ToastManagerProtocol> {
    self { ToastManager() }
      .cached
  }
}
