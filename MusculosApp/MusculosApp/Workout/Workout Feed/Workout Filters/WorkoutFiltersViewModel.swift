//
//  WorkoutFiltersViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.08.2023.
//

import Foundation
import Combine
import SwiftUI

class WorkoutFiltersViewModel: ObservableObject {
    @Published var selectedGenderOption: String = ""
    @Published var selectedLocationOption: String = ""
    @Published var selectedTypeOption: String = ""
    
    let genderListItem = SelectListItem(itemTitle: "Gender", options: ["Male", "Female"])
    let locationListItem = SelectListItem(itemTitle: "Location", options: ["Home", "Gym", "Mix"])
    let typeListItem = SelectListItem(itemTitle: "Type", options: ["Daily workout", "Workout plan"])
}

