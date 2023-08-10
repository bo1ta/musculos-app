//
//  File.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import Foundation
import SwiftUI

struct SelectedButton: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .lineLimit(0)
            .background(isSelected ? Color.appColor(with: .spriteGreen) : Color.white)
            .foregroundColor(isSelected ? .black : .gray)
            .font(Font.body.bold())
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 24, height: 20)))
            .opacity(UIConstants.componentOpacity)
    }
}

