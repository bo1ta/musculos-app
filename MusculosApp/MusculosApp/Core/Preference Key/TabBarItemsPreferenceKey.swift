//
//  TabBarItemsPreferenceKey.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.08.2023.
//

import Foundation
import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}
