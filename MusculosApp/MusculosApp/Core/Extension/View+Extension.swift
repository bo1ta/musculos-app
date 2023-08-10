//
//  View+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.08.2023.
//

import Foundation
import SwiftUI

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        self.modifier(TabBarItemViewModifier(tab: tab, selection: selection))
    }
}
