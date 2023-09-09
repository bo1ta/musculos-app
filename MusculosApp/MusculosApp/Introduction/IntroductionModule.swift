//
//  IntroductionModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.06.2023.
//

import Foundation
import Combine

struct IntroductionModule {
    var client: MusculosClient
    
    init(client: MusculosClient = MusculosClient()) {
        self.client = client
    }
}
