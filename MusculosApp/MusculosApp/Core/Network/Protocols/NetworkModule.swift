//
//  NetworkModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.06.2023.
//

import Foundation

protocol NetworkModule {
    var dispatcher: NetworkDispatcher { get }
}
