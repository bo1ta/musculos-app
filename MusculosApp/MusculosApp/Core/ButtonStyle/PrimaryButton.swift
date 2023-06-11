//
//  PrimaryButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import SwiftUI


struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .background(Color.appColor(with: .spriteGreen))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 24, height: 20)))
    }
}
