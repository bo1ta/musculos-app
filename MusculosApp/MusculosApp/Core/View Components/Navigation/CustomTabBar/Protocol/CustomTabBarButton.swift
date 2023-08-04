//
//  CustomTabBarButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.08.2023.
//

import Foundation
import SwiftUI

protocol CustomTabBarButton: View {
    var tabBarItem: TabBarItem { get }
    var onTapGesture: () -> Void { get set }
}
