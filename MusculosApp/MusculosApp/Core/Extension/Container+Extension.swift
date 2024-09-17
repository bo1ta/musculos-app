//
//  Container+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.05.2024.
//

import Foundation
import Factory
import Storage
import Utility

extension Container {
  var taskManager: Factory<TaskManagerProtocol> {
    self { TaskManager() }.unique
  }

  var modelCacheManager: Factory<ModelCacheManager> {
    self { ModelCacheManager() }.cached
  }
}
