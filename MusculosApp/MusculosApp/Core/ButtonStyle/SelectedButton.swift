//
//  File.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import Foundation
import SwiftUI

struct SelectedButton: ButtonStyle {
    var option: String
    var selectedOptions: [String: Bool]
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .background(selectedOptions[option] ?? false ? Color.appColor(with: .violetBlue) : Color.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 24, height: 20)))
            .opacity(0.8)
    }
}

