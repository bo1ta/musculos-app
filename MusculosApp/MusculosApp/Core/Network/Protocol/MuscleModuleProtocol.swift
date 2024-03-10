//
//  MuscleModuleProtocol.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

protocol MusculosModule {
  var client: MusculosClientProtocol { get set }
}
